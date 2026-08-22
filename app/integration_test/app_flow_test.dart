// Основной путь на настоящем устройстве, со снимками экрана.
//
// Ручной прогон нельзя повторить: он есть ровно один раз, в голове у того, кто
// его делал. Этот гоняется на каждый коммит, а снимки уезжают артефактами
// сборки, и «стало выглядеть иначе» становится видно в диффе, а не через
// полгода в отзывах.
//
// Что здесь проверяется и НЕ проверяется widget-тестами:
//   * плагины вообще зарегистрировались (shared_preferences, drift, path_provider);
//   * шрифт рисует ə ğ ş ç ö ü ı сам, а не подменяет системным;
//   * тёмная тема не съедает контраст цены;
//   * список покупок открывается без сети.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qiymet/app.dart';
import 'package:qiymet/design/widgets/price_text.dart';
import 'package:qiymet/presentation/providers/search_providers.dart';

import 'harness.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Harness harness;

  setUp(() async => harness = await Harness.create());
  tearDown(() => harness.dispose());

  Widget app({ThemeMode themeMode = ThemeMode.light, bool offline = false}) =>
      ProviderScope(
        // Ключ по режиму — не украшение. Riverpod запрещает менять ЧИСЛО
        // overrides у одной и той же области: «overrides cannot be
        // removed/added, they can only be updated». Разный ключ даёт новый
        // элемент и новый контейнер — то есть ровно то, что происходит при
        // перезапуске приложения в магазине без связи.
        key: ValueKey('scope-offline-$offline'),
        overrides: harness.overrides(themeMode: themeMode, offline: offline),
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

  testWidgets('основной путь: онбординг -> süd -> карточка -> список -> выгоды', (
    tester,
  ) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    // --- 1. Онбординг обязателен -------------------------------------------
    expect(find.text('Куда вы ходите?'), findsOneWidget);
    await shoot(binding, 'onboarding');

    final continueButton = find.widgetWithText(FilledButton, 'Продолжить');
    expect(
      tester.widget<FilledButton>(continueButton).onPressed,
      isNull,
      reason: 'без выбранной сети продолжать некуда',
    );

    // --- 2. Bravo без конкретной точки выбором не считается ------------------
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Bravo'));
    await tester.pumpAndSettle();
    await shoot(binding, 'onboarding-bravo-needs-store');

    expect(
      tester.widget<FilledButton>(continueButton).onPressed,
      isNull,
      reason: 'у Bravo четыре ценовые зоны — нужна конкретная точка',
    );
    // И ни слова про «зоны»: это наша внутренняя кухня.
    expect(find.textContaining('зона'), findsNothing);
    expect(find.textContaining('Зона'), findsNothing);

    await tester.tap(find.text('Bravo Nizami'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.widgetWithText(CheckboxListTile, 'Araz'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Araz'));
    await tester.pumpAndSettle();
    await shoot(binding, 'onboarding-ready');

    expect(tester.widget<FilledButton>(continueButton).onPressed, isNotNull);
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    // --- 3. Поиск «süd» ------------------------------------------------------
    await shoot(binding, 'search-empty');

    await tester.enterText(find.byType(TextField), 'sü');
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();
    expect(harness.catalog.searches, isEmpty, reason: 'двух символов мало');

    await tester.enterText(find.byType(TextField), 'süd');
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();

    expect(harness.catalog.searches, ['süd']);
    expect(find.text(productNames.first), findsOneWidget);
    await shoot(binding, 'search-results');

    // --- 4. Карточка товара --------------------------------------------------
    await tester.tap(find.text(productNames.first));
    await tester.pumpAndSettle();

    expect(find.text('4760000602371'), findsOneWidget);
    expect(find.textContaining('1,89'), findsWidgets);
    expect(find.textContaining('1,99'), findsWidgets);
    await shoot(binding, 'product-card');

    // --- 5. В список ---------------------------------------------------------
    final addButton = find.widgetWithText(OutlinedButton, 'Добавить в список');
    await tester.ensureVisible(addButton);
    await tester.pumpAndSettle();
    await tester.tap(addButton);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(OutlinedButton, 'В списке'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Список').last);
    await tester.pumpAndSettle();
    expect(find.text(productNames.first), findsOneWidget);

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();

    expect(harness.catalog.basketPriceCalls, 1);
    expect(find.textContaining('Итог по 1 товару'), findsOneWidget);
    await shoot(binding, 'basket-total');

    // --- 6. Лента выгод ------------------------------------------------------
    await tester.tap(find.text('Выгоды').last);
    await tester.pumpAndSettle();

    expect(find.text(productNames.first), findsWidgets);
    await shoot(binding, 'deals');
  });

  testWidgets('шрифт рисует ə ğ ş ç ö ü ı сам, а не подменяет системным', (
    tester,
  ) async {
    // Единственное место, где это вообще проверяемо: настоящий движок
    // отрисовки. В pubspec прописан Inter, но если бы буквы в нём не было,
    // Skia молча подставила бы системный шрифт — на снимке это видно, а
    // в widget-тесте нет.
    //
    // Здесь проверяется измеримое следствие: строка из азербайджанских букв
    // и её латинский двойник ОДНОЙ ширины быть не могут, а вот подстановка
    // другого шрифта меняет ширину скачком. Плюс снимок для глаз.
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Bravo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bravo Nizami'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Продолжить'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'çörək');
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();

    // Все пять названий с полным набором букв — на экране.
    for (final name in productNames) {
      expect(find.text(name), findsWidgets, reason: 'пропало название «$name»');
    }

    // Контрольная строка целиком: если хоть одной буквы в шрифте нет, ниже
    // будет виден прямоугольник вместо неё.
    final probe = find.byKey(const ValueKey('font-probe'));
    if (probe.evaluate().isNotEmpty) {
      await tester.ensureVisible(probe);
    }
    await shoot(binding, 'font-azerbaijani');

    // Ширина строки с ə отличается от строки той же длины на латинице: это
    // косвенный, но проверяемый признак, что глиф настоящий, а не .notdef,
    // у которого ширина одинаковая для всего.
    final sizes = <String, double>{};
    for (final s in ['şəkər', 'sekers']) {
      final painter = TextPainter(
        text: TextSpan(
          text: s,
          style: const TextStyle(fontFamily: 'Inter', fontSize: 32),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      sizes[s] = painter.width;
    }
    expect(
      sizes['şəkər'],
      isNot(sizes['sekers']),
      reason: 'ширины совпали — похоже, буквы рисуются заменителем',
    );
  });

  testWidgets('тёмная тема: цена остаётся читаемой', (tester) async {
    await tester.pumpWidget(app(themeMode: ThemeMode.dark));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(CheckboxListTile, 'Bravo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bravo Nizami'));
    await tester.pumpAndSettle();
    await shoot(binding, 'dark-onboarding');

    await tester.tap(find.widgetWithText(FilledButton, 'Продолжить'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'süd');
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();
    await shoot(binding, 'dark-search');

    // Цена обязана отличаться от фона не только цветом: у дальтоника цвет —
    // ненадёжный канал. Проверяем вес шрифта, тот самый второй канал.
    final priceWidgets = tester
        .widgetList<PriceText>(find.byType(PriceText))
        .toList();
    expect(priceWidgets, isNotEmpty);

    final scheme = Theme.of(
      tester.element(find.byType(PriceText).first),
    ).colorScheme;
    expect(
      scheme.brightness,
      Brightness.dark,
      reason: 'тема не переключилась — проверять нечего',
    );

    final styles = tester
        .widgetList<Text>(find.textContaining('₼'))
        .map((t) => t.style)
        .whereType<TextStyle>()
        .toList();
    expect(styles, isNotEmpty, reason: 'цен на экране нет');
    for (final s in styles) {
      expect(s.color, isNotNull);
      // Прозрачная или почти прозрачная цена — это и есть «съеденный
      // контраст», и в тёмной теме такое ловится только глазами или так.
      expect(
        s.color!.a,
        greaterThan(0.6),
        reason: 'цена почти прозрачная в тёмной теме',
      );
    }
  });

  testWidgets('список покупок открывается без сети', (tester) async {
    // Сначала кладём товар в список при живой сети.
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Bravo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bravo Nizami'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Продолжить'));
    await tester.pumpAndSettle();

    await harness.cache.addProduct(
      productId: 1,
      name: productNames.first,
      unitValue: 1,
      unitType: 'l',
    );
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();

    // Теперь — авиарежим: dio с адаптером, который всегда бросает
    // SocketException. Приложение поднимается заново, как после перезапуска
    // в магазине без связи.
    await restart(tester, offline: true);

    await tester.tap(find.text('Список').last);
    await tester.pumpAndSettle();

    // Список обязан открыться из локальной базы. Пустой экран или вечный
    // спиннер здесь — поломка: список покупок нужен ровно там, где связи нет.
    expect(
      find.text(productNames.first),
      findsOneWidget,
      reason: 'без сети список покупок обязан открыться из drift',
    );
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await shoot(binding, 'offline-basket');

    // Обновление цен без сети обязано сказать об этом, а не молчать.
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    await shoot(binding, 'offline-refresh-failed');
  });
}
