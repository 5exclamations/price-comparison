"""Отпечаток товара по названию: для того, у чего нет штрихкода.

Штрихкод есть не всегда. У весовых товаров его нет по природе, у Neptun его
нет вообще (160 GTIN на 4000 позиций), у Rahat заполнен на четверть. При этом
именно весовые товары — помидоры, картофель, курица — люди сравнивают чаще
всего, поэтому обойтись одним EAN нельзя.

Идея: свести название к множеству значимых слов плюс подпись фасовки.
«Pomidor Çəhrayı 1kq 2512» и «POMİDOR ÇƏHRAYI KQ» дают одинаковый отпечаток,
а «Pomidor Salyan kq» — уже другой, потому что сорт разный.
"""
import re
import units

TRANS = str.maketrans({'ə': 'a', 'ı': 'i', 'ö': 'o', 'ü': 'u', 'ç': 'c', 'ş': 's', 'ğ': 'g',
                       'Ə': 'a', 'I': 'i', 'İ': 'i', 'Ö': 'o', 'Ü': 'u', 'Ç': 'c',
                       'Ş': 's', 'Ğ': 'g',
                       # кириллица, которую сети мешают с латиницей в одном названии
                       'а': 'a', 'е': 'e', 'о': 'o', 'с': 'c', 'р': 'p', 'х': 'x',
                       'у': 'y', 'к': 'k', 'м': 'm', 'т': 't', 'в': 'v', 'н': 'n'})

# слова, которые ничего не говорят о товаре
STOP = {
    'kq', 'kg', 'qr', 'gr', 'q', 'g', 'ml', 'l', 'lt', 'eded', 'ed', 'adet', 'st',
    'caki', 'ceki', 'cheki', 'paket', 'qutuda', 'qutu', 'setka', 'tnk', 'tk', 'bag',
    'ile', 've', 'v', 'i', 'na', 'dan', 'den', 'uchun', 'ucun', 'super', 'lyuks',
    'luks', 'yeni', 'new', 'aksiya', 'endirim', 'mehsul', 'mehsullar',
    'no', 'n', 'x', 'sm', 'cm', 'mm', 'de', 'da',
}

TOKEN = re.compile(r'[a-z0-9]+')


def tokens(name: str):
    s = (name or '').translate(TRANS).lower()
    s = re.sub(r'\d+(?:[.,]\d+)?\s*%', ' ', s)      # проценты жирности сносим отдельно
    # выкидываем фасовку целиком, иначе «1kq» и «1l» останутся словами
    s = units.MULTI.sub(' ', s)
    s = units.AMOUNT.sub(' ', s)
    s = units.PACK.sub(' ', s)
    out = []
    for t in TOKEN.findall(s):
        if t in STOP:
            continue
        if t.isdigit():                            # внутренние коды сетей и числа фасовки
            continue
        if len(t) < 2:
            continue
        out.append(t)
    return out


def fat(name: str):
    """Жирность: 2,5% и 2.5% это одно, и она различает молоко."""
    m = re.search(r'(\d{1,2}(?:[.,]\d)?)\s*%', name or '')
    return round(float(m.group(1).replace(',', '.')), 1) if m else None


def key(name: str):
    """Отпечаток. None, если слов слишком мало, чтобы что-то утверждать."""
    t = tokens(name)
    if len(t) < 2:
        return None
    v, u, pack = units.parse(name)
    # «1 kq» на ценнике и весовой товар без фасовки — на практике одно и то же
    if u == 'g' and v == 1000:
        u, v = 'kg_bulk', None
    return (tuple(sorted(set(t))), u, v, pack, fat(name))


def variant_digits(name: str):
    """Числа, оставшиеся после снятия фасовки и процентов.

    Это варианты товара, а не мусор: «DURACELL BATAREYA 2025» и «2032» —
    разные батарейки, «BALTİKA PİVƏ 0» и «7» — разное пиво, у краски для волос
    номер это оттенок. tokens() чистые числа выбрасывает намеренно (там же
    оказываются внутренние коды сетей), но для loose_key() их терять нельзя:
    без них склеится то, что склеивать нельзя.
    """
    s = (name or '').translate(TRANS).lower()
    s = re.sub(r'\d+(?:[.,]\d+)?\s*%', ' ', s)
    s = units.MULTI.sub(' ', s)
    s = units.AMOUNT.sub(' ', s)
    s = units.PACK.sub(' ', s)
    return tuple(sorted(t for t in TOKEN.findall(s) if t.isdigit()))


def loose_key(name: str):
    """Отпечаток, терпимый к пробелу внутри названия бренда.

    Сети пишут один бренд по-разному: «Azərsüd Süd» и «Azər Süd» — это молоко
    Azərsüd, но у key() отпечатки разные (`azarsud`+`sud` против `azar`+`sud`),
    а триграммная похожесть 0.62 при пороге 0.82. Понижать порог нельзя: на нём
    держится точность 96%.

    Приём: слово, целиком входящее в другое слово того же названия, выкидываем,
    остальные склеиваем в одну строку без границ.

        ('azarsud', 'sud') -> 'sud' входит в 'azarsud' -> 'azarsud'
        ('azar', 'sud')    -> ни одно не входит        -> 'azarsud'

    Фасовка, упаковка, жирность и варианты-числа остаются в ключе как есть —
    без них ключ склеивает 20% сметану с 25%, а 2025-ю батарейку с 2032-й.
    Проверено на живой базе: 653 группы, все просмотренные — настоящие дубли.

    Ключ заведомо грубее key(), поэтому применять его можно только между
    РАЗНЫМИ сетями. Внутри одной сети одинаковое название почти всегда значит
    разный артикул: у «DONEGAL DARAQ» их два десятка подряд.
    """
    k = key(name)
    if k is None:
        return None
    t, u, v, pack, f = k
    keep = [w for w in t if not any(w != o and w in o for o in t)]
    glued = ''.join(sorted(keep or t))
    return (glued, u, v, pack, f, variant_digits(name))

if __name__ == '__main__':
    pairs = [
        ('Pomidor Çəhrayı 1kq 2512', 'POMİDOR ÇƏHRAYI KQ', True),
        ('Pomidor Salyan kq', 'Pomidor Çəhrayı kq', False),
        ('Kartof Yerli kq 3046', 'KARTOF YERLİ KQ', True),
        ('Milla Süd 2,5% 1 l', 'MİLLA SÜD 2.5% 1L', True),
        ('Milla Süd 3,2% 1 l', 'MİLLA SÜD 2.5% 1L', False),
        ('Coca-Cola 330 ml', 'COCA COLA 330 ML BANKA', False),   # «banka» различает
        ('Toyuq Budu kq', 'TOYUQ BUDU ÇƏKİ KQ', True),
    ]
    # loose_key терпит пробел внутри бренда, но обязан сохранять всё, что
    # различает товар: жирность, фасовку и числа-варианты.
    loose_pairs = [
        ('Azərsüd Süd 3.2% 1l', 'Azər Süd 3.2% 1 l', True),
        ('Azərsüd Süd 3.2% 1l', 'Azərsüd Süd 2.5% 1l', False),   # жирность
        ('DURACELL BATAREYA 2025', 'DURACELL BATAREYA 2032', False),  # вариант
        ('BALTİKA PİVƏ 500 ML 0 ŞÜŞƏ', 'BALTİKA PİVƏ 500 ML 7 ŞÜŞƏ', False),
        ('KOROVUŞKA KƏRƏ YAĞI 400 Q 82,5%', 'Korovuska 400 qr Kərə Yağı 82.5%', True),
        ('Oman Un 1 kq', 'OMAN UN 1 KQ', True),
        ('OMAN UN 1 KQ', 'OMAN UN 4 KQ', False),                 # фасовка
    ]

    ok = 0
    for a, b, exp in pairs:
        got = key(a) is not None and key(a) == key(b)
        ok += got == exp
        print(('OK  ' if got == exp else 'FAIL'), f'{a[:32]:34}|{b[:32]:34}', 'совпало' if got else 'разные')

    print()
    for a, b, exp in loose_pairs:
        got = loose_key(a) is not None and loose_key(a) == loose_key(b)
        ok += got == exp
        print(('OK  ' if got == exp else 'FAIL'), f'loose {a[:28]:30}|{b[:28]:30}',
              'совпало' if got else 'разные')

    total = len(pairs) + len(loose_pairs)
    print(f'\n{ok}/{total}')
