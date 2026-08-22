import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qiymet/design/theme.dart';
import 'package:qiymet/design/widgets/packaging_text.dart';
import 'package:qiymet/domain/models/packaging.dart';
import 'package:qiymet/l10n/app_localizations.dart';

Widget wrap(Widget child, {Locale locale = const Locale('ru')}) => MaterialApp(
  locale: locale,
  supportedLocales: const [Locale('az'), Locale('ru'), Locale('en')],
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  theme: AppTheme.light(),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('формат фасовки', () {
    test('целые значения без дробной части', () {
      expect(formatPackaging(const Packaging(value: 270, type: 'g')), '270 q');
      expect(formatPackaging(const Packaging(value: 1, type: 'l')), '1 l');
      expect(
        formatPackaging(const Packaging(value: 10, type: 'pcs')),
        '10 ədəd',
      );
    });

    test('дробные сохраняются', () {
      expect(formatPackaging(const Packaging(value: 1.5, type: 'l')), '1.5 l');
      expect(
        formatPackaging(const Packaging(value: 0.5, type: 'kg')),
        '0.5 kq',
      );
    });

    test('незнакомая единица показывается как есть, а не теряется', () {
      expect(
        formatPackaging(const Packaging(value: 3, type: 'banka')),
        '3 banka',
      );
    });

    test('без значения или типа — пусто', () {
      expect(formatPackaging(const Packaging(type: 'g')), '');
      expect(formatPackaging(const Packaging(value: 100)), '');
    });
  });

  group('весовые товары', () {
    test('kg_bulk распознаётся', () {
      const p = Packaging(type: 'kg_bulk');
      expect(p.isPerKilogram, isTrue);
      expect(
        p.isKnown,
        isTrue,
        reason: 'показывать есть что, пусть и без числа',
      );
    });

    testWidgets('пишем «цена за 1 кг» словами', (tester) async {
      // Без этой подписи человек сравнит цену килограмма помидоров с ценой
      // пачки печенья и решит, что помидоры дороже.
      await tester.pumpWidget(
        wrap(const PackagingText(packaging: Packaging(type: 'kg_bulk'))),
      );
      expect(find.text('цена за 1 кг'), findsOneWidget);
    });

    testWidgets('на карточке подпись выделена весом', (tester) async {
      await tester.pumpWidget(
        wrap(const PackagingText(packaging: Packaging(type: 'kg_bulk'))),
      );
      final style = tester.widget<Text>(find.text('цена за 1 кг')).style!;
      expect(style.fontWeight, FontWeight.w600);
    });

    testWidgets('в списке подпись не выделяется', (tester) async {
      await tester.pumpWidget(
        wrap(
          const PackagingText(
            packaging: Packaging(type: 'kg_bulk'),
            emphasizePerKilogram: false,
          ),
        ),
      );
      final style = tester.widget<Text>(find.text('цена за 1 кг')).style!;
      expect(style.fontWeight, FontWeight.w400);
    });

    testWidgets('на всех трёх языках подпись есть и различается', (
      tester,
    ) async {
      final seen = <String>{};
      for (final locale in [
        const Locale('az'),
        const Locale('ru'),
        const Locale('en'),
      ]) {
        await tester.pumpWidget(
          wrap(
            const PackagingText(packaging: Packaging(type: 'kg_bulk')),
            locale: locale,
          ),
        );
        final text = tester.widget<Text>(find.byType(Text)).data!;
        expect(text.isNotEmpty, isTrue);
        seen.add(text);
      }
      expect(seen.length, 3, reason: 'переводы обязаны различаться');
    });
  });

  testWidgets('неизвестная фасовка ничего не рисует', (tester) async {
    await tester.pumpWidget(wrap(const PackagingText(packaging: Packaging())));
    expect(find.byType(Text), findsNothing);
  });
}
