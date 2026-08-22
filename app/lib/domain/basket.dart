import 'models/basket_item.dart';

/// Итог по одной сети.
class ChainTotal {
  const ChainTotal({
    required this.chainCode,
    required this.chainName,
    required this.totalMinor,
    required this.covered,
    required this.missing,
  });

  final String chainCode;
  final String chainName;

  /// Сумма по тем позициям, что в этой сети ЕСТЬ.
  final int totalMinor;

  final int covered;

  /// Сколько позиций сеть не закрывает. Молчать про них нельзя: человек
  /// приедет за десятью товарами, а купит семь.
  final int missing;

  bool get isComplete => missing == 0;
}

/// Вариант «разбить на несколько сетей».
class SplitOption {
  const SplitOption({
    required this.chains,
    required this.totalMinor,
    required this.savingsMinor,
  });

  /// Коды сетей, по которым предлагается разложить корзину.
  final List<String> chains;
  final int totalMinor;

  /// Насколько дешевле лучшей ОДНОЙ сети. Может быть нулём.
  final int savingsMinor;

  int get storeCount => chains.length;
}

/// Расчёт корзины.
class BasketPlan {
  const BasketPlan({
    required this.perChain,
    this.bestSingle,
    this.splits = const [],
    required this.pricedItems,
    required this.manualItems,
    required this.unpricedItems,
  });

  /// Итоги по каждой сети, полные впереди, дальше по возрастанию цены.
  final List<ChainTotal> perChain;

  /// Лучшая сеть, закрывающая корзину целиком. null — ни одна не закрывает.
  final ChainTotal? bestSingle;

  /// Варианты разбиения, от двух сетей и больше. Только те, что реально
  /// дешевле лучшей одной.
  final List<SplitOption> splits;

  final int pricedItems;

  /// Позиции, добавленные текстом: цены у них нет и быть не может.
  final int manualItems;

  /// Позиции с product_id, но без цены в выбранных сетях.
  final int unpricedItems;

  bool get isEmpty => pricedItems == 0;

  /// Есть ли смысл вообще показывать разбиение.
  bool get hasSplit => splits.isNotEmpty;
}

/// Посчитать корзину.
///
/// [chains] — сети, выбранные пользователем, в порядке от сервера.
/// [maxChains] — на сколько магазинов максимум предлагать разбить.
///
/// Три решения, которые здесь важнее кода.
///
/// **Разбиение не подаётся как обязательное.** По замерам корзина из 30
/// товаров, разложенная на три сети вместо одной лучшей, экономит медианно
/// 4.2%. Поэтому функция всегда возвращает [BasketPlan.bestSingle] первым, а
/// варианты разбиения — отдельным списком с абсолютной экономией в гяпиках.
/// Решает человек: два маната стоят второго магазина или нет.
///
/// **Неполные сети не прячутся.** Сеть, где нет трёх позиций из десяти, может
/// оказаться самой дешёвой по остатку — и показать её как «дешевле всех» было
/// бы обманом. Такие сети идут после полных и несут число непокрытых позиций.
///
/// **Цены, требующие выбора магазина, в расчёт не идут.** У сети с несколькими
/// прайсами любая из них, подставленная в сумму, сделала бы итог выдумкой.
BasketPlan planBasket({
  required List<BasketItem> items,
  required Set<String> chains,
  Map<String, String> chainNames = const {},
  int maxChains = 3,
}) {
  final manual = items.where((i) => i.productId == null).length;
  final withProduct = items.where((i) => i.productId != null).toList();

  // Цены только по выбранным сетям и только те, которые можно назвать.
  final usable = <BasketItem, Map<String, int>>{};
  for (final item in withProduct) {
    final byChain = <String, int>{};
    for (final p in item.prices) {
      if (!chains.contains(p.chainCode)) continue;
      if (p.requiresStoreSelection || !p.available) continue;
      final existing = byChain[p.chainCode];
      if (existing == null || p.priceMinor < existing) {
        byChain[p.chainCode] = p.priceMinor;
      }
    }
    if (byChain.isNotEmpty) usable[item] = byChain;
  }

  final priced = usable.length;
  final unpriced = withProduct.length - priced;

  if (priced == 0) {
    return BasketPlan(
      perChain: const [],
      pricedItems: 0,
      manualItems: manual,
      unpricedItems: unpriced,
    );
  }

  // ---------- итог по каждой сети ----------
  final perChain = <ChainTotal>[];
  for (final chain in chains) {
    var total = 0;
    var covered = 0;
    for (final byChain in usable.values) {
      final price = byChain[chain];
      if (price != null) {
        total += price;
        covered++;
      }
    }
    if (covered == 0) continue;
    perChain.add(
      ChainTotal(
        chainCode: chain,
        chainName: chainNames[chain] ?? chain,
        totalMinor: total,
        covered: covered,
        missing: priced - covered,
      ),
    );
  }

  // Полные сети впереди: неполная дешевле не потому, что выгоднее, а потому
  // что в ней меньше товаров.
  perChain.sort((a, b) {
    if (a.isComplete != b.isComplete) return a.isComplete ? -1 : 1;
    return a.totalMinor.compareTo(b.totalMinor);
  });

  final complete = perChain.where((c) => c.isComplete).toList();
  final bestSingle = complete.isEmpty ? null : complete.first;

  // ---------- разбиение ----------
  final codes = chains.toList()..sort();
  final splits = <SplitOption>[];

  for (var size = 2; size <= maxChains && size <= codes.length; size++) {
    SplitOption? best;

    for (final subset in _combinations(codes, size)) {
      var total = 0;
      var covered = 0;
      for (final byChain in usable.values) {
        int? cheapest;
        for (final c in subset) {
          final price = byChain[c];
          if (price != null && (cheapest == null || price < cheapest)) {
            cheapest = price;
          }
        }
        if (cheapest != null) {
          total += cheapest;
          covered++;
        }
      }
      // Разбиение имеет смысл, только если закрывает корзину целиком.
      if (covered != priced) continue;

      // Набор из size сетей, где одна фактически не нужна, — это тот же
      // набор поменьше. Такой вариант отбрасываем: он предложил бы лишний
      // магазин ради нуля.
      if (!_allChainsUsed(usable.values, subset)) continue;

      if (best == null || total < best.totalMinor) {
        best = SplitOption(
          chains: subset,
          totalMinor: total,
          savingsMinor: bestSingle == null ? 0 : bestSingle.totalMinor - total,
        );
      }
    }

    if (best == null) continue;
    // Показываем только то, что реально дешевле. Вариант «на два магазина
    // ровно за те же деньги» — не выгода, а лишняя поездка.
    if (bestSingle != null && best.savingsMinor <= 0) continue;
    // И только если он дешевле предыдущего, более скромного разбиения.
    if (splits.isNotEmpty && best.totalMinor >= splits.last.totalMinor)
      continue;
    splits.add(best);
  }

  return BasketPlan(
    perChain: perChain,
    bestSingle: bestSingle,
    splits: splits,
    pricedItems: priced,
    manualItems: manual,
    unpricedItems: unpriced,
  );
}

/// Все ли сети набора реально дают хоть одну самую дешёвую позицию.
bool _allChainsUsed(Iterable<Map<String, int>> items, List<String> subset) {
  final used = <String>{};
  for (final byChain in items) {
    String? winner;
    int? best;
    for (final c in subset) {
      final price = byChain[c];
      if (price != null && (best == null || price < best)) {
        best = price;
        winner = c;
      }
    }
    if (winner != null) used.add(winner);
  }
  return used.length == subset.length;
}

Iterable<List<String>> _combinations(List<String> source, int size) sync* {
  if (size == 0) {
    yield const [];
    return;
  }
  for (var i = 0; i <= source.length - size; i++) {
    for (final rest in _combinations(source.sublist(i + 1), size - 1)) {
      yield [source[i], ...rest];
    }
  }
}
