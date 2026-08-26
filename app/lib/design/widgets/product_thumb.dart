import 'package:cached_network_image/cached_network_image.dart';
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

    // Просим у CDN картинку под наш размер, а не оригинал. Разница не
    // косметическая: у Wolt оригинал 1200x666 весит 38 КБ, версия под превью —
    // 2.4 КБ. На экране поиска это полсотни картинок, то есть 1.9 МБ против
    // 120 КБ за один экран.
    final dpr = MediaQuery.maybeDevicePixelRatioOf(context) ?? 2.0;
    final targetPx = (size * dpr).round();
    final sized = _sizedUrl(url, targetPx);

    return ClipRRect(
      borderRadius: BorderRadius.circular(Radii.sm),
      // CachedNetworkImage, а не Image.network: у последнего кеш только
      // в памяти и только на время сеанса. Пролистал ленту вниз и обратно —
      // картинки качаются заново, и это ровно то мигание, которое видно
      // глазом. Дисковый кеш заодно даёт картинки офлайн, что для приложения
      // с офлайновым каталогом на drift обязано работать одинаково.
      child: CachedNetworkImage(
        imageUrl: sized,
        width: size,
        height: size,
        fit: BoxFit.cover,
        // Декодируем в размер показа, а не в размер файла. Без этого 600x333
        // держится в памяти целиком на каждую строку списка.
        memCacheWidth: targetPx,
        // Плашка вместо спиннера: размер занят с первого кадра, и список
        // не прыгает, когда картинки долетают вразнобой.
        placeholder: (_, _) => fallback,
        errorWidget: (_, _, _) => fallback,
        // Без анимации: в списке она читается как рябь, а не как плавность.
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
      ),
    );
  }
}

/// Ссылка на картинку нужного размера.
///
/// Оба CDN умеют отдавать уменьшенную копию, и не пользоваться этим — значит
/// тянуть по 38-57 КБ на каждую строку списка вместо 2-6 КБ. Замерено:
///
///   Wolt     1200x666  38.0 КБ  ->  ?w=200   200x111   2.4 КБ
///   Shopify            57.3 КБ  ->  ?width=160         5.7 КБ
///
/// Хост неизвестен — возвращаем ссылку как есть: лучше медленно, чем никак.
@visibleForTesting
String sizedImageUrl(String url, int targetPx) => _sizedUrl(url, targetPx);

String _sizedUrl(String url, int targetPx) {
  final uri = Uri.tryParse(url);
  if (uri == null) return url;

  final String param;
  final int value;
  switch (uri.host) {
    case 'wolt-menu-images-cdn.wolt.com':
      // Wolt округляет до своих ступеней (200, 300, 600, 1200) — просить
      // промежуточные значения бессмысленно, отдаст ближайшую сверху.
      param = 'w';
      value = targetPx <= 200
          ? 200
          : targetPx <= 300
          ? 300
          : targetPx <= 600
          ? 600
          : 1200;
    case 'cdn.shopify.com':
      // Shopify отдаёт ровно запрошенную ширину.
      param = 'width';
      value = targetPx;
    default:
      return url;
  }

  // Через queryParameters, а не конкатенацией: у Shopify в ссылке уже есть
  // `?v=...`, и приклеенный «?» превратил бы её в битую.
  return uri
      .replace(queryParameters: {...uri.queryParameters, param: '$value'})
      .toString();
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
