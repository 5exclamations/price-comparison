import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_history.freezed.dart';

@freezed
abstract class PricePoint with _$PricePoint {
  const factory PricePoint({
    required DateTime observedAt,
    required int priceMinor,
    int? oldPriceMinor,
    required bool isPromo,
    required String chainCode,
  }) = _PricePoint;
}

/// История цены за период.
@freezed
abstract class PriceHistory with _$PriceHistory {
  const factory PriceHistory({
    required int productId,
    required int days,
    required List<PricePoint> points,
  }) = _PriceHistory;

  const PriceHistory._();

  /// Минимум наблюдений, ниже которого линия — не линия, а две точки.
  static const minPoints = 3;

  /// Минимальный охват. Меньше недели — рисовать нечего.
  static const minSpan = Duration(days: 7);

  DateTime? get first =>
      points.isEmpty ? null : points.map((p) => p.observedAt).reduce(_min);
  DateTime? get last =>
      points.isEmpty ? null : points.map((p) => p.observedAt).reduce(_max);

  Duration get span {
    final a = first, b = last;
    if (a == null || b == null) return Duration.zero;
    return b.difference(a);
  }

  /// Хватает ли данных, чтобы рисовать график.
  ///
  /// Пустой или почти пустой график хуже его отсутствия: он выглядит как
  /// утверждение «цена не менялась», хотя на самом деле мы просто ещё не
  /// смотрели. Поэтому при нехватке данных экран пишет словами, а не рисует.
  bool get isDrawable => points.length >= minPoints && span >= minSpan;

  int? get minPriceMinor => points.isEmpty
      ? null
      : points.map((p) => p.priceMinor).reduce((a, b) => a < b ? a : b);
  int? get maxPriceMinor => points.isEmpty
      ? null
      : points.map((p) => p.priceMinor).reduce((a, b) => a > b ? a : b);

  static DateTime _min(DateTime a, DateTime b) => a.isBefore(b) ? a : b;
  static DateTime _max(DateTime a, DateTime b) => a.isAfter(b) ? a : b;
}
