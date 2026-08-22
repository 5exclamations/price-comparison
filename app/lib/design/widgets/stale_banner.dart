import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import 'observed_at_text.dart';

/// Плашка «данные от 14:20» поверх сохранённого ответа.
///
/// Появляется, когда сети нет и список приехал из локального кеша. Молчать
/// в этот момент нельзя: цифры выглядят как обычные свежие цены, и человек
/// поедет в магазин по вчерашней цене.
class StaleBanner extends StatelessWidget {
  const StaleBanner({super.key, required this.cachedAt, this.onRetry});

  final DateTime cachedAt;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final colors = context.priceColors;

    return Container(
      margin: const EdgeInsets.fromLTRB(Spacing.lg, 0, Spacing.lg, Spacing.md),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: colors.staleData, width: Borders.hairline),
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_off_outlined, size: 18, color: colors.staleData),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(
              l10n.offlineDataFrom(formatObservedAt(cachedAt, locale: locale)),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}
