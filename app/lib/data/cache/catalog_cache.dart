import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/text.dart';
import '../../domain/models/basket_item.dart';
import '../../domain/models/deal.dart';
import '../../domain/models/freshness.dart';
import '../../domain/models/product_card.dart';
import '../../domain/models/product_summary.dart';
import 'chain_price_json.dart';

part 'catalog_cache.g.dart';

/// Товары, которые уже видели. Позволяет показать список без сети.
///
/// Деньги и здесь целые: IntColumn, а не RealColumn.
class CachedProducts extends Table {
  IntColumn get productId => integer()();
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get ean => text().nullable()();
  RealColumn get unitValue => real().nullable()();
  TextColumn get unitType => text().nullable()();
  IntColumn get bestPriceMinor => integer().nullable()();
  TextColumn get bestPriceChain => text().nullable()();
  IntColumn get chainsCount => integer().withDefault(const Constant(0))();
  BoolColumn get hasPromo => boolean().withDefault(const Constant(false))();
  BoolColumn get needsStoreSelection =>
      boolean().withDefault(const Constant(false))();

  /// Время НАБЛЮДЕНИЯ цены, а не время записи в кеш. Показывать цену без него
  /// нельзя, поэтому и в кеше оно обязано лежать рядом.
  DateTimeColumn get observedAt => dateTime().nullable()();

  /// Когда положили в кеш. По нему считается плашка «данные от 14:20».
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {productId};
}

/// Какие товары нашлись по конкретному запросу.
///
/// Ключ включает запрос И магазин: у сети с несколькими прайсами ответ на
/// «süd» в разных магазинах разный. Хранить один общий список значило бы
/// показать оффлайн цены чужой точки.
///
/// Оффлайн отдаём ответ ровно на тот запрос, который человек ввёл. Показать
/// вместо него «последние виденные товары» было бы подменой: человек ищет
/// молоко, а видит стиральный порошок с плашкой «данные от 14:20».
class CachedSearches extends Table {
  TextColumn get queryKey => text()();
  TextColumn get productIds => text()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {queryKey};
}

/// Последняя загруженная лента акций.
class CachedDeals extends Table {
  IntColumn get dealId => integer()();
  IntColumn get productId => integer()();
  TextColumn get name => text()();
  TextColumn get chainCode => text()();
  IntColumn get storeId => integer().nullable()();
  TextColumn get storeName => text().nullable()();
  IntColumn get priceMinor => integer()();
  IntColumn get oldPriceMinor => integer()();
  IntColumn get marketPriceMinor => integer()();
  RealColumn get claimedDiscount => real()();
  RealColumn get realDiscount => real()();
  RealColumn get inflation => real()();
  BoolColumn get inflated => boolean()();
  DateTimeColumn get observedAt => dateTime()();

  /// null = лента без выбранного магазина.
  IntColumn get scopeStoreId => integer().nullable()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {dealId};
}

/// Список покупок. Живёт только на устройстве: на сервере его нет и не нужно.
///
/// Ключ — собственный id, а не productId: позицию можно добавить текстом, без
/// товара из каталога. Уникальность по productId держит отдельный частичный
/// индекс, чтобы один и тот же товар не попал в список дважды, а ручных
/// «хлеб» можно было записать хоть три.
class ShoppingItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().nullable()();
  TextColumn get name => text()();
  RealColumn get unitValue => real().nullable()();
  TextColumn get unitType => text().nullable()();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  DateTimeColumn get addedAt => dateTime()();

  /// Цены по сетям, как их отдал сервер. Хранятся здесь, а не считаются на
  /// лету: список открывают в магазине, где связи может не быть вовсе.
  TextColumn get pricesJson => text().nullable()();
  DateTimeColumn get pricesUpdatedAt => dateTime().nullable()();
}

@DriftDatabase(
  tables: [CachedProducts, CachedSearches, CachedDeals, ShoppingItems],
)
class CatalogCache extends _$CatalogCache {
  CatalogCache([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'qiymet_cache'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    // Это кеш, а не источник правды: при смене схемы дешевле пересоздать
    // таблицы, чем писать миграции. Список покупок — исключение, он
    // пользовательский, поэтому переезжает отдельно.
    onUpgrade: (m, from, to) async {
      // Кеш цен пересоздаём молча: это не источник правды.
      await m.drop(cachedProducts);
      await m.drop(cachedSearches);
      await m.drop(cachedDeals);
      // Список покупок — пользовательские данные. Его переносим, а не
      // сносим: человек мог собрать корзину и обновить приложение по
      // дороге в магазин.
      if (from < 3) {
        await m.drop(shoppingItems);
      }
      await m.createAll();
    },
  );

  static String searchKey(String query, int? storeId) =>
      '${normalizeAzQuery(query)}|${storeId ?? 0}';

  // ---------- поиск ----------

  Future<void> putSearchResults({
    required String query,
    required int? storeId,
    required List<ProductSummary> items,
  }) async {
    final now = DateTime.now().toUtc();
    await batch((b) {
      b.insertAllOnConflictUpdate(cachedProducts, [
        for (final i in items)
          CachedProductsCompanion.insert(
            productId: Value(i.productId),
            name: i.name,
            brand: Value(i.brand),
            ean: Value(i.ean),
            unitValue: Value(i.unitValue),
            unitType: Value(i.unitType),
            bestPriceMinor: Value(i.bestPriceMinor),
            bestPriceChain: Value(i.bestPriceChain),
            chainsCount: Value(i.chainsCount),
            hasPromo: Value(i.hasPromo),
            needsStoreSelection: Value(i.needsStoreSelection),
            observedAt: Value(i.observedAt),
            cachedAt: now,
          ),
      ]);
      b.insert(
        cachedSearches,
        CachedSearchesCompanion.insert(
          queryKey: searchKey(query, storeId),
          productIds: items.map((i) => i.productId).join(','),
          cachedAt: now,
        ),
        onConflict: DoUpdate(
          (_) => CachedSearchesCompanion(
            productIds: Value(items.map((i) => i.productId).join(',')),
            cachedAt: Value(now),
          ),
        ),
      );
    });
  }

  /// Сохранённый ответ на этот же запрос. null — такого запроса не искали.
  Future<Fresh<List<ProductSummary>>?> cachedSearch({
    required String query,
    required int? storeId,
  }) async {
    final row =
        await (select(cachedSearches)
              ..where((t) => t.queryKey.equals(searchKey(query, storeId))))
            .getSingleOrNull();
    if (row == null) return null;

    final ids = row.productIds
        .split(',')
        .where((s) => s.isNotEmpty)
        .map(int.parse)
        .toList();
    if (ids.isEmpty) {
      return Fresh(
        value: const [],
        fromCache: true,
        cachedAt: _utc(row.cachedAt),
      );
    }

    final products = await (select(
      cachedProducts,
    )..where((t) => t.productId.isIn(ids))).get();
    final byId = {for (final p in products) p.productId: p};

    return Fresh(
      // Порядок сохраняем тот же, что отдал сервер: он отсортирован по
      // релевантности, и пересортировка кешем сбила бы выдачу.
      value: [
        for (final id in ids)
          if (byId[id] != null) _toSummary(byId[id]!),
      ],
      fromCache: true,
      cachedAt: _utc(row.cachedAt),
    );
  }

  /// Время из drift приходит меткой ЛОКАЛЬНОГО пояса: в базе лежат секунды
  /// эпохи, а флаг «это UTC» теряется. Момент времени тот же, но DateTime,
  /// прочитанный из кеша, перестаёт быть равен тому, что пришёл с сервера,
  /// и любое сравнение «то же наблюдение или новое» начинает врать.
  ///
  /// Все наши отметки времени — серверные, то есть UTC. Возвращаем их такими
  /// же, какими положили.
  static DateTime _utc(DateTime v) => v.toUtc();
  static DateTime? _utcOrNull(DateTime? v) => v?.toUtc();

  ProductSummary _toSummary(CachedProduct p) => ProductSummary(
    productId: p.productId,
    name: p.name,
    brand: p.brand,
    ean: p.ean,
    unitValue: p.unitValue,
    unitType: p.unitType,
    bestPriceMinor: p.bestPriceMinor,
    bestPriceChain: p.bestPriceChain,
    chainsCount: p.chainsCount,
    hasPromo: p.hasPromo,
    observedAt: _utcOrNull(p.observedAt),
    needsStoreSelection: p.needsStoreSelection,
  );

  // ---------- акции ----------

  Future<void> putDeals({
    required int? storeId,
    required List<Deal> items,
  }) async {
    final now = DateTime.now().toUtc();
    await batch((b) {
      b.deleteWhere(
        cachedDeals,
        (t) => storeId == null
            ? t.scopeStoreId.isNull()
            : t.scopeStoreId.equals(storeId),
      );
      b.insertAllOnConflictUpdate(cachedDeals, [
        for (final d in items)
          CachedDealsCompanion.insert(
            dealId: Value(d.dealId),
            productId: d.productId,
            name: d.name,
            chainCode: d.chainCode,
            storeId: Value(d.storeId),
            storeName: Value(d.storeName),
            priceMinor: d.priceMinor,
            oldPriceMinor: d.oldPriceMinor,
            marketPriceMinor: d.marketPriceMinor,
            claimedDiscount: d.claimedDiscount,
            realDiscount: d.realDiscount,
            inflation: d.inflation,
            inflated: d.inflated,
            observedAt: d.observedAt,
            scopeStoreId: Value(storeId),
            cachedAt: now,
          ),
      ]);
    });
  }

  Future<Fresh<List<Deal>>> deals({int? storeId}) async {
    final query = select(cachedDeals)
      ..where(
        (t) => storeId == null
            ? t.scopeStoreId.isNull()
            : t.scopeStoreId.equals(storeId),
      )
      ..orderBy([(t) => OrderingTerm.desc(t.realDiscount)]);

    final rows = await query.get();
    return Fresh(
      value: [
        for (final r in rows)
          Deal(
            dealId: r.dealId,
            productId: r.productId,
            name: r.name,
            chainCode: r.chainCode,
            storeId: r.storeId,
            storeName: r.storeName,
            priceCluster: null,
            priceMinor: r.priceMinor,
            oldPriceMinor: r.oldPriceMinor,
            marketPriceMinor: r.marketPriceMinor,
            referenceChains: 0,
            claimedDiscount: r.claimedDiscount,
            realDiscount: r.realDiscount,
            inflation: r.inflation,
            inflated: r.inflated,
            observedAt: _utc(r.observedAt),
          ),
      ],
      fromCache: true,
      cachedAt: rows.isEmpty ? null : _utc(rows.first.cachedAt),
    );
  }

  // ---------- список покупок ----------

  /// Добавить товар из каталога. Повторное добавление не плодит строки.
  Future<void> addProduct({
    required int productId,
    required String name,
    double? unitValue,
    String? unitType,
  }) async {
    final existing = await (select(
      shoppingItems,
    )..where((t) => t.productId.equals(productId))).getSingleOrNull();
    if (existing != null) return;

    await into(shoppingItems).insert(
      ShoppingItemsCompanion.insert(
        productId: Value(productId),
        name: name,
        unitValue: Value(unitValue),
        unitType: Value(unitType),
        addedAt: DateTime.now().toUtc(),
      ),
    );
  }

  /// Дописать позицию текстом.
  ///
  /// Цены у неё нет и не будет: человек написал «хлеб», а какой именно — знает
  /// он один. В сумму корзины такая строка не входит и не портит её молча.
  Future<void> addManual(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    await into(shoppingItems).insert(
      ShoppingItemsCompanion.insert(
        name: trimmed,
        addedAt: DateTime.now().toUtc(),
      ),
    );
  }

  Future<void> removeItem(int id) =>
      (delete(shoppingItems)..where((t) => t.id.equals(id))).go();

  Future<void> removeByProduct(int productId) =>
      (delete(shoppingItems)..where((t) => t.productId.equals(productId))).go();

  Future<void> setDone(int id, bool done) =>
      (update(shoppingItems)..where((t) => t.id.equals(id))).write(
        ShoppingItemsCompanion(done: Value(done)),
      );

  Future<void> clearDone() =>
      (delete(shoppingItems)..where((t) => t.done.equals(true))).go();

  /// Сохранить цены, приехавшие с сервера.
  ///
  /// Кладём в базу, а не держим в памяти: список открывают в магазине, где
  /// связи может не быть вовсе, и цифры должны пережить перезапуск.
  Future<void> putBasketPrices(Map<int, List<ChainPrice>> byProduct) async {
    final now = DateTime.now().toUtc();
    await batch((b) {
      for (final entry in byProduct.entries) {
        b.update(
          shoppingItems,
          ShoppingItemsCompanion(
            pricesJson: Value(encodeChainPrices(entry.value)),
            pricesUpdatedAt: Value(now),
          ),
          where: (t) => t.productId.equals(entry.key),
        );
      }
    });
  }

  /// Список целиком. Купленные уезжают вниз.
  Stream<List<BasketItem>> watchBasket() {
    final query = select(shoppingItems)
      ..orderBy([
        // Сначала не купленные: в магазине смотрят на то, что ещё нужно взять.
        (t) => OrderingTerm.asc(t.done),
        (t) => OrderingTerm.desc(t.addedAt),
      ]);
    return query.watch().map(
      (rows) => [for (final r in rows) _toBasketItem(r)],
    );
  }

  Future<List<BasketItem>> basketOnce() async {
    final rows =
        await (select(shoppingItems)..orderBy([
              (t) => OrderingTerm.asc(t.done),
              (t) => OrderingTerm.desc(t.addedAt),
            ]))
            .get();
    return [for (final r in rows) _toBasketItem(r)];
  }

  Future<bool> isInList(int productId) async =>
      await (select(
        shoppingItems,
      )..where((t) => t.productId.equals(productId))).getSingleOrNull() !=
      null;

  BasketItem _toBasketItem(ShoppingItem r) => BasketItem(
    id: r.id,
    productId: r.productId,
    name: r.name,
    unitValue: r.unitValue,
    unitType: r.unitType,
    done: r.done,
    addedAt: r.addedAt,
    prices: decodeChainPrices(r.pricesJson),
    pricesUpdatedAt: r.pricesUpdatedAt,
  );

  // ---------- инвалидация ----------

  /// Выбросить все кешированные цены.
  ///
  /// Вызывается при смене магазина. Без этого человек, переехавший из одного
  /// магазина сети в другой, увидит цифры прошлой точки — и они будут
  /// выглядеть как обычные свежие цены, без единого признака подвоха.
  ///
  /// Список покупок НЕ трогаем: это выбор пользователя, а не кеш.
  Future<void> clearPrices() async {
    await batch((b) {
      b.deleteAll(cachedDeals);
      b.deleteAll(cachedProducts);
      b.deleteAll(cachedSearches);
      // Позиции списка остаются, но их цены обнуляются: они посчитаны для
      // прошлого магазина, и показать их как свои было бы тем самым враньём,
      // ради которого затевалась инвалидация.
      b.update(
        shoppingItems,
        const ShoppingItemsCompanion(
          pricesJson: Value(null),
          pricesUpdatedAt: Value(null),
        ),
      );
    });
  }
}

final catalogCacheProvider = Provider<CatalogCache>((ref) {
  final db = CatalogCache();
  ref.onDispose(db.close);
  return db;
});
