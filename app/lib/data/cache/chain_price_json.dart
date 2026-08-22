import 'dart:convert';

import '../../domain/models/product_card.dart';

/// Сериализация цен для хранения в drift.
///
/// Отдельный файл, а не toJson на доменной модели: доменные типы не должны
/// знать, что их кто-то кладёт в базу. Формат намеренно короткий — эти строки
/// лежат в каждой позиции списка.
String encodeChainPrices(List<ChainPrice> prices) => jsonEncode([
  for (final p in prices)
    {
      'c': p.chainCode,
      'n': p.chainName,
      'm': p.priceModel,
      'p': p.priceMinor,
      if (p.oldPriceMinor != null) 'o': p.oldPriceMinor,
      if (p.storeId != null) 'si': p.storeId,
      if (p.storeName != null) 'sn': p.storeName,
      if (p.priceCluster != null) 'z': p.priceCluster,
      'ci': p.chainId,
      'a': p.available,
      'r': p.requiresStoreSelection,
      'pr': p.isPromo,
      't': p.observedAt.toIso8601String(),
      's': p.source,
    },
]);

List<ChainPrice> decodeChainPrices(String? raw) {
  if (raw == null || raw.isEmpty) return const [];
  try {
    final list = jsonDecode(raw) as List<dynamic>;
    return [
      for (final e in list.cast<Map<String, dynamic>>())
        ChainPrice(
          chainId: e['ci'] as int? ?? 0,
          chainCode: e['c'] as String,
          chainName: e['n'] as String? ?? e['c'] as String,
          priceModel: e['m'] as String? ?? 'single',
          storeId: e['si'] as int?,
          storeName: e['sn'] as String?,
          priceCluster: e['z'] as String?,
          priceMinor: e['p'] as int,
          oldPriceMinor: e['o'] as int?,
          isPromo: e['pr'] as bool? ?? false,
          available: e['a'] as bool? ?? true,
          observedAt: DateTime.parse(e['t'] as String),
          source: e['s'] as String? ?? 'cache',
          requiresStoreSelection: e['r'] as bool? ?? false,
        ),
    ];
  } on Object {
    // Формат поехал между версиями. Терять цены не страшно — они
    // перезагрузятся; падать на открытии списка в магазине нельзя.
    return const [];
  }
}
