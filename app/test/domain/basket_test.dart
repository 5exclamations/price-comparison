import 'package:flutter_test/flutter_test.dart';
import 'package:qiymet/domain/basket.dart';
import 'package:qiymet/domain/models/basket_item.dart';
import 'package:qiymet/domain/models/product_card.dart';

ChainPrice price(
  String chain,
  int minor, {
  bool needsStore = false,
  bool available = true,
}) => ChainPrice(
  chainId: chain.hashCode,
  chainCode: chain,
  chainName: chain,
  priceModel: needsStore ? 'per_cluster' : 'single',
  priceMinor: minor,
  isPromo: false,
  available: available,
  observedAt: DateTime.utc(2026, 8, 17),
  source: 'test',
  requiresStoreSelection: needsStore,
);

BasketItem item(int id, List<ChainPrice> prices) => BasketItem(
  id: id,
  productId: id,
  name: 'Товар $id',
  addedAt: DateTime.utc(2026, 8, 17),
  prices: prices,
);

BasketItem manual(int id) =>
    BasketItem(id: id, name: 'Хлеб', addedAt: DateTime.utc(2026, 8, 17));

void main() {
  group('формулировка из задания', () {
    test('«в Bravo — 47.30, разбить на две — 45.10, экономия 2.20»', () {
      final plan = planBasket(
        items: [
          item(1, [price('bravo', 2000), price('araz', 2200)]),
          item(2, [price('bravo', 1730), price('araz', 1510)]),
          item(3, [price('bravo', 1000), price('araz', 1200)]),
        ],
        chains: {'bravo', 'araz'},
      );

      expect(plan.bestSingle!.chainCode, 'bravo');
      expect(plan.bestSingle!.totalMinor, 4730);
      expect(plan.splits.single.totalMinor, 4510);
      expect(plan.splits.single.savingsMinor, 220);
      expect(plan.splits.single.storeCount, 2);
    });
  });

  group('разбиение не навязывается', () {
    test('одна сеть дешевле — разбиения нет вовсе', () {
      final plan = planBasket(
        items: [
          item(1, [price('araz', 100), price('spar', 200)]),
          item(2, [price('araz', 100), price('spar', 200)]),
        ],
        chains: {'araz', 'spar'},
      );
      expect(plan.hasSplit, isFalse);
      expect(plan.bestSingle!.totalMinor, 200);
    });

    test('ровно та же сумма — лишний магазин не предлагаем', () {
      // Вариант «на два магазина за те же деньги» — не выгода, а лишняя
      // поездка.
      final plan = planBasket(
        items: [
          item(1, [price('araz', 100), price('spar', 100)]),
          item(2, [price('araz', 100), price('spar', 100)]),
        ],
        chains: {'araz', 'spar'},
      );
      expect(plan.hasSplit, isFalse);
    });

    test('в набор не тащим сеть, которая ничего не выигрывает', () {
      final plan = planBasket(
        items: [
          item(1, [
            price('araz', 100),
            price('spar', 300),
            price('rahat', 300),
          ]),
          item(2, [
            price('araz', 300),
            price('spar', 100),
            price('rahat', 300),
          ]),
        ],
        chains: {'araz', 'spar', 'rahat'},
      );
      // rahat нигде не даёт лучшую цену — предлагать три магазина незачем.
      for (final s in plan.splits) {
        expect(s.chains, isNot(contains('rahat')));
      }
    });
  });

  group('неполные сети', () {
    test('сеть без части товаров не становится лучшей', () {
      // Иначе она выглядела бы дешевле просто потому, что в ней меньше
      // товаров.
      final plan = planBasket(
        items: [
          item(1, [price('araz', 100), price('spar', 150)]),
          item(2, [price('spar', 150)]),
        ],
        chains: {'araz', 'spar'},
      );
      expect(plan.bestSingle!.chainCode, 'spar');
      final araz = plan.perChain.firstWhere((c) => c.chainCode == 'araz');
      expect(araz.missing, 1);
      expect(araz.isComplete, isFalse);
    });

    test('полные идут впереди неполных', () {
      final plan = planBasket(
        items: [
          item(1, [price('araz', 100), price('spar', 150)]),
          item(2, [price('spar', 150)]),
        ],
        chains: {'araz', 'spar'},
      );
      expect(plan.perChain.first.isComplete, isTrue);
    });

    test('ни одна сеть не закрывает список — так и говорим', () {
      final plan = planBasket(
        items: [
          item(1, [price('araz', 100)]),
          item(2, [price('spar', 100)]),
        ],
        chains: {'araz', 'spar'},
      );
      expect(plan.bestSingle, isNull);
      expect(plan.splits.single.totalMinor, 200);
    });
  });

  group('что в расчёт не идёт', () {
    test('цена сети, требующей выбора магазина', () {
      // Любая из нескольких зон, подставленная в сумму, сделала бы итог
      // выдумкой.
      final plan = planBasket(
        items: [
          item(1, [price('bravo', 100, needsStore: true), price('araz', 300)]),
        ],
        chains: {'bravo', 'araz'},
      );
      expect(plan.bestSingle!.chainCode, 'araz');
      expect(plan.bestSingle!.totalMinor, 300);
    });

    test('товар, которого нет в наличии', () {
      final plan = planBasket(
        items: [
          item(1, [price('araz', 100, available: false), price('spar', 300)]),
        ],
        chains: {'araz', 'spar'},
      );
      expect(plan.bestSingle!.chainCode, 'spar');
    });

    test('сеть, которую пользователь не выбирал', () {
      final plan = planBasket(
        items: [
          item(1, [price('araz', 100)]),
          item(2, [price('oba', 50)]),
        ],
        chains: {'araz'},
      );
      expect(plan.pricedItems, 1);
      expect(plan.unpricedItems, 1);
    });
  });

  group('ручные позиции', () {
    test('не входят в сумму и не портят её молча', () {
      final plan = planBasket(
        items: [
          manual(1),
          item(2, [price('araz', 100)]),
        ],
        chains: {'araz'},
      );
      expect(plan.bestSingle!.totalMinor, 100);
      expect(plan.manualItems, 1);
      expect(plan.pricedItems, 1);
    });

    test('корзина из одних ручных даёт пустой расчёт', () {
      final plan = planBasket(items: [manual(1), manual(2)], chains: {'araz'});
      expect(plan.isEmpty, isTrue);
      expect(plan.manualItems, 2);
      expect(plan.bestSingle, isNull);
    });
  });

  group('края', () {
    test('пустая корзина', () {
      expect(planBasket(items: const [], chains: {'araz'}).isEmpty, isTrue);
    });

    test('сети не выбраны', () {
      final plan = planBasket(
        items: [
          item(1, [price('araz', 100)]),
        ],
        chains: const {},
      );
      expect(plan.isEmpty, isTrue);
      expect(plan.perChain, isEmpty);
    });

    test('разбиение никогда не дороже лучшей одной сети', () {
      final plan = planBasket(
        items: [
          item(1, [price('a', 500), price('b', 300), price('c', 700)]),
          item(2, [price('a', 200), price('b', 900), price('c', 250)]),
          item(3, [price('a', 400), price('b', 450), price('c', 380)]),
        ],
        chains: {'a', 'b', 'c'},
      );
      for (final s in plan.splits) {
        expect(s.totalMinor, lessThanOrEqualTo(plan.bestSingle!.totalMinor));
        expect(s.savingsMinor, greaterThan(0));
      }
    });

    test('каждое следующее разбиение дешевле предыдущего', () {
      final plan = planBasket(
        items: [
          item(1, [price('a', 100), price('b', 500), price('c', 500)]),
          item(2, [price('a', 500), price('b', 100), price('c', 500)]),
          item(3, [price('a', 500), price('b', 500), price('c', 100)]),
        ],
        chains: {'a', 'b', 'c'},
      );
      for (var i = 1; i < plan.splits.length; i++) {
        expect(
          plan.splits[i].totalMinor,
          lessThan(plan.splits[i - 1].totalMinor),
        );
      }
    });
  });

  group('bestPriceIn у позиции', () {
    test('берёт минимум среди выбранных сетей', () {
      final i = item(1, [price('araz', 300), price('spar', 200)]);
      expect(i.bestPriceIn({'araz', 'spar'}), 200);
      expect(i.bestChainIn({'araz', 'spar'}), 'spar');
      expect(i.bestPriceIn({'araz'}), 300);
    });

    test('пропускает то, что нельзя показывать', () {
      final i = item(1, [
        price('bravo', 100, needsStore: true),
        price('araz', 300),
      ]);
      expect(i.bestPriceIn({'bravo', 'araz'}), 300);
    });

    test('null, если позиции нет ни в одной выбранной сети', () {
      expect(item(1, [price('oba', 100)]).bestPriceIn({'araz'}), isNull);
    });
  });
}
