import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_dto.freezed.dart';
part 'history_dto.g.dart';

/// Ответ GET /v1/product/{id}/history.
@freezed
abstract class HistoryResponseDto with _$HistoryResponseDto {
  const factory HistoryResponseDto({
    @JsonKey(name: 'product_id') required int productId,
    required int days,
    required DateTime since,
    required List<HistoryPointDto> points,
    required List<HistoryEventDto> events,
  }) = _HistoryResponseDto;

  factory HistoryResponseDto.fromJson(Map<String, dynamic> json) =>
      _$HistoryResponseDtoFromJson(json);
}

@freezed
abstract class HistoryPointDto with _$HistoryPointDto {
  const factory HistoryPointDto({
    @JsonKey(name: 'observed_at') required DateTime observedAt,
    @JsonKey(name: 'price_minor') required int priceMinor,
    @JsonKey(name: 'old_price_minor') int? oldPriceMinor,
    @JsonKey(name: 'is_promo') required bool isPromo,
    required bool available,
    @JsonKey(name: 'chain_code') required String chainCode,
    @JsonKey(name: 'store_id') int? storeId,
    @JsonKey(name: 'price_cluster') String? priceCluster,
  }) = _HistoryPointDto;

  factory HistoryPointDto.fromJson(Map<String, dynamic> json) =>
      _$HistoryPointDtoFromJson(json);
}

@freezed
abstract class HistoryEventDto with _$HistoryEventDto {
  const factory HistoryEventDto({
    @JsonKey(name: 'observed_at') required DateTime observedAt,
    required String kind,
    @JsonKey(name: 'chain_code') required String chainCode,
    @JsonKey(name: 'price_minor') required int priceMinor,
    @JsonKey(name: 'prev_price_minor') required int prevPriceMinor,
    @JsonKey(name: 'old_price_minor') int? oldPriceMinor,
    @JsonKey(name: 'inflated_old_price') @Default(false) bool inflatedOldPrice,
  }) = _HistoryEventDto;

  factory HistoryEventDto.fromJson(Map<String, dynamic> json) =>
      _$HistoryEventDtoFromJson(json);
}
