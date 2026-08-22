import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/cache/selection_store.dart';

/// Анонимный идентификатор устройства.
///
/// Ни почты, ни пароля, ни регистрации: сервер знает про пользователя ровно
/// эту случайную строку. Она нужна, чтобы подписки на цену принадлежали
/// кому-то конкретному и переживали перезапуск.
///
/// Генерится один раз и хранится локально. Сбрасывается только вместе с
/// приложением — и тогда подписки теряются, что честно: восстанавливать их
/// не по чему, мы намеренно не знаем, кто это был.
class DeviceIdStore {
  DeviceIdStore(this._prefs);

  final SharedPreferences _prefs;

  static const _key = 'device_id_v1';
  static const _alphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';

  String get id {
    final existing = _prefs.getString(_key);
    if (existing != null && existing.length >= 8) return existing;

    final rnd = Random.secure();
    final generated = List.generate(
      24,
      (_) => _alphabet[rnd.nextInt(_alphabet.length)],
    ).join();
    // Пишем без await: значение уже в памяти prefs, а на диск ляжет само.
    // Ждать здесь нельзя — id нужен синхронно, при сборке dio.
    _prefs.setString(_key, generated);
    return generated;
  }
}

final deviceIdStoreProvider = Provider<DeviceIdStore>(
  (ref) => DeviceIdStore(ref.watch(sharedPreferencesProvider)),
);

final deviceIdProvider = Provider<String>(
  (ref) => ref.watch(deviceIdStoreProvider).id,
);
