import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/deals_page.dart';
import '../../domain/models/freshness.dart';
import '../../domain/models/price_history.dart';
import '../../domain/models/product_card.dart';
import '../../domain/models/product_summary.dart';
import '../api/dio_client.dart';
import '../api/dto/watch_dto.dart';
import '../api/qiymet_api.dart';
import '../cache/catalog_cache.dart';
import '../mappers.dart';

/// Сети нет — и это отличается от «сервер ответил ошибкой».
///
/// Разница принципиальна: при отсутствии сети мы имеем право показать
/// сохранённый ответ с плашкой о времени. При ошибке сервера — нет, потому
/// что сервер жив и мог бы ответить иначе.
bool _isOffline(Object error) {
  if (error is! DioException) return false;
  return switch (error.type) {
    DioExceptionType.connectionError ||
    DioExceptionType.connectionTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.sendTimeout => true,
    DioExceptionType.unknown => error.error is SocketException,
    _ => false,
  };
}

/// Доступ к каталогу: сеть плюс локальный кеш.
///
/// Виджеты ходят сюда через провайдеры и не знают ни про dio, ни про drift.
class CatalogRepository {
  CatalogRepository({required this.api, required this.cache});

  final QiymetApi api;
  final CatalogCache cache;

  /// Поиск. Без сети отдаёт сохранённый ответ НА ЭТОТ ЖЕ запрос.
  ///
  /// Показать вместо него «последние виденные товары» было бы подменой:
  /// человек ищет молоко, а видит стиральный порошок под плашкой «данные
  /// от 14:20» и решает, что приложение врёт.
  Future<Fresh<List<ProductSummary>>> search({
    required String query,
    int? storeId,
    int limit = 20,
  }) async {
    try {
      final response = await api.search(
        q: query,
        storeId: storeId,
        limit: limit,
      );
      final items = response.items.map(toProductSummary).toList();
      await cache.putSearchResults(
        query: query,
        storeId: storeId,
        items: items,
      );
      return Fresh(value: items);
    } on Object catch (e) {
      if (!_isOffline(e)) rethrow;
      final cached = await cache.cachedSearch(query: query, storeId: storeId);
      if (cached == null) rethrow;
      return cached;
    }
  }

  Future<ProductCard?> product({required int productId, int? storeId}) async {
    try {
      final dto = await api.product(id: productId, storeId: storeId);
      return toProductCard(dto);
    } on DioException catch (e) {
      // 404 — товара нет либо склейка в карантине. Показывать её нельзя,
      // и для клиента это неотличимо от несуществующего товара.
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  /// Страница ленты акций.
  ///
  /// Без сети отдаётся сохранённая лента с временем последнего обновления.
  /// Кешируется только ПЕРВАЯ страница: догружать оффлайн всё равно нечего,
  /// а хранить весь бесконечный список на устройстве незачем.
  Future<Fresh<DealsPage>> deals({
    int? storeId,
    double? minDiscount,
    String? category,
    String? chains,
    int limit = 20,
    String? cursor,
  }) async {
    try {
      final response = await api.deals(
        storeId: storeId,
        minDiscount: minDiscount,
        category: category,
        chains: chains,
        limit: limit,
        cursor: cursor,
      );
      final items = response.items.map(toDeal).toList();

      // В кеш кладём только первую страницу и только без фильтров: под
      // фильтром лента другая, и подсовывать её оффлайн как «ту самую» нельзя.
      if (cursor == null &&
          minDiscount == null &&
          category == null &&
          chains == null) {
        await cache.putDeals(storeId: storeId, items: items);
      }

      return Fresh(
        value: DealsPage(
          items: items,
          nextCursor: response.nextCursor,
          hasMore: response.hasMore,
        ),
      );
    } on Object catch (e) {
      if (!_isOffline(e)) rethrow;
      // Догрузка оффлайн бессмысленна — сохранена одна страница.
      if (cursor != null) rethrow;
      final cached = await cache.deals(storeId: storeId);
      return Fresh(
        value: DealsPage(items: cached.value),
        fromCache: true,
        cachedAt: cached.cachedAt,
      );
    }
  }

  /// Цены по сетям для списка покупок: один запрос на всю корзину.
  ///
  /// Товары из `missing` (удалённые либо в карантине) в ответе просто не
  /// появятся — их цены останутся пустыми, и экран покажет позицию без суммы,
  /// а не выкинет её молча.
  Future<Map<int, List<ChainPrice>>> basketPrices({
    required List<int> productIds,
    int? storeId,
  }) async {
    if (productIds.isEmpty) return const {};
    final response = await api.prices(
      productIds: productIds.join(','),
      storeId: storeId,
    );
    return {
      for (final item in response.items)
        item.productId: [for (final p in item.prices) toChainPrice(p)],
    };
  }

  /// Категории, в которых сейчас есть акции.
  Future<List<String>> categories() async {
    final response = await api.categories();
    return [for (final c in response.items) c.code];
  }

  Future<PriceHistory> history({
    required int productId,
    int days = 30,
    int? storeId,
  }) async {
    final dto = await api.history(id: productId, days: days, storeId: storeId);
    return toPriceHistory(dto);
  }

  /// Подписаться на падение цены.
  ///
  /// Пользователь заводится сервером по заголовку X-Device-Id: ни регистрации,
  /// ни push-токена для самой подписки не нужно. Токен понадобится только
  /// чтобы уведомление доехало.
  Future<void> watch({
    required int productId,
    int? storeId,
    int? targetPriceMinor,
  }) async {
    await api.createWatch(
      WatchInDto(
        productId: productId,
        storeId: storeId,
        targetPriceMinor: targetPriceMinor,
      ),
    );
  }

  Future<Set<int>> watchedProductIds() async {
    final response = await api.watches();
    return {for (final w in response.items) w.productId};
  }

  Future<void> unwatch(int watchId) => api.deleteWatch(id: watchId);

  Future<int?> watchIdFor(int productId) async {
    final response = await api.watches();
    for (final w in response.items) {
      if (w.productId == productId) return w.id;
    }
    return null;
  }
}

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepository(
    api: ref.watch(qiymetApiProvider),
    cache: ref.watch(catalogCacheProvider),
  );
});
