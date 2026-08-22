import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'design/theme.dart';
import 'l10n/app_localizations.dart';
import 'presentation/providers/settings_providers.dart';
import 'presentation/router.dart';

/// Корень приложения.
class QiymetApp extends ConsumerStatefulWidget {
  const QiymetApp({super.key});

  @override
  ConsumerState<QiymetApp> createState() => _QiymetAppState();
}

class _QiymetAppState extends ConsumerState<QiymetApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'qiymət',
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routerProvider),
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(themeModeProvider),
      locale: ref.watch(localeProvider),
      supportedLocales: supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      // Системный язык может быть любым. Если он не наш — берём
      // азербайджанский, а не английский: это язык основной аудитории.
      localeResolutionCallback: (device, supported) {
        if (device == null) return supported.first;
        for (final locale in supported) {
          if (locale.languageCode == device.languageCode) return locale;
        }
        return supported.first;
      },
    );
  }
}
