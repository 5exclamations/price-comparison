#!/usr/bin/env python3
"""Автономная HTML-витрина поверх qiymet.db: поиск товара и цены по трём сетям."""
import sqlite3, json, html, datetime, os

con = sqlite3.connect(os.environ.get('QIYMET_SQLITE', 'qiymet.db'))
con.row_factory = sqlite3.Row

COLS = [('bazarstore', 'Bazarstore', 'единая цена по сети'),
        ('araz',       'Araz',       'единая цена, проверено на 8 филиалах'),
        ('spar',       'SPAR',       'премиальный формат Araz'),
        ('neptun',     'Neptun',     'единая цена, проверено на 3 филиалах'),
        ('rahat',      'Rahat',      'Rahat Gourmet'),
        ('bravo:A1',   'Bravo A1',   'Koroğlu · 20 Yanvar · Radiozavod'),
        ('bravo:A2',   'Bravo A2',   'Nərimanov · Şərifzadə'),
        ('bravo:B',    'Bravo B',    '28 Mall · Gənclik Mall · Qala · Zirə'),
        ('bravo:C',    'Bravo C',    'Hövsan')]

rows = con.execute("""
SELECT p.id, p.ean, p.name, c.code AS chain, s.price_cluster AS cl,
       cp.price, cp.old_price, cp.observed_at
FROM products p
JOIN store_items si    ON si.product_id = p.id
JOIN chains c          ON c.id = si.chain_id
LEFT JOIN stores s     ON s.id = si.store_id
JOIN current_prices cp ON cp.store_item_id = si.id
WHERE p.quarantined = 0
""").fetchall()

prod = {}
for r in rows:
    d = prod.setdefault(r['id'], {'ean': r['ean'] or '', 'name': r['name'], 'offers': {}})
    key = r['chain'] if r['chain'] != 'bravo' else f"bravo:{r['cl'] or '?'}"
    o = d['offers'].get(key)
    # на сеть берём минимальную из наблюдений, это цена, которую реально заплатит покупатель
    if o is None or r['price'] < o['p']:
        d['offers'][key] = {'p': r['price'], 'o': r['old_price']}

items = []
for d in prod.values():
    if len({k.split(':')[0] for k in d['offers']}) < 2:
        continue                                  # сравнивать не с чем: только одна сеть
    pr = [o['p'] for o in d['offers'].values()]
    d['min'], d['max'] = min(pr), max(pr)
    d['spread'] = round(100 * (d['max'] - d['min']) / d['min']) if d['min'] else 0
    d['promo'] = any(o['o'] for o in d['offers'].values())
    items.append(d)
items.sort(key=lambda x: -x['spread'])

# лента выгод: скидка считается против рынка, а не против ценника сети
import honesty
DEALS = sorted(honesty.analyse(honesty.load()), key=lambda x: -x['real'])
seen, deals = set(), []
for r in DEALS:
    k = (r['ean'], r['chain'])
    if k in seen or r['real'] <= 0.05:
        continue
    seen.add(k)
    deals.append({'n': r['name'], 'e': r['ean'], 'c': r['chain'], 'z': r['cluster'] or '',
                  'p': r['price'], 'o': r['old'], 'm': r['market'],
                  'r': round(100 * r['real']), 'cl': round(100 * r['claimed'])})
n_infl = sum(1 for d in deals if d['cl'] - d['r'] > 15)

n_q = con.execute('SELECT COUNT(*) FROM products WHERE quarantined = 1').fetchone()[0]
n_promo = sum(1 for d in items if d['promo'])
built = datetime.datetime.now().strftime('%d.%m.%Y %H:%M')
print(f'товаров для сравнения: {len(items)}, с акцией: {n_promo}, в карантине: {n_q}')
print(f'выгод в ленте: {len(deals)}, из них с накрученной старой ценой: {n_infl}')

DOC = """<!doctype html>
<html lang="az"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>qiymət — market qiymətlərinin müqayisəsi</title>
<style>
 :root{--bg:#0f1115;--card:#171a21;--line:#242833;--tx:#e7e9ee;--dim:#8b90a0;
       --lo:#3fb950;--hi:#f0883e;--acc:#4c8dff;--pr:#d29922}
 @media(prefers-color-scheme:light){:root{--bg:#f6f7f9;--card:#fff;--line:#e3e6ec;
       --tx:#1b1d23;--dim:#6b7280;--lo:#1a7f37;--hi:#bc4c00;--pr:#9a6700}}
 *{box-sizing:border-box}
 body{margin:0;background:var(--bg);color:var(--tx);
      font:15px/1.5 -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif}
 .wrap{max-width:1120px;margin:0 auto;padding:28px 18px 60px}
 h1{font-size:22px;margin:0 0 4px;font-weight:650}
 .sub{color:var(--dim);font-size:13px;margin-bottom:18px}
 .bar{display:flex;gap:10px;margin-bottom:12px;flex-wrap:wrap;align-items:center}
 input{flex:1;min-width:220px;padding:11px 14px;border-radius:10px;border:1px solid var(--line);
       background:var(--card);color:var(--tx);font-size:15px;outline:none}
 input:focus{border-color:var(--acc)}
 label{font-size:13px;color:var(--dim);display:flex;gap:6px;align-items:center;cursor:pointer}
 .stat{display:flex;gap:20px;margin-bottom:16px;color:var(--dim);font-size:13px;flex-wrap:wrap}
 .stat b{color:var(--tx);font-weight:600}
 table{width:100%;border-collapse:collapse;background:var(--card);
       border:1px solid var(--line);border-radius:12px;overflow:hidden}
 th,td{padding:10px 11px;text-align:right;border-bottom:1px solid var(--line);
       font-variant-numeric:tabular-nums;white-space:nowrap}
 th{font-size:11px;text-transform:uppercase;letter-spacing:.05em;color:var(--dim);
    font-weight:600;cursor:help}
 th:first-child,td:first-child{text-align:left;white-space:normal;min-width:250px}
 tbody tr:last-child td{border-bottom:none}
 tbody tr:hover{background:rgba(127,127,127,.06)}
 .nm{font-size:14px}
 .ean{color:var(--dim);font-size:11px;font-variant-numeric:tabular-nums}
 .lo{color:var(--lo);font-weight:650}
 .hi{color:var(--hi)}
 .none{color:var(--dim)}
 .old{display:block;font-size:10px;color:var(--pr);text-decoration:line-through;line-height:1.2}
 .sp{font-size:12px;color:var(--dim)}
 .sp.big{color:var(--hi);font-weight:600}
 .tag{display:inline-block;margin-left:6px;padding:0 5px;border-radius:4px;font-size:10px;
      background:rgba(210,153,34,.16);color:var(--pr);vertical-align:1px}
 .note{margin-top:16px;color:var(--dim);font-size:12px;line-height:1.75}
 .empty{padding:30px;text-align:center;color:var(--dim)}
 .tabs{display:flex;gap:4px;margin-bottom:14px;border-bottom:1px solid var(--line)}
 .tab{padding:8px 14px;font-size:14px;color:var(--dim);cursor:pointer;border-bottom:2px solid transparent}
 .tab.on{color:var(--tx);border-bottom-color:var(--acc);font-weight:600}
 .chain{display:inline-block;padding:1px 7px;border-radius:5px;font-size:11px;
        background:rgba(76,141,255,.14);color:var(--acc)}
 .warn{display:inline-block;margin-left:6px;padding:0 5px;border-radius:4px;font-size:10px;
       background:rgba(240,136,62,.16);color:var(--hi)}
 .big{font-weight:650;color:var(--lo)}
</style></head><body><div class="wrap">
<h1>qiymət</h1>
<div class="sub">Сравнение цен по сетям Азербайджана. Демо на живых данных, снято __BUILT__.</div>
<div class="tabs">
  <div class="tab on" data-v="cmp">Сравнение цен</div>
  <div class="tab" data-v="deal">Выгоды сегодня · __ND__</div>
</div>
<div class="bar">
  <input id="q" placeholder="Поиск: süd, çay, kola, şəkər, huggies…" autocomplete="off">
  <label id="lp"><input type="checkbox" id="onlyp"> только акции</label>
  <label id="lh" style="display:none"><input type="checkbox" id="hidefake"> скрыть накрученные</label>
</div>
<div class="stat">
  <span>сравнивается: <b>__N__</b></span>
  <span>сетей: <b>6</b></span>
  <span>ценовых зон Bravo: <b>4</b></span>
  <span>с акцией: <b>__NP__</b></span>
  <span>в карантине: <b>__NQ__</b></span>
  <span id="shown"></span>
</div>
<table id="tcmp"><thead><tr><th>Товар</th>__HEAD__<th>разброс</th></tr></thead>
<tbody id="tb"></tbody></table>
<table id="tdeal" style="display:none"><thead><tr><th>Товар</th><th>Где</th>
<th title="цена по акции">цена</th><th title="медиана обычных цен на этот же штрихкод в других сетях">рынок</th>
<th title="ценник сети: было / стало">заявлено</th>
<th title="насколько дешевле рынка на самом деле">реально</th></tr></thead>
<tbody id="tbd"></tbody></table>
<div class="empty" id="empty" style="display:none">Ничего не найдено</div>
<div class="note" id="ncmp">
Зачёркнутая цифра — цена до акции, так что скидку видно отдельно от базовой цены.
Зоны Bravo A1…C получены замером совпадения цен, а не форматом магазина: в зоне B
лежат Superstore, Supermarket и Ekspress с одинаковыми ценами. У Araz цена по филиалам
совпадает на 89–100%, поэтому зон нет. Склейка идёт по штрихкоду EAN-13; товары, где
фасовка или цена расходятся подозрительно сильно, отправлены в карантин и здесь не показаны.
</div>
<div class="note" id="ndeal" style="display:none">
Скидка здесь считается не от ценника сети, а от рынка: берётся медиана обычных,
неакционных цен на этот же штрихкод в других сетях. Поэтому «заявлено −55%» и
«реально −25%» — нормальная ситуация, и такие позиции помечены. Товары, где рынок
сам выглядит аномально (втрое дешевле или дороже заявленной старой цены), из расчёта
исключены: там врёт эталон, а не акция.
</div>
</div>
<script>
const DATA = __DATA__, COLS = __COLS__, DEALS = __DEALS__;
const CH = {bazarstore:'Bazarstore', araz:'Araz', bravo:'Bravo'};
const tb=document.getElementById('tb'), q=document.getElementById('q'),
      onlyp=document.getElementById('onlyp'), shown=document.getElementById('shown'),
      empty=document.getElementById('empty');
// Турецкая İ — ловушка: 'İ'.toLowerCase() даёт 'i' плюс отдельный combining dot
// U+0307, и поиск «milka» перестаёт находить «MİLKA». Поэтому сначала заменяем
// заглавные азербайджанские буквы, потом опускаем регистр, потом сносим остатки
// комбинирующих знаков.
function az(s){return s.replace(/İ/g,'i').replace(/I/g,'i').replace(/Ə/g,'a')
  .replace(/Ö/g,'o').replace(/Ü/g,'u').replace(/Ç/g,'c').replace(/Ş/g,'s').replace(/Ğ/g,'g')
  .toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g,'')
  .replace(/ə/g,'a').replace(/ı/g,'i').replace(/ö/g,'o')
  .replace(/ü/g,'u').replace(/ç/g,'c').replace(/ş/g,'s').replace(/ğ/g,'g');}
function m(v){return (v/100).toFixed(2);}
function render(list){
  tb.innerHTML = list.slice(0,300).map(function(d){
    var cells = COLS.map(function(c){
      var o = d.o[c[0]];
      if(!o) return '<td class="none">—</td>';
      var cls = o.p===d.min ? 'lo' : (o.p===d.max ? 'hi' : '');
      return '<td class="'+cls+'">'+m(o.p)+(o.o?'<span class="old">'+m(o.o)+'</span>':'')+'</td>';
    }).join('');
    return '<tr><td><div class="nm">'+d.n+(d.pr?'<span class="tag">акция</span>':'')+
           '</div><div class="ean">'+d.e+'</div></td>'+cells+
           '<td class="sp'+(d.s>=10?' big':'')+'">'+(d.s?d.s+'%':'—')+'</td></tr>';
  }).join('');
  shown.textContent='показано: '+Math.min(list.length,300)+' из '+list.length;
  empty.style.display=list.length?'none':'block';
}
function apply(){
  var v=az(q.value.trim()), p=onlyp.checked;
  render(DATA.filter(function(d){
    if(p && !d.pr) return false;
    return !v || az(d.n).includes(v) || (d.e && d.e.includes(v));
  }));
}
function renderDeals(list){
  document.getElementById('tbd').innerHTML = list.slice(0,300).map(function(d){
    var infl = d.cl - d.r > 15;
    return '<tr><td><div class="nm">'+d.n+(infl?'<span class="warn">старая цена накручена</span>':'')+
      '</div><div class="ean">'+d.e+'</div></td>'+
      '<td><span class="chain">'+CH[d.c]+(d.z&&d.z!=='ALL'?' '+d.z:'')+'</span></td>'+
      '<td class="big">'+m(d.p)+'</td><td>'+m(d.m)+'</td>'+
      '<td class="sp">'+m(d.o)+' &rarr; '+m(d.p)+' ('+(-d.cl)+'%)</td>'+
      '<td class="lo">'+(-d.r)+'%</td></tr>';
  }).join('');
  shown.textContent='показано: '+Math.min(list.length,300)+' из '+list.length;
  empty.style.display=list.length?'none':'block';
}
var view='cmp';
function apply2(){
  var v=az(q.value.trim()), hf=document.getElementById('hidefake').checked;
  renderDeals(DEALS.filter(function(d){
    if(hf && d.cl-d.r>15) return false;
    return !v || az(d.n).includes(v) || (d.e && d.e.includes(v));
  }));
}
function run(){ view==='cmp' ? apply() : apply2(); }
document.querySelectorAll('.tab').forEach(function(t){
  t.addEventListener('click',function(){
    document.querySelectorAll('.tab').forEach(function(x){x.classList.remove('on')});
    t.classList.add('on'); view=t.dataset.v;
    var c = view==='cmp';
    document.getElementById('tcmp').style.display = c?'':'none';
    document.getElementById('tdeal').style.display = c?'none':'';
    document.getElementById('ncmp').style.display = c?'':'none';
    document.getElementById('ndeal').style.display = c?'none':'';
    document.getElementById('lp').style.display = c?'':'none';
    document.getElementById('lh').style.display = c?'none':'';
    run();
  });
});
q.addEventListener('input',run);
onlyp.addEventListener('change',run);
document.getElementById('hidefake').addEventListener('change',run);
run();
</script></body></html>"""

data = [{'n': d['name'], 'e': d['ean'], 'min': d['min'], 'max': d['max'],
         's': d['spread'], 'pr': 1 if d['promo'] else 0, 'o': d['offers']} for d in items]

head = ''.join(f'<th title="{html.escape(t)}">{html.escape(lbl)}</th>' for _, lbl, t in COLS)
out = (DOC.replace('__DATA__', json.dumps(data, ensure_ascii=False))
          .replace('__COLS__', json.dumps([[k, l] for k, l, _ in COLS], ensure_ascii=False))
          .replace('__HEAD__', head).replace('__N__', str(len(items)))
          .replace('__NP__', str(n_promo)).replace('__NQ__', str(n_q))
          .replace('__DEALS__', json.dumps(deals, ensure_ascii=False))
          .replace('__ND__', str(len(deals)))
          .replace('__BUILT__', built))
open('demo.html', 'w', encoding='utf-8').write(out)
print('demo.html записан,', round(len(out) / 1024), 'КБ')
