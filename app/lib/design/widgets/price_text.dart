import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// Насколько эта цена хороша относительно остальных сетей.
///
/// Различаются НЕ ТОЛЬКО цветом. Дальтоников примерно каждый двенадцатый
/// мужчина, и в Азербайджане их столько же, сколько везде, поэтому у каждого
/// состояния свой вес шрифта:
///
///   cheapest  — жирный (w700)
///   neutral   — обычный (w400)
///   priciest  — средний (w500), но приглушённого цвета
///
/// Разница в весе видна и на чёрно-белом экране, и человеку, который вообще
/// не различает зелёный с красным.
enum PriceEmphasis {
  /// Самая низкая цена среди сетей.
  cheapest,

  /// Между лучшей и худшей.
  neutral,

  /// Самая высокая цена среди сетей.
  priciest,
}

/// Размер цены на экране.
enum PriceSize {
  /// В плотных списках.
  small,

  /// По умолчанию: карточка товара, строка сети.
  medium,

  /// Главная цена на экране товара.
  large,
}

/// Форматирование денег. **Единственное место в приложении**, где гяпики
/// превращаются в манаты.
///
/// Правило проекта: деньги везде целые числа гяпиков, форматирование только
/// на границе показа. Если понадобилось отформатировать цену где-то ещё —
/// значит, туда нужно передать [PriceText], а не строку.
abstract final class PriceFormat {
  static const String currencySymbol = '₼';

  /// Неразрывный пробел между суммой и знаком маната.
  ///
  /// Обычный пробел позволил бы «₼» уехать на следующую строку и оставить
  /// голое число — в списке цен это выглядит как другая валюта. Константа
  /// названа потому, что символ невидим: тесты, набиравшие его на глаз,
  /// сравнивали строки, которые различаются одним байтом.
  static const String nbsp = '\u00A0';

  /// Гяпики в строку по правилам локали.
  ///
  /// Считается целочисленно: 1399 -> «13» и «99», а не 1399 / 100. Деление
  /// дало бы double, то есть ровно тот float, которого в деньгах быть не
  /// должно. Разделитель и группировка берутся из локали: в az и ru это
  /// запятая, в en — точка.
  static String minorToString(int minor, {String? locale}) {
    final negative = minor < 0;
    final abs = minor.abs();
    final whole = abs ~/ 100;
    final fraction = abs % 100;

    final grouped = NumberFormat.decimalPattern(locale).format(whole);
    final separator = NumberFormat.decimalPattern(locale).symbols.DECIMAL_SEP;
    final sign = negative ? '-' : '';

    return '$sign$grouped$separator${fraction.toString().padLeft(2, '0')}';
  }

  /// То же самое, но со знаком маната.
  static String minorToDisplay(int minor, {String? locale}) =>
      '${minorToString(minor, locale: locale)}$nbsp$currencySymbol';
}

/// Цена. Принимает целое число гяпиков и умеет показать зачёркнутую старую.
///
/// ```dart
/// PriceText(minor: 1399, oldMinor: 3469, emphasis: PriceEmphasis.cheapest)
/// // 13,99 ₼  3̶4̶,̶6̶9̶
/// ```
class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    required this.minor,
    this.oldMinor,
    this.emphasis = PriceEmphasis.neutral,
    this.size = PriceSize.medium,
    this.locale,
    this.semanticPrefix,
  });

  /// Цена в гяпиках. Именно int — никаких double в деньгах.
  final int minor;

  /// Зачёркнутая цена в гяпиках. Показывается, только если строго больше
  /// текущей: «старая цена» ниже новой означала бы, что цена выросла, и
  /// зачёркивать там нечего.
  final int? oldMinor;

  final PriceEmphasis emphasis;
  final PriceSize size;

  /// Локаль форматирования. По умолчанию берётся из контекста.
  final String? locale;

  /// Приписка для скринридера: «Bravo, зона B».
  final String? semanticPrefix;

  double get _fontSize => switch (size) {
    PriceSize.small => FontSizes.priceSmall,
    PriceSize.medium => FontSizes.priceMedium,
    PriceSize.large => FontSizes.priceLarge,
  };

  /// Вес — второй канал различения, независимый от цвета.
  FontWeight get _weight => switch (emphasis) {
    PriceEmphasis.cheapest => FontWeights.bold,
    PriceEmphasis.neutral => FontWeights.regular,
    PriceEmphasis.priciest => FontWeights.medium,
  };

  Color _color(BuildContext context) => switch (emphasis) {
    PriceEmphasis.cheapest => context.priceColors.cheapest,
    PriceEmphasis.neutral => context.priceColors.neutral,
    PriceEmphasis.priciest => context.priceColors.priciest,
  };

  @override
  Widget build(BuildContext context) {
    final effectiveLocale =
        locale ?? Localizations.localeOf(context).toString();
    final current = PriceFormat.minorToDisplay(minor, locale: effectiveLocale);

    final showOld = oldMinor != null && oldMinor! > minor;
    final old = showOld
        ? PriceFormat.minorToString(oldMinor!, locale: effectiveLocale)
        : null;

    return Semantics(
      label: [
        if (semanticPrefix != null) semanticPrefix,
        current,
        if (old != null) 'вместо $old',
      ].join(', '),
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            current,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: _fontSize,
              fontWeight: _weight,
              color: _color(context),
              fontFeatures: AppFonts.tabularFigures,
              height: 1.1,
            ),
          ),
          if (old != null) ...[
            const SizedBox(width: Spacing.sm),
            Text(
              old,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: _fontSize * 0.75,
                fontWeight: FontWeights.regular,
                color: context.priceColors.staleData,
                fontFeatures: AppFonts.tabularFigures,
                decoration: TextDecoration.lineThrough,
                decorationThickness: 1.5,
                height: 1.1,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
