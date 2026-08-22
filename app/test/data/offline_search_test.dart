import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qiymet/data/cache/catalog_cache.dart';
import 'package:qiymet/domain/models/product_card.dart';
import 'package:qiymet/domain/models/product_summary.dart';

ProductSummary product(int id, String name, {int? price = 1000}) =>
    ProductSummary(
      productId: id,
      name: name,
      unitValue: 1000,
      unitType: 'g',
      bestPriceMinor: price,
      bestPriceChain: 'araz',
      chainsCount: 3,
      hasPromo: false,
      observedAt: DateTime.utc(2026, 8, 17, 11, 20),
    );

void main() {
  late CatalogCache cache;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    cache = CatalogCache(NativeDatabase.memory());
  });

  tearDown(() => cache.close());

  group('оффлайн отдаёт ответ на ТОТ ЖЕ запрос', () {
    test('сохранённый запрос находится', () async {
      await cache.putSearchResults(
        query: 'süd',
        storeId: null,
        items: [product(1, 'Süd 1 l'), product(2, 'Süd 2.5%')],
      );

      final cached = await cache.cachedSearch(query: 'süd', storeId: null);
      expect(cached, isNotNull);
      expect(cached!.value.map((p) => p.productId), [1, 2]);
      expect(cached.fromCache, isTrue);
      expect(cached.cachedAt, isNotNull);
      expect(
        cached.needsStaleWarning,
        isTrue,
        reason: 'плашка «данные от 14:20» обязана показаться',
      );
    });

    test('другой запрос НЕ подменяется чужим ответом', () async {
      // Человек ищет молоко, а видит стиральный порошок под плашкой «данные
      // от 14:20» — так делать нельзя.
      await cache.putSearchResults(
        query: 'süd',
        storeId: null,
        items: [product(1, 'Süd 1 l')],
      );

      expect(await cache.cachedSearch(query: 'çörək', storeId: null), isNull);
    });

    test('запрос находится независимо от регистра и диакритики', () async {
      await cache.putSearchResults(
        query: 'ŞƏKƏR',
        storeId: null,
        items: [product(3, 'Şəkər tozu 1 kq')],
      );

      // Ключ строится по normalizeAz, поэтому «sakar» и «ŞƏKƏR» — один запрос.
      final cached = await cache.cachedSearch(query: 'sakar', storeId: null);
      expect(cached?.value.single.productId, 3);
    });

    test('ключ включает магазин', () async {
      // У сети с несколькими прайсами ответ на один и тот же запрос в разных
      // магазинах разный. Общий ключ подсунул бы цены чужой точки.
      await cache.putSearchResults(
        query: 'süd',
        storeId: 3,
        items: [product(1, 'Süd', price: 100)],
      );

      expect(await cache.cachedSearch(query: 'süd', storeId: 4), isNull);
      expect(
        (await cache.cachedSearch(
          query: 'süd',
          storeId: 3,
        ))!.value.single.bestPriceMinor,
        100,
      );
    });

    test('порядок выдачи сохраняется', () async {
      // Сервер сортирует по релевантности; пересортировка кешем сбила бы её.
      await cache.putSearchResults(
        query: 'çay',
        storeId: null,
        items: [product(9, 'A'), product(3, 'B'), product(7, 'C')],
      );

      final cached = await cache.cachedSearch(query: 'çay', storeId: null);
      expect(cached!.value.map((p) => p.productId), [9, 3, 7]);
    });

    test('повторный поиск обновляет и список, и время', () async {
      await cache.putSearchResults(
        query: 'süd',
        storeId: null,
        items: [product(1, 'Süd')],
      );
      final first = await cache.cachedSearch(query: 'süd', storeId: null);

      // Секунда с небольшим, а не 5 мс: drift хранит время в СЕКУНДАХ эпохи,
      // и более мелкая разница в кеш просто не помещается.
      await Future<void>.delayed(const Duration(milliseconds: 1100));
      await cache.putSearchResults(
        query: 'süd',
        storeId: null,
        items: [product(1, 'Süd'), product(2, 'Süd 2')],
      );
      final second = await cache.cachedSearch(query: 'süd', storeId: null);

      expect(second!.value.length, 2);
      expect(second.cachedAt!.isAfter(first!.cachedAt!), isTrue);
    });

    test('пустой результат тоже кешируется', () async {
      // «Ничего не нашлось» — это ответ, и оффлайн его лучше повторить,
      // чем показать ошибку.
      await cache.putSearchResults(query: 'zzzz', storeId: null, items: []);

      final cached = await cache.cachedSearch(query: 'zzzz', storeId: null);
      expect(cached, isNotNull);
      expect(cached!.value, isEmpty);
    });

    test('время наблюдения переживает кеш', () async {
      // Цена без времени наблюдения не показывается — значит, и в кеше оно
      // обязано лежать рядом.
      await cache.putSearchResults(
        query: 'süd',
        storeId: null,
        items: [product(1, 'Süd')],
      );

      final cached = await cache.cachedSearch(query: 'süd', storeId: null);
      expect(
        cached!.value.single.observedAt,
        DateTime.utc(2026, 8, 17, 11, 20),
      );
    });
  });

  group('список покупок', () {
    test('добавить, отметить, удалить', () async {
      await cache.addProduct(productId: 1, name: 'Süd 1 l');
      expect(await cache.isInList(1), isTrue);

      final items = await cache.basketOnce();
      await cache.setDone(items.single.id, true);
      expect((await cache.basketOnce()).single.done, isTrue);

      await cache.removeByProduct(1);
      expect(await cache.isInList(1), isFalse);
    });

    test('повторное добавление не плодит строки', () async {
      await cache.addProduct(productId: 1, name: 'Süd');
      await cache.addProduct(productId: 1, name: 'Süd');
      expect((await cache.basketOnce()).length, 1);
    });

    test('ручные позиции можно записать несколько раз', () async {
      // «хлеб» и «ещё хлеб» — законный случай, в отличие от товара каталога.
      await cache.addManual('çörək');
      await cache.addManual('çörək');
      expect((await cache.basketOnce()).length, 2);
      expect((await cache.basketOnce()).every((i) => i.isManual), isTrue);
    });

    test('пустая строка не добавляется', () async {
      await cache.addManual('   ');
      expect(await cache.basketOnce(), isEmpty);
    });

    test('купленные уезжают вниз', () async {
      await cache.addProduct(productId: 1, name: 'A');
      await cache.addProduct(productId: 2, name: 'B');
      final items = await cache.basketOnce();
      await cache.setDone(items.first.id, true);

      final sorted = await cache.basketOnce();
      expect(sorted.last.done, isTrue);
      expect(sorted.first.done, isFalse);
    });

    test('смена магазина обнуляет цены, но не сам список', () async {
      // Позиции — выбор пользователя. Цены посчитаны для прошлого магазина,
      // и показывать их как свои нельзя.
      await cache.addProduct(productId: 1, name: 'Süd');
      await cache.putBasketPrices({
        1: [
          ChainPrice(
            chainId: 1,
            chainCode: 'araz',
            chainName: 'Araz',
            priceModel: 'single',
            priceMinor: 100,
            isPromo: false,
            available: true,
            observedAt: DateTime.utc(2026, 8, 17),
            source: 'test',
          ),
        ],
      });
      expect((await cache.basketOnce()).single.prices, hasLength(1));

      await cache.clearPrices();

      final after = await cache.basketOnce();
      expect(after, hasLength(1), reason: 'позиция обязана остаться');
      expect(after.single.prices, isEmpty, reason: 'цены прошлой точки — нет');
      expect(after.single.pricesUpdatedAt, isNull);
    });

    test('цены переживают перезапуск', () async {
      await cache.addProduct(productId: 1, name: 'Süd');
      await cache.putBasketPrices({
        1: [
          ChainPrice(
            chainId: 1,
            chainCode: 'araz',
            chainName: 'Araz',
            priceModel: 'single',
            priceMinor: 250,
            isPromo: false,
            available: true,
            observedAt: DateTime.utc(2026, 8, 17, 11, 20),
            source: 'test',
          ),
        ],
      });

      final item = (await cache.basketOnce()).single;
      expect(item.bestPriceIn({'araz'}), 250);
      expect(item.prices.single.observedAt, DateTime.utc(2026, 8, 17, 11, 20));
      expect(item.pricesUpdatedAt, isNotNull);
    });
  });
}
