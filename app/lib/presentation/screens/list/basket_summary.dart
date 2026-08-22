import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design/tokens/colors.dart';
import '../../../design/tokens/spacing.dart';
import '../../../design/tokens/typography.dart';
import '../../../design/widgets/observed_at_text.dart';
import '../../../design/widgets/price_text.dart';
import '../../../domain/basket.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/basket_providers.dart';

/// Итог корзины: сколько выйдет в каждой сети и что даст разбиение.
///
/// Главное правило этого блока — **не переоценивать выгоду разбиения**. По
/// замерам корзина из 30 товаров, разложенная на три сети вместо одной лучшей,
/// экономит медианно 4.2%. Поэтому:
///
///  * первой и крупно идёт одна лучшая сеть — обычный сценарий «съездил
///    в один магазин и всё купил»;
///  * разбиение показывается строкой ниже, с АБСОЛЮТНОЙ экономией в манатах,
///    а не только процентом: «экономия 2.20 ₼» человек взвешивает сам, а
///    «−4.2%» звучит как повод ехать;
///  * ни кнопки «оптимизировать», ни выделения цветом у разбиения нет. Это
///    справка, а не действие.
class BasketSummary extends ConsumerWidget {
  const BasketSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final plan = ref.watch(basketPlanProvider);
    final updatedAt = ref.watch(basketPricesUpdatedProvider);

    if (plan.isEmpty) {
      return _Note(text: _emptyReason(l10n, plan));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.lg,
        Spacing.xl,
        Spacing.lg,
        Spacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: Spacing.md),
          Text(
            l10n.basketTotalTitle(plan.pricedItems),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: Spacing.md),

          if (plan.bestSingle == null)
            _Note(text: l10n.basketNoCompleteChain)
          else
            _SingleChainRow(total: plan.bestSingle!),

          // Разбиение — справка, а не призыв к действию.
          for (final split in plan.splits) ...[
            const SizedBox(height: Spacing.sm),
            _SplitRow(split: split, plan: plan),
          ],

          if (plan.hasSplit) ...[
            const SizedBox(height: Spacing.sm),
            Text(
              // Прямо говорим, что выгода обычно небольшая. Пусть человек
              // решает, стоит ли второй магазин этих денег.
              l10n.basketSplitDisclaimer,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: context.priceColors.staleData,
              ),
            ),
          ],

          const SizedBox(height: Spacing.lg),
          _OtherChains(plan: plan),

          if (plan.manualItems > 0 || plan.unpricedItems > 0) ...[
            const SizedBox(height: Spacing.md),
            _Note(text: _excludedNote(l10n, plan)),
          ],

          if (updatedAt != null) ...[
            const SizedBox(height: Spacing.md),
            // Сумма без времени наблюдения — такое же враньё, как цена без него.
            ObservedAtText(observedAt: updatedAt),
          ],
        ],
      ),
    );
  }

  String _emptyReason(AppLocalizations l10n, BasketPlan plan) {
    if (plan.manualItems > 0 && plan.unpricedItems == 0) {
      return l10n.basketOnlyManual;
    }
    return l10n.basketNoPricesYet;
  }

  String _excludedNote(AppLocalizations l10n, BasketPlan plan) {
    final parts = <String>[
      if (plan.manualItems > 0) l10n.basketManualExcluded(plan.manualItems),
      if (plan.unpricedItems > 0)
        l10n.basketUnpricedExcluded(plan.unpricedItems),
    ];
    return parts.join(' ');
  }
}

/// Одна лучшая сеть — основной сценарий.
class _SingleChainRow extends StatelessWidget {
  const _SingleChainRow({required this.total});

  final ChainTotal total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            total.chainName,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeights.semiBold),
          ),
        ),
        PriceText(
          minor: total.totalMinor,
          size: PriceSize.large,
          emphasis: PriceEmphasis.cheapest,
          semanticPrefix: total.chainName,
        ),
      ],
    );
  }
}

/// Строка разбиения. Ровно та формулировка, что просили:
/// «если разбить на две сети — 45.10 ₼, экономия 2.20 ₼».
class _SplitRow extends StatelessWidget {
  const _SplitRow({required this.split, required this.plan});

  final SplitOption split;
  final BasketPlan plan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.basketSplitInto(split.storeCount),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                split.chains.join(' + '),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            PriceText(minor: split.totalMinor, size: PriceSize.medium),
            Text(
              // Абсолютная экономия, а не процент: два маната человек
              // взвешивает сам, «минус 4%» звучит как повод ехать.
              l10n.basketSaves(
                PriceFormat.minorToDisplay(split.savingsMinor, locale: locale),
              ),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ],
    );
  }
}

/// Остальные сети, включая неполные.
class _OtherChains extends StatelessWidget {
  const _OtherChains({required this.plan});

  final BasketPlan plan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rest = plan.perChain
        .where((c) => c.chainCode != plan.bestSingle?.chainCode)
        .toList();
    if (rest.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.basketOtherChains,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: Spacing.sm),
        for (final c in rest)
          Padding(
            padding: const EdgeInsets.only(bottom: Spacing.xs),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    c.chainName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                if (!c.isComplete) ...[
                  // Неполная сеть может выглядеть дешевле просто потому, что
                  // в ней меньше товаров. Молчать про это нельзя.
                  Text(
                    l10n.basketMissingItems(c.missing),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: context.priceColors.priciest,
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                ],
                PriceText(
                  minor: c.totalMinor,
                  size: PriceSize.small,
                  emphasis: c.isComplete
                      ? PriceEmphasis.neutral
                      : PriceEmphasis.priciest,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: context.priceColors.staleData),
      ),
    );
  }
}
