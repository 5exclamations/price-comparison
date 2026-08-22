"""Разбор объёма, веса и количества из названия товара (az/ru/en вперемешку).

Возвращает (value, unit, pack), где unit из {g, ml, pcs, kg_bulk}.
kg_bulk = весовой товар, цена за килограмм, конкретного веса у него нет.
"""
import re

# Порядок важен: длинные алиасы первыми, иначе 'q' съест 'qr'.
UNIT_ALIASES = [
    ('kq', 'kg'), ('kg', 'kg'), ('кг', 'kg'),
    ('qram', 'g'), ('qr', 'g'), ('gr', 'g'), ('gram', 'g'), ('г', 'g'), ('q', 'g'), ('g', 'g'),
    ('ml', 'ml'), ('мл', 'ml'),
    ('litr', 'l'), ('lt', 'l'), ('л', 'l'), ('l', 'l'),
    ('ədəd', 'pcs'), ('eded', 'pcs'), ('ədd', 'pcs'), ('əd', 'pcs'),
    ('adet', 'pcs'), ('şt', 'pcs'), ('st', 'pcs'), ('pcs', 'pcs'), ('pc', 'pcs'),
]
_ALT = '|'.join(a for a, _ in UNIT_ALIASES)
_TO = dict(UNIT_ALIASES)

# 500 QR / 1,5 L / 90ML / 300qr
AMOUNT = re.compile(rf'(?<![\d.,])(\d+(?:[.,]\d+)?)\s*({_ALT})(?![a-zçəğıöşü])', re.IGNORECASE)
# 6X1.5 L, 2x200 ml
MULTI = re.compile(rf'(\d+)\s*[xх*]\s*(\d+(?:[.,]\d+)?)\s*({_ALT})(?![a-zçəğıöşü])', re.IGNORECASE)
# 7 Lİ / 10 LU / 6-LI / 12-li  (упаковка из N штук)
PACK = re.compile(r'(?<![\d.,])(\d{1,3})\s*[-\s]?(l[ıiuü])(?![a-zçəğıöşü])', re.IGNORECASE)
# хвост «kq» / «kg» без числа = весовой товар
BULK = re.compile(r'(?:^|\s)(kq|kg|кг)(?:\s|$)', re.IGNORECASE)
# габариты, это не фасовка. Либо три числа через x, либо два числа с sm/cm.
# Важно не съесть мультипак 6X1.5 L, поэтому просто «число x число» сюда не попадает.
DIMS = re.compile(
    r'\d+(?:[.,]\d+)?\s*[xх]\s*\d+(?:[.,]\d+)?\s*[xх]\s*\d+(?:[.,]\d+)?'
    r'|\d+(?:[.,]\d+)?\s*[xх]\s*\d+(?:[.,]\d+)?\s*(?:sm|cm|см)\b',
    re.IGNORECASE)


def parse(name: str):
    if not name:
        return None, None, None
    s = DIMS.sub(' ', name)          # выкидываем габариты до всего остального
    pack = None

    m = MULTI.search(s)
    if m:
        pack = int(m.group(1))
        val = float(m.group(2).replace(',', '.'))
        unit = _TO[m.group(3).lower()]
        return _base(val, unit) + (pack,)

    p = PACK.search(s)
    if p:
        pack = int(p.group(1))
        s = s[:p.start()] + ' ' + s[p.end():]

    m = AMOUNT.search(s)
    if m:
        val = float(m.group(1).replace(',', '.'))
        unit = _TO[m.group(2).lower()]
        v, u = _base(val, unit)
        return v, u, pack

    if BULK.search(s):
        return None, 'kg_bulk', pack
    if pack:
        return float(pack), 'pcs', pack
    return None, None, None


def _base(val, unit):
    """Приводим к граммам и миллилитрам, чтобы 1 kq и 1000 q были одним числом."""
    if unit == 'kg':
        return val * 1000, 'g'
    if unit == 'l':
        return val * 1000, 'ml'
    return val, unit


if __name__ == '__main__':
    tests = [
        ('Tess Sunrise Qara Çay Qutuda 200qr', (200, 'g')),
        ('ULKER ÇOKOMEL MARSHMALLOW 36 QR', (36, 'g')),
        ('LD DONDURMA 90 ML RASPBERRY STİCK', (90, 'ml')),
        ('Kələm Qırmızı kq', (None, 'kg_bulk')),
        ('SLADUS GOLD MONEDA SOKOLAD  KG', (None, 'kg_bulk')),
        ('MOLPED QADIN BEZİ 7 Lİ ANTİBAKTERYAL', (7, 'pcs')),
        ('FLOREX ZİBİL TORBASI LIMON 10 LU BÜZMƏLİ', (10, 'pcs')),
        ('Coca Cola 1,5 L', (1500, 'ml')),
        ('SU 6X1.5 L', (1500, 'ml')),
        ('ASMA ÇARPAYI 2 NƏFƏRLİK 120X200CM 3', (None, None)),
        ('AMD FİNCAN SMILE 8.9X9 SM R105 03', (None, None)),
        ('Bravo Fırın Zavod Çörəyi 600 Qr', (600, 'g')),
        ('KÖK SOYULMUŞ 500 QR', (500, 'g')),
        ('Möcüzə Bakı Kurabiyesi 300qr', (300, 'g')),
        ('MOÇİ DONDURMA 195 Q PÜSTƏ 6-LI', (195, 'g')),
    ]
    ok = 0
    for name, exp in tests:
        v, u, p = parse(name)
        good = (v, u) == exp
        ok += good
        print(('OK  ' if good else 'FAIL'), f'{name[:45]:47}', (v, u, p), 'ждали', exp)
    print(f'\n{ok}/{len(tests)}')
