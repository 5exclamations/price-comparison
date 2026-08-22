import 'package:freezed_annotation/freezed_annotation.dart';

import 'product_card.dart';

part 'basket_item.freezed.dart';

/// Позиция списка покупок.
///
/// [productId] может быть null: человек имеет право дописать «хлеб» руками,
/// не выбирая товар из каталога. У такой позиции нет и не будет цены — она
/// живёт как обычный пункт списка, но в сумму корзины не входит и не портит
/// её молча.
@freezed
abstract class BasketItem with _$BasketItem {
  const factory BasketItem({
    required int id,
    int? productId,
    required String name,
    double? unitValue,
    String? unitType,
    @Default(false) bool done,
    required DateTime addedAt,

    /// Цены по сетям. Пусто, если позиция ручная либо цены ещё не загружены.
    @Default(<ChainPrice>[]) List<ChainPrice> prices,

    /// Когда цены обновлялись последний раз. Показывается рядом с суммой:
    /// корзина без времени наблюдения — такое же враньё, как цена без него.
    DateTime? pricesUpdatedAt,
  }) = _BasketItem;

  const BasketItem._();

  bool get isManual => productId == null;

  /// Лучшая цена среди [chains]. null, если позиции там нет.
  int? bestPriceIn(Set<String> chains) {
    int? best;
    for (final p in prices) {
      if (!chains.contains(p.chainCode)) continue;
      if (p.requiresStoreSelection || !p.available) continue;
      if (best == null || p.priceMinor < best) best = p.priceMinor;
    }
    return best;
  }

  String? bestChainIn(Set<String> chains) {
    int? best;
    String? code;
    for (final p in prices) {
      if (!chains.contains(p.chainCode)) continue;
      if (p.requiresStoreSelection || !p.available) continue;
      if (best == null || p.priceMinor < best) {
        best = p.priceMinor;
        code = p.chainCode;
      }
    }
    return code;
  }
}
