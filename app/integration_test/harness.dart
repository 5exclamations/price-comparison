// Обвязка для прогонов на настоящем устройстве.
//
// Заглушены ровно два места, где приложение выходит наружу: HTTP-репозитории.
// Всё остальное — настоящее: движок отрисовки, шрифты, drift на файловой
// системе устройства, плагины, роутер.
//
// Именно поэтому эти тесты не дублируют test/integration/main_path_test.dart,
// хотя проходят тот же путь. Тот гоняется на flutter_tester: там нет ни
// плагинов, ни Skia, и шрифт рисует не тот код, что на телефоне.
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qiymet/data/api/dio_client.dart';
import 'package:qiymet/data/cache/catalog_cache.dart';
import 'package:qiymet/data/cache/selection_store.dart';
import 'package:qiymet/data/repositories/catalog_repository.dart';
import 'package:qiymet/data/repositories/store_repository.dart';
import 'package:qiymet/presentation/providers/health_providers.dart';
import 'package:qiymet/presentation/providers/settings_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test/fakes/app_fakes.dart';

export '../test/fakes/app_fakes.dart';

/// Снимать ли экраны. Включается только под `flutter drive`, который умеет
/// принять картинку и положить её на диск:
///
///   flutter drive --driver=test_driver/integration_test.dart \
///     --target=integration_test/app_flow_test.dart \
///     --dart-define=QIYMET_SCREENSHOTS=true
///
/// Без флага `takeScreenshot` бросает исключение, и обычный
/// `flutter test integration_test/` падал бы не по делу.
const bool screenshotsEnabled = bool.fromEnvironment('QIYMET_SCREENSHOTS');

int _shotIndex = 0;

/// Снимок экрана с номером в имени: порядок в артефактах должен читаться
/// без открывания каждого файла.
Future<void> shoot(
  IntegrationTestWidgetsFlutterBinding binding,
  String name,
) async {
  _shotIndex++;
  if (!screenshotsEnabled) return;

  // На Android поверхность Flutter надо сначала перевести в картинку, иначе
  // снимок вернёт чёрный прямоугольник.
  if (Platform.isAndroid) {
    await binding.convertFlutterSurfaceToImage();
    await binding.pump();
  }
  await binding.takeScreenshot(
    '${_shotIndex.toString().padLeft(2, '0')}-$name',
  );
}

/// Общая обвязка: подменяет только выход наружу.
class Harness {
  Harness._(this.cache, this.prefs, this.catalog);

  final CatalogCache cache;
  final SharedPreferences prefs;
  final FakeCatalogRepository catalog;

  static Future<Harness> create() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // База в памяти, а не на устройстве: прогон не должен зависеть от того,
    // что осталось от прошлого запуска.
    final cache = CatalogCache(NativeDatabase.memory());
    return Harness._(cache, prefs, FakeCatalogRepository());
  }

  List<Override> overrides({
    ThemeMode themeMode = ThemeMode.light,
    Locale locale = const Locale('ru'),
    bool offline = false,
  }) => [
    sharedPreferencesProvider.overrideWithValue(prefs),
    catalogCacheProvider.overrideWithValue(cache),
    localeProvider.overrideWith((ref) => locale),
    themeModeProvider.overrideWith((ref) => themeMode),

    // Плашка «данные обновляются» ходит в свой эндпоинт и проверяется
    // отдельно; здесь проверяется путь пользователя.
    dataQuestionableProvider.overrideWith((ref) => false),

    if (offline)
      // Оффлайн — это подменённый АДАПТЕР внутри настоящего dio.
      dioProvider.overrideWith((ref) {
        final dio = Dio(BaseOptions(baseUrl: apiBaseUrl));
        dio.httpClientAdapter = OfflineAdapter();
        return dio;
      })
    else ...[
      catalogRepositoryProvider.overrideWithValue(catalog),
      storeRepositoryProvider.overrideWithValue(FakeStoreRepository()),
    ],
  ];

  Future<void> dispose() => cache.close();
}
