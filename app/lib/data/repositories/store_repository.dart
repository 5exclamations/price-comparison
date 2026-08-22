import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/store.dart';
import '../api/dio_client.dart';
import '../api/qiymet_api.dart';

/// Список магазинов и сетей.
///
/// price_cluster из ответа сюда намеренно не переносится: это внутренняя
/// кухня, пользователю мы показываем магазин, а не «зону».
class StoreRepository {
  StoreRepository(this._api);

  final QiymetApi _api;

  Future<List<Store>> stores({double? lat, double? lon}) async {
    final response = await _api.stores(lat: lat, lon: lon);
    return [
      for (final s in response.items)
        Store(
          storeId: s.storeId,
          chainId: s.chainId,
          chainCode: s.chainCode,
          chainName: s.chainName,
          priceModel: s.priceModel,
          name: s.name,
          format: s.format,
          address: s.address,
          lat: s.lat,
          lon: s.lon,
          distanceM: s.distanceM,
          synthetic: s.synthetic,
        ),
    ];
  }
}

final storeRepositoryProvider = Provider<StoreRepository>(
  (ref) => StoreRepository(ref.watch(qiymetApiProvider)),
);
