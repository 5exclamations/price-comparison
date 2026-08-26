import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'dto/category_dto.dart';
import 'dto/deal_dto.dart';
import 'dto/health_dto.dart';
import 'dto/history_dto.dart';
import 'dto/basket_prices_dto.dart';
import 'dto/product_card_dto.dart';
import 'dto/receipt_dto.dart';
import 'dto/catalog_response_dto.dart';
import 'dto/search_response_dto.dart';
import 'dto/store_dto.dart';
import 'dto/watch_dto.dart';

part 'qiymet_api.g.dart';

/// Клиент qiymət API. Пути и типы соответствуют OpenAPI-схеме сервера.
///
/// Единственное место в приложении, где живут адреса эндпоинтов. Виджеты
/// сюда не ходят: между ними и этим классом стоит репозиторий.
@RestApi()
abstract class QiymetApi {
  factory QiymetApi(Dio dio, {String baseUrl}) = _QiymetApi;

  /// Поиск по названию и штрихкоду. Курсорная пагинация, не offset.
  @GET('/v1/search')
  Future<SearchResponseDto> search({
    @Query('q') required String q,
    @Query('store_id') int? storeId,
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
  });

  /// Карточка товара. Для Bravo — по зоне выбранного магазина.
  /// Карантинный товар отдаёт 404.
  @GET('/v1/product/{id}')
  Future<ProductCardDto> product({
    @Path('id') required int id,
    @Query('store_id') int? storeId,
  });

  /// Лента акций по НАСТОЯЩЕЙ скидке — от медианы неакционных цен на тот же
  /// штрихкод в других сетях, а не от зачёркнутой цены на ценнике.
  @GET('/v1/deals')
  Future<DealsResponseDto> deals({
    @Query('store_id') int? storeId,
    @Query('category') String? category,

    /// «Только мои сети»: коды через запятую. Фильтр серверный — клиентский
    /// при курсорной пагинации выбросил бы половину страницы.
    @Query('chains') String? chains,
    @Query('min_discount') double? minDiscount,
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
  });

  /// Категории, в которых сейчас есть акции. Пустой список = фильтровать
  /// не по чему, и клиент прячет фильтр.
  @GET('/v1/categories')
  Future<CategoriesResponseDto> categories();

  /// Каталог: что вообще продаётся у сети или в точке.
  ///
  /// chainId/storeId — ЧЕЙ ассортимент показывать, storeIdSelected — чью цену
  /// считать применимой. Это разные вещи: можно смотреть каталог Bravo, держа
  /// выбранной точку Araz.
  @GET('/v1/catalog')
  Future<CatalogResponseDto> catalog({
    @Query('chain_id') int? chainId,
    @Query('store_id') int? storeId,
    @Query('category') String? category,
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
  });

  /// Разделы, в которых у этой сети или точки реально есть товары.
  @GET('/v1/catalog/categories')
  Future<CategoriesResponseDto> catalogCategories({
    @Query('chain_id') int? chainId,
    @Query('store_id') int? storeId,
  });

  /// Магазины. При заданной точке сервер добавит расстояние.
  ///
  /// Сети с единой ценой приходят одной синтетической записью со
  /// store_id = null: выбирать там филиал незачем, прайс общий.
  @GET('/v1/stores')
  Future<StoresResponseDto> stores({
    @Query('lat') double? lat,
    @Query('lon') double? lon,
  });

  /// История цены: точки для графика плюс события «акция началась/кончилась».
  @GET('/v1/product/{id}/history')
  Future<HistoryResponseDto> history({
    @Path('id') required int id,
    @Query('days') int? days,
    @Query('store_id') int? storeId,
  });

  /// Подписаться на падение цены.
  ///
  /// Пользователь заводится сервером по заголовку X-Device-Id — регистрации
  /// и push-токена для этого не требуется.
  @POST('/v1/watches')
  Future<WatchOutDto> createWatch(@Body() WatchInDto body);

  @GET('/v1/watches')
  Future<WatchesResponseDto> watches();

  @DELETE('/v1/watches/{id}')
  Future<void> deleteWatch({@Path('id') required int id});

  /// Цены по сетям для нескольких товаров сразу.
  ///
  /// Один запрос вместо N: список покупок открывают в магазине, где связь
  /// плохая, и тридцать отдельных запросов туда не доедут.
  @GET('/v1/prices')
  Future<BasketPricesDto> prices({
    @Query('product_ids') required String productIds,
    @Query('store_id') int? storeId,
  });

  // ---------- чеки ----------

  /// Текст согласия. Клиент обязан показать именно его.
  @GET('/v1/consents/receipts/text')
  Future<ConsentTextDto> consentText({@Query('lang') required String lang});

  @GET('/v1/consents')
  Future<ConsentStateDto> consentState();

  @POST('/v1/consents')
  Future<ConsentStateDto> grantConsent({
    @Query('lang') required String lang,
    @Query('version') required int version,
  });

  /// Отозвать согласие. Сервер удалит все чеки пользователя.
  @DELETE('/v1/consents')
  Future<void> revokeConsent();

  /// Отправить ссылку с QR. Разбирает и сохраняет сервер.
  @POST('/v1/receipts')
  Future<ReceiptDto> submitReceipt(@Body() ReceiptSubmitDto body);

  @GET('/v1/receipts')
  Future<ReceiptsResponseDto> receipts();

  @DELETE('/v1/receipts/{id}')
  Future<void> deleteReceipt({@Path('id') required int id});

  @GET('/v1/points')
  Future<PointsDto> points();

  /// Свежесть данных и результат последнего прогона проверок.
  ///
  /// Если data_quality.passed = false, приложение показывает плашку
  /// «данные обновляются» вместо цен.
  @GET('/v1/health')
  Future<HealthDto> health();
}
