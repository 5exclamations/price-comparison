"""qiymet_norm: сделать идемпотентной на Ё.

Revision ID: 0009
Revises: 0008
Create Date: 2026-08-18

Функция из 0005 не идемпотентна, и нашёл это клиентский тест на смесь
латиницы с кириллицей.

Как ломается. «Ё» (U+0401) в таблице двойников не значится: двойник — это «Е»,
а «Ё» отдельная кодовая точка. Первый шаг сворачивает её в строчную «ё», NFD
раскладывает в «е» + U+0308, диакритика снимается — на выходе КИРИЛЛИЧЕСКАЯ
«е». Применяем функцию второй раз: теперь это уже двойник, и он превращается
в латинскую «e». Две прогонки дают разный результат.

Почему это не теория. Клиент нормализует запрос у себя (lib/core/text.dart),
сервер применяет qiymet_norm ещё раз — к запросу и к колонке. Имя товара
проходит функцию один раз и лежит в индексе с кириллической «е», а запрос
пользователя — дважды и приходит с латинской «e». «Ёлки», «Тёма», «мёд»
перестают находиться. Ошибки нет, лога нет, просто пустая выдача.

То же самое с «Ў» (основа «У») — белорусская буква, в каталоге маловероятна,
но чинится тем же движением.

Починка: свернуть двойников ЕЩЁ РАЗ, уже после NFD. После lower и NFD
заглавных не остаётся, поэтому второму translate хватает строчной таблицы.
Порядок первых шагов не меняется — он по-прежнему единственно верный.

Индексы приходится пересоздать. CREATE OR REPLACE на функции, по которой
построен индекс, Postgres разрешает, но записи в индексе остаются от старого
определения — то есть индекс начинает врать.
"""
from alembic import op

revision = "0009"
down_revision = "0008"
branch_labels = None
depends_on = None

# Двойники латиницы в строчной кириллице. Заглавных после lower() не бывает.
LOOKALIKES_FROM = "аеосрхук"
LOOKALIKES_TO = "aeocpxyk"

NORM_BODY_NEW = r"""
    SELECT translate(
             regexp_replace(
               normalize(
                 lower(
                   translate($1,
                     -- 1. азербайджанские: сначала они, иначе lower сломает İ
                     'İIıƏəÖöÜüÇçŞşĞğ'
                     -- 2. кириллические двойники латиницы, оба регистра
                     || 'АЕОСРХУК' || 'аеосрхук'
                     -- 3. остальная кириллица в верхнем регистре: сворачиваем
                     --    сами, чтобы не зависеть от локали базы
                     || 'БВГДЁЖЗИЙЛМНПТФЦЧШЩЪЫЬЭЮЯ',
                     'iiiaaoouuccssgg'
                     || 'aeocpxyk' || 'aeocpxyk'
                     || 'бвгдёжзийлмнптфцчшщъыьэюя')),
                 NFD),
               U&'[\0300-\036F]', '', 'g'),
             -- 4. двойники ещё раз: NFD мог обнажить основу, как у «ё» -> «е».
             --    Без этого шага функция не идемпотентна.
             'аеосрхук', 'aeocpxyk')
"""

NORM_BODY_OLD = r"""
    SELECT regexp_replace(
             normalize(
               lower(
                 translate($1,
                   'İIıƏəÖöÜüÇçŞşĞğ'
                   || 'АЕОСРХУК' || 'аеосрхук'
                   || 'БВГДЁЖЗИЙЛМНПТФЦЧШЩЪЫЬЭЮЯ',
                   'iiiaaoouuccssgg'
                   || 'aeocpxyk' || 'aeocpxyk'
                   || 'бвгдёжзийлмнптфцчшщъыьэюя')),
               NFD),
             U&'[\0300-\036F]', '', 'g')
"""


def _replace(body: str, comment: str) -> None:
    op.execute("DROP INDEX IF EXISTS idx_products_name_trgm")
    op.execute("DROP INDEX IF EXISTS idx_si_norm_name_trgm")

    op.execute(
        f"""
        CREATE OR REPLACE FUNCTION qiymet_norm(text)
        RETURNS text
        LANGUAGE sql
        IMMUTABLE
        STRICT
        PARALLEL SAFE
        AS $${body}$$
        """
    )
    op.execute(f"COMMENT ON FUNCTION qiymet_norm(text) IS '{comment}'")

    op.execute(
        "CREATE INDEX idx_products_name_trgm "
        "ON products USING gin (qiymet_norm(name) gin_trgm_ops)"
    )
    op.execute(
        "CREATE INDEX idx_si_norm_name_trgm "
        "ON store_items USING gin (qiymet_norm(norm_name) gin_trgm_ops)"
    )


def upgrade() -> None:
    _replace(
        NORM_BODY_NEW,
        "Нормализация по правилу CLAUDE.md: translate азербайджанских и "
        "кириллических двойников -> lower -> NFD и сброс комбинирующих знаков "
        "-> двойники ещё раз. Порядок менять нельзя. Идемпотентна",
    )

    # Проверка прямо в миграции: если после NFD двойников не свернуть,
    # qiymet_norm(qiymet_norm(x)) разойдётся с qiymet_norm(x). На это
    # опирается API, поэтому цена ошибки — молча пустая выдача.
    op.execute(
        """
        DO $$
        DECLARE
            sample text;
        BEGIN
            FOREACH sample IN ARRAY ARRAY[
                'Ёлка', 'мёд', 'Тёма', 'MİLKA', 'Çuğundur',
                'Кока-Кола', 'Сoca-Cola 330 ml'
            ] LOOP
                IF qiymet_norm(qiymet_norm(sample)) IS DISTINCT FROM
                   qiymet_norm(sample) THEN
                    RAISE EXCEPTION
                        'qiymet_norm не идемпотентна на %: % -> %',
                        sample, qiymet_norm(sample),
                        qiymet_norm(qiymet_norm(sample));
                END IF;
            END LOOP;
        END $$
        """
    )


def downgrade() -> None:
    _replace(
        NORM_BODY_OLD,
        "Нормализация по правилу CLAUDE.md: translate азербайджанских и "
        "кириллических двойников -> lower -> NFD и сброс комбинирующих знаков. "
        "Порядок менять нельзя",
    )
