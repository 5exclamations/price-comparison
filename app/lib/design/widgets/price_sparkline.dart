import 'package:flutter/material.dart';

import '../../domain/models/price_history.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import 'price_text.dart';

/// График цены за период.
///
/// Рисуется вручную, без библиотеки графиков: линия по точкам и две подписи —
/// это ровно та задача, ради которой не стоит тащить зависимость с своим
/// API, своими багами и своим циклом обновлений.
///
/// Виджет НЕ решает, рисовать ли себя. Это решает [PriceHistory.isDrawable]:
/// при нехватке данных экран пишет словами, а не показывает линию из двух
/// точек, которая выглядит как утверждение «цена не менялась».
class PriceSparkline extends StatelessWidget {
  const PriceSparkline({super.key, required this.history, this.height = 120});

  final PriceHistory history;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.priceColors;
    final min = history.minPriceMinor;
    final max = history.maxPriceMinor;
    if (min == null || max == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(
            painter: _SparklinePainter(
              points: history.points,
              line: colors.cheapest,
              promo: colors.promo,
              grid: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        // Подписи крайних значений: без них линия — просто красивая загогулина.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PriceText(
              minor: min,
              size: PriceSize.small,
              emphasis: PriceEmphasis.cheapest,
            ),
            PriceText(
              minor: max,
              size: PriceSize.small,
              emphasis: PriceEmphasis.priciest,
            ),
          ],
        ),
      ],
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({
    required this.points,
    required this.line,
    required this.promo,
    required this.grid,
  });

  final List<PricePoint> points;
  final Color line;
  final Color promo;
  final Color grid;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final sorted = [...points]
      ..sort((a, b) => a.observedAt.compareTo(b.observedAt));

    final t0 = sorted.first.observedAt.millisecondsSinceEpoch;
    final t1 = sorted.last.observedAt.millisecondsSinceEpoch;
    final prices = sorted.map((p) => p.priceMinor).toList();
    final pMin = prices.reduce((a, b) => a < b ? a : b);
    final pMax = prices.reduce((a, b) => a > b ? a : b);

    // Плоская линия — тоже результат: цена не менялась. Рисуем её по центру,
    // а не делим на ноль.
    final spanT = (t1 - t0) == 0 ? 1 : (t1 - t0);
    final spanP = (pMax - pMin) == 0 ? 1 : (pMax - pMin);
    final flat = pMax == pMin;

    Offset at(PricePoint p) {
      final x = (p.observedAt.millisecondsSinceEpoch - t0) / spanT * size.width;
      final y = flat
          ? size.height / 2
          : size.height - (p.priceMinor - pMin) / spanP * size.height;
      return Offset(x, y.clamp(0.0, size.height));
    }

    // Горизонтали по краям диапазона.
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = Borders.hairline;
    canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), gridPaint);
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      gridPaint,
    );

    final path = Path()..moveTo(at(sorted.first).dx, at(sorted.first).dy);
    for (final p in sorted.skip(1)) {
      final o = at(p);
      path.lineTo(o.dx, o.dy);
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Точки, где шла акция, помечаем отдельно: по одной линии не видно,
    // была цена акционной или просто низкой.
    final dot = Paint()..color = promo;
    for (final p in sorted) {
      if (p.isPromo) canvas.drawCircle(at(p), 3, dot);
    }
  }

  @override
  bool shouldRepaint(_SparklinePainter old) =>
      old.points != points || old.line != line;
}
