import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/cache/selection_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Выбор магазина нужен уже на первом кадре: от него зависит, показывать
  // онбординг или пускать в приложение. Читаем до runApp, чтобы экран не
  // моргнул онбордингом у тех, кто выбор давно сделал.
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const QiymetApp(),
    ),
  );
}
