import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_dto.freezed.dart';
part 'health_dto.g.dart';

/// Ответ GET /v1/health.
@freezed
abstract class HealthDto with _$HealthDto {
  const factory HealthDto({
    required String status,
    @JsonKey(name: 'stale_after_hours') required int staleAfterHours,
    @JsonKey(name: 'generated_at') required DateTime generatedAt,
    required List<ChainHealthDto> chains,
    @JsonKey(name: 'data_quality') required DataQualityDto dataQuality,

    /// Точки, чьи данные старше staleAfterHours.
    ///
    /// Сеть считается свежей по самой СТАРОЙ своей точке, но приложению этого
    /// мало: человеку важна не сеть, а его магазин. У Bravo четыре ценовые
    /// зоны, и выпавшая зона — это вчерашние цены конкретно для тех, кто её
    /// выбрал.
    @JsonKey(name: 'stale_store_ids') @Default(<int>[]) List<int> staleStoreIds,
  }) = _HealthDto;

  factory HealthDto.fromJson(Map<String, dynamic> json) =>
      _$HealthDtoFromJson(json);
}

@freezed
abstract class ChainHealthDto with _$ChainHealthDto {
  const factory ChainHealthDto({
    @JsonKey(name: 'chain_code') required String chainCode,
    @JsonKey(name: 'chain_name') required String chainName,
    @JsonKey(name: 'age_hours') double? ageHours,
    required String status,
    @Default(<StoreHealthDto>[]) List<StoreHealthDto> stores,
  }) = _ChainHealthDto;

  factory ChainHealthDto.fromJson(Map<String, dynamic> json) =>
      _$ChainHealthDtoFromJson(json);
}

/// Свежесть данных одной точки.
@freezed
abstract class StoreHealthDto with _$StoreHealthDto {
  const factory StoreHealthDto({
    @JsonKey(name: 'store_id') int? storeId,
    @JsonKey(name: 'store_name') String? storeName,
    @JsonKey(name: 'age_hours') double? ageHours,
    required String status,
  }) = _StoreHealthDto;

  factory StoreHealthDto.fromJson(Map<String, dynamic> json) =>
      _$StoreHealthDtoFromJson(json);
}

/// Результат последнего прогона проверок данных.
@freezed
abstract class DataQualityDto with _$DataQualityDto {
  const factory DataQualityDto({
    @JsonKey(name: 'checked_at') DateTime? checkedAt,

    /// false — приложение обязано показать плашку вместо цен.
    required bool passed,
    @JsonKey(name: 'failed_checks')
    @Default(<String>[])
    List<String> failedChecks,
  }) = _DataQualityDto;

  factory DataQualityDto.fromJson(Map<String, dynamic> json) =>
      _$DataQualityDtoFromJson(json);
}
