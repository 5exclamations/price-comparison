"""Текст согласия на обработку чеков.

Текст живёт на СЕРВЕРЕ, а не в приложении. Причина юридическая: доказывать
потом придётся, на что именно человек согласился, а версия приложения у него
может быть любая. Клиент показывает то, что отдал сервер, и подтверждает
версию — сервер записывает свой же хеш.

Версия увеличивается при любом смысловом изменении текста. Старое согласие при
этом перестаёт действовать, и приложение спросит заново: «человек когда-то
что-то нажал» согласием не является.

Ссылка на закон Азербайджанской Республики «О персональных данных»
(«Fərdi məlumatlar haqqında») от 11 мая 2010 года № 998-IIIQ.
"""
import hashlib

CONSENT_VERSION = 1

LAW_REFERENCE = {
    "az": "«Fərdi məlumatlar haqqında» Azərbaycan Respublikasının Qanunu "
          "(11 may 2010-cu il, № 998-IIIQ)",
    "ru": "Закон Азербайджанской Республики «О персональных данных» "
          "(11 мая 2010 года, № 998-IIIQ)",
    "en": "Law of the Republic of Azerbaijan on Personal Data "
          "(11 May 2010, No. 998-IIIQ)",
}

TEXTS = {
    "az": """Çeklərinizi yükləməyə icazə

Çekdəki QR kodu skan etdikdə tətbiq həmin çekin linkini serverimizə göndərir,
biz də portaldan çekin tərkibini oxuyuruq.

Nə saxlayırıq: mağazanın adı, çekin tarixi və vaxtı, məhsulların adları,
sayı və qiymətləri, ümumi məbləğ.

Nə saxlamırıq: adınızı, telefonunuzu, kart məlumatlarınızı. Qeydiyyat yoxdur —
sizi yalnız cihazınızın anonim nömrəsi ilə tanıyırıq.

Nə üçün lazımdır: kassadakı qiymət mağaza vitrinindəki qiymətdən dəqiqdir.
Bu, bizim çata bilmədiyimiz mağazaların qiymətlərini də göstərməyə imkan verir.

Ümumi statistikada məlumatlar şəxssizləşdirilir: qiymət, mağaza və saat qalır,
sizə aparan heç bir əlaqə qalmır. Şəxssizləşdirilmiş məlumat artıq fərdi
məlumat sayılmır və çeklərinizi silsəniz də statistikada qalır — bunu əvvəlcədən
açıq deyirik.

İstənilən vaxt razılığı geri götürə və bütün çeklərinizi silə bilərsiniz:
Tənzimləmələr → Çeklərim.""",

    "ru": """Согласие на загрузку ваших чеков

Когда вы сканируете QR с чека, приложение отправляет ссылку с этого чека на наш
сервер, и мы читаем состав чека с портала.

Что сохраняем: название магазина, дату и время чека, названия товаров, их
количество и цены, итоговую сумму.

Что не сохраняем: ваше имя, телефон, данные карты. Регистрации нет — мы знаем
вас только по анонимному номеру устройства.

Зачем это нужно: цена на кассе точнее цены на витрине. Это позволяет показывать
цены и тех магазинов, куда мы иначе не добираемся.

В общей статистике данные обезличиваются: остаются цена, магазин и час, но не
остаётся ничего, что ведёт к вам. Обезличенные данные перестают быть
персональными и сохраняются в статистике, даже если вы удалите свои чеки, —
говорим об этом заранее и прямо.

Вы можете в любой момент отозвать согласие и удалить все свои чеки:
Настройки → Мои чеки.""",

    "en": """Consent to upload your receipts

When you scan the QR code on a receipt, the app sends that receipt's link to our
server, and we read the receipt contents from the portal.

What we store: the shop name, the receipt date and time, product names, their
quantities and prices, and the total.

What we do not store: your name, phone number, or card details. There is no
registration — we know you only by an anonymous device identifier.

Why this matters: the price at the till is more accurate than the price on a
shelf listing. It also lets us show prices for shops we cannot otherwise reach.

In shared statistics the data is anonymised: the price, the shop and the hour
remain, but nothing that leads back to you. Anonymised data is no longer
personal data and stays in the statistics even if you delete your receipts — we
say this upfront.

You can withdraw consent and delete all your receipts at any time:
Settings → My receipts.""",
}


def consent_text(locale: str) -> str:
    lang = locale if locale in TEXTS else "az"
    return f"{TEXTS[lang]}\n\n{LAW_REFERENCE[lang]}"


def consent_digest(locale: str) -> str:
    """Хеш показанного текста. Меняется текст — согласие спрашивается заново."""
    return hashlib.sha256(consent_text(locale).encode("utf-8")).hexdigest()[:32]
