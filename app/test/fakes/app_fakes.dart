// Фейки и данные для прогонов приложения целиком.
//
// Один файл на две стороны: headless-тесты в test/integration/ и прогон на
// устройстве в integration_test/. Если развести их по копиям, «прошло локально»
// и «прошло на эмуляторе» начнут означать разное, и разойдутся они молча.
//
// Заглушено ровно то, что выходит наружу: два HTTP-репозитория и, для
// авиарежима, адаптер внутри dio.
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:qiymet/data/repositories/catalog_repository.dart';
import 'package:qiymet/data/repositories/store_repository.dart';
import 'package:qiymet/domain/models/deal.dart';
import 'package:qiymet/domain/models/deals_page.dart';
import 'package:qiymet/domain/models/freshness.dart';
import 'package:qiymet/domain/models/price_history.dart';
import 'package:qiymet/domain/models/product_card.dart';
import 'package:qiymet/domain/models/product_summary.dart';
import 'package:qiymet/domain/models/store.dart';

final observedAt = DateTime.utc(2026, 8, 17, 11, 20);

/// Три сети с единой ценой и одна с ценой по точкам — как в жизни.
final testStores = <Store>[
  const Store(
    storeId: null,
    chainId: 1,
    chainCode: 'araz',
    chainName: 'Araz',
    priceModel: 'single',
    name: 'Araz',
    synthetic: true,
  ),
  const Store(
    storeId: null,
    chainId: 4,
    chainCode: 'neptun',
    chainName: 'Neptun',
    priceModel: 'single',
    name: 'Neptun',
    synthetic: true,
  ),
  const Store(
    storeId: 11,
    chainId: 2,
    chainCode: 'bravo',
    chainName: 'Bravo',
    priceModel: 'per_cluster',
    name: 'Bravo Nizami',
    synthetic: false,
  ),
  const Store(
    storeId: 12,
    chainId: 2,
    chainCode: 'bravo',
    chainName: 'Bravo',
    priceModel: 'per_cluster',
    name: 'Bravo Xətai',
    synthetic: false,
  ),
];

/// Названия с полным набором азербайджанских букв: ə ğ ş ç ö ü ı.
///
/// Это не украшение выборки. Единственный способ убедиться, что шрифт рисует
/// их сам, а не подменяет системным, — увидеть их в настоящем рендере.
const productNames = <String>[
  'Süd 2.5% 1 L',
  'Çörək buğda 500 qr',
  'Şəkər tozu 1 kq',
  'Göbələk şampinyon 400 qr',
  'Çuğundur kq',
];

ProductCard milkCard({required int? storeId}) => ProductCard(
  productId: 1,
  name: productNames.first,
  brand: 'Palıd',
  ean: '4760000602371',
  unitValue: 1,
  unitType: 'l',
  chainsCount: 3,
  bestPriceMinor: 189,
  bestPriceChain: 'araz',
  prices: [
    ChainPrice(
      chainId: 1,
      chainCode: 'araz',
      chainName: 'Araz',
      priceModel: 'single',
      priceMinor: 189,
      isPromo: false,
      available: true,
      observedAt: observedAt,
      source: 'web',
    ),
    ChainPrice(
      chainId: 4,
      chainCode: 'neptun',
      chainName: 'Neptun',
      priceModel: 'single',
      priceMinor: 205,
      isPromo: false,
      available: true,
      observedAt: observedAt,
      source: 'web',
    ),
    if (storeId != null)
      ChainPrice(
        chainId: 2,
        chainCode: 'bravo',
        chainName: 'Bravo',
        priceModel: 'per_cluster',
        storeId: storeId,
        storeName: 'Bravo Nizami',
        priceMinor: 199,
        isPromo: false,
        available: true,
        observedAt: observedAt,
        source: 'web',
      ),
  ],
);

Deal deal(int id, String name) => Deal(
  dealId: id,
  productId: id,
  name: name,
  chainCode: 'bravo',
  storeId: 11,
  storeName: 'Bravo Nizami',
  priceMinor: 149 + id,
  oldPriceMinor: 320 + id,
  marketPriceMinor: 299 + id,
  referenceChains: 3,
  claimedDiscount: 0.53,
  realDiscount: 0.5,
  inflation: 0.03,
  inflated: id == 3,
  observedAt: observedAt,
);

class FakeStoreRepository implements StoreRepository {
  @override
  Future<List<Store>> stores({double? lat, double? lon}) async => testStores;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeCatalogRepository implements CatalogRepository {
  final List<String> searches = [];
  int basketPriceCalls = 0;

  @override
  Future<Fresh<List<ProductSummary>>> search({
    required String query,
    int? storeId,
    int limit = 20,
  }) async {
    searches.add(query);
    return Fresh(
      value: [
        for (var i = 0; i < productNames.length; i++)
          ProductSummary(
            productId: i + 1,
            name: productNames[i],
            brand: i == 0 ? 'Palıd' : null,
            ean: i == 0 ? '4760000602371' : null,
            unitValue: i == 0 ? 1 : null,
            unitType: i == 0 ? 'l' : (i == 4 ? 'kg_bulk' : null),
            bestPriceMinor: 189 + i * 37,
            bestPriceChain: 'araz',
            chainsCount: 3,
            hasPromo: i.isOdd,
            observedAt: observedAt,
          ),
      ],
    );
  }

  @override
  Future<ProductCard?> product({required int productId, int? storeId}) async =>
      productId == 1 ? milkCard(storeId: storeId) : null;

  @override
  Future<Map<int, List<ChainPrice>>> basketPrices({
    required List<int> productIds,
    int? storeId,
  }) async {
    basketPriceCalls++;
    return {
      for (final id in productIds)
        if (id == 1) id: milkCard(storeId: storeId).prices,
    };
  }

  @override
  Future<Fresh<DealsPage>> deals({
    int? storeId,
    double? minDiscount,
    String? category,
    String? chains,
    int limit = 20,
    String? cursor,
  }) async => Fresh(
    value: DealsPage(
      items: [
        for (var i = 0; i < productNames.length; i++)
          deal(i + 1, productNames[i]),
      ],
    ),
  );

  @override
  Future<List<String>> categories() async => const [];

  @override
  Future<PriceHistory> history({
    required int productId,
    int days = 30,
    int? storeId,
  }) async => PriceHistory(productId: productId, days: days, points: const []);

  @override
  Future<void> watch({
    required int productId,
    int? storeId,
    int? targetPriceMinor,
  }) async {}

  @override
  Future<Set<int>> watchedProductIds() async => const {};

  @override
  Future<void> unwatch(int watchId) async {}

  @override
  Future<int?> watchIdFor(int productId) async => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Адаптер, который всегда бросает SocketException.
///
/// Именно подмена адаптера, а не репозитория: так обрыв случается там же, где
/// в жизни — внутри dio, — и проходит через тот же код обработки ошибок. Тест,
/// подменивший репозиторий, проверял бы аккуратность собственной заглушки.
class OfflineAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    throw DioException.connectionError(
      requestOptions: options,
      reason: 'нет сети',
      error: const SocketException('Network is unreachable'),
    );
  }

  @override
  void close({bool force = false}) {}
}
