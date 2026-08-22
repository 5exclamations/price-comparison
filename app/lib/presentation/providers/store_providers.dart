import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/geo.dart';
import '../../data/cache/catalog_cache.dart';
import '../../data/cache/selection_store.dart';
import '../../data/repositories/store_repository.dart';
import '../../domain/models/store.dart';
import '../../domain/models/store_selection.dart';

/// Список магазинов и сетей. При заданной точке сервер добавит расстояние.
final storesProvider =
    FutureProvider.family<List<Store>, ({double? lat, double? lon})>((
      ref,
      point,
    ) async {
      final repo = ref.watch(storeRepositoryProvider);
      return repo.stores(lat: point.lat, lon: point.lon);
    });

/// Коды сетей, у которых цена привязана к точке.
///
/// Берутся из ответа сервера (`price_model == 'per_cluster'`), а не из
/// константы 'bravo': сегодня такая сеть одна, завтра их станет две, и
/// захардкоженный код промолчит вместо того, чтобы потребовать выбор.
final chainsRequiringStoreProvider = Provider<Set<String>>((ref) {
  final stores = ref.watch(storesProvider((lat: null, lon: null)));
  return stores.maybeWhen(
    data: (list) => {
      for (final s in list)
        if (s.requiresStorePick) s.chainCode,
    },
    orElse: () => const {},
  );
});

/// Выбор пользователя.
class StoreSelectionController extends StateNotifier<StoreSelection> {
  StoreSelectionController(this._store, this._cache) : super(_store.read());

  final SelectionStore _store;
  final CatalogCache _cache;

  /// Отметить или снять сеть.
  Future<void> toggleChain(String chainCode) async {
    final next = {...state.chainCodes};
    if (!next.remove(chainCode)) next.add(chainCode);

    var updated = state.copyWith(chainCodes: next);

    // Сеть сняли — снимаем и её магазин, иначе в запрос уйдёт store_id
    // сети, которую пользователь больше не выбирает.
    if (!next.contains(state.pickedStoreChainCode)) {
      updated = updated.copyWith(
        pickedStoreId: null,
        pickedStoreChainCode: null,
        pickedStoreName: null,
      );
    }
    await _apply(updated);
  }

  /// Выбрать конкретный магазин.
  Future<void> pickStore(Store store) async {
    await _apply(
      state.copyWith(
        chainCodes: {...state.chainCodes, store.chainCode},
        pickedStoreId: store.storeId,
        pickedStoreChainCode: store.chainCode,
        pickedStoreName: store.name,
      ),
    );
  }

  Future<void> reset() async {
    await _store.clear();
    await _cache.clearPrices();
    state = StoreSelection.empty;
  }

  /// Сохранить и, если сменился магазин, выбросить кеш цен.
  ///
  /// Без этого человек, переехавший из одного магазина Bravo в другой, увидит
  /// цифры прошлого: в кеше лежат цены, посчитанные для старой точки, и
  /// выглядят они как обычные свежие цены. Это ровно тот случай, когда молчать
  /// хуже, чем показать пустой экран на секунду.
  Future<void> _apply(StoreSelection next) async {
    final storeChanged = next.pickedStoreId != state.pickedStoreId;
    state = next;
    await _store.write(next);
    if (storeChanged) {
      await _cache.clearPrices();
    }
  }
}

final storeSelectionProvider =
    StateNotifierProvider<StoreSelectionController, StoreSelection>((ref) {
      return StoreSelectionController(
        ref.watch(selectionStoreProvider),
        ref.watch(catalogCacheProvider),
      );
    });

/// store_id для запросов. Всё, что ходит в сеть, читает именно его.
final selectedStoreIdProvider = Provider<int?>(
  (ref) => ref.watch(storeSelectionProvider).storeId,
);

/// Готов ли выбор. От него зависит, пускать ли дальше онбординга.
final selectionCompleteProvider = Provider<bool>((ref) {
  final selection = ref.watch(storeSelectionProvider);
  final requiring = ref.watch(chainsRequiringStoreProvider);
  return selection.isCompleteFor(requiring);
});

// ---------- геолокация ----------

final geoLocatorProvider = Provider<GeoLocator>((ref) => const GeoLocator());

/// Последний результат определения местоположения. null — ещё не пробовали.
final locationOutcomeProvider = StateProvider<LocationOutcome?>((ref) => null);

/// Точка пользователя, если её удалось определить.
final userPointProvider = Provider<({double? lat, double? lon})>((ref) {
  final outcome = ref.watch(locationOutcomeProvider);
  if (outcome is LocationFound) {
    return (lat: outcome.latitude, lon: outcome.longitude);
  }
  return (lat: null, lon: null);
});
