import 'package:freezed_annotation/freezed_annotation.dart';

part 'deal.freezed.dart';

/// Акция с настоящей и заявленной скидкой.
///
/// Настоящая скидка считается от медианы неакционных цен на тот же штрихкод в
/// ДРУГИХ сетях, а не от зачёркнутой цены на ценнике. Оба числа лежат рядом,
/// чтобы интерфейс мог показать разницу, а не выбирать, какому верить.
@freezed
abstract class Deal with _$Deal {
  const factory Deal({
    /// Устойчивый идентификатор акции. Один товар даёт несколько акций —
    /// по одной на сеть и ценовую зону, — поэтому productId для этого не годится.
    required int dealId,
    required int productId,
    required String name,
    String? brand,
    String? ean,
    required String chainCode,
    int? storeId,
    String? storeName,
    String? priceCluster,
    required int priceMinor,
    required int oldPriceMinor,

    /// Медиана неакционных цен на тот же штрихкод в других сетях.
    required int marketPriceMinor,
    required int referenceChains,
    required double claimedDiscount,
    required double realDiscount,
    required double inflation,

    /// Заявленная скидка глубже настоящей больше чем на 15 п.п.
    required bool inflated,
    required DateTime observedAt,
  }) = _Deal;
}
