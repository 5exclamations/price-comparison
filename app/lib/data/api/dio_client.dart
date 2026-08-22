import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/device_id.dart';
import 'qiymet_api.dart';

/// Базовый адрес API. Задаётся при сборке:
/// `flutter run --dart-define=QIYMET_API_URL=https://api.qiymet.az`
const String apiBaseUrl = String.fromEnvironment(
  'QIYMET_API_URL',
  defaultValue: 'http://localhost:8000',
);

/// Настроенный dio.
///
/// Провайдер, а не глобальная переменная: в тестах его подменяют на клиент
/// с поддельным адаптером, и ни один экран об этом не знает.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        // Анонимный id устройства. Нужен подпискам на цену: сервер заводит
        // по нему пользователя без регистрации.
        'X-Device-Id': ref.watch(deviceIdProvider),
      },
      // Сервер отвечает 404 на карантинный товар — это нормальный ответ,
      // а не сбой, и разбирать его должен репозиторий.
      validateStatus: (code) => code != null && code < 500,
    ),
  );
  ref.onDispose(dio.close);
  return dio;
});

final qiymetApiProvider = Provider<QiymetApi>(
  (ref) => QiymetApi(ref.watch(dioProvider)),
);
