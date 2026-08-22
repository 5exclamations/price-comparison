import 'package:flutter/material.dart';

import '../../domain/models/packaging.dart';
import '../../l10n/app_localizations.dart';
import '../tokens/typography.dart';

/// Фасовка товара.
///
/// Главное здесь — весовые товары. У них `unitType == 'kg_bulk'`, цена указана
/// ЗА КИЛОГРАММ, и это нужно писать словами. Иначе человек сравнит цену
/// килограмма помидоров с ценой пачки печенья и сделает вывод наоборот.
class PackagingText extends StatelessWidget {
  const PackagingText({
    super.key,
    required this.packaging,
    this.style,
    this.emphasizePerKilogram = true,
  });

  final Packaging packaging;
  final TextStyle? style;

  /// Подсветить «цена за 1 кг» весом шрифта. На карточке товара это важно,
  /// в плотном списке — избыточно.
  final bool emphasizePerKilogram;

  @override
  Widget build(BuildContext context) {
    if (!packaging.isKnown) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final base = style ?? Theme.of(context).textTheme.labelSmall;

    if (packaging.isPerKilogram) {
      return Text(
        l10n.pricePerKilogram,
        style: base?.copyWith(
          fontWeight: emphasizePerKilogram
              ? FontWeights.semiBold
              : FontWeights.regular,
        ),
      );
    }

    return Text(formatPackaging(packaging), style: base);
  }
}

/// «270 q», «1,5 l», «10 ədəd».
///
/// Дробную часть показываем только когда она есть: «1 l» читается лучше,
/// чем «1.0 l», а «0,5 l» терять нельзя.
String formatPackaging(Packaging packaging) {
  final value = packaging.value;
  final type = packaging.type;
  if (value == null || type == null) return '';

  final suffix = unitSuffixAz[type.toLowerCase()] ?? type;
  final isWhole = value == value.roundToDouble();
  // Знаков после запятой ровно столько, сколько есть: у 1.5 — один, у 1.25 —
  // два. Проверяется остаток от ДЕЛЕНИЯ НА ЕДИНИЦУ после умножения на десять:
  // `value * 10 % 10` (было раньше) у 1.5 даёт 5 и уводило в два знака,
  // печатая «1.50 l».
  final number = isWhole
      ? value.round().toString()
      : value.toStringAsFixed(value * 10 % 1 == 0 ? 1 : 2);

  return '$number $suffix';
}
