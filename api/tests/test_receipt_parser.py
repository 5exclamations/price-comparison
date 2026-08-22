"""Разбор чека и проверка ссылки с QR."""
import pytest

from api.receipts.parser import (
    ParsedReceipt,
    ReceiptParseError,
    money_to_minor,
    parse_datetime,
    parse_receipt,
)
from api.receipts.source import ReceiptUrlError, parse_receipt_url

# ---------- деньги ----------


class TestMoney:
    def test_manats_to_qapik(self):
        assert money_to_minor("13.99") == 1399
        assert money_to_minor("13,99") == 1399   # запятая, как печатает касса
        assert money_to_minor("0.05") == 5
        assert money_to_minor("0,5") == 50       # не 5
        assert money_to_minor("100") == 10000
        assert money_to_minor(7) == 700

    def test_spaces_are_tolerated(self):
        assert money_to_minor(" 1 234,50 ") == 123450

    def test_float_does_not_lose_qapik(self):
        # 13.99 в double — это 13.9899999...; через строку теряться нечему.
        assert money_to_minor(13.99) == 1399

    def test_every_value_round_trips(self):
        for minor in range(0, 2001):
            text = f"{minor // 100},{minor % 100:02d}"
            assert money_to_minor(text) == minor

    def test_garbage_is_rejected(self):
        for bad in ("", "abc", "13.999", "1.2.3", "13,", None, True):
            with pytest.raises(ReceiptParseError):
                money_to_minor(bad)


# ---------- время ----------


class TestDateTime:
    def test_naive_time_is_baku_not_utc(self):
        """Касса печатает местное время.

        Прочитать его как UTC значит сдвинуть все покупки на четыре часа и
        потом объяснять, почему человек «покупал в 4 утра».
        """
        dt = parse_datetime("17.08.2026 14:30:00")
        assert dt.hour == 10  # 14:30 в Баку = 10:30 UTC
        assert dt.tzinfo is not None

    def test_formats(self):
        for text in (
            "2026-08-17T14:30:00",
            "2026-08-17 14:30:00",
            "17.08.2026 14:30:00",
            "17.08.2026 14:30",
        ):
            assert parse_datetime(text).year == 2026

    def test_garbage(self):
        with pytest.raises(ReceiptParseError):
            parse_datetime("позавчера")


# ---------- JSON ----------

JSON_RECEIPT = """
{
  "documentId": "AZ0001234567",
  "dateTime": "17.08.2026 14:30:00",
  "objectName": "Bravo Superstore 28 Mall",
  "tin": "1234567890",
  "totalAmount": "24,48",
  "items": [
    {"name": "SÜD 2.5% 1 L", "quantity": 2, "price": "2,49", "total": "4,98",
     "unit": "əd", "barcode": "4760000602371"},
    {"name": "ÇÖRƏK AĞ 500 QR", "quantity": 1, "price": "0,80", "total": "0,80"},
    {"name": "POMİDOR", "quantity": 1.5, "price": "3,20", "total": "4,80",
     "unit": "kq"}
  ]
}
"""


class TestJson:
    def test_full_receipt(self):
        r = parse_receipt(JSON_RECEIPT)
        assert isinstance(r, ParsedReceipt)
        assert r.fiscal_id == "AZ0001234567"
        assert r.merchant_name == "Bravo Superstore 28 Mall"
        assert r.merchant_tin == "1234567890"
        assert r.total_minor == 2448
        assert len(r.items) == 3

    def test_items_are_in_qapik(self):
        r = parse_receipt(JSON_RECEIPT)
        milk = r.items[0]
        assert milk.unit_price_minor == 249
        assert milk.total_minor == 498
        assert milk.quantity == 2
        assert milk.ean == "4760000602371"

    def test_weighted_item_keeps_fractional_quantity(self):
        r = parse_receipt(JSON_RECEIPT)
        tomato = r.items[2]
        assert tomato.quantity == 1.5
        assert tomato.unit == "kq"
        assert tomato.unit_price_minor == 320

    def test_line_numbers_are_sequential(self):
        r = parse_receipt(JSON_RECEIPT)
        assert [i.line_no for i in r.items] == [1, 2, 3]

    def test_alternative_field_names(self):
        """Портал может назвать поля иначе — разбираем по именам, не по позициям."""
        payload = """
        {"fiscalId": "X1", "createdAt": "2026-08-17T10:00:00",
         "companyName": "Araz", "sum": "1,00",
         "products": [{"productName": "Çay", "unitPrice": "1,00", "qty": 1}]}
        """
        r = parse_receipt(payload)
        assert r.fiscal_id == "X1"
        assert r.merchant_name == "Araz"
        assert r.items[0].raw_name == "Çay"

    def test_envelope_is_unwrapped(self):
        payload = '{"data": %s}' % JSON_RECEIPT
        assert parse_receipt(payload).fiscal_id == "AZ0001234567"

    def test_total_is_summed_when_absent(self):
        payload = """
        {"documentId":"X","dateTime":"2026-08-17T10:00:00",
         "items":[{"name":"A","price":"1,00","total":"1,00"},
                  {"name":"B","price":"2,50","total":"2,50"}]}
        """
        assert parse_receipt(payload).total_minor == 350

    def test_broken_line_does_not_kill_the_receipt(self):
        """Одна кривая строка не должна отменять весь чек."""
        payload = """
        {"documentId":"X","dateTime":"2026-08-17T10:00:00",
         "items":[{"name":"A","price":"1,00"},
                  {"quantity": 1},
                  {"name":"B","price":"2,00"}]}
        """
        r = parse_receipt(payload)
        assert [i.raw_name for i in r.items] == ["A", "B"]

    def test_receipt_without_items_is_rejected(self):
        payload = '{"documentId":"X","dateTime":"2026-08-17T10:00:00","items":[]}'
        with pytest.raises(ReceiptParseError):
            parse_receipt(payload)

    def test_fallback_id_from_url(self):
        payload = '{"dateTime":"2026-08-17T10:00:00","items":[{"name":"A","price":"1,00"}]}'
        assert parse_receipt(payload, fallback_id="FROM-QR").fiscal_id == "FROM-QR"

    def test_no_id_anywhere_is_rejected(self):
        payload = '{"dateTime":"2026-08-17T10:00:00","items":[{"name":"A","price":"1,00"}]}'
        with pytest.raises(ReceiptParseError):
            parse_receipt(payload)


# ---------- HTML ----------

HTML_RECEIPT = """
<html><body>
  <p>Obyekt: Araz Supermarket</p>
  <p>VÖEN: 9876543210</p>
  <p>Fiskal: AZ0009999</p>
  <p>17.08.2026 09:15:00</p>
  <table>
    <tr><th>Ad</th><th>Say</th><th>Qiymət</th><th>Məbləğ</th></tr>
    <tr><td>SÜD 1 L</td><td>2</td><td>2,49</td><td>4,98</td></tr>
    <tr><td>ÇÖRƏK</td><td>1</td><td>0,80</td><td>0,80</td></tr>
  </table>
</body></html>
"""


class TestHtml:
    def test_table_is_parsed(self):
        r = parse_receipt(HTML_RECEIPT)
        assert len(r.items) == 2
        assert r.items[0].raw_name == "SÜD 1 L"
        assert r.items[0].unit_price_minor == 249
        assert r.items[0].total_minor == 498

    def test_header_row_is_skipped(self):
        r = parse_receipt(HTML_RECEIPT)
        assert all(i.raw_name not in ("Ad", "Qiymət") for i in r.items)

    def test_metadata(self):
        r = parse_receipt(HTML_RECEIPT)
        assert r.fiscal_id == "AZ0009999"
        assert r.merchant_tin == "9876543210"
        assert r.issued_at.year == 2026

    def test_total_is_summed(self):
        assert parse_receipt(HTML_RECEIPT).total_minor == 578

    def test_page_without_table_is_rejected(self):
        with pytest.raises(ReceiptParseError):
            parse_receipt("<html><body><p>Чек не найден</p></body></html>")

    def test_empty_payload(self):
        with pytest.raises(ReceiptParseError):
            parse_receipt("")


# ---------- ссылка с QR: защита от SSRF ----------


class TestUrl:
    def test_valid_url(self):
        ref = parse_receipt_url("https://monitoring.e-kassa.gov.az/#/index?doc=ABC123")
        assert ref.doc_id == "ABC123"

    def test_doc_id_from_query(self):
        ref = parse_receipt_url("https://e-kassa.gov.az/receipt?doc=XYZ789")
        assert ref.doc_id == "XYZ789"

    def test_doc_id_from_path(self):
        ref = parse_receipt_url("https://e-kassa.gov.az/receipt/AZ00012345")
        assert ref.doc_id == "AZ00012345"

    @pytest.mark.parametrize(
        "url",
        [
            "http://e-kassa.gov.az/?doc=A1",            # не https
            "https://evil.example.com/?doc=A1",          # чужой хост
            "https://e-kassa.gov.az.evil.com/?doc=A1",   # похожий хост
            "https://localhost/?doc=A1",
            "https://127.0.0.1/?doc=A1",
            "https://169.254.169.254/?doc=A1",           # метаданные облака
            "https://e-kassa.gov.az:8080/?doc=A1",       # нестандартный порт
            "file:///etc/passwd",
            "",
            "   ",
        ],
    )
    def test_dangerous_urls_are_rejected(self, url):
        """Ходит по ссылке НАШ сервер — значит, любой чужой адрес это SSRF."""
        with pytest.raises(ReceiptUrlError):
            parse_receipt_url(url)

    def test_url_without_doc_id_is_rejected(self):
        with pytest.raises(ReceiptUrlError):
            parse_receipt_url("https://e-kassa.gov.az/")

    def test_absurdly_long_url(self):
        with pytest.raises(ReceiptUrlError):
            parse_receipt_url("https://e-kassa.gov.az/?doc=" + "A" * 3000)
