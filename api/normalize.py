"""Нормализация поискового запроса — точная копия SQL-функции qiymet_norm.

Порядок шагов из CLAUDE.md, и он единственно верный:

  1. заменить İ I ı Ə ə Ö ö Ü ü Ç ç Ş ş Ğ ğ и кириллические двойники
  2. только потом опустить регистр
  3. разложить в NFD и снести комбинирующие знаки

Если поменять 1 и 2 местами, 'İ'.lower() даст 'i' + U+0307, и «milka»
перестанет находить «MİLKA».

Эта функция обязана давать ровно то же, что qiymet_norm в базе: индекс построен
по SQL-выражению, и если Python разойдётся с ним хоть на одном символе, поиск
начнёт молча терять товары. Совпадение проверяется тестом
test_normalize.py::test_python_matches_sql на живой базе.
"""
import unicodedata

# Те же пары, что в translate() внутри qiymet_norm (миграция 0005).
#
# Регистр кириллицы свёрнут прямо здесь, а не оставлен на lower(): в SQL lower()
# зависит от локали базы (в кластере с --locale=C он не трогает не-ASCII), и
# Python разошёлся бы с индексом. После этой таблицы lower() нужен только для
# ASCII, а он ведёт себя одинаково везде.
_FROM = (
    "İIıƏəÖöÜüÇçŞşĞğ"                 # азербайджанские
    "АЕОСРХУК" "аеосрхук"             # кириллические двойники латиницы
    "БВГДЁЖЗИЙЛМНПТФЦЧШЩЪЫЬЭЮЯ"       # остальная кириллица, верхний регистр
)
_TO = (
    "iiiaaoouuccssgg"
    "aeocpxyk" "aeocpxyk"
    "бвгдёжзийлмнптфцчшщъыьэюя"
)

assert len(_FROM) == len(_TO), "таблица замен разъехалась"

_TRANS = str.maketrans(_FROM, _TO)


def normalize(s: str | None) -> str:
    """Привести строку к тому же виду, что даёт qiymet_norm в Postgres."""
    if not s:
        return ""
    s = s.translate(_TRANS).lower()
    s = unicodedata.normalize("NFD", s)
    # Сносим ровно диапазон U+0300..U+036F — тот же, что в SQL: U&'[\0300-\036F]'.
    # unicodedata.combining() захватил бы больше, и Python разошёлся бы с базой.
    return "".join(ch for ch in s if not ("\u0300" <= ch <= "\u036f"))


def looks_like_barcode(q: str) -> bool:
    """Штрихкод — это 8..14 цифр. Пробелы и дефисы сети иногда вставляют сами."""
    digits = q.replace(" ", "").replace("-", "")
    return digits.isdigit() and 8 <= len(digits) <= 14


def barcode_digits(q: str) -> str:
    return q.replace(" ", "").replace("-", "")
