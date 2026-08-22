"""Склейка по похожести названий для того, что не взяли ни штрихкод, ни отпечаток.

Никаких эмбеддингов и внешних моделей: на названиях товаров символьные триграммы
работают не хуже, а весят ноль и запускаются везде. «Nestle Nesquik Kakao 500qr»
и «NESQUIK KAKAO İÇKİSİ 500 Q NESTLE» дают косинус около 0.7 при том, что
порядок слов разный, а регистр и азербайджанские буквы разные тем более.

Похожесть сама по себе ничего не решает. Она только предлагает кандидатов,
дальше идут жёсткие условия: одинаковая фасовка, одинаковая жирность, цена в
разумном коридоре. Что прошло — склеиваем, что не прошло — в очередь к человеку.
"""
import math, re, collections
import units, fingerprint

NGRAM = 3
MIN_SIM = 0.62          # ниже этого даже в кандидаты не берём
# 0.82 выбран замером: на 5000 верных пар (один EAN, разные сети) и 5000 трудных
# ложных (тот же бренд, разные EAN) склейка выше этого порога при совпавшей
# фасовке даёт точность 96%. Без условия по фасовке было бы 84%.
AUTO_SIM = 0.82
PRICE_BAND = 0.40       # цена может отличаться на столько, дальше не верим
# Почти одинаковые названия — свидетельство сильнее ценового коридора. Овощи
# у разных сетей честно расходятся в полтора раза, и это не повод не склеивать.
SURE_SIM = 0.95


def grams(name):
    s = fingerprint.tokens(name)
    s = ' '.join(sorted(set(s)))          # порядок слов у сетей разный
    s = f'  {s}  '
    return [s[i:i + NGRAM] for i in range(len(s) - NGRAM + 1)]


def vec(name):
    c = collections.Counter(grams(name))
    n = math.sqrt(sum(v * v for v in c.values())) or 1.0
    return {k: v / n for k, v in c.items()}


def cos(a, b):
    if len(a) > len(b):
        a, b = b, a
    return sum(v * b.get(k, 0.0) for k, v in a.items())


def unit_sig(name):
    v, u, pack = units.parse(name)
    if u == 'g' and v == 1000:
        u, v = 'kg_bulk', None
    return u, v, fingerprint.fat(name)


def compatible(a, b):
    """Фасовка и жирность обязаны совпасть. Неизвестная фасовка — не повод верить."""
    ua, ub = unit_sig(a), unit_sig(b)
    if ua[0] is None or ub[0] is None:
        return False
    return ua == ub


def candidates(items, min_sim=MIN_SIM):
    """items: список dict с ключами id, chain, name, price.

    Блокировка по общим триграммам, иначе это N^2 на 17 тысячах позиций.
    """
    vecs = {it['id']: vec(it['name']) for it in items}
    inv = collections.defaultdict(list)
    for it in items:
        for g in set(vecs[it['id']]):
            inv[g].append(it['id'])
    # выкидываем слишком частые триграммы: они дают всех со всеми и ничего не значат
    common = {g for g, ids in inv.items() if len(ids) > 400}

    by_id = {it['id']: it for it in items}
    seen, out = set(), []
    for it in items:
        near = collections.Counter()
        for g in set(vecs[it['id']]) - common:
            for j in inv[g]:
                if j != it['id']:
                    near[j] += 1
        for j, _ in near.most_common(25):
            other = by_id[j]
            if other['chain'] == it['chain']:
                continue
            k = (it['id'], j) if it['id'] < j else (j, it['id'])
            if k in seen:
                continue
            seen.add(k)
            s = cos(vecs[it['id']], vecs[j])
            if s >= min_sim:
                out.append((s, it, other))
    out.sort(key=lambda x: -x[0])
    return out


def decide(sim, a, b):
    """Что делать с парой: склеить, отправить человеку или выбросить."""
    if not compatible(a['name'], b['name']):
        return 'drop', 'фасовка не совпадает'
    # Для ценового коридора берём цену ДО акции, если она есть. Иначе Milka со
    # скидкой в одной сети и без скидки в другой расходится вдвое, и пара уходит
    # человеку, хотя это очевидно один и тот же шоколад.
    pa = a.get('base') or a['price']
    pb = b.get('base') or b['price']
    lo, hi = min(pa, pb), max(pa, pb)
    if lo <= 0:
        return 'drop', 'нет цены'
    gap = (hi - lo) / lo
    if sim >= SURE_SIM or (sim >= AUTO_SIM and gap <= PRICE_BAND):
        return 'merge', f'похожесть {sim:.2f}, цены расходятся на {round(gap*100)}%'
    return 'queue', f'похожесть {sim:.2f}, цены расходятся на {round(gap*100)}%'
