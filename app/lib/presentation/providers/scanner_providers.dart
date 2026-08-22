import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/text.dart';
import '../../data/repositories/catalog_repository.dart';
import 'store_providers.dart';

/// Штрихкод -> productId.
///
/// Сканер отдаёт EAN, а карточке нужен внутренний id. Поиск по штрихкоду на
/// сервере точный, поэтому результат либо один, либо его нет: показывать
/// список из одной строки посреди магазина было бы издевательством.
final resolveBarcodeProvider = FutureProvider.family.autoDispose<int?, String>((
  ref,
  barcode,
) async {
  final digits = barcode.replaceAll(RegExp(r'[\s-]'), '');
  if (!looksLikeBarcode(digits)) return null;

  final repo = ref.watch(catalogRepositoryProvider);
  final storeId = ref.watch(selectedStoreIdProvider);
  final result = await repo.search(query: digits, storeId: storeId, limit: 1);

  return result.value.isEmpty ? null : result.value.first.productId;
});
