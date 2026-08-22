// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConsentTextDto _$ConsentTextDtoFromJson(Map<String, dynamic> json) =>
    _ConsentTextDto(
      kind: json['kind'] as String,
      version: (json['version'] as num).toInt(),
      locale: json['locale'] as String,
      text: json['text'] as String,
      digest: json['digest'] as String,
    );

Map<String, dynamic> _$ConsentTextDtoToJson(_ConsentTextDto instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'version': instance.version,
      'locale': instance.locale,
      'text': instance.text,
      'digest': instance.digest,
    };

_ConsentStateDto _$ConsentStateDtoFromJson(Map<String, dynamic> json) =>
    _ConsentStateDto(
      kind: json['kind'] as String,
      currentVersion: (json['current_version'] as num).toInt(),
      granted: json['granted'] as bool,
      grantedVersion: (json['granted_version'] as num?)?.toInt(),
      grantedAt: json['granted_at'] == null
          ? null
          : DateTime.parse(json['granted_at'] as String),
    );

Map<String, dynamic> _$ConsentStateDtoToJson(_ConsentStateDto instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'current_version': instance.currentVersion,
      'granted': instance.granted,
      'granted_version': instance.grantedVersion,
      'granted_at': instance.grantedAt?.toIso8601String(),
    };

_ReceiptSubmitDto _$ReceiptSubmitDtoFromJson(Map<String, dynamic> json) =>
    _ReceiptSubmitDto(url: json['url'] as String);

Map<String, dynamic> _$ReceiptSubmitDtoToJson(_ReceiptSubmitDto instance) =>
    <String, dynamic>{'url': instance.url};

_ReceiptItemDto _$ReceiptItemDtoFromJson(Map<String, dynamic> json) =>
    _ReceiptItemDto(
      lineNo: (json['line_no'] as num).toInt(),
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String?,
      unitPriceMinor: (json['unit_price_minor'] as num).toInt(),
      totalMinor: (json['total_minor'] as num).toInt(),
      ean: json['ean'] as String?,
    );

Map<String, dynamic> _$ReceiptItemDtoToJson(_ReceiptItemDto instance) =>
    <String, dynamic>{
      'line_no': instance.lineNo,
      'name': instance.name,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'unit_price_minor': instance.unitPriceMinor,
      'total_minor': instance.totalMinor,
      'ean': instance.ean,
    };

_ReceiptDto _$ReceiptDtoFromJson(Map<String, dynamic> json) => _ReceiptDto(
  id: (json['id'] as num).toInt(),
  fiscalId: json['fiscal_id'] as String,
  merchantName: json['merchant_name'] as String?,
  chainCode: json['chain_code'] as String?,
  issuedAt: DateTime.parse(json['issued_at'] as String),
  totalMinor: (json['total_minor'] as num).toInt(),
  uploadedAt: DateTime.parse(json['uploaded_at'] as String),
  status: json['status'] as String,
  duplicate: json['duplicate'] as bool? ?? false,
  pointsAwarded: (json['points_awarded'] as num?)?.toInt() ?? 0,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => ReceiptItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ReceiptItemDto>[],
);

Map<String, dynamic> _$ReceiptDtoToJson(_ReceiptDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fiscal_id': instance.fiscalId,
      'merchant_name': instance.merchantName,
      'chain_code': instance.chainCode,
      'issued_at': instance.issuedAt.toIso8601String(),
      'total_minor': instance.totalMinor,
      'uploaded_at': instance.uploadedAt.toIso8601String(),
      'status': instance.status,
      'duplicate': instance.duplicate,
      'points_awarded': instance.pointsAwarded,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

_ReceiptsResponseDto _$ReceiptsResponseDtoFromJson(Map<String, dynamic> json) =>
    _ReceiptsResponseDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => ReceiptDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReceiptsResponseDtoToJson(
  _ReceiptsResponseDto instance,
) => <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};

_PointsDto _$PointsDtoFromJson(Map<String, dynamic> json) => _PointsDto(
  points: (json['points'] as num).toInt(),
  receiptsUploaded: (json['receipts_uploaded'] as num).toInt(),
);

Map<String, dynamic> _$PointsDtoToJson(_PointsDto instance) =>
    <String, dynamic>{
      'points': instance.points,
      'receipts_uploaded': instance.receiptsUploaded,
    };
