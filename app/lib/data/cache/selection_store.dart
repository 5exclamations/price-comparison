import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/store_selection.dart';

/// Локальное хранение выбора магазина.
///
/// shared_preferences, а не drift: это одна маленькая настройка, которую надо
/// прочитать синхронно на старте, до первого запроса. Таблица в базе ради неё
/// была бы лишним слоем.
class SelectionStore {
  SelectionStore(this._prefs);

  final SharedPreferences _prefs;

  static const _key = 'store_selection_v1';

  StoreSelection read() {
    final raw = _prefs.getString(_key);
    if (raw == null) return StoreSelection.empty;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return StoreSelection(
        chainCodes: {...(map['chains'] as List? ?? const []).cast<String>()},
        pickedStoreId: map['store_id'] as int?,
        pickedStoreChainCode: map['store_chain'] as String?,
        pickedStoreName: map['store_name'] as String?,
      );
    } on Object {
      // Формат поехал между версиями. Терять данные не страшно — пользователь
      // просто пройдёт выбор заново, а падать на старте нельзя.
      return StoreSelection.empty;
    }
  }

  Future<void> write(StoreSelection selection) async {
    await _prefs.setString(
      _key,
      jsonEncode({
        'chains': selection.chainCodes.toList()..sort(),
        'store_id': selection.pickedStoreId,
        'store_chain': selection.pickedStoreChainCode,
        'store_name': selection.pickedStoreName,
      }),
    );
  }

  Future<void> clear() => _prefs.remove(_key);
}

/// Заполняется в main() до запуска приложения: выбор нужен уже на первом
/// кадре, чтобы решить, показывать онбординг или нет.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('переопределяется в main()'),
);

final selectionStoreProvider = Provider<SelectionStore>(
  (ref) => SelectionStore(ref.watch(sharedPreferencesProvider)),
);
