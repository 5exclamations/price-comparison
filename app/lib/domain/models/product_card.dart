import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_card.freezed.dart';

/// Цена одной сети (или одной ценовой зоны внутри сети).
@freezed
abstract class ChainPrice with _$ChainPrice {
  const factory ChainPrice({
    required int chainId,
    required String chainCode,
    required String chainName,
    required String priceModel,
    int? storeId,
    String? storeName,

    /// Измеренная ценовая зона. У Bravo их четыре, и они не совпадают
    /// с форматом магазина.
    String? priceCluster,
    required int priceMinor,
    int? oldPriceMinor,
    required bool isPromo,
    required bool available,
    required DateTime observedAt,
    required String source,

    /// Цена зависит от выбранного магазина, а магазин не выбран.
    /// Показывать её как единственную цену сети нельзя.
    @Default(false) bool requiresStoreSelection,
  }) = _ChainPrice;
}

/// Карточка товара целиком.
@freezed
abstract class ProductCard with _$ProductCard {
  const factory ProductCard({
    required int productId,
    required String name,
    String? brand,
    String? ean,
    /// Картинка товара. null примерно у 2% карточек — у сети её нет.
    /// Показывать через ProductThumb: он рисует плашку, когда ссылки нет
    /// или она не загрузилась.
    String? imageUrl,
    double? unitValue,
    String? unitType,
    required List<ChainPrice> prices,
    required int chainsCount,
    int? bestPriceMinor,
    String? bestPriceChain,

    /// Коды сетей, чью цену нельзя показать без выбора магазина.
    @Default(<String>[]) List<String> needsStoreSelection,
  }) = _ProductCard;
}
