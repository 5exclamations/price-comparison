import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/text.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../domain/models/freshness.dart';
import '../../domain/models/product_summary.dart';
import 'store_providers.dart';

/// Дебаунс ввода. 300 мс — столько, чтобы не слать запрос на каждую букву,
/// и не столько, чтобы поиск ощущался тормозящим.
const searchDebounce = Duration(milliseconds: 300);

/// С какого символа вообще искать.
///
/// Три — не произвольное число: индекс на сервере триграммный, и на запросе
/// короче трёх символов он не применяется, а запрос уходит в полный перебор.
/// Пускать в него с одной буквы значит просить сервер прочитать весь каталог,
/// чтобы показать первые двадцать строк.
const minQueryLength = 3;

/// Популярные запросы для пустого состояния.
///
/// Не выдуманные: базовые продукты, которые ищут чаще всего. Латиница с
/// диакритикой намеренно — normalizeAz всё равно приведёт ввод к общему виду,
/// а написание на вывеске выглядит привычнее транслита.
const popularQueries = ['süd', 'çörək', 'yumurta', 'şəkər'];

/// Текст в строке поиска.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Готов ли запрос к отправке: не короче трёх символов после нормализации.
bool isSearchable(String query) =>
    normalizeAzQuery(query).length >= minQueryLength;

/// Результаты поиска.
///
/// autoDispose здесь несёт нагрузку, а не эстетику: при смене запроса старый
/// провайдер уничтожается, флаг cancelled становится true, и запрос по
/// устаревшему тексту не уходит. Так работает дебаунс без таймеров и без
/// гонки «пришёл ответ на предыдущий запрос».
final searchResultsProvider =
    FutureProvider.autoDispose<Fresh<List<ProductSummary>>>((ref) async {
      final query = ref.watch(searchQueryProvider);
      final storeId = ref.watch(selectedStoreIdProvider);

      if (!isSearchable(query)) {
        return const Fresh(value: <ProductSummary>[]);
      }

      var cancelled = false;
      ref.onDispose(() => cancelled = true);

      await Future<void>.delayed(searchDebounce);
      if (cancelled) {
        // Пользователь успел напечатать ещё букву. Ответ на прошлый текст никому
        // не нужен, и показывать его поверх нового ввода нельзя.
        throw _DebouncedAway();
      }

      final repo = ref.watch(catalogRepositoryProvider);
      return repo.search(query: query, storeId: storeId);
    });

/// Отменённый дебаунсом запрос. Экран его не показывает как ошибку.
class _DebouncedAway implements Exception {
  const _DebouncedAway();
}

/// Был ли запрос просто отменён дебаунсом.
bool isDebouncedAway(Object error) => error is _DebouncedAway;
