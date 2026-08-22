import json, re, collections
D = json.load(open('raw/wolt_bravo.json'))
FRESH = ['tərəvəz', 'meyvə', 'göyərti']

def key(n):
    m = re.search(r'(\d{3,6})\s*$', n.strip())
    return ('code', m.group(1)) if m else ('name', re.sub(r'\s+', ' ', n.strip().lower()))

def build(fresh):
    idx = collections.defaultdict(dict)
    for v, d in D.items():
        for it in d['items']:
            if it['price'] is None: continue
            isf = any(f in (it['cat'] or '').lower() for f in FRESH)
            if isf != fresh: continue
            idx[key(it['name'])][v] = it['price'] / 100
    return {k: v for k, v in idx.items() if len(v) >= 6}

for label, fresh in [('СВЕЖИЕ (овощи/фрукты)', True), ('УПАКОВАННЫЕ (бакалея, молочка)', False)]:
    sh = build(fresh)
    if not sh:
        print(label, '— нет пересечений'); continue
    same = sum(1 for k, v in sh.items() if len(set(v.values())) == 1)
    print(f'\n=== {label}: товаров в 6+ точках {len(sh)}, цена одинакова везде {same} ({round(100*same/len(sh))}%)')
    vs = list(D.keys())
    print(' ' * 46 + ' '.join(f'{i+1:3d}' for i in range(len(vs))))
    for a in vs:
        row = []
        for b in vs:
            common = [k for k in sh if a in sh[k] and b in sh[k]]
            eq = sum(1 for k in common if sh[k][a] == sh[k][b])
            row.append(f'{round(100*eq/len(common)) if common else 0:3d}')
        print(f'{a[:33]:35}{D[a]["format"][:11]:11}' + ' '.join(row))
