/// Отступы. Шкала кратна 4 — других значений в приложении быть не должно.
///
/// Магическое число в виджете («SizedBox(height: 13)») выглядит безобидно
/// ровно до того момента, когда таких чисел становится сорок и половина
/// экранов расходится на пиксель. Если нужного шага нет — добавьте его сюда,
/// а не мимо.
abstract final class Spacing {
  /// 4 — только для склеивания иконки с подписью.
  static const double xs = 4;

  /// 8 — внутренние отступы мелких элементов, зазор между чипами.
  static const double sm = 8;

  /// 12 — между строками в списке.
  static const double md = 12;

  /// 16 — базовый отступ экрана и карточки.
  static const double lg = 16;

  /// 20 — между блоками внутри карточки.
  static const double xl = 20;

  /// 24 — между смысловыми блоками экрана.
  static const double xxl = 24;

  /// 32 — крупные разрывы, шапки.
  static const double xxxl = 32;

  /// 48 — пустые состояния, приветственные экраны.
  static const double huge = 48;
}

/// Радиусы скругления.
abstract final class Radii {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double pill = 999;
}

/// Толщина разделителей и рамок.
abstract final class Borders {
  static const double hairline = 1;
  static const double thick = 2;
}

/// Размеры, на которые нельзя нажать мимо: минимальная цель касания 48×48
/// по Material 3. Меньше — пользователь промахивается.
abstract final class TouchTarget {
  static const double min = 48;
}
