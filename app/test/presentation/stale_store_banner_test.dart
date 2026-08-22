// Плашка обязана включаться, когда протух ЛИЧНО твой магазин.
//
// Сбор молча переживает потерю отдельной точки: коннектор печатает
// «ПРОПУЩЕН <slug>» и идёт дальше. У Bravo четыре ценовые зоны. Если отвалилась
// одна, три оставшиеся тянут возраст СЕТИ наверх — и человек, выбравший
// выпавшую точку, видел вчерашние цены как сегодняшние. Ни плашки, ни
// предупреждения: снаружи всё выглядело здоровым.
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qiymet/data/api/dto/health_dto.dart';
import 'package:qiymet/data/cache/catalog_cache.dart';
import 'package:qiymet/data/cache/selection_store.dart';
import 'package:qiymet/domain/models/store.dart';
import 'package:qiymet/presentation/providers/health_providers.dart';
import 'package:qiymet/presentation/providers/store_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Здоровый ответ: проверки прошли, ни одна точка не протухла.
HealthDto _healthy({List<int> stale = const []}) => HealthDto(
  status: stale.isEmpty ? 'ok' : 'degraded',
  staleAfterHours: 12,
  generatedAt: DateTime.utc(2026, 8, 18),
  staleStoreIds: stale,
  chains: const [],
  dataQuality: const DataQualityDto(passed: true),
);

Store _bravo(int id) => Store(
  storeId: id,
  chainId: 2,
  chainCode: 'bravo',
  chainName: 'Bravo',
  priceModel: 'per_cluster',
  name: 'Bravo зона $id',
  synthetic: false,
);

Future<ProviderContainer> _container(HealthDto health) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();

  // Кеш в памяти: выбор магазина сбрасывает цены, и без подмены провайдер
  // полез бы в drift_flutter за настоящим файлом базы.
  final cache = CatalogCache(NativeDatabase.memory());

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      catalogCacheProvider.overrideWithValue(cache),
      healthProvider.overrideWith((ref) async => health),
    ],
  );
  addTearDown(cache.close);
  return container;
}

void main() {
  test('протухла ЧУЖАЯ точка — плашки нет', () async {
    final c = await _container(_healthy(stale: [4]));
    addTearDown(c.dispose);

    await c.read(storeSelectionProvider.notifier).pickStore(_bravo(1));
    await c.read(healthProvider.future);

    expect(
      c.read(dataQuestionableProvider),
      isFalse,
      reason: 'чужая выпавшая зона — не повод пугать этого человека',
    );
  });

  test('протухла СВОЯ точка — плашка есть, хотя проверки прошли', () async {
    final c = await _container(_healthy(stale: [4]));
    addTearDown(c.dispose);

    await c.read(storeSelectionProvider.notifier).pickStore(_bravo(4));
    await c.read(healthProvider.future);

    expect(
      c.read(dataQuestionableProvider),
      isTrue,
      reason: 'именно этот человек видит вчерашние цены',
    );
  });

  test('магазин не выбран — судим только по проверкам данных', () async {
    // Сети с единой ценой store_id не имеют вовсе, и привязывать плашку
    // к точке там не к чему.
    final c = await _container(_healthy(stale: [4]));
    addTearDown(c.dispose);

    await c.read(storeSelectionProvider.notifier).toggleChain('araz');
    await c.read(healthProvider.future);

    expect(c.read(dataQuestionableProvider), isFalse);
  });

  test('упавшие проверки включают плашку всем', () async {
    final c = await _container(
      HealthDto(
        status: 'degraded',
        staleAfterHours: 12,
        generatedAt: DateTime.utc(2026, 8, 18),
        chains: const [],
        dataQuality: const DataQualityDto(passed: false),
      ),
    );
    addTearDown(c.dispose);

    await c.read(storeSelectionProvider.notifier).pickStore(_bravo(1));
    await c.read(healthProvider.future);

    expect(c.read(dataQuestionableProvider), isTrue);
  });

  test('смена магазина пересчитывает плашку', () async {
    // Провайдер обязан зависеть от выбранной точки, а не прочитать её однажды.
    final c = await _container(_healthy(stale: [4]));
    addTearDown(c.dispose);

    final notifier = c.read(storeSelectionProvider.notifier);
    await notifier.pickStore(_bravo(1));
    await c.read(healthProvider.future);
    expect(c.read(dataQuestionableProvider), isFalse);

    await notifier.pickStore(_bravo(4));
    expect(
      c.read(dataQuestionableProvider),
      isTrue,
      reason: 'переехал в выпавшую зону — плашка обязана появиться',
    );
  });
}
