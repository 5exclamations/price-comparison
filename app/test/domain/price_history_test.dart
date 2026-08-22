import 'package:flutter_test/flutter_test.dart';
import 'package:qiymet/domain/models/price_history.dart';

PricePoint point(int daysAgo, int priceMinor, {bool promo = false}) =>
    PricePoint(
      observedAt: DateTime.utc(2026, 8, 17).subtract(Duration(days: daysAgo)),
      priceMinor: priceMinor,
      isPromo: promo,
      chainCode: 'bravo',
    );

PriceHistory history(List<PricePoint> points) =>
    PriceHistory(productId: 1, days: 30, points: points);

void main() {
  group('рисовать ли график', () {
    test('пустая история — нет', () {
      expect(history(const []).isDrawable, isFalse);
    });

    test('один прогон — нет', () {
      // Ровно то состояние, в котором сейчас дамп: один сбор, одна точка.
      expect(history([point(0, 1000)]).isDrawable, isFalse);
    });

    test('две точки за сутки — нет', () {
      expect(history([point(1, 1000), point(0, 900)]).isDrawable, isFalse);
    });

    test('пять точек за три дня — нет, охват мал', () {
      final h = history([for (var d = 0; d < 5; d++) point(d % 3, 1000 + d)]);
      expect(h.span.inDays, lessThan(7));
      expect(h.isDrawable, isFalse);
    });

    test('две точки за месяц — нет, линия из двух точек врёт', () {
      // Охват достаточный, но по двум точкам график выглядит как ровная
      // прямая — то есть как утверждение «цена стабильна».
      final h = history([point(30, 1000), point(0, 900)]);
      expect(h.span.inDays, greaterThanOrEqualTo(7));
      expect(h.isDrawable, isFalse);
    });

    test('три точки ровно за неделю — да', () {
      final h = history([point(7, 1000), point(3, 950), point(0, 900)]);
      expect(h.span, PriceHistory.minSpan);
      expect(h.isDrawable, isTrue);
    });

    test('месяц наблюдений — да', () {
      final h = history([for (var d = 0; d <= 30; d++) point(d, 1000 + d * 3)]);
      expect(h.isDrawable, isTrue);
    });
  });

  group('крайние значения', () {
    test('минимум и максимум', () {
      final h = history([point(5, 1500), point(3, 900), point(0, 1200)]);
      expect(h.minPriceMinor, 900);
      expect(h.maxPriceMinor, 1500);
    });

    test('на пустой истории их нет', () {
      expect(history(const []).minPriceMinor, isNull);
      expect(history(const []).maxPriceMinor, isNull);
    });

    test('плоская история: минимум равен максимуму', () {
      final h = history([point(7, 700), point(3, 700), point(0, 700)]);
      expect(h.minPriceMinor, 700);
      expect(h.maxPriceMinor, 700);
      expect(
        h.isDrawable,
        isTrue,
        reason: 'данных хватает, линия просто ровная',
      );
    });
  });

  group('охват', () {
    test('считается от первой до последней точки', () {
      expect(
        history([point(10, 1), point(0, 2)]).span,
        const Duration(days: 10),
      );
    });

    test('порядок точек не важен', () {
      final a = history([point(0, 1), point(10, 2)]);
      final b = history([point(10, 2), point(0, 1)]);
      expect(a.span, b.span);
    });

    test('на пустой истории ноль', () {
      expect(history(const []).span, Duration.zero);
    });
  });
}
