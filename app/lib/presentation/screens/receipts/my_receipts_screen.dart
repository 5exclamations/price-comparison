import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design/tokens/colors.dart';
import '../../../design/tokens/spacing.dart';
import '../../../design/widgets/observed_at_text.dart';
import '../../../design/widgets/price_text.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/receipt_providers.dart';
import 'receipt_scanner_screen.dart';

/// Мои чеки: список, баллы, отзыв согласия.
///
/// Отзыв и удаление живут здесь же, а не спрятаны в настройках третьим
/// уровнем: право отозвать согласие бесполезно, если его надо искать.
class MyReceiptsScreen extends ConsumerWidget {
  const MyReceiptsScreen({super.key});

  Future<void> _scan(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ReceiptScannerScreen()));
  }

  Future<void> _revoke(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.consentRevokeTitle),
        content: Text(l10n.consentRevokeBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.consentRevokeConfirm),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(receiptActionsProvider).revoke();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final receipts = ref.watch(myReceiptsProvider);
    final points = ref.watch(pointsProvider);
    final consent = ref.watch(consentStateProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.receiptsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _scan(context),
        icon: const Icon(Icons.qr_code_scanner),
        label: Text(l10n.receiptScanTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: Spacing.huge),
        children: [
          points.maybeWhen(
            data: (p) =>
                _PointsCard(points: p.points, receipts: p.receiptsUploaded),
            orElse: () => const SizedBox.shrink(),
          ),
          receipts.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(Spacing.xxl),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(Spacing.xxl),
              child: Text(l10n.receiptsEmpty, textAlign: TextAlign.center),
            ),
            data: (list) => list.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(Spacing.xxl),
                    child: Column(
                      children: [
                        const Icon(Icons.receipt_long_outlined, size: 48),
                        const SizedBox(height: Spacing.lg),
                        Text(
                          l10n.receiptsEmpty,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: Spacing.sm),
                        Text(
                          l10n.receiptsWhy,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      for (final r in list)
                        Dismissible(
                          key: ValueKey(r.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: Spacing.lg),
                            color: Theme.of(context).colorScheme.errorContainer,
                            child: const Icon(Icons.delete_outline),
                          ),
                          onDismissed: (_) =>
                              ref.read(receiptActionsProvider).delete(r.id),
                          child: ListTile(
                            title: Text(
                              r.merchantName ?? l10n.receiptUnknownStore,
                            ),
                            subtitle: ObservedAtText(
                              observedAt: r.issuedAt,
                              prefixed: false,
                            ),
                            trailing: PriceText(
                              minor: r.totalMinor,
                              size: PriceSize.small,
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          if (consent.valueOrNull?.granted ?? false) ...[
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.no_accounts_outlined,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(l10n.consentRevokeTitle),
              subtitle: Text(
                l10n.consentRevokeSubtitle,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              onTap: () => _revoke(context, ref),
            ),
          ],
        ],
      ),
    );
  }
}

class _PointsCard extends StatelessWidget {
  const _PointsCard({required this.points, required this.receipts});

  final int points;
  final int receipts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.priceColors;

    return Container(
      margin: const EdgeInsets.all(Spacing.lg),
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: colors.cheapestContainer,
        borderRadius: BorderRadius.circular(Radii.lg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.pointsTitle,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  '$points',
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall?.copyWith(color: colors.cheapest),
                ),
              ],
            ),
          ),
          Text(
            l10n.receiptsUploaded(receipts),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
