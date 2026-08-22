// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HealthDto _$HealthDtoFromJson(Map<String, dynamic> json) => _HealthDto(
  status: json['status'] as String,
  staleAfterHours: (json['stale_after_hours'] as num).toInt(),
  generatedAt: DateTime.parse(json['generated_at'] as String),
  chains: (json['chains'] as List<dynamic>)
      .map((e) => ChainHealthDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  dataQuality: DataQualityDto.fromJson(
    json['data_quality'] as Map<String, dynamic>,
  ),
  staleStoreIds:
      (json['stale_store_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
);

Map<String, dynamic> _$HealthDtoToJson(_HealthDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'stale_after_hours': instance.staleAfterHours,
      'generated_at': instance.generatedAt.toIso8601String(),
      'chains': instance.chains.map((e) => e.toJson()).toList(),
      'data_quality': instance.dataQuality.toJson(),
      'stale_store_ids': instance.staleStoreIds,
    };

_ChainHealthDto _$ChainHealthDtoFromJson(Map<String, dynamic> json) =>
    _ChainHealthDto(
      chainCode: json['chain_code'] as String,
      chainName: json['chain_name'] as String,
      ageHours: (json['age_hours'] as num?)?.toDouble(),
      status: json['status'] as String,
      stores:
          (json['stores'] as List<dynamic>?)
              ?.map((e) => StoreHealthDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <StoreHealthDto>[],
    );

Map<String, dynamic> _$ChainHealthDtoToJson(_ChainHealthDto instance) =>
    <String, dynamic>{
      'chain_code': instance.chainCode,
      'chain_name': instance.chainName,
      'age_hours': instance.ageHours,
      'status': instance.status,
      'stores': instance.stores.map((e) => e.toJson()).toList(),
    };

_StoreHealthDto _$StoreHealthDtoFromJson(Map<String, dynamic> json) =>
    _StoreHealthDto(
      storeId: (json['store_id'] as num?)?.toInt(),
      storeName: json['store_name'] as String?,
      ageHours: (json['age_hours'] as num?)?.toDouble(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$StoreHealthDtoToJson(_StoreHealthDto instance) =>
    <String, dynamic>{
      'store_id': instance.storeId,
      'store_name': instance.storeName,
      'age_hours': instance.ageHours,
      'status': instance.status,
    };

_DataQualityDto _$DataQualityDtoFromJson(Map<String, dynamic> json) =>
    _DataQualityDto(
      checkedAt: json['checked_at'] == null
          ? null
          : DateTime.parse(json['checked_at'] as String),
      passed: json['passed'] as bool,
      failedChecks:
          (json['failed_checks'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$DataQualityDtoToJson(_DataQualityDto instance) =>
    <String, dynamic>{
      'checked_at': instance.checkedAt?.toIso8601String(),
      'passed': instance.passed,
      'failed_checks': instance.failedChecks,
    };
