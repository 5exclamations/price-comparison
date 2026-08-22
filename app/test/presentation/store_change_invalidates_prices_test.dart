// Смена магазина обязана выбросить цены прошлой точки.
//
// У Bravo четыре ценовые зоны, и цена одного и того же товара в них разная.
// Человек переехал из одного филиала в другой, экран не перезапросил цены — и
// показывает вчерашнюю точку как сегодняшнюю. Внешне это неотличимо от
// нормальной работы: цифры на месте, ошибок нет, плашки нет.
//
// Логика самого сброса покрыта юнит-тестом (store_selection_controller_test).
// Здесь проверяется ПРОВОДКА: что экран действительно перестраивается, что
// новый запрос уходит с новым store_id и что старая цена с экрана исчезает.
// Ломалось именно это: контроллер честно чистил кеш, а провайдер результатов
// не зависел от store_id и продолжал отдавать своё.
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qiymet/design/widgets/price_text.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qiymet/data/cache/catalog_cache.dart';
import 'package:qiymet/data/cache/selection_store.dart';
import 'package:qiymet/data/repositories/catalog_repository.dart';
import 'package:qiymet/design/theme.dart';
import 'package:qiymet/domain/models/deal.dart';
import 'package:qiymet/domain/models/deals_page.dart';
import 'package:qiymet/domain/models/freshness.dart';
import 'package:qiymet/domain/models/product_card.dart';
import 'package:qiymet/domain/models/product_summary.dart';
import 'package:qiymet/domain/models/price_history.dart';
import 'package:qiymet/domain/models/store.dart';
import 'package:qiymet/l10n/app_localizations.dart';
import 'package:qiymet/presentation/providers/search_providers.dart';
import 'package:qiymet/presentation/providers/store_providers.dart';
import 'package:qiymet/presentation/screens/search/search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Репозиторий, у которого цена зависит от магазина — как у Bravo.
///
/// Возвращает store_id прямо в цене: 3 -> 3,00 ₼, 4 -> 4,00 ₼. Так на экране
/// сразу видно, чью точку показывают, и падение теста читается без отладчика.
class _PerStoreRepository implements CatalogRepository {
  final List<int?> searchedStores = [];

  @override
  Future<Fresh<List<ProductSummary>>> search({
    required String query,
    int? storeId,
    int limit = 20,
  }) async {
    searchedStores.add(storeId);
    return Fresh(
      value: [
        ProductSummary(
          productId: 1,
          name: 'Süd 2.5% 1 L',
          chainsCount: 4,
          hasPromo: false,
          bestPriceMinor: (storeId ?? 0) * 100,
          bestPriceChain: 'bravo',
          observedAt: DateTime.now().toUtc(),
        ),
      ],
    );
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
  Future<ProductCard?> product({required int productId, int? storeId}) async =>
      null;

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

Store _bravo(int id, String name) => Store(
  storeId: id,
  chainId: 2,
  chainCode: 'bravo',
  chainName: 'Bravo',
  priceModel: 'per_cluster',
  name: name,
  synthetic: false,
);

Deal _deal(int id) => Deal(
  dealId: id,
  productId: id,
  name: 'Товар $id',
  chainCode: 'bravo',
  priceMinor: 100,
  oldPriceMinor: 200,
  marketPriceMinor: 180,
  referenceChains: 2,
  claimedDiscount: 0.5,
  realDiscount: 0.44,
  inflation: 0.06,
  inflated: false,
  observedAt: DateTime.utc(2026, 8, 17),
);

void main() {
  late CatalogCache cache;
  late SelectionStore selection;
  late _PerStoreRepository repository;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting();
    SharedPreferences.setMockInitialValues({});

    cache = CatalogCache(NativeDatabase.memory());
    selection = SelectionStore(await SharedPreferences.getInstance());
    repository = _PerStoreRepository();
  });

  tearDown(() => cache.close());

  ProviderScope harness(Widget child) => ProviderScope(
    overrides: [
      catalogCacheProvider.overrideWithValue(cache),
      selectionStoreProvider.overrideWithValue(selection),
      catalogRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp(
      locale: const Locale('ru'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light(),
      home: child,
    ),
  );

  testWidgets('цена прошлого магазина уходит с экрана', (tester) async {
    final scope = harness(const SearchScreen());
    await tester.pumpWidget(scope);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(SearchScreen)),
    );
    final controller = container.read(storeSelectionProvider.notifier);

    await controller.pickStore(_bravo(3, 'Bravo Nizami'));
    await tester.enterText(find.byType(TextField), 'süd');

    // Дебаунс 300 мс, потом ответ.
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();

    expect(
      find.text('3,00${PriceFormat.nbsp}₼'),
      findsOneWidget,
      reason: 'ожидалась цена выбранной точки',
    );
    expect(repository.searchedStores, [3]);

    // Переезд в другой филиал той же сети.
    await controller.pickStore(_bravo(4, 'Bravo Xətai'));
    await tester.pump();

    // Пока новый ответ не пришёл, старой цены на экране быть не должно:
    // это и есть «показать пустой экран на секунду вместо чужой цифры».
    expect(
      find.text('3,00${PriceFormat.nbsp}₼'),
      findsNothing,
      reason: 'цена прошлой точки осталась на экране',
    );

    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();

    expect(find.text('4,00${PriceFormat.nbsp}₼'), findsOneWidget);
    expect(repository.searchedStores, [
      3,
      4,
    ], reason: 'второй запрос обязан уйти с новым store_id');
  });

  testWidgets('запрос повторяется даже при том же тексте поиска', (
    tester,
  ) async {
    // Ловушка: текст в строке не менялся, и провайдер, зависящий только от
    // запроса, счёл бы, что перезапрашивать нечего.
    await tester.pumpWidget(harness(const SearchScreen()));

    final container = ProviderScope.containerOf(
      tester.element(find.byType(SearchScreen)),
    );
    final controller = container.read(storeSelectionProvider.notifier);

    await controller.pickStore(_bravo(3, 'Bravo Nizami'));
    await tester.enterText(find.byType(TextField), 'süd');
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();

    await controller.pickStore(_bravo(4, 'Bravo Xətai'));
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();

    expect(repository.searchedStores.length, 2);
  });

  testWidgets('вместе с экраном чистится и сохранённый кеш', (tester) async {
    // Второй возможный способ показать чужую цену: экран перезапросил, но
    // оффлайн-ветка достала из drift ответ, посчитанный для прошлой точки.
    await tester.pumpWidget(harness(const SearchScreen()));

    final container = ProviderScope.containerOf(
      tester.element(find.byType(SearchScreen)),
    );
    final controller = container.read(storeSelectionProvider.notifier);

    await controller.pickStore(_bravo(3, 'Bravo Nizami'));
    await cache.putDeals(storeId: 3, items: [_deal(1)]);
    expect((await cache.deals(storeId: 3)).value, isNotEmpty);

    await controller.pickStore(_bravo(4, 'Bravo Xətai'));
    await tester.pumpAndSettle();

    expect(
      (await cache.deals(storeId: 3)).value,
      isEmpty,
      reason: 'в кеше остались цены прошлой точки',
    );
  });

  testWidgets('выбор сети с единой ценой лишнего запроса не вызывает', (
    tester,
  ) async {
    // У Araz, SPAR, Neptun и Rahat цена одна на всю сеть: store_id не меняется,
    // сбрасывать нечего. Дёргать сеть на каждый чекбокс — трата трафика
    // у человека, который стоит в магазине с одной палочкой связи.
    await tester.pumpWidget(harness(const SearchScreen()));

    final container = ProviderScope.containerOf(
      tester.element(find.byType(SearchScreen)),
    );
    final controller = container.read(storeSelectionProvider.notifier);

    await tester.enterText(find.byType(TextField), 'süd');
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();
    expect(repository.searchedStores, [null]);

    await controller.toggleChain('araz');
    await controller.toggleChain('spar');
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();

    expect(repository.searchedStores, [
      null,
    ], reason: 'store_id не менялся, перезапрашивать нечего');
  });
}
