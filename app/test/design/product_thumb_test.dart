import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qiymet/design/theme.dart';
import 'package:qiymet/design/widgets/product_thumb.dart';

Widget wrap(Widget child, {Brightness brightness = Brightness.light}) =>
    MaterialApp(
      theme: brightness == Brightness.light ? AppTheme.light() : AppTheme.dark(),
      home: Scaffold(body: Center(child: child)),
    );

/// Цвет плашки, чтобы сравнивать два рендера между собой.
Color bgOf(WidgetTester tester) {
  final container = tester.widget<Container>(
    find.descendant(
      of: find.byType(ProductThumb),
      matching: find.byType(Container),
    ),
  );
  return ((container.decoration! as BoxDecoration).color)!;
}

void main() {
  group('картинка есть всегда', () {
    testWidgets('без ссылки рисуется буква названия', (tester) async {
      await tester.pumpWidget(wrap(const ProductThumb(name: 'Süd 1 L')));

      expect(find.text('S'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('пустая строка равнозначна null', (tester) async {
      await tester.pumpWidget(
        wrap(const ProductThumb(name: 'Çörək', imageUrl: '')),
      );

      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('со ссылкой место занято ещё до загрузки', (tester) async {
      // Реальной сети в тестах нет, картинка не долетит никогда — и это ровно
      // тот случай, ради которого стоит loadingBuilder: плашка обязана быть
      // на экране с первого кадра, иначе список прыгает.
      await tester.pumpWidget(
        wrap(
          const ProductThumb(
            name: 'Pendir',
            imageUrl: 'https://example.invalid/x.jpg',
          ),
        ),
      );

      expect(find.byType(ProductThumb), findsOneWidget);
      expect(tester.getSize(find.byType(ProductThumb)).width, 56.0);
      expect(find.text('P'), findsOneWidget);
    });
  });

  group('буква', () {
    testWidgets('турецкая İ не превращается в комбинирующую точку', (
      tester,
    ) async {
      // 'İ'.toLowerCase() в Dart даёт 'i' + U+0307. Наивный срез первого
      // символа вернул бы букву с прилипшей точкой — та же ловушка, что и
      // в поиске, поэтому здесь normalizeAz.
      await tester.pumpWidget(wrap(const ProductThumb(name: 'İçməli su')));

      expect(find.text('I'), findsOneWidget);
    });

    testWidgets('цифры в начале пропускаются', (tester) async {
      await tester.pumpWidget(wrap(const ProductThumb(name: '7 UP 330 ml')));

      expect(find.text('U'), findsOneWidget);
    });

    testWidgets('название без букв даёт иконку, а не пустоту', (tester) async {
      await tester.pumpWidget(wrap(const ProductThumb(name: '750 500')));

      expect(find.byIcon(Icons.shopping_basket_outlined), findsOneWidget);
    });

    testWidgets('азербайджанские буквы сводятся к латинице', (tester) async {
      await tester.pumpWidget(wrap(const ProductThumb(name: 'Ət')));
      expect(find.text('A'), findsOneWidget);
    });
  });

  group('цвет плашки', () {
    testWidgets('одинаковый у одного названия', (tester) async {
      await tester.pumpWidget(wrap(const ProductThumb(name: 'Süd 1 L')));
      final first = bgOf(tester);

      await tester.pumpWidget(wrap(const ProductThumb(name: 'Süd 1 L')));
      expect(bgOf(tester), first);
    });

    testWidgets('разный у разных названий', (tester) async {
      await tester.pumpWidget(wrap(const ProductThumb(name: 'Süd 1 L')));
      final milk = bgOf(tester);

      await tester.pumpWidget(wrap(const ProductThumb(name: 'Çörək')));
      expect(bgOf(tester), isNot(milk));
    });

    // Светлую и тёмную темы проверяем разными тестами, а не двумя pumpWidget
    // подряд: во втором вызове поддерево с const-виджетом переиспользуется как
    // есть, плашка остаётся от первой темы, и тест вида «во второй раз темнее»
    // сравнивает результат сам с собой и всегда зелёный.
    testWidgets('в светлой теме плашка светлая', (tester) async {
      await tester.pumpWidget(
        wrap(const ProductThumb(name: 'Süd 1 L'), brightness: Brightness.light),
      );

      expect(bgOf(tester).computeLuminance(), greaterThan(0.5));
    });

    testWidgets('в тёмной теме плашка тёмная', (tester) async {
      await tester.pumpWidget(
        wrap(const ProductThumb(name: 'Süd 1 L'), brightness: Brightness.dark),
      );

      expect(bgOf(tester).computeLuminance(), lessThan(0.5));
    });
  });
}
