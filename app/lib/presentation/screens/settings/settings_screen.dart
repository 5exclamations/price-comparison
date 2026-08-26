import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../design/tokens/spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/settings_providers.dart';
import '../../providers/store_providers.dart';
import '../../router.dart';
import '../catalog/catalog_screen.dart';

/// Настройки: язык, тема, выбранный магазин. Заглушка с рабочими
/// переключателями языка и темы.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);
    final mode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          const SizedBox(height: Spacing.sm),
          _SectionTitle(text: l10n.settingsStores),
          ListTile(
            leading: const Icon(Icons.storefront_outlined),
            title: Text(_selectionSummary(context, ref)),
            subtitle: Text(
              l10n.storeChangeInvalidatesPrices,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(Routes.settingsStores),
          ),
          ListTile(
            leading: const Icon(Icons.grid_view_outlined),
            title: Text(l10n.catalogOpen),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const CatalogPickerScreen(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: Text(l10n.receiptsTitle),
            subtitle: Text(
              l10n.receiptsWhy,
              style: Theme.of(context).textTheme.labelSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(Routes.receipts),
          ),
          const Divider(),
          _SectionTitle(text: l10n.settingsLanguage),
          for (final option in supportedLocales)
            RadioListTile<Locale>(
              value: option,
              groupValue: locale,
              onChanged: (value) {
                if (value != null) {
                  ref.read(localeProvider.notifier).state = value;
                }
              },
              title: Text(languageName(option)),
            ),
          const Divider(),
          _SectionTitle(text: l10n.settingsTheme),
          for (final option in ThemeMode.values)
            RadioListTile<ThemeMode>(
              value: option,
              groupValue: mode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).state = value;
                }
              },
              title: Text(switch (option) {
                ThemeMode.system => l10n.themeSystem,
                ThemeMode.light => l10n.themeLight,
                ThemeMode.dark => l10n.themeDark,
              }),
            ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.lg,
        Spacing.lg,
        Spacing.lg,
        Spacing.sm,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Короткая сводка выбора: сети и, если он есть, конкретный магазин.
String _selectionSummary(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context);
  final selection = ref.watch(storeSelectionProvider);
  if (selection.chainCodes.isEmpty) return l10n.storesNotPicked;

  final chains = selection.chainCodes.length;
  final store = selection.pickedStoreName;
  return store == null
      ? l10n.chainsPicked(chains)
      : '${l10n.chainsPicked(chains)} · $store';
}
