import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../design/tokens/colors.dart';
import '../../../design/tokens/spacing.dart';
import '../../../design/widgets/observed_at_text.dart';
import '../../../design/widgets/packaging_text.dart';
import '../../../design/widgets/price_text.dart';
import '../../../domain/models/basket_item.dart';
import '../../../domain/models/packaging.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/basket_providers.dart';
import '../../providers/store_providers.dart';
import '../../router.dart';
import 'basket_summary.dart';

/// Список покупок и ответ на вопрос «куда ехать».
///
/// Экран обязан открываться и работать в магазине, где связь плохая. Поэтому
/// источник данных — локальная база, а не сеть: список и цены лежат в drift,
/// сеть нужна только чтобы освежить цифры. Неудачное обновление не ломает
/// экран, оно лишь оставляет прежнее время последней проверки.
class ListScreen extends ConsumerStatefulWidget {
  const ListScreen({super.key});

  @override
  ConsumerState<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends ConsumerState<ListScreen> {
  bool _refreshing = false;

  Future<void> _refresh() async {
    if (_refreshing) return;
    setState(() => _refreshing = true);

    final storeId = ref.read(selectedStoreIdProvider);
    final ok = await ref
        .read(basketActionsProvider)
        .refreshPrices(storeId: storeId);

    if (!mounted) return;
    setState(() => _refreshing = false);
    if (!ok) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.basketPricesOffline)));
    }
  }

  Future<void> _addManual() async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.basketAddManual),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: l10n.basketAddManualHint),
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l10n.basketAdd),
          ),
        ],
      ),
    );

    controller.dispose();
    if (name != null && name.trim().isNotEmpty) {
      await ref.read(basketActionsProvider).addManual(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = ref.watch(basketProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.listTitle),
        actions: [
          IconButton(
            icon: _refreshing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            tooltip: l10n.basketRefreshPrices,
            onPressed: _refreshing ? null : _refresh,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addManual,
        tooltip: l10n.basketAddManual,
        child: const Icon(Icons.add),
      ),
      body: items.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorGeneric)),
        data: (list) => list.isEmpty
            ? _Empty(onSearch: () => context.go(Routes.search))
            : _Basket(items: list, onRefresh: _refresh),
      ),
    );
  }
}

class _Basket extends ConsumerWidget {
  const _Basket({required this.items, required this.onRefresh});

  final List<BasketItem> items;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(storeSelectionProvider);
    final actions = ref.read(basketActionsProvider);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: Spacing.huge),
        itemCount: items.length + 1,
        itemBuilder: (context, i) {
          if (i == items.length) return const BasketSummary();

          final item = items[i];
          return Dismissible(
            key: ValueKey(item.id),
            // Свайп влево — отметить купленным, вправо — удалить.
            // Разные направления, потому что «купил» и «передумал» — разное.
            background: _SwipeBackground(
              alignment: Alignment.centerLeft,
              icon: Icons.delete_outline,
              color: Theme.of(context).colorScheme.errorContainer,
            ),
            secondaryBackground: _SwipeBackground(
              alignment: Alignment.centerRight,
              icon: item.done ? Icons.undo : Icons.check,
              color: context.priceColors.cheapestContainer,
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                // Купленные уезжают вниз, а не исчезают: человек может
                // передумать у кассы.
                await actions.setDone(item.id, !item.done);
                return false;
              }
              return true;
            },
            onDismissed: (_) => actions.remove(item.id),
            child: _ItemTile(item: item, chains: selection.chainCodes),
          );
        },
      ),
    );
  }
}

class _ItemTile extends ConsumerWidget {
  const _ItemTile({required this.item, required this.chains});

  final BasketItem item;
  final Set<String> chains;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(basketActionsProvider);
    final best = item.bestPriceIn(chains);
    final bestChain = item.bestChainIn(chains);
    final muted = item.done;

    return CheckboxListTile(
      value: item.done,
      onChanged: (v) => actions.setDone(item.id, v ?? false),
      title: Text(
        item.name,
        style: muted
            ? TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Theme.of(context).colorScheme.outline,
              )
            : null,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: Spacing.xs),
        child: Row(
          children: [
            if (!item.isManual)
              PackagingText(
                packaging: Packaging(
                  value: item.unitValue,
                  type: item.unitType,
                ),
                emphasizePerKilogram: false,
              ),
            if (item.isManual)
              Text(
                // Честно говорим, почему у строки нет цены.
                l10n.basketManualItem,
                style: Theme.of(context).textTheme.labelSmall,
              )
            else if (best == null)
              Text(
                l10n.basketNoPrice,
                style: Theme.of(context).textTheme.labelSmall,
              )
            else ...[
              const SizedBox(width: Spacing.sm),
              Text(
                bestChain ?? '',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ],
        ),
      ),
      secondary: best == null
          ? null
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                PriceText(
                  minor: best,
                  size: PriceSize.small,
                  emphasis: muted
                      ? PriceEmphasis.neutral
                      : PriceEmphasis.cheapest,
                  semanticPrefix: bestChain,
                ),
                ObservedAtText(
                  observedAt: item.pricesUpdatedAt,
                  prefixed: false,
                ),
              ],
            ),
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.alignment,
    required this.icon,
    required this.color,
  });

  final Alignment alignment;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
      child: Icon(icon),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.onSearch});

  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(Spacing.xxl),
      children: [
        const SizedBox(height: Spacing.huge),
        const Icon(Icons.checklist_outlined, size: 48),
        const SizedBox(height: Spacing.lg),
        Text(
          l10n.listEmpty,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: Spacing.xl),
        FilledButton.icon(
          onPressed: onSearch,
          icon: const Icon(Icons.search),
          label: Text(l10n.tabSearch),
        ),
      ],
    );
  }
}
