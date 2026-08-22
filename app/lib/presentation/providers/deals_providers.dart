import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/catalog_repository.dart';
import '../../domain/models/deal.dart';
import '../../domain/models/deal_filters.dart';
import 'store_providers.dart';

/// Активные фильтры ленты.
final dealFiltersProvider = StateProvider<DealFilters>(
  (ref) => DealFilters.none,
);

/// Категории, по которым есть смысл фильтровать.
///
/// Пустой список — не ошибка, а состояние данных: `products.category` сейчас
/// пуста. Экран по пустому списку прячет фильтр целиком, потому что ряд чипов,
/// ни один из которых ничего не отфильтрует, читается как поломка.
final dealCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.categories();
});

/// Состояние ленты: накопленные страницы плюс курсор.
class DealsFeedState {
  const DealsFeedState({
    this.items = const [],
    this.cursor,
    this.hasMore = true,
    this.loadingMore = false,
    this.fromCache = false,
    this.cachedAt,
    this.error,
  });

  final List<Deal> items;
  final String? cursor;
  final bool hasMore;
  final bool loadingMore;

  /// Ответ приехал из локального кеша: сети нет.
  final bool fromCache;
  final DateTime? cachedAt;

  /// Ошибка ДОГРУЗКИ. Первая страница отдаётся через AsyncValue, а сбой
  /// «загрузить ещё» не должен стирать уже показанный список.
  final Object? error;

  bool get needsStaleWarning => fromCache && cachedAt != null;

  /// Обнуляемые поля требуют явных флагов.
  ///
  /// `cursor ?? this.cursor` не даёт СБРОСИТЬ курсор: на последней странице
  /// сервер возвращает nextCursor = null, и состояние сохранило бы старый
  /// курсор, то есть начало бы врать о себе. Сейчас это прикрыто флагом
  /// hasMore, но полагаться на такое прикрытие нельзя.
  DealsFeedState copyWith({
    List<Deal>? items,
    String? cursor,
    bool clearCursor = false,
    bool? hasMore,
    bool? loadingMore,
    bool? fromCache,
    DateTime? cachedAt,
    Object? error,
    bool clearError = false,
  }) {
    return DealsFeedState(
      items: items ?? this.items,
      cursor: clearCursor ? null : (cursor ?? this.cursor),
      hasMore: hasMore ?? this.hasMore,
      loadingMore: loadingMore ?? this.loadingMore,
      fromCache: fromCache ?? this.fromCache,
      cachedAt: cachedAt ?? this.cachedAt,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Лента акций с курсорной пагинацией и pull-to-refresh.
///
/// Курсор, а не offset: витрина пересобирается после каждого прогона сбора, и
/// OFFSET 40 показал бы товары, часть которых уже была на предыдущей странице.
class DealsFeed extends StateNotifier<AsyncValue<DealsFeedState>> {
  DealsFeed(this._repo, this._storeId, this._filters)
    : super(const AsyncValue.loading()) {
    refresh();
  }

  final CatalogRepository _repo;
  final int? _storeId;
  final DealFilters _filters;

  static const pageSize = 20;

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final page = await _repo.deals(
        storeId: _storeId,
        minDiscount: _filters.minDiscount,
        category: _filters.category,
        chains: _filters.chainsParam,
        limit: pageSize,
      );
      state = AsyncValue.data(
        DealsFeedState(
          items: page.value.items,
          cursor: page.value.nextCursor,
          hasMore: page.value.hasMore,
          fromCache: page.fromCache,
          cachedAt: page.cachedAt,
        ),
      );
    } on Object catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null ||
        current.loadingMore ||
        !current.hasMore ||
        current.cursor == null) {
      return;
    }
    // Оффлайн-страницу отсекает уже проверка курсора выше: репозиторий отдаёт
    // кеш без курсора и с hasMore = false. Эта проверка — страховка на случай,
    // если кеш когда-нибудь научится хранить курсор: догружать по нему всё
    // равно будет нечего, страница в кеше одна.
    if (current.fromCache) return;

    state = AsyncValue.data(
      current.copyWith(loadingMore: true, clearError: true),
    );
    try {
      final page = await _repo.deals(
        storeId: _storeId,
        minDiscount: _filters.minDiscount,
        category: _filters.category,
        chains: _filters.chainsParam,
        limit: pageSize,
        cursor: current.cursor,
      );
      state = AsyncValue.data(
        current.copyWith(
          items: [...current.items, ...page.value.items],
          cursor: page.value.nextCursor,
          clearCursor: page.value.nextCursor == null,
          hasMore: page.value.hasMore,
          loadingMore: false,
          clearError: true,
        ),
      );
    } on Object catch (e) {
      // Список остаётся на экране: человек прокрутил до конца, а не потерял
      // всё, что уже прочитал.
      state = AsyncValue.data(current.copyWith(loadingMore: false, error: e));
    }
  }
}

final dealsFeedProvider =
    StateNotifierProvider<DealsFeed, AsyncValue<DealsFeedState>>((ref) {
      return DealsFeed(
        ref.watch(catalogRepositoryProvider),
        ref.watch(selectedStoreIdProvider),
        ref.watch(dealFiltersProvider),
      );
    });
