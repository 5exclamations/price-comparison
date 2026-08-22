import 'package:flutter/material.dart';

/// Типографика.
///
/// Шрифт Inter, подключён файлами в assets/fonts. Системный не годится:
/// в некоторых сборках Roboto нет ə (U+0259), и буква молча подменяется
/// из запасного шрифта — в азербайджанском тексте это заметно сразу, потому
/// что ə одна из самых частых букв.
///
/// Покрытие проверено по таблице cmap: Inter содержит ə ı ğ ş ç ö ü в обоих
/// регистрах и кириллицу для русской локали. Контрольная строка —
/// «Çuğundur, göbələk, şəkər tozu, ət və südlü məhsullar».
abstract final class AppFonts {
  static const String family = 'Inter';

  /// Цифры фиксированной ширины. Обязательны для цен: без них колонка чисел
  /// в списке дёргается при обновлении, потому что «1» уже «8».
  static const List<FontFeature> tabularFigures = [
    FontFeature.tabularFigures(),
  ];
}

/// Веса. Названия по назначению, а не по числу: так труднее поставить
/// «чуть пожирнее» просто потому, что захотелось.
abstract final class FontWeights {
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

/// Размеры шрифта. Шкала своя, но шаги осмысленные, а не «на глаз».
abstract final class FontSizes {
  static const double caption = 12;
  static const double body = 14;
  static const double bodyLarge = 16;
  static const double title = 18;
  static const double headline = 22;
  static const double display = 28;

  /// Отдельная шкала для цен: цена — главное число на экране.
  static const double priceSmall = 14;
  static const double priceMedium = 18;
  static const double priceLarge = 26;
}

/// Собирает TextTheme на базе Material 3 с нашим шрифтом.
TextTheme buildTextTheme(TextTheme base) {
  return base
      .copyWith(
        displaySmall: base.displaySmall?.copyWith(
          fontSize: FontSizes.display,
          fontWeight: FontWeights.bold,
          height: 1.2,
        ),
        headlineSmall: base.headlineSmall?.copyWith(
          fontSize: FontSizes.headline,
          fontWeight: FontWeights.semiBold,
          height: 1.25,
        ),
        titleMedium: base.titleMedium?.copyWith(
          fontSize: FontSizes.title,
          fontWeight: FontWeights.semiBold,
          height: 1.3,
        ),
        bodyLarge: base.bodyLarge?.copyWith(
          fontSize: FontSizes.bodyLarge,
          fontWeight: FontWeights.regular,
          height: 1.4,
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          fontSize: FontSizes.body,
          fontWeight: FontWeights.regular,
          height: 1.4,
        ),
        labelSmall: base.labelSmall?.copyWith(
          fontSize: FontSizes.caption,
          fontWeight: FontWeights.medium,
          height: 1.3,
        ),
      )
      .apply(fontFamily: AppFonts.family);
}
