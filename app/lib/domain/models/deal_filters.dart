import 'package:freezed_annotation/freezed_annotation.dart';

part 'deal_filters.freezed.dart';

/// Фильтры ленты акций.
///
/// Все три уходят на сервер, ни один не применяется в клиенте. Причина
/// в курсорной пагинации: клиентский фильтр выбросил бы часть страницы, и
/// человек увидел бы три акции там, где их двадцать, а «загрузить ещё»
/// подтягивало бы такие же огрызки.
@freezed
abstract class DealFilters with _$DealFilters {
  const factory DealFilters({
    String? category,

    /// Порог по НАСТОЯЩЕЙ скидке в долях: 0.25 = минус 25% от рынка.
    double? minDiscount,

    /// «Только мои сети». Пусто — все.
    @Default(<String>{}) Set<String> chains,
  }) = _DealFilters;

  const DealFilters._();

  static const none = DealFilters();

  bool get isEmpty => category == null && minDiscount == null && chains.isEmpty;

  int get activeCount =>
      (category == null ? 0 : 1) +
      (minDiscount == null ? 0 : 1) +
      (chains.isEmpty ? 0 : 1);

  /// Коды сетей в том виде, в каком их ждёт API.
  String? get chainsParam =>
      chains.isEmpty ? null : (chains.toList()..sort()).join(',');
}

/// Пороги для фильтра «минимальная скидка».
///
/// Не произвольные: по замерам медианная выгода на акциях 26.7%, а у четверти
/// товаров скидка больше 44%. Шкала построена вокруг этих чисел, чтобы
/// пользователь отсекал шум, а не пустоту.
const List<double> discountThresholds = [0.10, 0.25, 0.40, 0.50];
