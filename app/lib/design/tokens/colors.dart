import 'package:flutter/material.dart';

/// Цвета приложения.
///
/// Базовая палитра строится из одного зерна через Material 3, а всё, что
/// несёт смысл («дешевле всех», «накрутка»), лежит в [PriceColors] —
/// расширении темы, у которого есть отдельные значения для светлой и тёмной.
abstract final class Seed {
  /// Зелёный не выбран случайно: приложение про экономию, а не про распродажи.
  static const Color brand = Color(0xFF2E7D5B);
}

/// Смысловые цвета для цен.
///
/// ВАЖНО: цветом одним пользоваться нельзя. Дальтоников в Азербайджане
/// столько же, сколько везде — примерно каждый двенадцатый мужчина. Поэтому
/// «дешевле всех» и «дороже всех» различаются ещё и весом шрифта
/// (см. PriceEmphasis в design/widgets/price_text.dart), а в списке — ещё и
/// порядком строк. Цвет здесь третий канал, а не единственный.
@immutable
class PriceColors extends ThemeExtension<PriceColors> {
  const PriceColors({
    required this.cheapest,
    required this.cheapestContainer,
    required this.priciest,
    required this.neutral,
    required this.promo,
    required this.promoContainer,
    required this.inflatedWarning,
    required this.staleData,
  });

  /// Самая низкая цена среди сетей.
  final Color cheapest;
  final Color cheapestContainer;

  /// Самая высокая цена среди сетей.
  final Color priciest;

  /// Всё остальное между ними.
  final Color neutral;

  /// Идёт акция — и она честная.
  final Color promo;
  final Color promoContainer;

  /// Заявленная скидка глубже настоящей больше чем на 15 п.п.
  /// Такое приложение показывает, но не хвалит.
  final Color inflatedWarning;

  /// Данные старше 12 часов: сеть давно не обновлялась.
  final Color staleData;

  static const light = PriceColors(
    cheapest: Color(0xFF1B5E3F),
    cheapestContainer: Color(0xFFD7F0E2),
    priciest: Color(0xFF8A4B2A),
    neutral: Color(0xFF3A3A3A),
    promo: Color(0xFF1B5E3F),
    promoContainer: Color(0xFFD7F0E2),
    inflatedWarning: Color(0xFF8A6A00),
    staleData: Color(0xFF6B6B6B),
  );

  static const dark = PriceColors(
    cheapest: Color(0xFF7EE0AE),
    cheapestContainer: Color(0xFF102C20),
    priciest: Color(0xFFE0A57E),
    neutral: Color(0xFFDADADA),
    promo: Color(0xFF7EE0AE),
    promoContainer: Color(0xFF102C20),
    inflatedWarning: Color(0xFFE8C766),
    staleData: Color(0xFF9A9A9A),
  );

  @override
  PriceColors copyWith({
    Color? cheapest,
    Color? cheapestContainer,
    Color? priciest,
    Color? neutral,
    Color? promo,
    Color? promoContainer,
    Color? inflatedWarning,
    Color? staleData,
  }) {
    return PriceColors(
      cheapest: cheapest ?? this.cheapest,
      cheapestContainer: cheapestContainer ?? this.cheapestContainer,
      priciest: priciest ?? this.priciest,
      neutral: neutral ?? this.neutral,
      promo: promo ?? this.promo,
      promoContainer: promoContainer ?? this.promoContainer,
      inflatedWarning: inflatedWarning ?? this.inflatedWarning,
      staleData: staleData ?? this.staleData,
    );
  }

  @override
  PriceColors lerp(ThemeExtension<PriceColors>? other, double t) {
    if (other is! PriceColors) return this;
    return PriceColors(
      cheapest: Color.lerp(cheapest, other.cheapest, t)!,
      cheapestContainer: Color.lerp(
        cheapestContainer,
        other.cheapestContainer,
        t,
      )!,
      priciest: Color.lerp(priciest, other.priciest, t)!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
      promo: Color.lerp(promo, other.promo, t)!,
      promoContainer: Color.lerp(promoContainer, other.promoContainer, t)!,
      inflatedWarning: Color.lerp(inflatedWarning, other.inflatedWarning, t)!,
      staleData: Color.lerp(staleData, other.staleData, t)!,
    );
  }
}

/// Достать смысловые цвета из темы: `context.priceColors.cheapest`.
extension PriceColorsX on BuildContext {
  PriceColors get priceColors =>
      Theme.of(this).extension<PriceColors>() ?? PriceColors.light;
}
