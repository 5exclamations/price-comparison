import 'package:freezed_annotation/freezed_annotation.dart';

part 'watch_dto.freezed.dart';
part 'watch_dto.g.dart';

/// Тело POST /v1/watches.
@freezed
abstract class WatchInDto with _$WatchInDto {
  const factory WatchInDto({
    @JsonKey(name: 'product_id') required int productId,
    @JsonKey(name: 'store_id') int? storeId,

    /// Целевая цена в ГЯПИКАХ. null = хватит падения на 5%.
    @JsonKey(name: 'target_price_minor') int? targetPriceMinor,
  }) = _WatchInDto;

  factory WatchInDto.fromJson(Map<String, dynamic> json) =>
      _$WatchInDtoFromJson(json);
}

@freezed
abstract class WatchOutDto with _$WatchOutDto {
  const factory WatchOutDto({
    required int id,
    @JsonKey(name: 'product_id') required int productId,
    @JsonKey(name: 'product_name') required String productName,
    @JsonKey(name: 'store_id') int? storeId,
    @JsonKey(name: 'store_name') String? storeName,
    @JsonKey(name: 'target_price_minor') int? targetPriceMinor,
    required bool active,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'current_best_price_minor') int? currentBestPriceMinor,
    @JsonKey(name: 'current_best_chain') String? currentBestChain,
    @JsonKey(name: 'observed_at') DateTime? observedAt,
  }) = _WatchOutDto;

  factory WatchOutDto.fromJson(Map<String, dynamic> json) =>
      _$WatchOutDtoFromJson(json);
}

@freezed
abstract class WatchesResponseDto with _$WatchesResponseDto {
  const factory WatchesResponseDto({required List<WatchOutDto> items}) =
      _WatchesResponseDto;

  factory WatchesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$WatchesResponseDtoFromJson(json);
}
