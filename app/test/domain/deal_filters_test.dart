import 'package:flutter_test/flutter_test.dart';
import 'package:qiymet/domain/models/deal_filters.dart';

void main() {
  group('пустые фильтры', () {
    test('по умолчанию ничего не задано', () {
      expect(DealFilters.none.isEmpty, isTrue);
      expect(DealFilters.none.activeCount, 0);
      expect(DealFilters.none.chainsParam, isNull);
    });
  });

  group('счётчик активных', () {
    test('каждый фильтр считается один раз', () {
      expect(const DealFilters(minDiscount: 0.25).activeCount, 1);
      expect(const DealFilters(category: 'süd').activeCount, 1);
      expect(const DealFilters(chains: {'araz'}).activeCount, 1);
    });

    test('несколько сетей — всё равно один активный фильтр', () {
      expect(
        const DealFilters(chains: {'araz', 'bravo', 'spar'}).activeCount,
        1,
      );
    });

    test('все три вместе', () {
      const f = DealFilters(
        category: 'süd',
        minDiscount: 0.4,
        chains: {'araz'},
      );
      expect(f.activeCount, 3);
      expect(f.isEmpty, isFalse);
    });
  });

  group('параметр сетей для API', () {
    test('пустой набор не отправляется вовсе', () {
      expect(const DealFilters().chainsParam, isNull);
    });

    test('коды через запятую', () {
      expect(const DealFilters(chains: {'araz'}).chainsParam, 'araz');
    });

    test('порядок стабильный, иначе кеш промахнётся', () {
      // Set не гарантирует порядок. Без сортировки один и тот же выбор давал
      // бы разные URL и разные ключи кеша — и на сервере, и в dio.
      const a = DealFilters(chains: {'spar', 'araz', 'bravo'});
      const b = DealFilters(chains: {'bravo', 'spar', 'araz'});
      expect(a.chainsParam, b.chainsParam);
      expect(a.chainsParam, 'araz,bravo,spar');
    });
  });

  group('пороги скидки', () {
    test('шкала построена вокруг измеренных значений', () {
      // Медианная выгода на акциях 26.7%, у четверти товаров больше 44%.
      expect(discountThresholds, contains(0.25));
      expect(discountThresholds, contains(0.40));
    });

    test('пороги возрастают и лежат в допустимом диапазоне', () {
      final sorted = [...discountThresholds]..sort();
      expect(discountThresholds, sorted);
      for (final t in discountThresholds) {
        expect(t, greaterThan(0));
        expect(t, lessThan(1));
      }
    });
  });
}
