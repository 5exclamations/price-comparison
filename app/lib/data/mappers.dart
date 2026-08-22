import '../domain/models/deal.dart';
import '../domain/models/price_history.dart';
import '../domain/models/product_card.dart';
import '../domain/models/product_summary.dart';
import 'api/dto/deal_dto.dart';
import 'api/dto/history_dto.dart';
import 'api/dto/product_card_dto.dart';
import 'api/dto/search_response_dto.dart';

/// DTO -> доменная модель.
///
/// Отдельный слой нужен, чтобы форма ответа сервера не протекала в экраны:
/// когда API добавит поле или переименует его, правка будет здесь одна.

ProductSummary toProductSummary(SearchItemDto d) => ProductSummary(
  productId: d.productId,
  name: d.name,
  brand: d.brand,
  ean: d.ean,
  unitValue: d.unitValue,
  unitType: d.unitType,
  bestPriceMinor: d.bestPriceMinor,
  bestPriceChain: d.bestPriceChain,
  chainsCount: d.chainsCount,
  hasPromo: d.hasPromo,
  observedAt: d.observedAt,
  needsStoreSelection: d.needsStoreSelection,
);

ChainPrice toChainPrice(ChainPriceDto d) => ChainPrice(
  chainId: d.chainId,
  chainCode: d.chainCode,
  chainName: d.chainName,
  priceModel: d.priceModel,
  storeId: d.storeId,
  storeName: d.storeName,
  priceCluster: d.priceCluster,
  priceMinor: d.priceMinor,
  oldPriceMinor: d.oldPriceMinor,
  isPromo: d.isPromo,
  available: d.available,
  observedAt: d.observedAt,
  source: d.source,
  requiresStoreSelection: d.requiresStoreSelection,
);

ProductCard toProductCard(ProductCardDto d) => ProductCard(
  productId: d.productId,
  name: d.name,
  brand: d.brand,
  ean: d.ean,
  unitValue: d.unitValue,
  unitType: d.unitType,
  prices: d.prices.map(toChainPrice).toList(),
  chainsCount: d.chainsCount,
  bestPriceMinor: d.bestPriceMinor,
  bestPriceChain: d.bestPriceChain,
  needsStoreSelection: d.needsStoreSelection,
);

Deal toDeal(DealDto d) => Deal(
  dealId: d.dealId,
  productId: d.productId,
  name: d.name,
  brand: d.brand,
  ean: d.ean,
  chainCode: d.chainCode,
  storeId: d.storeId,
  storeName: d.storeName,
  priceCluster: d.priceCluster,
  priceMinor: d.priceMinor,
  oldPriceMinor: d.oldPriceMinor,
  marketPriceMinor: d.marketPriceMinor,
  referenceChains: d.referenceChains,
  claimedDiscount: d.claimedDiscount,
  realDiscount: d.realDiscount,
  inflation: d.inflation,
  inflated: d.inflated,
  observedAt: d.observedAt,
);

PriceHistory toPriceHistory(HistoryResponseDto d) => PriceHistory(
  productId: d.productId,
  days: d.days,
  points: [
    for (final p in d.points)
      PricePoint(
        observedAt: p.observedAt,
        priceMinor: p.priceMinor,
        oldPriceMinor: p.oldPriceMinor,
        isPromo: p.isPromo,
        chainCode: p.chainCode,
      ),
  ],
);
