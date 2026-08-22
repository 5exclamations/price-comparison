import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/api/dio_client.dart';
import '../../data/api/dto/receipt_dto.dart';

/// Текст согласия для текущего языка.
final consentTextProvider = FutureProvider.family<ConsentTextDto, String>((
  ref,
  lang,
) async {
  return ref.watch(qiymetApiProvider).consentText(lang: lang);
});

/// Есть ли действующее согласие.
final consentStateProvider = FutureProvider<ConsentStateDto>((ref) async {
  return ref.watch(qiymetApiProvider).consentState();
});

/// Мои чеки.
final myReceiptsProvider = FutureProvider<List<ReceiptDto>>((ref) async {
  final response = await ref.watch(qiymetApiProvider).receipts();
  return response.items;
});

/// Баллы.
final pointsProvider = FutureProvider<PointsDto>((ref) async {
  return ref.watch(qiymetApiProvider).points();
});

/// Действия с чеками и согласием.
class ReceiptActions {
  ReceiptActions(this._ref);

  final Ref _ref;

  Future<void> grant(String lang, int version) async {
    await _ref
        .read(qiymetApiProvider)
        .grantConsent(lang: lang, version: version);
    _ref.invalidate(consentStateProvider);
  }

  /// Отозвать согласие. Сервер при этом удаляет все чеки — отзыв без
  /// удаления был бы отзывом на словах.
  Future<void> revoke() async {
    await _ref.read(qiymetApiProvider).revokeConsent();
    _ref
      ..invalidate(consentStateProvider)
      ..invalidate(myReceiptsProvider)
      ..invalidate(pointsProvider);
  }

  Future<ReceiptDto> submit(String url) async {
    final receipt = await _ref
        .read(qiymetApiProvider)
        .submitReceipt(ReceiptSubmitDto(url: url));
    _ref
      ..invalidate(myReceiptsProvider)
      ..invalidate(pointsProvider);
    return receipt;
  }

  Future<void> delete(int id) async {
    await _ref.read(qiymetApiProvider).deleteReceipt(id: id);
    _ref
      ..invalidate(myReceiptsProvider)
      ..invalidate(pointsProvider);
  }
}

final receiptActionsProvider = Provider<ReceiptActions>(
  (ref) => ReceiptActions(ref),
);
