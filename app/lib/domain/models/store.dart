import 'package:freezed_annotation/freezed_annotation.dart';

part 'store.freezed.dart';

/// Магазин или сеть целиком.
///
/// У сетей с единой ценой сервер отдаёт одну синтетическую запись со
/// [storeId] = null: цена там не зависит от точки, и выбирать филиал незачем.
/// У Bravo приходят настоящие магазины — цена у них разная.
@freezed
abstract class Store with _$Store {
  const factory Store({
    int? storeId,
    required int chainId,
    required String chainCode,
    required String chainName,
    required String priceModel,
    required String name,
    String? format,
    String? address,
    double? lat,
    double? lon,

    /// Расстояние в метрах. null, если у магазина нет координат либо точка
    /// пользователя неизвестна.
    int? distanceM,

    /// Одна запись на всю сеть вместо списка филиалов.
    required bool synthetic,
  }) = _Store;

  const Store._();

  /// Нужно ли выбирать конкретный магазин этой сети.
  ///
  /// Единственный признак — модель цены с сервера. Выводить это из названия
  /// сети нельзя: сегодня зон четыре у Bravo, завтра их заведёт кто-то ещё.
  bool get requiresStorePick => priceModel == 'per_cluster';
}
