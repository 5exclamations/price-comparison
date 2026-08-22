// Тёмная тема и авиарежим — headless-двойники сценариев из integration_test/.
//
// Зачем двойники, если те же сценарии гоняются на эмуляторе: эмулятор есть
// только в CI и стоит десять минут, а эти проверки нужны на каждом сохранении
// файла. На устройстве остаётся то, чего здесь не бывает по определению —
// настоящая отрисовка шрифта и снимки экрана.
//
// Данные общие: test/fakes/app_fakes.dart. Разойдись они по копиям, «прошло
// локально» и «прошло на эмуляторе» начали бы означать разное.
import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qiymet/app.dart';
import 'package:qiymet/data/api/dio_client.dart';
import 'package:qiymet/data/cache/catalog_cache.dart';
import 'package:qiymet/data/cache/selection_store.dart';
import 'package:qiymet/data/repositories/catalog_repository.dart';
import 'package:qiymet/data/repositories/store_repository.dart';
import 'package:qiymet/presentation/providers/health_providers.dart';
import 'package:qiymet/presentation/providers/search_providers.dart';
import 'package:qiymet/presentation/providers/settings_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fakes/app_fakes.dart';

void main() {
  late CatalogCache cache;
  late SharedPreferences prefs;
  late FakeCatalogRepository catalog;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting();
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    cache = CatalogCache(NativeDatabase.memory());
    catalog = FakeCatalogRepository();
  });

  tearDown(() => cache.close());

  Widget app({ThemeMode themeMode = ThemeMode.light, bool offline = false}) =>
      ProviderScope(
        // Ключ по режиму — не украшение. Riverpod запрещает менять ЧИСЛО
        // overrides у одной и той же области: «overrides cannot be
        // removed/added, they can only be updated». Разный ключ даёт новый
        // элемент и новый контейнер — то есть ровно то, что происходит при
        // перезапуске приложения в магазине без связи.
        key: ValueKey('scope-offline-$offline'),
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          catalogCacheProvider.overrideWithValue(cache),
          localeProvider.overrideWith((ref) => const Locale('ru')),
          themeModeProvider.overrideWith((ref) => themeMode),
          dataQuestionableProvider.overrideWith((ref) => false),
          if (offline)
            // Обрыв случается там же, где в жизни, — внутри dio. Тест,
            // подменивший репозиторий, проверял бы аккуратность собственной
            // заглушки, а не поведение приложения без сети.
            dioProvider.overrideWith((ref) {
              final dio = Dio(BaseOptions(baseUrl: apiBaseUrl));
              dio.httpClientAdapter = OfflineAdapter();
              return dio;
            })
          else ...[
            catalogRepositoryProvider.overrideWithValue(catalog),
            storeRepositoryProvider.overrideWithValue(FakeStoreRepository()),
          ],
        ],
        child: const QiymetApp(),
      );

  /// Перезапуск приложения с другим набором подмен.
  ///
  /// Сначала сносим дерево целиком, и это не перестраховка. go_router держит
  /// ключи навигаторов в переменных уровня файла: два живых экземпляра
  /// приложения в одном процессе дают «Multiple widgets used the same
  /// GlobalKey». В жизни второго экземпляра не бывает — приложение
  /// перезапускают, а не удваивают, — поэтому и здесь честнее снести первое.
  Future<void> restart(WidgetTester tester, {required bool offline}) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(app(offline: offline));
    await tester.pumpAndSettle();
  }

  /// Пройти онбординг: выбрать точку Bravo и выйти на поиск.
  Future<void> passOnboarding(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Bravo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bravo Nizami'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Продолжить'));
    await tester.pumpAndSettle();
  }

  Future<void> teardownTree(WidgetTester tester) async {
    // drift при закрытии потоков заводит таймер нулевой длины уже после
    // последнего кадра. Разбираем дерево сами и даём ему догореть, иначе тест
    // падает с «A Timer is still pending» вместо своего результата.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  }

  testWidgets('тёмная тема: цена не теряет контраст', (tester) async {
    await tester.pumpWidget(app(themeMode: ThemeMode.dark));
    await tester.pumpAndSettle();
    await passOnboarding(tester);

    await tester.enterText(find.byType(TextField), 'süd');
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Scaffold).first);
    expect(
      Theme.of(context).colorScheme.brightness,
      Brightness.dark,
      reason: 'тема не переключилась — проверять нечего',
    );

    final priceStyles = tester
        .widgetList<Text>(find.textContaining('₼'))
        .map((t) => t.style)
        .whereType<TextStyle>()
        .toList();
    expect(priceStyles, isNotEmpty, reason: 'цен на экране нет');

    for (final s in priceStyles) {
      expect(s.color, isNotNull);
      // Полупрозрачная цена на тёмном фоне — это и есть «съеденный контраст».
      // Проверяем измеримое: непрозрачность и то, что цвет не совпал с фоном.
      expect(
        s.color!.a,
        greaterThan(0.6),
        reason: 'цена почти прозрачная в тёмной теме',
      );
      expect(
        s.color!.value,
        isNot(Theme.of(context).colorScheme.surface.value),
        reason: 'цена цвета фона — на экране её попросту не видно',
      );
    }

    await teardownTree(tester);
  });

  testWidgets('список покупок открывается без сети', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await passOnboarding(tester);

    await cache.addProduct(
      productId: 1,
      name: productNames.first,
      unitValue: 1,
      unitType: 'l',
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    // Авиарежим: приложение поднимается заново с dio, который всегда бросает
    // SocketException. Так это выглядит в магазине без связи.
    await restart(tester, offline: true);

    await tester.tap(find.text('Список').last);
    await tester.pumpAndSettle();

    expect(
      find.text(productNames.first),
      findsOneWidget,
      reason: 'без сети список обязан открыться из drift',
    );
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await teardownTree(tester);
  });

  testWidgets('обновление цен без сети говорит об этом, а не молчит', (
    tester,
  ) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await passOnboarding(tester);
    await cache.addProduct(productId: 1, name: productNames.first);
    await tester.pump(const Duration(milliseconds: 100));

    await restart(tester, offline: true);
    await tester.tap(find.text('Список').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    // Молчание здесь — худший исход: человек решит, что цены обновились.
    expect(
      find.byType(SnackBar),
      findsOneWidget,
      reason: 'неудачное обновление обязано быть заметным',
    );

    await teardownTree(tester);
  });
}
