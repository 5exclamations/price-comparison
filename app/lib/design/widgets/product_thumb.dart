import 'package:flutter/material.dart';

import '../../core/text.dart';
import '../tokens/spacing.dart';

/// Картинка товара, которая есть ВСЕГДА.
///
/// У ~2% карточек ссылки нет: сеть её не отдала, и взять неоткуда. Ещё
/// какая-то доля ссылок не загрузится — чужой CDN, метро, самолётный режим.
/// Поэтому виджет закрывает все четыре состояния, и ни одно из них не
/// оставляет пустое место в вёрстке:
///
///   ссылки нет      -> плашка
///   грузится        -> плашка (не спиннер: он дёргает глаз в длинном списке)
///   не загрузилась  -> плашка
///   загрузилась     -> картинка
///
/// Плашка не абстрактная серая клетка, а буква названия на своём цвете:
/// в ленте из пятидесяти позиций это единственное, что отличает одну
/// безкартиночную строку от другой.
class ProductThumb extends StatelessWidget {
  const ProductThumb({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = 56.0,
  });

  /// Название товара. Из него берётся буква и цвет плашки.
  final String name;

  /// Ссылка на картинку. null и пустая строка равнозначны.
  final String? imageUrl;

  final double size;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final fallback = _Fallback(name: name, size: size);

    if (url == null || url.isEmpty) return fallback;

    return ClipRRect(
      borderRadius: BorderRadius.circular(Radii.sm),
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        // Пока не декодирован ни один кадр — плашка. Размер занят с первого
        // кадра, и список не прыгает, когда картинки долетают вразнобой.
        //
        // Именно frameBuilder, а не loadingBuilder: у последнего
        // loadingProgress равен null не только когда всё загрузилось, но и
        // пока не пришёл первый чанк. То есть «progress == null -> показываем
        // child» рисует пустой RawImage — ровно ту дыру, которой тут быть не
        // должно. frame == null означает однозначное «кадра ещё нет».
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) return child;
          return fallback;
        },
        errorBuilder: (_, _, _) => fallback,
      ),
    );
  }
}

/// Плашка: буква названия на цвете, выведенном из этого же названия.
class _Fallback extends StatelessWidget {
  const _Fallback({required this.name, required this.size});

  final String name;
  final double size;

  /// Первая буква нормализованного названия.
  ///
  /// Через normalizeAz, а не через name[0].toUpperCase(): у турецкой «İ»
  /// toLowerCase даёт «i» + U+0307, и наивный срез первого символа вернул бы
  /// либо голую комбинирующую точку, либо букву с чужим акцентом. Та же
  /// ловушка, что и в поиске.
  String? get _letter {
    for (final rune in normalizeAzQuery(name).runes) {
      final ch = String.fromCharCode(rune);
      // Цифры пропускаем: карточка «7 UP» узнаваема по «U», а не по «7».
      if (RegExp(r'[a-zà-ÿа-я]').hasMatch(ch)) return ch.toUpperCase();
    }
    return null;
  }

  /// Цвет из названия. Детерминированный: у товара всегда один и тот же вид,
  /// в том числе после перезапуска и на другом телефоне.
  int get _hash {
    var h = 0;
    for (final rune in normalizeAzQuery(name).runes) {
      h = (h * 31 + rune) & 0x7FFFFFFF;
    }
    return h;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final letter = _letter;

    // Тон по кругу, насыщенность низкая: плашка обязана отличаться от соседней,
    // но не спорить с ценой, ради которой человек сюда и смотрит.
    final hue = (_hash % 360).toDouble();
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = HSLColor.fromAHSL(1, hue, 0.32, dark ? 0.26 : 0.90).toColor();
    final fg = HSLColor.fromAHSL(1, hue, 0.45, dark ? 0.78 : 0.32).toColor();

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Radii.sm),
      ),
      child: letter == null
          // Названия без единой буквы бывают — например, только код и вес.
          ? Icon(Icons.shopping_basket_outlined,
              size: size * 0.42, color: scheme.outline)
          : Text(
              letter,
              style: TextStyle(
                fontSize: size * 0.42,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
    );
  }
}
