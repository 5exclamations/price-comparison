import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/cache/catalog_cache.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../domain/models/price_history.dart';
import '../../domain/models/product_card.dart';
import 'store_providers.dart';

/// Карточка товара. null означает «нет такого» — в том числе когда склейка
/// в карантине: сервер отдаёт на неё 404, и это правильно.
final productCardProvider = FutureProvider.family<ProductCard?, int>((
  ref,
  productId,
) async {
  final storeId = ref.watch(selectedStoreIdProvider);
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.product(productId: productId, storeId: storeId);
});

/// История цены за 30 дней.
///
/// Хватает ли данных на график, решает сама модель (PriceHistory.isDrawable):
/// меньше недели наблюдений — рисовать нечего, и экран пишет об этом словами.
final priceHistoryProvider = FutureProvider.family<PriceHistory, int>((
  ref,
  productId,
) async {
  final storeId = ref.watch(selectedStoreIdProvider);
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.history(productId: productId, days: 30, storeId: storeId);
});

/// Товары, за ценой которых пользователь уже следит.
final watchedProductsProvider = FutureProvider<Set<int>>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.watchedProductIds();
});

/// Есть ли товар в списке покупок. Поток, чтобы кнопка меняла вид сразу.
final inShoppingListProvider = StreamProvider.family<bool, int>((
  ref,
  productId,
) {
  return ref
      .watch(catalogCacheProvider)
      .watchBasket()
      .map((items) => items.any((i) => i.productId == productId));
});

/// Действия над товаром: подписка на цену.
///
/// Список покупок живёт в BasketActions: складывать его сюда значило бы
/// держать две двери в одну комнату.
class ProductActions {
  ProductActions(this._repo);

  final CatalogRepository _repo;

  Future<void> watch({
    required int productId,
    int? storeId,
    int? targetPriceMinor,
  }) => _repo.watch(
    productId: productId,
    storeId: storeId,
    targetPriceMinor: targetPriceMinor,
  );

  Future<void> unwatch(int productId) async {
    final id = await _repo.watchIdFor(productId);
    if (id != null) await _repo.unwatch(id);
  }
}

final productActionsProvider = Provider<ProductActions>((ref) {
  return ProductActions(ref.watch(catalogRepositoryProvider));
});
