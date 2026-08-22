"""Подписки на товар и регистрация устройств.

Регистрации пользователя нет: клиент присылает анонимный id устройства в
заголовке X-Device-Id, сервер заводит по нему запись. Ни почты, ни пароля, ни
согласий — и целый класс обязанностей по персональным данным не возникает.

Ответы этих маршрутов не кешируются: это личные данные пользователя, и класть
их в общий Redis по ключу без учёта устройства было бы прямой утечкой.
"""
from fastapi import APIRouter, Depends, Header, HTTPException, Path, Response
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncConnection

from ..db import get_conn
from ..schemas import (
    DeviceIn,
    DeviceOut,
    WatchesResponse,
    WatchIn,
    WatchOut,
)

router = APIRouter()


async def current_user_id(
    conn: AsyncConnection,
    device_id: str,
    create: bool = False,
    lang: str | None = None,
    tz: str | None = None,
) -> int:
    row = (
        await conn.execute(
            text("SELECT id FROM users WHERE anon_id = :a"), {"a": device_id}
        )
    ).first()

    if row is not None:
        await conn.execute(
            text("UPDATE users SET last_seen_at = now() WHERE id = :id"),
            {"id": row[0]},
        )
        return row[0]

    if not create:
        raise HTTPException(
            status_code=404,
            detail="Устройство не зарегистрировано. Сначала POST /v1/devices",
        )

    new = (
        await conn.execute(
            text(
                "INSERT INTO users (anon_id, lang, timezone) "
                "VALUES (:a, coalesce(:l,'az'), coalesce(:t,'Asia/Baku')) "
                "ON CONFLICT (anon_id) DO UPDATE SET last_seen_at = now() "
                "RETURNING id"
            ),
            {"a": device_id, "l": lang, "t": tz},
        )
    ).first()
    return new[0]


async def device_id_header(
    x_device_id: str = Header(
        ..., alias="X-Device-Id", min_length=8,
        description="Анонимный идентификатор устройства, генерит клиент",
    ),
) -> str:
    return x_device_id


@router.post("/devices", response_model=DeviceOut, summary="Зарегистрировать устройство")
async def register_device(
    body: DeviceIn,
    response: Response,
    device_id: str = Depends(device_id_header),
    conn: AsyncConnection = Depends(get_conn),
):
    """Завести пользователя по анонимному id и сохранить токен FCM.

    Повторный вызов с тем же токеном обновляет язык и зону, а не плодит записи:
    приложение зовёт этот маршрут при каждом запуске.
    """
    response.headers["Cache-Control"] = "private, no-store"

    async with conn.begin():
        user_id = await current_user_id(
            conn, device_id, create=True, lang=body.lang, tz=body.timezone
        )
        await conn.execute(
            text("UPDATE users SET lang = :l, timezone = :t WHERE id = :id"),
            {"l": body.lang, "t": body.timezone, "id": user_id},
        )
        token_row = (
            await conn.execute(
                text(
                    """
                    INSERT INTO device_tokens (user_id, token, platform)
                    VALUES (:u, :tok, :p)
                    ON CONFLICT (token) DO UPDATE
                       SET user_id = EXCLUDED.user_id,
                           platform = EXCLUDED.platform,
                           -- токен снова живой: приложение прислало его само
                           disabled_at = NULL,
                           disabled_reason = NULL
                    RETURNING id
                    """
                ),
                {"u": user_id, "tok": body.token, "p": body.platform},
            )
        ).first()

    return DeviceOut(
        user_id=user_id,
        device_token_id=token_row[0],
        lang=body.lang,
        timezone=body.timezone,
    )


WATCH_LIST = """
SELECT w.id, w.product_id, p.name AS product_name,
       w.store_id, s.name AS store_name,
       w.target_price_minor, w.active, w.created_at,
       best.price  AS best_price,
       best.code   AS best_chain,
       best.observed_at
FROM watches w
JOIN products p     ON p.id = w.product_id
LEFT JOIN stores s  ON s.id = w.store_id
LEFT JOIN LATERAL (
    -- Текущая лучшая цена по подписке. Позиции Bravo без выбранного магазина
    -- сюда не попадают: показывать цену сети с четырьмя зонами как одну нельзя.
    SELECT cp.price, c.code, cp.observed_at
    FROM store_items si
    JOIN chains c          ON c.id = si.chain_id
    JOIN current_prices cp ON cp.store_item_id = si.id
    WHERE si.product_id = w.product_id
      AND cp.available = 1
      AND (w.store_id IS NOT NULL OR c.price_model <> 'per_cluster')
      AND (w.store_id IS NULL OR si.store_id = w.store_id OR si.store_id IS NULL)
    ORDER BY cp.price
    LIMIT 1
) best ON true
WHERE w.user_id = :uid
ORDER BY w.created_at DESC
"""


@router.get("/watches", response_model=WatchesResponse, summary="Мои подписки")
async def list_watches(
    response: Response,
    device_id: str = Depends(device_id_header),
    conn: AsyncConnection = Depends(get_conn),
):
    response.headers["Cache-Control"] = "private, no-store"
    user_id = await current_user_id(conn, device_id)

    rows = (await conn.execute(text(WATCH_LIST), {"uid": user_id})).mappings().all()
    return WatchesResponse(
        items=[
            WatchOut(
                id=r["id"],
                product_id=r["product_id"],
                product_name=r["product_name"],
                store_id=r["store_id"],
                store_name=r["store_name"],
                target_price_minor=r["target_price_minor"],
                active=r["active"],
                created_at=r["created_at"],
                current_best_price_minor=r["best_price"],
                current_best_chain=r["best_chain"],
                observed_at=r["observed_at"],
            )
            for r in rows
        ]
    )


@router.post("/watches", response_model=WatchOut, status_code=201,
             summary="Подписаться на товар")
async def create_watch(
    body: WatchIn,
    response: Response,
    device_id: str = Depends(device_id_header),
    conn: AsyncConnection = Depends(get_conn),
):
    """Подписаться на падение цены.

    Повторная подписка на тот же товар не создаёт вторую: уникальный индекс
    построен по COALESCE(store_id, 0), потому что при store_id IS NULL обычный
    UNIQUE дубли не ловит — и пользователь получал бы по два пуша.
    """
    response.headers["Cache-Control"] = "private, no-store"

    async with conn.begin():
        user_id = await current_user_id(conn, device_id, create=True)

        product = (
            await conn.execute(
                text("SELECT name, quarantined FROM products WHERE id = :p"),
                {"p": body.product_id},
            )
        ).first()
        # Карантинный товар нельзя даже подписать: мы не доверяем этой склейке,
        # значит не сможем честно сказать, на что именно упала цена.
        if product is None or product[1] == 1:
            raise HTTPException(status_code=404, detail="Товар не найден")

        if body.store_id is not None:
            exists = (
                await conn.execute(
                    text("SELECT 1 FROM stores WHERE id = :s"), {"s": body.store_id}
                )
            ).first()
            if exists is None:
                raise HTTPException(
                    status_code=404, detail=f"Магазин {body.store_id} не найден"
                )

        row = (
            await conn.execute(
                text(
                    """
                    INSERT INTO watches
                        (user_id, product_id, store_id, target_price_minor)
                    VALUES (:u, :p, :s, :t)
                    ON CONFLICT (user_id, product_id, COALESCE(store_id, 0))
                    DO UPDATE SET target_price_minor = EXCLUDED.target_price_minor,
                                  active = true
                    RETURNING id, created_at, active
                    """
                ),
                {
                    "u": user_id,
                    "p": body.product_id,
                    "s": body.store_id,
                    "t": body.target_price_minor,
                },
            )
        ).first()

    return WatchOut(
        id=row[0],
        product_id=body.product_id,
        product_name=product[0],
        store_id=body.store_id,
        store_name=None,
        target_price_minor=body.target_price_minor,
        active=row[2],
        created_at=row[1],
        current_best_price_minor=None,
        current_best_chain=None,
        observed_at=None,
    )


@router.delete("/watches/{watch_id}", status_code=204, summary="Отписаться")
async def delete_watch(
    response: Response,
    watch_id: int = Path(ge=1),
    device_id: str = Depends(device_id_header),
    conn: AsyncConnection = Depends(get_conn),
):
    async with conn.begin():
        user_id = await current_user_id(conn, device_id)
        row = (
            await conn.execute(
                text(
                    "DELETE FROM watches WHERE id = :id AND user_id = :u RETURNING id"
                ),
                {"id": watch_id, "u": user_id},
            )
        ).first()

    if row is None:
        # И «нет такой подписки», и «чужая подписка» дают 404: по коду ответа
        # нельзя перебором узнать, что существует у других.
        raise HTTPException(status_code=404, detail="Подписка не найдена")
    return Response(status_code=204)
