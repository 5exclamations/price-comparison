import 'package:freezed_annotation/freezed_annotation.dart';

import 'deal.dart';

part 'deals_page.freezed.dart';

/// Страница ленты акций.
///
/// Курсор, а не номер страницы: витрина пересобирается после каждого прогона
/// сбора, и OFFSET показал бы товары, часть которых уже была выше.
@freezed
abstract class DealsPage with _$DealsPage {
  const factory DealsPage({
    required List<Deal> items,
    String? nextCursor,
    @Default(false) bool hasMore,
  }) = _DealsPage;
}
