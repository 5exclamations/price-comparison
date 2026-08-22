import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_dto.freezed.dart';
part 'store_dto.g.dart';

/// Ответ GET /v1/stores.
@freezed
abstract class StoresResponseDto with _$StoresResponseDto {
  const factory StoresResponseDto({
    required List<StoreDto> items,

    /// У скольких записей есть координаты. Ноль означает, что сортировать по
    /// расстоянию нечем, и экран не должен обещать пользователю сортировку.
    @JsonKey(name: 'coordinates_known') required int coordinatesKnown,
  }) = _StoresResponseDto;

  factory StoresResponseDto.fromJson(Map<String, dynamic> json) =>
      _$StoresResponseDtoFromJson(json);
}

@freezed
abstract class StoreDto with _$StoreDto {
  const factory StoreDto({
    @JsonKey(name: 'store_id') int? storeId,
    @JsonKey(name: 'chain_id') required int chainId,
    @JsonKey(name: 'chain_code') required String chainCode,
    @JsonKey(name: 'chain_name') required String chainName,
    @JsonKey(name: 'price_model') required String priceModel,
    required String name,
    String? format,
    @JsonKey(name: 'price_cluster') String? priceCluster,
    String? address,
    double? lat,
    double? lon,
    @JsonKey(name: 'distance_m') int? distanceM,
    required bool synthetic,
  }) = _StoreDto;

  factory StoreDto.fromJson(Map<String, dynamic> json) =>
      _$StoreDtoFromJson(json);
}
