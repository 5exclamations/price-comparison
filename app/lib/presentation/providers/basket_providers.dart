import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/cache/catalog_cache.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../domain/basket.dart';
import '../../domain/models/basket_item.dart';
import 'store_providers.dart';

/// Список покупок из локальной базы.
///
/// Поток из drift, а не запрос к серверу: экран обязан открываться в магазине,
/// где связи нет. Сеть здесь нужна только чтобы освежить цены.
final basketProvider = StreamProvider<List<BasketItem>>((ref) {
  return ref.watch(catalogCacheProvider).watchBasket();
});

/// Расчёт корзины по выбранным сетям.
final basketPlanProvider = Provider<BasketPlan>((ref) {
  final items = ref.watch(basketProvider).valueOrNull ?? const [];
  final selection = ref.watch(storeSelectionProvider);

  return planBasket(
    items: items.where((i) => !i.done).toList(),
    chains: selection.chainCodes,
    chainNames: ref.watch(chainNamesProvider),
  );
});

/// Коды сетей -> человеческие названия.
final chainNamesProvider = Provider<Map<String, String>>((ref) {
  final stores = ref.watch(storesProvider((lat: null, lon: null)));
  return stores.maybeWhen(
    data: (list) => {for (final s in list) s.chainCode: s.chainName},
    orElse: () => const {},
  );
});

/// Когда цены в списке обновлялись последний раз.
final basketPricesUpdatedProvider = Provider<DateTime?>((ref) {
  final items = ref.watch(basketProvider).valueOrNull ?? const [];
  DateTime? oldest;
  for (final i in items) {
    if (i.isManual) continue;
    final at = i.pricesUpdatedAt;
    if (at == null) return null; // есть позиция без цен вовсе
    if (oldest == null || at.isBefore(oldest)) oldest = at;
  }
  return oldest;
});

/// Действия над списком.
class BasketActions {
  BasketActions(this._cache, this._repo);

  final CatalogCache _cache;
  final CatalogRepository _repo;

  Future<void> addProduct({
    required int productId,
    required String name,
    double? unitValue,
    String? unitType,
  }) => _cache.addProduct(
    productId: productId,
    name: name,
    unitValue: unitValue,
    unitType: unitType,
  );

  Future<void> addManual(String name) => _cache.addManual(name);

  Future<void> remove(int id) => _cache.removeItem(id);

  /// Убрать из списка по товару, а не по строке: карточка знает productId,
  /// но не знает id позиции.
  Future<void> removeByProduct(int productId) =>
      _cache.removeByProduct(productId);

  Future<void> setDone(int id, bool done) => _cache.setDone(id, done);

  Future<void> clearDone() => _cache.clearDone();

  /// Обновить цены списка.
  ///
  /// Один запрос на всю корзину, а не по запросу на позицию: тридцать
  /// отдельных запросов в магазине со слабой связью не доедут.
  ///
  /// Ошибка сети здесь не считается сбоем экрана: список уже показан, цены
  /// лежат в базе с прошлого раза, и человек увидит их вместе со временем
  /// последнего обновления.
  Future<bool> refreshPrices({int? storeId}) async {
    final items = await _cache.basketOnce();
    final ids = [
      for (final i in items)
        if (i.productId != null && !i.done) i.productId!,
    ];
    if (ids.isEmpty) return true;

    try {
      final prices = await _repo.basketPrices(
        productIds: ids,
        storeId: storeId,
      );
      await _cache.putBasketPrices(prices);
      return true;
    } on Object {
      return false;
    }
  }
}

final basketActionsProvider = Provider<BasketActions>((ref) {
  return BasketActions(
    ref.watch(catalogCacheProvider),
    ref.watch(catalogRepositoryProvider),
  );
});
