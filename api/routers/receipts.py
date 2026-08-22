"""Чеки из фискальных касс: согласие, загрузка, удаление, баллы."""
from fastapi import APIRouter, Depends, HTTPException, Path, Query, Response
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncConnection

from ..db import get_conn
from ..normalize import normalize
from ..receipts.consent_text import CONSENT_VERSION, consent_digest, consent_text
from ..receipts.parser import ReceiptParseError, parse_receipt
from ..receipts.source import (
    HttpReceiptFetcher,
    ReceiptFetcher,
    ReceiptUrlError,
    parse_receipt_url,
)
from ..schemas import (
    ConsentState,
    ConsentText,
    PointsOut,
    ReceiptItemOut,
    ReceiptOut,
    ReceiptsResponse,
    ReceiptSubmitIn,
)
from .watches import current_user_id, device_id_header

router = APIRouter()

# Баллы. Числа скромные намеренно: чек ценен данными, а не тем, чтобы его
# несли ради баллов — за баллами понесут чужие чеки.
POINTS_PER_RECEIPT = 10
POINTS_NEW_STORE = 25


def _fetcher() -> ReceiptFetcher:
    """Подменяется в тестах. Настоящий ходит в сеть."""
    return HttpReceiptFetcher()


# ---------- согласие ----------


@router.get(
    "/consents/receipts/text",
    response_model=ConsentText,
    summary="Текст согласия",
)
async def receipts_consent_text(
    response: Response,
    lang: str = Query("az", pattern="^(az|ru|en)$"),
):
    """Текст, который обязан показать клиент.

    Текст живёт на сервере, а не в приложении: доказывать потом придётся, на
    что именно человек согласился, а версия приложения у него может быть любая.
    """
    response.headers["Cache-Control"] = "public, max-age=3600"
    return ConsentText(
        kind="receipts",
        version=CONSENT_VERSION,
        locale=lang,
        text=consent_text(lang),
        digest=consent_digest(lang),
    )


@router.get("/consents", response_model=ConsentState, summary="Моё согласие")
async def my_consent(
    response: Response,
    device_id: str = Depends(device_id_header),
    conn: AsyncConnection = Depends(get_conn),
):
    response.headers["Cache-Control"] = "private, no-store"
    row = (
        await conn.execute(
            text(
                "SELECT c.version, c.granted_at FROM consents c "
                "JOIN users u ON u.id = c.user_id "
                "WHERE u.anon_id = :a AND c.kind = 'receipts' "
                "AND c.revoked_at IS NULL"
            ),
            {"a": device_id},
        )
    ).first()

    return ConsentState(
        kind="receipts",
        current_version=CONSENT_VERSION,
        granted=row is not None and row[0] == CONSENT_VERSION,
        granted_version=row[0] if row else None,
        granted_at=row[1] if row else None,
    )


@router.post("/consents", response_model=ConsentState, summary="Дать согласие")
async def grant_consent(
    response: Response,
    lang: str = Query("az", pattern="^(az|ru|en)$"),
    version: int = Query(..., description="Версия текста, который был показан"),
    device_id: str = Depends(device_id_header),
    conn: AsyncConnection = Depends(get_conn),
):
    """Записать согласие.

    Версия проверяется: если клиент показал устаревший текст, согласие не
    принимается. Иначе старая сборка приложения собирала бы согласия на текст,
    которого уже нет.
    """
    response.headers["Cache-Control"] = "private, no-store"
    if version != CONSENT_VERSION:
        raise HTTPException(
            status_code=409,
            detail=(
                f"Показан текст версии {version}, действует {CONSENT_VERSION}. "
                "Обновите текст и спросите заново"
            ),
        )

    user_id = await current_user_id(conn, device_id, create=True)
    await conn.execute(
        text(
            "INSERT INTO consents (user_id, kind, version, text_digest, locale) "
            "VALUES (:u, 'receipts', :v, :d, :l) "
            "ON CONFLICT (user_id, kind) WHERE revoked_at IS NULL "
            "DO UPDATE SET version = EXCLUDED.version, "
            "              text_digest = EXCLUDED.text_digest, "
            "              locale = EXCLUDED.locale, "
            "              granted_at = now()"
        ),
        {"u": user_id, "v": version, "d": consent_digest(lang), "l": lang},
    )
    await conn.commit()

    return ConsentState(
        kind="receipts",
        current_version=CONSENT_VERSION,
        granted=True,
        granted_version=version,
        granted_at=None,
    )


@router.delete("/consents", status_code=200, summary="Отозвать согласие")
async def revoke_consent(
    response: Response,
    device_id: str = Depends(device_id_header),
    conn: AsyncConnection = Depends(get_conn),
):
    """Отозвать согласие и удалить все чеки.

    Отзыв без удаления был бы отзывом на словах. Обезличенные наблюдения
    остаются — они уже не персональные данные, и текст согласия говорит об
    этом прямо, до того как человек согласился.
    """
    response.headers["Cache-Control"] = "private, no-store"

    user_id = await current_user_id(conn, device_id)
    await conn.execute(
        text(
            "UPDATE consents SET revoked_at = now() "
            "WHERE user_id = :u AND kind = 'receipts' AND revoked_at IS NULL"
        ),
        {"u": user_id},
    )
    deleted = (
        await conn.execute(
            text("SELECT forget_user_receipts(:u)"), {"u": user_id}
        )
    ).scalar()
    await conn.commit()

    return {"revoked": True, "receipts_deleted": deleted}


# ---------- чеки ----------


async def _require_consent(conn: AsyncConnection, user_id: int) -> None:
    row = (
        await conn.execute(
            text(
                "SELECT version FROM consents WHERE user_id = :u "
                "AND kind = 'receipts' AND revoked_at IS NULL"
            ),
            {"u": user_id},
        )
    ).first()
    if row is None or row[0] != CONSENT_VERSION:
        raise HTTPException(
            status_code=403,
            detail="Нужно согласие на обработку чеков. GET /v1/consents/receipts/text",
        )


@router.post("/receipts", response_model=ReceiptOut, summary="Загрузить чек")
async def submit_receipt(
    body: ReceiptSubmitIn,
    response: Response,
    device_id: str = Depends(device_id_header),
    conn: AsyncConnection = Depends(get_conn),
    fetcher: ReceiptFetcher = Depends(_fetcher),
):
    """Разобрать чек по ссылке с QR и сохранить.

    Повторная загрузка того же чека не создаёт дубль и не начисляет баллы
    второй раз: фискальный номер уникален глобально.

    Магазин не из наших сетей — тоже сохраняем. Это бесплатно расширяет
    покрытие: через полгода такие чеки дадут цены магазинов, куда скрейпер
    не залезет никогда.
    """
    response.headers["Cache-Control"] = "private, no-store"

    try:
        ref = parse_receipt_url(body.url)
    except ReceiptUrlError as exc:
        raise HTTPException(status_code=400, detail=str(exc))

    user_id = await current_user_id(conn, device_id, create=True)
    await _require_consent(conn, user_id)

    # Дедупликация до похода в сеть: незачем дёргать портал ради чека,
    # который у нас уже есть.
    existing = (
        await conn.execute(
            text("SELECT id FROM receipts WHERE fiscal_id = :f"),
            {"f": ref.doc_id},
        )
    ).first()
    if existing is not None:
        return await _load_receipt(conn, existing[0], duplicate=True)

    # Закрываем транзакцию, открытую чтениями выше. Держать её открытой через
    # поход в сеть нельзя: портал может отвечать секундами, а транзакция всё
    # это время занимала бы соединение и блокировала бы вакуум.
    await conn.commit()

    try:
        payload = await fetcher.fetch(ref)
        parsed = parse_receipt(payload, fallback_id=ref.doc_id)
    except ReceiptUrlError as exc:
        raise HTTPException(status_code=502, detail=f"Портал: {exc}")
    except ReceiptParseError as exc:
        raise HTTPException(status_code=422, detail=f"Не разобрали чек: {exc}")

    # Повтор мог появиться, пока ходили в сеть.
    again = (
        await conn.execute(
            text("SELECT id FROM receipts WHERE fiscal_id = :f"),
            {"f": parsed.fiscal_id},
        )
    ).first()
    if again is not None:
        return await _load_receipt(conn, again[0], duplicate=True)

    chain_id, store_id = await _match_merchant(conn, parsed.merchant_name)

    receipt_id = (
        await conn.execute(
            text(
                """
                INSERT INTO receipts
                    (user_id, fiscal_id, source_url, chain_id, store_id,
                     merchant_name, merchant_tin, issued_at, total_minor)
                VALUES (:u, :f, :url, :chain, :store, :name, :tin, :at, :total)
                RETURNING id
                """
            ),
            {
                "u": user_id,
                "f": parsed.fiscal_id,
                "url": ref.url,
                "chain": chain_id,
                "store": store_id,
                "name": parsed.merchant_name,
                "tin": parsed.merchant_tin,
                "at": parsed.issued_at,
                "total": parsed.total_minor,
            },
        )
    ).scalar()

    for item in parsed.items:
        await conn.execute(
            text(
                """
                INSERT INTO receipt_items
                    (receipt_id, line_no, raw_name, norm_name, ean,
                     quantity, unit, unit_price_minor, total_minor)
                VALUES (:r, :n, :raw, :norm, :ean, :q, :unit, :price, :total)
                """
            ),
            {
                "r": receipt_id,
                "n": item.line_no,
                "raw": item.raw_name,
                "norm": normalize(item.raw_name),
                "ean": item.ean,
                "q": item.quantity,
                "unit": item.unit,
                "price": item.unit_price_minor,
                "total": item.total_minor,
            },
        )

    # Баллы. Уникальный индекс не даст начислить дважды за один чек.
    await conn.execute(
        text(
            "INSERT INTO point_events (user_id, points, reason, receipt_id) "
            "VALUES (:u, :p, 'receipt_uploaded', :r) "
            "ON CONFLICT DO NOTHING"
        ),
        {"u": user_id, "p": POINTS_PER_RECEIPT, "r": receipt_id},
    )
    if chain_id is None:
        # Магазин не наш — такой чек ценнее обычного: он про покрытие.
        await conn.execute(
            text(
                "INSERT INTO point_events (user_id, points, reason, receipt_id) "
                "VALUES (:u, :p, 'receipt_new_store', :r) "
                "ON CONFLICT DO NOTHING"
            ),
            {"u": user_id, "p": POINTS_NEW_STORE, "r": receipt_id},
        )

    await conn.commit()
    return await _load_receipt(conn, receipt_id)


async def _match_merchant(
    conn: AsyncConnection, name: str | None
) -> tuple[int | None, int | None]:
    """Узнать сеть по названию из чека.

    Не узнали — не беда: чек всё равно сохраняется, просто без привязки.
    Гадать нельзя: ошибочная привязка испортит цены целой сети.
    """
    if not name:
        return None, None

    normalized = normalize(name)
    row = (
        await conn.execute(
            text(
                "SELECT c.id, s.id FROM chains c "
                "LEFT JOIN stores s ON s.chain_id = c.id "
                "  AND qiymet_norm(:name) LIKE '%' || qiymet_norm(s.name) || '%' "
                "WHERE qiymet_norm(:name) LIKE '%' || qiymet_norm(c.name) || '%' "
                "ORDER BY s.id NULLS LAST LIMIT 1"
            ),
            {"name": normalized},
        )
    ).first()
    return (row[0], row[1]) if row else (None, None)


async def _load_receipt(
    conn: AsyncConnection, receipt_id: int, duplicate: bool = False
) -> ReceiptOut:
    row = (
        await conn.execute(
            text(
                "SELECT r.id, r.fiscal_id, r.merchant_name, c.code, r.issued_at, "
                "       r.total_minor, r.uploaded_at, r.status "
                "FROM receipts r LEFT JOIN chains c ON c.id = r.chain_id "
                "WHERE r.id = :id"
            ),
            {"id": receipt_id},
        )
    ).mappings().first()
    if row is None:
        raise HTTPException(status_code=404, detail="Чек не найден")

    items = (
        await conn.execute(
            text(
                "SELECT line_no, raw_name, quantity, unit, unit_price_minor, "
                "       total_minor, ean "
                "FROM receipt_items WHERE receipt_id = :id ORDER BY line_no"
            ),
            {"id": receipt_id},
        )
    ).mappings().all()

    points = (
        await conn.execute(
            text(
                "SELECT coalesce(sum(points), 0)::int FROM point_events "
                "WHERE receipt_id = :id"
            ),
            {"id": receipt_id},
        )
    ).scalar()

    return ReceiptOut(
        id=row["id"],
        fiscal_id=row["fiscal_id"],
        merchant_name=row["merchant_name"],
        chain_code=row["code"],
        issued_at=row["issued_at"],
        total_minor=row["total_minor"],
        uploaded_at=row["uploaded_at"],
        status=row["status"],
        duplicate=duplicate,
        points_awarded=0 if duplicate else (points or 0),
        items=[
            ReceiptItemOut(
                line_no=i["line_no"],
                name=i["raw_name"],
                quantity=i["quantity"],
                unit=i["unit"],
                unit_price_minor=i["unit_price_minor"],
                total_minor=i["total_minor"],
                ean=i["ean"],
            )
            for i in items
        ],
    )


@router.get("/receipts", response_model=ReceiptsResponse, summary="Мои чеки")
async def my_receipts(
    response: Response,
    device_id: str = Depends(device_id_header),
    conn: AsyncConnection = Depends(get_conn),
):
    response.headers["Cache-Control"] = "private, no-store"
    user_id = await current_user_id(conn, device_id)

    rows = (
        await conn.execute(
            text(
                "SELECT r.id, r.fiscal_id, r.merchant_name, c.code, r.issued_at, "
                "       r.total_minor, r.uploaded_at, r.status "
                "FROM receipts r LEFT JOIN chains c ON c.id = r.chain_id "
                "WHERE r.user_id = :u ORDER BY r.uploaded_at DESC LIMIT 200"
            ),
            {"u": user_id},
        )
    ).mappings().all()

    return ReceiptsResponse(
        items=[
            ReceiptOut(
                id=r["id"],
                fiscal_id=r["fiscal_id"],
                merchant_name=r["merchant_name"],
                chain_code=r["code"],
                issued_at=r["issued_at"],
                total_minor=r["total_minor"],
                uploaded_at=r["uploaded_at"],
                status=r["status"],
                items=[],
            )
            for r in rows
        ]
    )


@router.delete("/receipts/{receipt_id}", status_code=204, summary="Удалить чек")
async def delete_receipt(
    receipt_id: int = Path(ge=1),
    device_id: str = Depends(device_id_header),
    conn: AsyncConnection = Depends(get_conn),
):
    """Удалить свой чек. Чужой удалить нельзя, и 404 об этом не расскажет."""
    user_id = await current_user_id(conn, device_id)
    row = (
        await conn.execute(
            text(
                "DELETE FROM receipts WHERE id = :id AND user_id = :u "
                "RETURNING id"
            ),
            {"id": receipt_id, "u": user_id},
        )
    ).first()
    await conn.commit()

    if row is None:
        raise HTTPException(status_code=404, detail="Чек не найден")
    return Response(status_code=204)


@router.get("/points", response_model=PointsOut, summary="Мои баллы")
async def my_points(
    response: Response,
    device_id: str = Depends(device_id_header),
    conn: AsyncConnection = Depends(get_conn),
):
    response.headers["Cache-Control"] = "private, no-store"
    user_id = await current_user_id(conn, device_id)

    total = (
        await conn.execute(
            text("SELECT points FROM user_points WHERE user_id = :u"),
            {"u": user_id},
        )
    ).scalar()

    receipts = (
        await conn.execute(
            text("SELECT count(*) FROM receipts WHERE user_id = :u"),
            {"u": user_id},
        )
    ).scalar()

    return PointsOut(points=total or 0, receipts_uploaded=receipts or 0)
