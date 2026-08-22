import 'package:freezed_annotation/freezed_annotation.dart';

part 'freshness.freezed.dart';

/// Откуда взялись данные и насколько они свежие.
///
/// Обёртка нужна из-за одного правила: пользователь простит цену трёхчасовой
/// давности, если видит, когда её проверяли. Молча устаревшую не простит —
/// съездит в магазин, не найдёт цену и удалит приложение. Поэтому «откуда» и
/// «когда» едут вместе с данными, а не теряются в репозитории.
@freezed
abstract class Fresh<T> with _$Fresh<T> {
  const factory Fresh({
    required T value,

    /// true = ответ пришёл из локального кеша, сеть недоступна.
    @Default(false) bool fromCache,

    /// Когда данные были положены в кеш. Заполнено только при fromCache.
    DateTime? cachedAt,
  }) = _Fresh<T>;

  const Fresh._();

  /// Показывать ли плашку «данные от 14:20».
  bool get needsStaleWarning => fromCache && cachedAt != null;
}
