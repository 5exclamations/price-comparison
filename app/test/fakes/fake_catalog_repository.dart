import 'package:dio/dio.dart';
import 'package:qiymet/data/repositories/catalog_repository.dart';
import 'package:qiymet/domain/models/deals_page.dart';
import 'package:qiymet/domain/models/freshness.dart';
import 'package:qiymet/domain/models/price_history.dart';
import 'package:qiymet/domain/models/product_card.dart';
import 'package:qiymet/domain/models/product_summary.dart';

/// Репозиторий-заглушка для тестов ленты.
///
/// Отдаёт заранее заданные страницы и запоминает, с какими параметрами его
/// звали: именно это и проверяется — что фильтры доехали до сервера, а не
/// применились где-то в клиенте.
class FakeCatalogRepository implements CatalogRepository {
  FakeCatalogRepository({
    required this.pages,
    this.delay = Duration.zero,
    this.failAfterFirst = false,
    this.failOnCall,
  });

  final List<Fresh<DealsPage>> pages;
  final Duration delay;

  /// Сломаться на любом вызове после первого.
  final bool failAfterFirst;

  /// Сломаться на конкретном по счёту вызове (нумерация с единицы).
  final int? failOnCall;

  int calls = 0;

  /// Сколько страниц уже отдано. Считается отдельно от [calls]: упавший
  /// вызов страницу не расходует.
  int delivered = 0;
  String? lastCategory;
  double? lastMinDiscount;
  String? lastChains;
  String? lastCursor;

  @override
  Future<Fresh<DealsPage>> deals({
    int? storeId,
    double? minDiscount,
    String? category,
    String? chains,
    int limit = 20,
    String? cursor,
  }) async {
    calls++;
    lastCategory = category;
    lastMinDiscount = minDiscount;
    lastChains = chains;
    lastCursor = cursor;

    if (delay > Duration.zero) await Future<void>.delayed(delay);

    if (failOnCall == calls || (failAfterFirst && calls > 1)) {
      // Страницу упавший вызов не забирает: повтор обязан принести ту же
      // самую, а не следующую. Иначе тест на повтор проверял бы не то.
      throw DioException(
        requestOptions: RequestOptions(path: '/v1/deals'),
        type: DioExceptionType.badResponse,
      );
    }

    final index = delivered++;
    if (index >= pages.length) {
      return const Fresh(value: DealsPage(items: []));
    }
    return pages[index];
  }

  // Остальное ленте не нужно.
  @override
  Future<List<String>> categories() async => const [];

  @override
  Future<Fresh<List<ProductSummary>>> search({
    required String query,
    int? storeId,
    int limit = 20,
  }) async => const Fresh(value: <ProductSummary>[]);

  @override
  Future<ProductCard?> product({required int productId, int? storeId}) async =>
      null;

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
