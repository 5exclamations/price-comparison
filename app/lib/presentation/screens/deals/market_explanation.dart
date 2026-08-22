import 'package:flutter/material.dart';

import '../../../design/tokens/colors.dart';
import '../../../design/tokens/spacing.dart';
import '../../../design/tokens/typography.dart';
import '../../../design/widgets/price_text.dart';
import '../../../domain/models/deal.dart';
import '../../../l10n/app_localizations.dart';

/// Объяснение по тапу на «дешевле рынка на 60%».
///
/// Показывает на числах ЭТОЙ акции, а не отвлечённо: что заявила сеть, что мы
/// насчитали и откуда взялся рынок. Абстрактное «мы считаем честно» никого не
/// убеждает — три числа рядом убеждают.
Future<void> showMarketExplanation(BuildContext context, Deal deal) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => _MarketExplanation(deal: deal),
  );
}

class _MarketExplanation extends StatelessWidget {
  const _MarketExplanation({required this.deal});

  final Deal deal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.priceColors;
    final claimed = (deal.claimedDiscount * 100).round();
    final real = (deal.realDiscount * 100).round();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Spacing.xxl,
          0,
          Spacing.xxl,
          Spacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.marketExplainTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Spacing.md),
            Text(
              l10n.marketExplainBody(deal.referenceChains),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: Spacing.xl),

            _Row(
              label: l10n.marketExplainNow,
              child: PriceText(
                minor: deal.priceMinor,
                emphasis: PriceEmphasis.cheapest,
              ),
            ),
            _Row(
              label: l10n.marketExplainClaimed,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PriceText(
                    minor: deal.oldPriceMinor,
                    size: PriceSize.small,
                    emphasis: PriceEmphasis.neutral,
                  ),
                  const SizedBox(width: Spacing.sm),
                  Text(
                    '−$claimed%',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            _Row(
              label: l10n.marketExplainMarket,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PriceText(
                    minor: deal.marketPriceMinor,
                    size: PriceSize.small,
                    emphasis: PriceEmphasis.neutral,
                  ),
                  const SizedBox(width: Spacing.sm),
                  Text(
                    '−$real%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeights.bold,
                      color: colors.promo,
                    ),
                  ),
                ],
              ),
            ),

            if (deal.inflated) ...[
              const SizedBox(height: Spacing.lg),
              Container(
                padding: const EdgeInsets.all(Spacing.md),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Radii.md),
                  border: Border.all(
                    color: colors.inflatedWarning,
                    width: Borders.hairline,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_outlined,
                      size: 18,
                      color: colors.inflatedWarning,
                    ),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: Text(
                        l10n.inflatedExplained(
                          ((deal.inflation) * 100).round(),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(width: Spacing.md),
          child,
        ],
      ),
    );
  }
}
