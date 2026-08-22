import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_summary.freezed.dart';

/// Товар в результатах поиска.
///
/// Доменная модель, а не DTO: сюда не попадают поля, нужные только транспорту
/// (курсоры, служебные флаги). Виджеты работают с этим типом.
@freezed
abstract class ProductSummary with _$ProductSummary {
  const factory ProductSummary({
    required int productId,
    required String name,
    String? brand,
    String? ean,

    /// Фасовка: число и единица. Нужны вместе — «250» без «g» бессмысленно,
    /// а у kg_bulk числа нет вовсе, там цена за килограмм.
    double? unitValue,
    String? unitType,

    /// Лучшая цена в ГЯПИКАХ. null, если её нельзя назвать однозначно.
    int? bestPriceMinor,
    String? bestPriceChain,
    required int chainsCount,
    required bool hasPromo,

    /// Время наблюдения лучшей цены. Показывать цену без него нельзя.
    DateTime? observedAt,

    /// У сети с самой низкой ценой прайс зависит от магазина (Bravo),
    /// а магазин не выбран.
    @Default(false) bool needsStoreSelection,
  }) = _ProductSummary;
}
