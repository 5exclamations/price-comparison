import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/api/dio_client.dart';
import '../../data/api/dto/health_dto.dart';
import 'store_providers.dart';

/// Как часто перепроверять состояние данных.
///
/// Пять минут: если сбор сломался, он не починится за секунду, а дёргать
/// сервер на каждом переключении вкладки незачем.
const healthRefreshInterval = Duration(minutes: 5);

/// Состояние данных на сервере.
///
/// autoDispose не для порядка: без него таймер перезапроса живёт, пока живо
/// приложение, и продолжает будить сеть на экранах, где плашки нет вовсе.
/// С autoDispose провайдер умирает вместе с последней плашкой, а таймер
/// снимается в onDispose.
final healthProvider = FutureProvider.autoDispose<HealthDto>((ref) async {
  final timer = Timer(healthRefreshInterval, ref.invalidateSelf);
  ref.onDispose(timer.cancel);

  return ref.watch(qiymetApiProvider).health();
});

/// Показывать ли плашку «данные обновляются».
///
/// Правило простое: если последний прогон проверок данных упал, цифры
/// подозрительные, и молча показывать их нельзя — человек съездит в магазин
/// по неверной цене и не вернётся.
///
/// Недоступность сервера плашкой НЕ считается: приложение обязано работать
/// оффлайн, и там своя плашка, про время последнего обновления. Смешивать «мы
/// не знаем» и «мы знаем, что данные плохие» нельзя — это разные сообщения.
/// Вторая причина показать плашку — протух ЛИЧНО выбранный магазин.
///
/// Сеть может быть свежей: у Bravo четыре ценовые зоны, и сбор молча
/// переживает потерю одной точки. Три оставшиеся тянут возраст сети наверх,
/// а человек, выбравший выпавшую зону, видит вчерашние цены как сегодняшние.
/// До этого разреза он не видел вообще ничего — ни плашки, ни предупреждения.
final dataQuestionableProvider = Provider.autoDispose<bool>((ref) {
  final storeId = ref.watch(selectedStoreIdProvider);

  return ref
      .watch(healthProvider)
      .maybeWhen(
        data: (h) =>
            !h.dataQuality.passed ||
            (storeId != null && h.staleStoreIds.contains(storeId)),
        orElse: () => false,
      );
});
