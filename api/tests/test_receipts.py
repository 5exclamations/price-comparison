"""Чеки: согласие, загрузка, дедупликация, баллы, удаление, обезличивание."""
import uuid

import pytest
from sqlalchemy import text

from api.db import engine
from api.receipts.consent_text import CONSENT_VERSION
from api.receipts.source import ReceiptRef
from api.routers import receipts as receipts_router

pytestmark = pytest.mark.asyncio

RECEIPT_JSON = """
{
  "documentId": "%s",
  "dateTime": "17.08.2026 14:30:00",
  "objectName": "%s",
  "tin": "1234567890",
  "totalAmount": "6,58",
  "items": [
    {"name": "SÜD 2.5%% 1 L", "quantity": 2, "price": "2,49", "total": "4,98"},
    {"name": "ÇÖRƏK AĞ", "quantity": 2, "price": "0,80", "total": "1,60"}
  ]
}
"""


class FakeFetcher:
    """Подменяет поход на портал: сеть в тестах не нужна."""

    def __init__(self, payload: str):
        self.payload = payload
        self.calls = 0

    async def fetch(self, ref: ReceiptRef) -> str:
        self.calls += 1
        return self.payload % (ref.doc_id, self.merchant) if "%s" in self.payload \
            else self.payload

    merchant = "Bravo Superstore 28 Mall"


def device() -> str:
    return f"receipt-{uuid.uuid4()}"


def headers(dev: str) -> dict[str, str]:
    return {"X-Device-Id": dev}


async def grant(client, dev: str):
    return await client.post(
        "/v1/consents",
        headers=headers(dev),
        params={"lang": "ru", "version": CONSENT_VERSION},
    )


def use_fetcher(app, payload: str, merchant: str = "Bravo Superstore 28 Mall"):
    fetcher = FakeFetcher(payload)
    fetcher.merchant = merchant
    app.dependency_overrides[receipts_router._fetcher] = lambda: fetcher
    return fetcher


@pytest.fixture(autouse=True)
def _cleanup_overrides():
    from api.main import app
    yield
    app.dependency_overrides.pop(receipts_router._fetcher, None)


# ---------- согласие ----------


class TestConsent:
    async def test_text_is_served_in_three_languages(self, client):
        digests = set()
        for lang in ("az", "ru", "en"):
            r = await client.get(
                "/v1/consents/receipts/text", params={"lang": lang}
            )
            assert r.status_code == 200
            body = r.json()
            assert body["version"] == CONSENT_VERSION
            assert len(body["text"]) > 200
            digests.add(body["digest"])
        assert len(digests) == 3, "у разных языков разный текст и разный хеш"

    async def test_text_mentions_the_law(self, client):
        for lang, needle in [
            ("ru", "998-IIIQ"),
            ("az", "Fərdi məlumatlar"),
            ("en", "Personal Data"),
        ]:
            r = await client.get(
                "/v1/consents/receipts/text", params={"lang": lang}
            )
            assert needle in r.json()["text"]

    async def test_text_warns_that_anonymised_data_stays(self, client):
        """Про необратимость обезличивания надо сказать ДО согласия."""
        r = await client.get("/v1/consents/receipts/text", params={"lang": "ru"})
        assert "обезличив" in r.json()["text"].lower()

    async def test_no_consent_by_default(self, client):
        dev = device()
        await client.post(
            "/v1/devices",
            headers=headers(dev),
            json={"token": "x" * 20, "platform": "android"},
        )
        r = await client.get("/v1/consents", headers=headers(dev))
        assert r.json()["granted"] is False

    async def test_grant_and_read_back(self, client):
        dev = device()
        assert (await grant(client, dev)).status_code == 200
        r = await client.get("/v1/consents", headers=headers(dev))
        assert r.json()["granted"] is True
        assert r.json()["granted_version"] == CONSENT_VERSION

    async def test_stale_version_is_rejected(self, client):
        """Старая сборка не должна собирать согласия на текст, которого нет."""
        r = await client.post(
            "/v1/consents",
            headers=headers(device()),
            params={"lang": "ru", "version": CONSENT_VERSION - 1},
        )
        assert r.status_code == 409

    async def test_consent_is_not_cached(self, client):
        dev = device()
        await grant(client, dev)
        r = await client.get("/v1/consents", headers=headers(dev))
        assert r.headers["cache-control"] == "private, no-store"


# ---------- загрузка ----------


class TestUpload:
    async def test_upload_without_consent_is_403(self, client):
        from api.main import app

        use_fetcher(app, RECEIPT_JSON)
        r = await client.post(
            "/v1/receipts",
            headers=headers(device()),
            json={"url": "https://e-kassa.gov.az/?doc=NOCONSENT1"},
        )
        assert r.status_code == 403

    async def test_upload_parses_and_stores(self, client):
        from api.main import app

        dev = device()
        await grant(client, dev)
        use_fetcher(app, RECEIPT_JSON)

        r = await client.post(
            "/v1/receipts",
            headers=headers(dev),
            json={"url": f"https://e-kassa.gov.az/?doc=AZ{uuid.uuid4().hex[:10]}"},
        )
        assert r.status_code == 200
        body = r.json()
        assert body["total_minor"] == 658
        assert len(body["items"]) == 2
        assert body["items"][0]["unit_price_minor"] == 249
        assert body["duplicate"] is False

    async def test_known_merchant_is_matched_to_chain(self, client):
        from api.main import app

        dev = device()
        await grant(client, dev)
        use_fetcher(app, RECEIPT_JSON, merchant="Bravo Superstore 28 Mall")

        r = await client.post(
            "/v1/receipts",
            headers=headers(dev),
            json={"url": f"https://e-kassa.gov.az/?doc=AZ{uuid.uuid4().hex[:10]}"},
        )
        assert r.json()["chain_code"] == "bravo"

    async def test_unknown_merchant_is_still_saved(self, client):
        """Магазин не из наших сетей — чек всё равно сохраняется.

        Это бесплатно расширяет покрытие: через полгода такие чеки дадут цены
        магазинов, куда скрейпер не залезет никогда.
        """
        from api.main import app

        dev = device()
        await grant(client, dev)
        use_fetcher(app, RECEIPT_JSON, merchant="Filankəs Marketi")

        r = await client.post(
            "/v1/receipts",
            headers=headers(dev),
            json={"url": f"https://e-kassa.gov.az/?doc=AZ{uuid.uuid4().hex[:10]}"},
        )
        assert r.status_code == 200
        assert r.json()["chain_code"] is None
        assert r.json()["merchant_name"] == "Filankəs Marketi"

    async def test_duplicate_is_not_stored_twice(self, client):
        from api.main import app

        dev = device()
        await grant(client, dev)
        fetcher = use_fetcher(app, RECEIPT_JSON)
        url = f"https://e-kassa.gov.az/?doc=AZ{uuid.uuid4().hex[:10]}"

        first = await client.post("/v1/receipts", headers=headers(dev), json={"url": url})
        second = await client.post("/v1/receipts", headers=headers(dev), json={"url": url})

        assert first.json()["id"] == second.json()["id"]
        assert second.json()["duplicate"] is True
        assert fetcher.calls == 1, "за дублем в портал ходить незачем"

    async def test_bad_url_is_400_not_500(self, client):
        dev = device()
        await grant(client, dev)
        r = await client.post(
            "/v1/receipts",
            headers=headers(dev),
            json={"url": "https://evil.example.com/?doc=A1"},
        )
        assert r.status_code == 400

    async def test_unparseable_response_is_422(self, client):
        from api.main import app

        dev = device()
        await grant(client, dev)
        use_fetcher(app, "<html><body>Чек не найден</body></html>")

        r = await client.post(
            "/v1/receipts",
            headers=headers(dev),
            json={"url": f"https://e-kassa.gov.az/?doc=AZ{uuid.uuid4().hex[:10]}"},
        )
        assert r.status_code == 422


# ---------- баллы ----------


class TestPoints:
    async def test_points_for_upload(self, client):
        from api.main import app

        dev = device()
        await grant(client, dev)
        use_fetcher(app, RECEIPT_JSON)
        await client.post(
            "/v1/receipts",
            headers=headers(dev),
            json={"url": f"https://e-kassa.gov.az/?doc=AZ{uuid.uuid4().hex[:10]}"},
        )

        r = await client.get("/v1/points", headers=headers(dev))
        assert r.json()["points"] == receipts_router.POINTS_PER_RECEIPT
        assert r.json()["receipts_uploaded"] == 1

    async def test_unknown_store_is_worth_more(self, client):
        from api.main import app

        dev = device()
        await grant(client, dev)
        use_fetcher(app, RECEIPT_JSON, merchant="Filankəs Marketi")
        await client.post(
            "/v1/receipts",
            headers=headers(dev),
            json={"url": f"https://e-kassa.gov.az/?doc=AZ{uuid.uuid4().hex[:10]}"},
        )

        r = await client.get("/v1/points", headers=headers(dev))
        assert r.json()["points"] == (
            receipts_router.POINTS_PER_RECEIPT + receipts_router.POINTS_NEW_STORE
        )

    async def test_duplicate_does_not_pay_twice(self, client):
        from api.main import app

        dev = device()
        await grant(client, dev)
        use_fetcher(app, RECEIPT_JSON)
        url = f"https://e-kassa.gov.az/?doc=AZ{uuid.uuid4().hex[:10]}"

        await client.post("/v1/receipts", headers=headers(dev), json={"url": url})
        await client.post("/v1/receipts", headers=headers(dev), json={"url": url})

        r = await client.get("/v1/points", headers=headers(dev))
        assert r.json()["points"] == receipts_router.POINTS_PER_RECEIPT


# ---------- удаление и отзыв ----------


class TestDeletion:
    async def test_delete_own_receipt(self, client):
        from api.main import app

        dev = device()
        await grant(client, dev)
        use_fetcher(app, RECEIPT_JSON)
        created = await client.post(
            "/v1/receipts",
            headers=headers(dev),
            json={"url": f"https://e-kassa.gov.az/?doc=AZ{uuid.uuid4().hex[:10]}"},
        )

        r = await client.delete(
            f"/v1/receipts/{created.json()['id']}", headers=headers(dev)
        )
        assert r.status_code == 204
        assert (await client.get("/v1/receipts", headers=headers(dev))).json()["items"] == []

    async def test_cannot_delete_someone_elses(self, client):
        from api.main import app

        mine, theirs = device(), device()
        await grant(client, mine)
        await grant(client, theirs)
        use_fetcher(app, RECEIPT_JSON)
        created = await client.post(
            "/v1/receipts",
            headers=headers(mine),
            json={"url": f"https://e-kassa.gov.az/?doc=AZ{uuid.uuid4().hex[:10]}"},
        )

        r = await client.delete(
            f"/v1/receipts/{created.json()['id']}", headers=headers(theirs)
        )
        assert r.status_code == 404

    async def test_revoking_consent_deletes_receipts(self, client):
        """Отзыв без удаления был бы отзывом на словах."""
        from api.main import app

        dev = device()
        await grant(client, dev)
        use_fetcher(app, RECEIPT_JSON)
        await client.post(
            "/v1/receipts",
            headers=headers(dev),
            json={"url": f"https://e-kassa.gov.az/?doc=AZ{uuid.uuid4().hex[:10]}"},
        )

        r = await client.delete("/v1/consents", headers=headers(dev))
        assert r.status_code == 200
        assert r.json()["receipts_deleted"] == 1

        assert (await client.get("/v1/consents", headers=headers(dev))).json()["granted"] is False
        assert (await client.get("/v1/receipts", headers=headers(dev))).json()["items"] == []

    async def test_revoking_zeroes_the_points(self, client):
        from api.main import app

        dev = device()
        await grant(client, dev)
        use_fetcher(app, RECEIPT_JSON)
        await client.post(
            "/v1/receipts",
            headers=headers(dev),
            json={"url": f"https://e-kassa.gov.az/?doc=AZ{uuid.uuid4().hex[:10]}"},
        )
        await client.delete("/v1/consents", headers=headers(dev))

        assert (await client.get("/v1/points", headers=headers(dev))).json()["points"] == 0

    async def test_upload_after_revoke_needs_consent_again(self, client):
        from api.main import app

        dev = device()
        await grant(client, dev)
        await client.delete("/v1/consents", headers=headers(dev))
        use_fetcher(app, RECEIPT_JSON)

        r = await client.post(
            "/v1/receipts",
            headers=headers(dev),
            json={"url": f"https://e-kassa.gov.az/?doc=AZ{uuid.uuid4().hex[:10]}"},
        )
        assert r.status_code == 403


# ---------- обезличивание ----------


class TestAnonymisation:
    async def test_promotion_keeps_no_link_to_the_person(self):
        """В общий пул уходит цена и время — и ничего, что ведёт к человеку.

        Проверяем саму функцию: в price_observations нет ни user_id, ни
        receipt_id, а обратный join невозможен по построению.
        """
        async with engine().connect() as conn:
            cols = (
                await conn.execute(
                    text(
                        "SELECT column_name FROM information_schema.columns "
                        "WHERE table_name = 'price_observations'"
                    )
                )
            ).scalars().all()

        assert "user_id" not in cols
        assert "receipt_id" not in cols

    async def test_promotion_rounds_time_to_the_hour(self):
        """Точная минута покупки вместе с редким товаром — почти отпечаток."""
        async with engine().connect() as conn:
            body = (
                await conn.execute(
                    text("SELECT prosrc FROM pg_proc WHERE proname = 'promote_receipt_items'")
                )
            ).scalar()
        assert "date_trunc('hour'" in body

    async def test_forget_function_exists_and_is_documented(self):
        async with engine().connect() as conn:
            comment = (
                await conn.execute(
                    text(
                        "SELECT obj_description(p.oid) FROM pg_proc p "
                        "WHERE p.proname = 'forget_user_receipts'"
                    )
                )
            ).scalar()
        assert comment and "не персональные" in comment
