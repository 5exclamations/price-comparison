// Основной путь: онбординг -> поиск «süd» -> карточка -> список -> итог.
//
// Это единственный тест, который проходит приложение целиком, с настоящим
// роутером, настоящим redirect-сторожем онбординга и настоящей локальной базой.
// Заглушены только два места, где приложение выходит наружу: HTTP-репозитории.
//
// Он ловит то, чего не видит ни один тест по отдельности:
//   * онбординг обязателен — без выбора магазина приложение не пускает дальше;
//   * выбор Bravo без конкретной точки НЕ считается законченным;
//   * поиск начинается с третьего символа и после дебаунса;
//   * из карточки товар попадает в список;
//   * итог по корзине считается по выбранным сетям и не выдумывает цену там,
//     где её нет.
//
// Запускается обычным `flutter test`, не через integration_test: настоящее
// устройство здесь ничего не добавляет, а в CI такой тест гоняется на каждом
// коммите, а не «когда доедет ферма симуляторов».
import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qiymet/app.dart';
import 'package:qiymet/data/cache/catalog_cache.dart';
import 'package:qiymet/data/cache/selection_store.dart';
import 'package:qiymet/data/repositories/catalog_repository.dart';
import 'package:qiymet/data/repositories/store_repository.dart';
import 'package:qiymet/design/widgets/observed_at_text.dart';
import 'package:qiymet/domain/models/deals_page.dart';
import 'package:qiymet/domain/models/freshness.dart';
import 'package:qiymet/domain/models/price_history.dart';
import 'package:qiymet/domain/models/product_card.dart';
import 'package:qiymet/domain/models/product_summary.dart';
import 'package:qiymet/domain/models/store.dart';
import 'package:qiymet/presentation/providers/search_providers.dart';
import 'package:qiymet/presentation/providers/settings_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------- данные, максимально похожие на настоящие ----------

final _observedAt = DateTime.utc(2026, 8, 17, 11, 20);

/// Три сети с единой ценой и одна с ценой по точкам — как в жизни.
final _stores = <Store>[
  const Store(
    storeId: null,
    chainId: 1,
    chainCode: 'araz',
    chainName: 'Araz',
    priceModel: 'single',
    name: 'Araz',
    synthetic: true,
  ),
  const Store(
    storeId: null,
    chainId: 4,
    chainCode: 'neptun',
    chainName: 'Neptun',
    priceModel: 'single',
    name: 'Neptun',
    synthetic: true,
  ),
  const Store(
    storeId: 11,
    chainId: 2,
    chainCode: 'bravo',
    chainName: 'Bravo',
    priceModel: 'per_cluster',
    name: 'Bravo Nizami',
    synthetic: false,
  ),
  const Store(
    storeId: 12,
    chainId: 2,
    chainCode: 'bravo',
    chainName: 'Bravo',
    priceModel: 'per_cluster',
    name: 'Bravo Xətai',
    synthetic: false,
  ),
];

/// Цена молока: у Bravo зависит от точки, поэтому её отдаём только для
/// выбранного магазина.
ProductCard _milkCard({required int? storeId}) => ProductCard(
  productId: 1,
  name: 'Süd 2.5% 1 L',
  brand: 'Palıd',
  ean: '4760000602371',
  unitValue: 1,
  unitType: 'l',
  chainsCount: 3,
  bestPriceMinor: 189,
  bestPriceChain: 'araz',
  prices: [
    ChainPrice(
      chainId: 1,
      chainCode: 'araz',
      chainName: 'Araz',
      priceModel: 'single',
      priceMinor: 189,
      isPromo: false,
      available: true,
      observedAt: _observedAt,
      source: 'web',
    ),
    ChainPrice(
      chainId: 4,
      chainCode: 'neptun',
      chainName: 'Neptun',
      priceModel: 'single',
      priceMinor: 205,
      isPromo: false,
      available: true,
      observedAt: _observedAt,
      source: 'web',
    ),
    if (storeId != null)
      ChainPrice(
        chainId: 2,
        chainCode: 'bravo',
        chainName: 'Bravo',
        priceModel: 'per_cluster',
        storeId: storeId,
        storeName: 'Bravo Nizami',
        priceMinor: 199,
        isPromo: false,
        available: true,
        observedAt: _observedAt,
        source: 'web',
      ),
  ],
);

class _FakeStoreRepository implements StoreRepository {
  @override
  Future<List<Store>> stores({double? lat, double? lon}) async => _stores;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeCatalogRepository implements CatalogRepository {
  final List<String> searches = [];
  int basketPriceCalls = 0;

  @override
  Future<Fresh<List<ProductSummary>>> search({
    required String query,
    int? storeId,
    int limit = 20,
  }) async {
    searches.add(query);
    return Fresh(
      value: [
        ProductSummary(
          productId: 1,
          name: 'Süd 2.5% 1 L',
          brand: 'Palıd',
          ean: '4760000602371',
          unitValue: 1,
          unitType: 'l',
          bestPriceMinor: 189,
          bestPriceChain: 'araz',
          chainsCount: 3,
          hasPromo: false,
          observedAt: _observedAt,
        ),
      ],
    );
  }

  @override
  Future<ProductCard?> product({required int productId, int? storeId}) async =>
      productId == 1 ? _milkCard(storeId: storeId) : null;

  @override
  Future<Map<int, List<ChainPrice>>> basketPrices({
    required List<int> productIds,
    int? storeId,
  }) async {
    basketPriceCalls++;
    return {
      for (final id in productIds)
        if (id == 1) id: _milkCard(storeId: storeId).prices,
    };
  }

  @override
  Future<Fresh<DealsPage>> deals({
    int? storeId,
    double? minDiscount,
    String? category,
    String? chains,
    int limit = 20,
    String? cursor,
  }) async => const Fresh(value: DealsPage(items: []));

  @override
  Future<List<String>> categories() async => const [];

  @override
  Future<PriceHistory> history({
    required int productId,
    int days = 30,
    int? storeId,
  }) async => PriceHistory(productId: productId, days: days, points: const []);

  @override
  Future<void> watch({
    required int productId,
    int? storeId,
    int? targetPriceMinor,
  }) async {}

  @override
  Future<Set<int>> watchedProductIds() async => const {};

  @override
  Future<void> unwatch(int watchId) async {}

  @override
  Future<int?> watchIdFor(int productId) async => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late CatalogCache cache;
  late SharedPreferences prefs;
  late _FakeCatalogRepository catalog;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting();
    SharedPreferences.setMockInitialValues({});

    cache = CatalogCache(NativeDatabase.memory());
    prefs = await SharedPreferences.getInstance();
    catalog = _FakeCatalogRepository();
  });

  tearDown(() => cache.close());

  Widget app() => ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      catalogCacheProvider.overrideWithValue(cache),
      catalogRepositoryProvider.overrideWithValue(catalog),
      storeRepositoryProvider.overrideWithValue(_FakeStoreRepository()),
      // Русская локаль: тест сверяет текст, а читать его падение будет
      // человек. На выбор языка в приложении это никак не влияет.
      localeProvider.overrideWith((ref) => const Locale('ru')),
    ],
    child: const QiymetApp(),
  );

  testWidgets('онбординг -> süd -> карточка -> список -> итог', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    // ---------- 1. Онбординг обязателен ----------
    expect(
      find.text('Куда вы ходите?'),
      findsOneWidget,
      reason: 'приложение обязано начаться с выбора магазина',
    );
    expect(
      find.byType(TextField),
      findsNothing,
      reason: 'до выбора магазина поиска быть не должно',
    );

    final continueButton = find.widgetWithText(FilledButton, 'Продолжить');
    expect(
      tester.widget<FilledButton>(continueButton).onPressed,
      isNull,
      reason: 'без единой отмеченной сети продолжать некуда',
    );

    // ---------- 2. Bravo без точки не считается выбором ----------
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Bravo'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<FilledButton>(continueButton).onPressed,
      isNull,
      reason: 'у Bravo цена зависит от магазина — нужна конкретная точка',
    );
    // И ни слова про «зоны»: это наша внутренняя кухня.
    expect(find.textContaining('зона'), findsNothing);
    expect(find.textContaining('Зона'), findsNothing);

    await tester.tap(find.text('Bravo Nizami'));
    await tester.pumpAndSettle();

    // Заодно отмечаем сеть с единой ценой: человек ходит в две-три.
    // Список сетей длиннее экрана, поэтому сначала доскроллим: ListView
    // не строит то, чего не видно, и tap по несуществующему виджету упал бы
    // с сообщением про поиск, а не про экран.
    await tester.scrollUntilVisible(
      find.widgetWithText(CheckboxListTile, 'Araz'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Araz'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<FilledButton>(continueButton).onPressed,
      isNotNull,
      reason: 'магазин выбран — выпускаем из онбординга',
    );

    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    // ---------- 3. Поиск «süd» ----------
    expect(find.byType(TextField), findsOneWidget);

    // Двух символов мало: триграммный индекс на них не работает, и запрос
    // ушёл бы в полный перебор каталога.
    await tester.enterText(find.byType(TextField), 'sü');
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();
    expect(catalog.searches, isEmpty, reason: 'запрос ушёл слишком рано');

    await tester.enterText(find.byType(TextField), 'süd');
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();

    expect(catalog.searches, ['süd']);
    expect(find.text('Süd 2.5% 1 L'), findsOneWidget);

    // ---------- 4. Карточка товара ----------
    await tester.tap(find.text('Süd 2.5% 1 L'));
    await tester.pumpAndSettle();

    expect(
      find.text('4760000602371'),
      findsOneWidget,
      reason: 'штрихкод на карточке обязателен',
    );
    // Цены всех трёх сетей, включая цену ВЫБРАННОЙ точки Bravo.
    expect(find.text('Araz'), findsWidgets);
    expect(find.text('Bravo'), findsWidgets);
    expect(find.textContaining('1,89'), findsWidgets);
    expect(find.textContaining('1,99'), findsWidgets);

    // ---------- 5. В список ----------
    final addButton = find.widgetWithText(OutlinedButton, 'Добавить в список');
    // Кнопка внизу прокручиваемой карточки, и до неё надо доскроллить, а не
    // просто найти: ListView не создаёт элементы для того, что лежит дальше
    // cacheExtent, а find ходит по дереву элементов. Пока карточка была
    // короткой, кнопка случайно попадала в этот запас и находилась сразу —
    // достаточно было добавить сверху картинку, чтобы тест развалился на
    // ровном месте. Прокрутка убирает эту зависимость от высоты вёрстки.
    await tester.scrollUntilVisible(addButton, 200, maxScrolls: 20);
    await tester.pumpAndSettle();
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    // Список приходит потоком из drift: событие асинхронное, и одного кадра
    // мало — pumpAndSettle крутит анимации, а не очередь базы.
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    expect(
      find.widgetWithText(OutlinedButton, 'В списке'),
      findsOneWidget,
      reason: 'кнопка обязана показать, что товар уже добавлен',
    );

    // ---------- 6. Итог по корзине ----------
    // pageBack() ищет кнопку по подсказке и на русской локали не находит.
    // BackButton — тот же виджет, но без привязки к языку.
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Вкладка «Список» в нижней навигации. Ищем по подписи, а не по иконке:
    // NavigationBar подменяет иконку на selectedIcon, и поиск по неактивной
    // перестаёт находить вкладку ровно тогда, когда она выбрана.
    await tester.tap(find.text('Список').last);
    await tester.pumpAndSettle();

    expect(find.text('Süd 2.5% 1 L'), findsOneWidget);

    // Цены в списке появляются после обновления: локальная база хранит только
    // то, что мы туда положили, и выдумывать цену она не имеет права.
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();

    expect(catalog.basketPriceCalls, 1);
    expect(find.textContaining('Итог по 1 товару'), findsOneWidget);

    // Araz дешевле (1,89 против 1,99 у выбранной точки Bravo) — итог должен
    // считаться по нему, а не по первой попавшейся сети.
    expect(find.textContaining('1,89'), findsWidgets);

    // Одна позиция в одной сети — разбивать нечего, и предлагать это нельзя.
    expect(find.textContaining('если разбить'), findsNothing);

    // Сумма без времени наблюдения — такое же враньё, как цена без него.
    // Цены только что обновились, поэтому это сегодняшнее время без даты.
    expect(find.byType(ObservedAtText), findsWidgets);
    expect(find.textContaining('проверено'), findsWidgets);

    await _teardown(tester);
  });

  testWidgets('перезапуск не гонит через онбординг второй раз', (tester) async {
    // Выбор уже сделан: приложение обязано открыться сразу на поиске.
    // Ключ и формат — как у SelectionStore. Писать сюда выдуманный ключ
    // значит проверить, что приложение переживает пустое хранилище, а не то,
    // что выбор действительно сохраняется.
    SharedPreferences.setMockInitialValues({
      'flutter.store_selection_v1': jsonEncode({
        'chains': ['araz'],
        'store_id': null,
        'store_chain': null,
        'store_name': null,
      }),
    });
    prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Куда вы ходите?'), findsNothing);

    await _teardown(tester);
  });
}

/// Снести дерево внутри теста и дать догореть таймерам.
///
/// drift при закрытии потоков заводит таймер нулевой длины, а ProviderScope
/// закрывает их в своём dispose — то есть уже после последнего кадра. Если
/// дерево сносит сам flutter_test, этот таймер остаётся «висящим», и тест
/// падает с «A Timer is still pending» вместо своего настоящего результата.
/// Разбирать приложение самим и прокрутить ещё кадр дешевле, чем разбираться
/// в этом сообщении каждый раз заново.
Future<void> _teardown(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  // Именно миллисекунда, а не Duration.zero: нулевое продвижение часов
  // таймер нулевой длины не запускает.
  await tester.pump(const Duration(milliseconds: 1));
}
