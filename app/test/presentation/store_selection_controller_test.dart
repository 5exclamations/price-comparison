import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qiymet/data/cache/catalog_cache.dart';
import 'package:qiymet/data/cache/selection_store.dart';
import 'package:qiymet/domain/models/deal.dart';
import 'package:qiymet/domain/models/store.dart';
import 'package:qiymet/domain/models/store_selection.dart';
import 'package:qiymet/presentation/providers/store_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

Store bravo(int id, String name) => Store(
  storeId: id,
  chainId: 2,
  chainCode: 'bravo',
  chainName: 'Bravo',
  priceModel: 'per_cluster',
  name: name,
  synthetic: false,
);

Deal deal(int id) => Deal(
  dealId: id,
  productId: id,
  name: 'Товар $id',
  chainCode: 'bravo',
  priceMinor: 100,
  oldPriceMinor: 200,
  marketPriceMinor: 180,
  referenceChains: 2,
  claimedDiscount: 0.5,
  realDiscount: 0.44,
  inflation: 0.06,
  inflated: false,
  observedAt: DateTime.utc(2026, 8, 17),
);

void main() {
  late CatalogCache cache;
  late SelectionStore selectionStore;
  late StoreSelectionController controller;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});

    cache = CatalogCache(NativeDatabase.memory());
    selectionStore = SelectionStore(await SharedPreferences.getInstance());
    controller = StoreSelectionController(selectionStore, cache);
  });

  tearDown(() => cache.close());

  test('отметить и снять сеть', () async {
    await controller.toggleChain('araz');
    expect(controller.state.contains('araz'), isTrue);

    await controller.toggleChain('araz');
    expect(controller.state.contains('araz'), isFalse);
  });

  test('можно выбрать несколько сетей: человек ходит в две-три', () async {
    await controller.toggleChain('araz');
    await controller.toggleChain('spar');
    await controller.toggleChain('rahat');
    expect(controller.state.chainCodes, {'araz', 'spar', 'rahat'});
  });

  test('выбор магазина отмечает и его сеть', () async {
    await controller.pickStore(bravo(3, 'Bravo Superstore 28 Mall'));
    expect(controller.state.contains('bravo'), isTrue);
    expect(controller.state.storeId, 3);
    expect(controller.state.pickedStoreName, 'Bravo Superstore 28 Mall');
  });

  test('снятие сети сбрасывает её магазин', () async {
    // Иначе в запрос уйдёт store_id сети, которую пользователь больше не выбрал.
    await controller.pickStore(bravo(3, 'Bravo Superstore 28 Mall'));
    await controller.toggleChain('bravo');

    expect(controller.state.contains('bravo'), isFalse);
    expect(controller.state.storeId, isNull);
    expect(controller.state.pickedStoreChainCode, isNull);
  });

  test('выбор переживает перезапуск приложения', () async {
    await controller.pickStore(bravo(4, 'Bravo Ekspress Hovsan'));
    await controller.toggleChain('araz');

    // Новый контроллер читает то же хранилище — как после перезапуска.
    final restored = StoreSelectionController(selectionStore, cache);
    expect(restored.state.storeId, 4);
    expect(restored.state.chainCodes, {'bravo', 'araz'});
    expect(restored.state.pickedStoreName, 'Bravo Ekspress Hovsan');
  });

  group('смена магазина выбрасывает кеш цен', () {
    test('иначе человек увидит цифры прошлой точки', () async {
      await controller.pickStore(bravo(3, 'зона B'));
      await cache.putDeals(storeId: 3, items: [deal(1), deal(2)]);
      expect((await cache.deals(storeId: 3)).value.length, 2);

      // Переехал в другой магазин той же сети — цены там другие.
      await controller.pickStore(bravo(4, 'зона C'));

      expect(
        (await cache.deals(storeId: 3)).value,
        isEmpty,
        reason: 'кеш прошлой точки обязан быть выброшен',
      );
      expect((await cache.deals(storeId: 4)).value, isEmpty);
    });

    test('повторный выбор того же магазина кеш не трогает', () async {
      await controller.pickStore(bravo(3, 'Bravo'));
      await cache.putDeals(storeId: 3, items: [deal(1)]);

      await controller.pickStore(bravo(3, 'Bravo'));

      expect(
        (await cache.deals(storeId: 3)).value.length,
        1,
        reason: 'магазин не менялся — сбрасывать нечего',
      );
    });

    test('снятие сети с магазином тоже чистит кеш', () async {
      await controller.pickStore(bravo(3, 'Bravo'));
      await cache.putDeals(storeId: 3, items: [deal(1)]);

      await controller.toggleChain('bravo');

      expect((await cache.deals(storeId: 3)).value, isEmpty);
    });

    test('отметка сети с единой ценой кеш не сбрасывает', () async {
      await cache.putDeals(storeId: null, items: [deal(1)]);
      await controller.toggleChain('araz');

      expect(
        (await cache.deals(storeId: null)).value.length,
        1,
        reason: 'store_id не менялся, цены те же',
      );
    });

    test('reset чистит и выбор, и кеш', () async {
      await controller.pickStore(bravo(3, 'Bravo'));
      await cache.putDeals(storeId: 3, items: [deal(1)]);

      await controller.reset();

      expect(controller.state, StoreSelection.empty);
      expect((await cache.deals(storeId: 3)).value, isEmpty);
      expect(
        StoreSelectionController(selectionStore, cache).state,
        StoreSelection.empty,
      );
    });
  });
}
