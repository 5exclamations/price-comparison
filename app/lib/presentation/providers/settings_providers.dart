import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Языки интерфейса. Азербайджанский основной — он первый и он же
/// запасной, если системный язык нам неизвестен.
const List<Locale> supportedLocales = [
  Locale('az'),
  Locale('ru'),
  Locale('en'),
];

String languageName(Locale locale) => switch (locale.languageCode) {
  'az' => 'Azərbaycanca',
  'ru' => 'Русский',
  'en' => 'English',
  _ => locale.languageCode,
};

/// Выбранный язык. null означает «как в системе».
final localeProvider = StateProvider<Locale?>((ref) => null);

/// Светлая, тёмная или как в системе.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

// Выбор магазина живёт в store_providers.dart: он тянет за собой хранение,
// инвалидацию кеша и сторожа роутера, и складывать это в «настройки» было бы
// свалкой.
