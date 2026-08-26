import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/catalog_repository.dart';
import '../../domain/models/product_summary.dart';

/// Чей каталог смотрим. store_id важнее chain_id: у Bravo цена привязана
/// к точке, и «каталог сети» там показал бы цены, которых нет ни в одном
/// конкретном магазине.
class CatalogTarget {
  const CatalogTarget({this.chainId, this.storeId, this.title = ''});

  final int? chainId;
  final int? storeId;
  final String title;

  @override
  bool operator ==(Object other) =>
      other is CatalogTarget &&
      other.chainId == chainId &&
      other.storeId == storeId;

  @override
  int get hashCode => Object.hash(chainId, storeId);
}

/// Выбранный раздел. null — весь каталог.
final catalogCategoryProvider = StateProvider<String?>((ref) => null);

/// Разделы, в которых у выбранной сети или точки есть товары.
final catalogCategoriesProvider =
    FutureProvider.family<List<String>, CatalogTarget>((ref, target) async {
      final repo = ref.watch(catalogRepositoryProvider);
      return repo.catalogCategories(
        chainId: target.chainId,
        storeId: target.storeId,
      );
    });

class CatalogState {
  const CatalogState({
    this.items = const [],
    this.cursor,
    this.hasMore = true,
    this.loadingMore = false,
    this.error,
  });

  final List<ProductSummary> items;
  final String? cursor;
  final bool hasMore;
  final bool loadingMore;
  final Object? error;

  CatalogState copyWith({
    List<ProductSummary>? items,
    String? cursor,
    bool? hasMore,
    bool? loadingMore,
    Object? error,
  }) => CatalogState(
    items: items ?? this.items,
    cursor: cursor,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore ?? this.loadingMore,
    error: error,
  );
}

/// Каталог с подгрузкой по мере прокрутки.
class CatalogNotifier extends AutoDisposeFamilyAsyncNotifier<CatalogState, CatalogTarget> {
  @override
  Future<CatalogState> build(CatalogTarget arg) async {
    // Смена раздела перезапускает загрузку с первой страницы: курсор
    // принадлежит прошлой выборке, и подставлять его в новую нельзя —
    // страницы разъедутся.
    final category = ref.watch(catalogCategoryProvider);
    final repo = ref.watch(catalogRepositoryProvider);
    final page = await repo.catalog(
      chainId: arg.chainId,
      storeId: arg.storeId,
      category: category,
    );
    return CatalogState(
      items: page.items,
      cursor: page.cursor,
      hasMore: page.hasMore,
    );
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.loadingMore || !current.hasMore) return;
    if (current.cursor == null) return;

    state = AsyncData(current.copyWith(loadingMore: true, cursor: current.cursor));
    try {
      final repo = ref.read(catalogRepositoryProvider);
      final page = await repo.catalog(
        chainId: arg.chainId,
        storeId: arg.storeId,
        category: ref.read(catalogCategoryProvider),
        cursor: current.cursor,
      );
      state = AsyncData(
        CatalogState(
          items: [...current.items, ...page.items],
          cursor: page.cursor,
          hasMore: page.hasMore,
        ),
      );
    } catch (e) {
      state = AsyncData(current.copyWith(loadingMore: false, cursor: current.cursor));
    }
  }
}

final catalogProvider =
    AsyncNotifierProvider.autoDispose.family<CatalogNotifier, CatalogState, CatalogTarget>(
      CatalogNotifier.new,
    );
