import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design/tokens/spacing.dart';
import '../../../domain/models/deal_filters.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/deals_providers.dart';
import '../../providers/store_providers.dart';

/// Фильтры ленты: категория, минимальная скидка, только мои сети.
Future<void> showDealFiltersSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => const _FiltersSheet(),
  );
}

class _FiltersSheet extends ConsumerWidget {
  const _FiltersSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final filters = ref.watch(dealFiltersProvider);
    final categories = ref.watch(dealCategoriesProvider);
    final selection = ref.watch(storeSelectionProvider);

    void update(DealFilters next) =>
        ref.read(dealFiltersProvider.notifier).state = next;

    return SafeArea(
      child: SingleChildScrollView(
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.filters,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (!filters.isEmpty)
                  TextButton(
                    onPressed: () => update(DealFilters.none),
                    child: Text(l10n.filtersReset),
                  ),
              ],
            ),
            const SizedBox(height: Spacing.lg),

            // ---------- минимальная скидка ----------
            Text(
              l10n.filterMinDiscount,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: Spacing.sm),
            Wrap(
              spacing: Spacing.sm,
              children: [
                ChoiceChip(
                  label: Text(l10n.filterAny),
                  selected: filters.minDiscount == null,
                  onSelected: (_) => update(
                    DealFilters(
                      category: filters.category,
                      chains: filters.chains,
                    ),
                  ),
                ),
                for (final t in discountThresholds)
                  ChoiceChip(
                    label: Text('${(t * 100).round()}%+'),
                    selected: filters.minDiscount == t,
                    onSelected: (_) => update(filters.copyWith(minDiscount: t)),
                  ),
              ],
            ),
            const SizedBox(height: Spacing.xl),

            // ---------- только мои сети ----------
            if (selection.chainCodes.isNotEmpty) ...[
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.filterMyChainsOnly),
                subtitle: Text(
                  selection.chainCodes.join(', '),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                value: filters.chains.isNotEmpty,
                onChanged: (on) => update(
                  filters.copyWith(
                    chains: on ? selection.chainCodes : const <String>{},
                  ),
                ),
              ),
              const SizedBox(height: Spacing.lg),
            ],

            // ---------- категория ----------
            // Фильтр показывается, ТОЛЬКО если категории есть. Сейчас
            // products.category пуста на 100%, список приходит пустым, и ряд
            // чипов, ни один из которых ничего не отфильтрует, читался бы как
            // поломка.
            categories.maybeWhen(
              data: (list) => list.isEmpty
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.filterCategory,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(height: Spacing.sm),
                        Wrap(
                          spacing: Spacing.sm,
                          runSpacing: Spacing.sm,
                          children: [
                            ChoiceChip(
                              label: Text(l10n.filterAny),
                              selected: filters.category == null,
                              onSelected: (_) => update(
                                DealFilters(
                                  minDiscount: filters.minDiscount,
                                  chains: filters.chains,
                                ),
                              ),
                            ),
                            for (final c in list)
                              ChoiceChip(
                                label: Text(c),
                                selected: filters.category == c,
                                onSelected: (_) =>
                                    update(filters.copyWith(category: c)),
                              ),
                          ],
                        ),
                      ],
                    ),
              orElse: () => const SizedBox.shrink(),
            ),

            const SizedBox(height: Spacing.xl),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.filtersApply),
            ),
          ],
        ),
      ),
    );
  }
}
