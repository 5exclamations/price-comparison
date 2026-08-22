import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt_dto.freezed.dart';
part 'receipt_dto.g.dart';

/// Текст согласия. Живёт на сервере, а не в приложении: доказывать потом
/// придётся, на что именно человек согласился, а версия приложения у него
/// может быть любая.
@freezed
abstract class ConsentTextDto with _$ConsentTextDto {
  const factory ConsentTextDto({
    required String kind,
    required int version,
    required String locale,
    required String text,
    required String digest,
  }) = _ConsentTextDto;

  factory ConsentTextDto.fromJson(Map<String, dynamic> json) =>
      _$ConsentTextDtoFromJson(json);
}

@freezed
abstract class ConsentStateDto with _$ConsentStateDto {
  const factory ConsentStateDto({
    required String kind,
    @JsonKey(name: 'current_version') required int currentVersion,
    required bool granted,
    @JsonKey(name: 'granted_version') int? grantedVersion,
    @JsonKey(name: 'granted_at') DateTime? grantedAt,
  }) = _ConsentStateDto;

  factory ConsentStateDto.fromJson(Map<String, dynamic> json) =>
      _$ConsentStateDtoFromJson(json);
}

@freezed
abstract class ReceiptSubmitDto with _$ReceiptSubmitDto {
  const factory ReceiptSubmitDto({required String url}) = _ReceiptSubmitDto;

  factory ReceiptSubmitDto.fromJson(Map<String, dynamic> json) =>
      _$ReceiptSubmitDtoFromJson(json);
}

@freezed
abstract class ReceiptItemDto with _$ReceiptItemDto {
  const factory ReceiptItemDto({
    @JsonKey(name: 'line_no') required int lineNo,
    required String name,
    required double quantity,
    String? unit,
    @JsonKey(name: 'unit_price_minor') required int unitPriceMinor,
    @JsonKey(name: 'total_minor') required int totalMinor,
    String? ean,
  }) = _ReceiptItemDto;

  factory ReceiptItemDto.fromJson(Map<String, dynamic> json) =>
      _$ReceiptItemDtoFromJson(json);
}

@freezed
abstract class ReceiptDto with _$ReceiptDto {
  const factory ReceiptDto({
    required int id,
    @JsonKey(name: 'fiscal_id') required String fiscalId,
    @JsonKey(name: 'merchant_name') String? merchantName,

    /// null — магазин не из наших сетей. Чек всё равно сохранён: это
    /// бесплатно расширяет покрытие.
    @JsonKey(name: 'chain_code') String? chainCode,
    @JsonKey(name: 'issued_at') required DateTime issuedAt,
    @JsonKey(name: 'total_minor') required int totalMinor,
    @JsonKey(name: 'uploaded_at') required DateTime uploadedAt,
    required String status,
    @Default(false) bool duplicate,
    @JsonKey(name: 'points_awarded') @Default(0) int pointsAwarded,
    @Default(<ReceiptItemDto>[]) List<ReceiptItemDto> items,
  }) = _ReceiptDto;

  factory ReceiptDto.fromJson(Map<String, dynamic> json) =>
      _$ReceiptDtoFromJson(json);
}

@freezed
abstract class ReceiptsResponseDto with _$ReceiptsResponseDto {
  const factory ReceiptsResponseDto({required List<ReceiptDto> items}) =
      _ReceiptsResponseDto;

  factory ReceiptsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ReceiptsResponseDtoFromJson(json);
}

@freezed
abstract class PointsDto with _$PointsDto {
  const factory PointsDto({
    required int points,
    @JsonKey(name: 'receipts_uploaded') required int receiptsUploaded,
  }) = _PointsDto;

  factory PointsDto.fromJson(Map<String, dynamic> json) =>
      _$PointsDtoFromJson(json);
}
