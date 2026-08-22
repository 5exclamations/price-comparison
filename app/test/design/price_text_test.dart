import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qiymet/design/theme.dart';
import 'package:qiymet/design/tokens/colors.dart';
import 'package:qiymet/design/tokens/typography.dart';
import 'package:qiymet/design/widgets/price_text.dart';

Widget _wrap(Widget child, {Locale locale = const Locale('az')}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: const [Locale('az'), Locale('ru'), Locale('en')],
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: AppTheme.light(),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
  });

  group('форматирование денег', () {
    test('гяпики превращаются в манаты без float', () {
      expect(PriceFormat.minorToString(1399, locale: 'en'), '13.99');
      expect(PriceFormat.minorToString(3469, locale: 'en'), '34.69');
      expect(PriceFormat.minorToString(100, locale: 'en'), '1.00');
      expect(PriceFormat.minorToString(5, locale: 'en'), '0.05');
      expect(PriceFormat.minorToString(0, locale: 'en'), '0.00');
    });

    test('копейки не теряются на некруглых значениях', () {
      // Именно здесь деление 1/100 в double дало бы 0.009999...
      for (var minor = 0; minor < 1000; minor++) {
        final s = PriceFormat.minorToString(minor, locale: 'en');
        expect(s.split('.').last.length, 2, reason: 'на $minor');
      }
    });

    test('разделитель зависит от локали', () {
      expect(PriceFormat.minorToString(1399, locale: 'en'), '13.99');
      expect(PriceFormat.minorToString(1399, locale: 'ru'), '13,99');
      expect(PriceFormat.minorToString(1399, locale: 'az'), '13,99');
    });

    test('крупные числа группируются', () {
      final s = PriceFormat.minorToString(123456789, locale: 'en');
      expect(s, endsWith('.89'));
      expect(s.startsWith('1'), isTrue);
      expect(s.length, greaterThan(9), reason: 'ожидались разделители групп');
    });

    test('отрицательные значения не ломают формат', () {
      expect(PriceFormat.minorToString(-1399, locale: 'en'), '-13.99');
    });

    test('к показу добавляется знак маната', () {
      expect(
        PriceFormat.minorToDisplay(1399, locale: 'en'),
        '13.99${PriceFormat.nbsp}₼',
      );
    });
  });

  group('PriceText', () {
    testWidgets('показывает цену', (tester) async {
      await tester.pumpWidget(_wrap(const PriceText(minor: 1399)));
      expect(find.textContaining('13,99'), findsOneWidget);
      expect(find.textContaining('₼'), findsOneWidget);
    });

    testWidgets('зачёркивает старую цену', (tester) async {
      await tester.pumpWidget(
        _wrap(const PriceText(minor: 1399, oldMinor: 3469)),
      );
      expect(find.textContaining('13,99'), findsOneWidget);

      final old = tester.widget<Text>(find.text('34,69'));
      expect(old.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('не зачёркивает цену, которая не выше текущей', (tester) async {
      // «Старая» цена ниже новой означала бы, что цена выросла.
      // Зачёркивать там нечего, и показывать её нельзя.
      await tester.pumpWidget(
        _wrap(const PriceText(minor: 3469, oldMinor: 1399)),
      );
      expect(find.text('13,99'), findsNothing);
    });

    testWidgets('дешевле и дороже всех различаются ВЕСОМ, а не только цветом', (
      tester,
    ) async {
      // Дальтоников примерно каждый двенадцатый мужчина. Если бы разница была
      // только в цвете, для них экран стал бы нечитаемым.
      await tester.pumpWidget(
        _wrap(
          const Column(
            children: [
              PriceText(minor: 1000, emphasis: PriceEmphasis.cheapest),
              PriceText(minor: 2000, emphasis: PriceEmphasis.neutral),
              PriceText(minor: 3000, emphasis: PriceEmphasis.priciest),
            ],
          ),
        ),
      );

      final cheapest = tester
          .widget<Text>(find.text('10,00${PriceFormat.nbsp}₼'))
          .style!;
      final neutral = tester
          .widget<Text>(find.text('20,00${PriceFormat.nbsp}₼'))
          .style!;
      final priciest = tester
          .widget<Text>(find.text('30,00${PriceFormat.nbsp}₼'))
          .style!;

      // Вес — независимый от цвета канал различения
      expect(cheapest.fontWeight, FontWeights.bold);
      expect(neutral.fontWeight, FontWeights.regular);
      expect(priciest.fontWeight, FontWeights.medium);
      expect(cheapest.fontWeight, isNot(priciest.fontWeight));

      // Цвет тоже различается, но он вторичен
      expect(cheapest.color, isNot(priciest.color));
      expect(cheapest.color, PriceColors.light.cheapest);
      expect(priciest.color, PriceColors.light.priciest);
    });

    testWidgets('цифры моноширинные — колонка цен не дёргается', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const PriceText(minor: 1399)));
      final style = tester
          .widget<Text>(find.text('13,99${PriceFormat.nbsp}₼'))
          .style!;
      expect(style.fontFeatures, contains(const FontFeature.tabularFigures()));
    });

    testWidgets('размер меняется по PriceSize', (tester) async {
      for (final (size, expected) in [
        (PriceSize.small, FontSizes.priceSmall),
        (PriceSize.medium, FontSizes.priceMedium),
        (PriceSize.large, FontSizes.priceLarge),
      ]) {
        await tester.pumpWidget(_wrap(PriceText(minor: 1000, size: size)));
        expect(
          tester
              .widget<Text>(find.text('10,00${PriceFormat.nbsp}₼'))
              .style!
              .fontSize,
          expected,
        );
      }
    });

    testWidgets('скринридер получает осмысленную подпись', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PriceText(
            minor: 1399,
            oldMinor: 3469,
            semanticPrefix: 'Bravo, зона B',
          ),
        ),
      );
      expect(
        find.bySemanticsLabel(RegExp(r'Bravo.*13,99.*34,69')),
        findsOneWidget,
      );
    });

    testWidgets('локаль берётся из контекста', (tester) async {
      await tester.pumpWidget(
        _wrap(const PriceText(minor: 1399), locale: const Locale('en')),
      );
      expect(find.text('13.99${PriceFormat.nbsp}₼'), findsOneWidget);
    });

    testWidgets('в тёмной теме цвета другие, а веса те же', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('az'),
          supportedLocales: const [Locale('az')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.dark(),
          home: const Scaffold(
            body: PriceText(minor: 1000, emphasis: PriceEmphasis.cheapest),
          ),
        ),
      );
      final style = tester
          .widget<Text>(find.text('10,00${PriceFormat.nbsp}₼'))
          .style!;
      expect(style.color, PriceColors.dark.cheapest);
      expect(style.fontWeight, FontWeights.bold);
    });
  });
}
