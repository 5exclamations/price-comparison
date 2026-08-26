import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../design/tokens/colors.dart';
import '../../../design/tokens/spacing.dart';
import '../../../design/widgets/observed_at_text.dart';
import '../../../design/widgets/packaging_text.dart';
import '../../../design/widgets/product_thumb.dart';
import '../../../design/widgets/price_text.dart';
import '../../../design/widgets/questionable_data_banner.dart';
import '../../../design/widgets/stale_banner.dart';
import '../../../domain/models/freshness.dart';
import '../../../domain/models/packaging.dart';
import '../../../domain/models/product_summary.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/search_providers.dart';
import '../../router.dart';
import 'scanner_screen.dart';

/// Поиск товара по названию и штрихкоду.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setQuery(String value) {
    _controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    ref.read(searchQueryProvider.notifier).state = value;
  }

  Future<void> _scan() async {
    final productId = await Navigator.of(
      context,
    ).push<int>(MaterialPageRoute(builder: (_) => const ScannerScreen()));
    if (productId != null && mounted) {
      // Отсканировал — сразу карточка. Промежуточный список из одной строки
      // посреди магазина только отнимал бы время.
      context.push(Routes.productOf(productId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.searchTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.lg,
              0,
              Spacing.lg,
              Spacing.md,
            ),
            child: TextField(
              controller: _controller,
              autocorrect: false,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (query.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: l10n.clear,
                        onPressed: () => _setQuery(''),
                      ),
                    IconButton(
                      icon: const Icon(Icons.qr_code_scanner),
                      tooltip: l10n.scanTitle,
                      onPressed: _scan,
                    ),
                  ],
                ),
              ),
              onChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
            ),
          ),
          const QuestionableDataBanner(),
          Expanded(
            child: switch (results) {
              // Дебаунс отменил прошлый запрос — это не ошибка и не пустота,
              // просто человек ещё печатает.
              AsyncError(:final error) when isDebouncedAway(error) =>
                const _Spinner(),
              AsyncError() => _Message(
                text: l10n.errorGeneric,
                action: l10n.retry,
                onAction: () => ref.invalidate(searchResultsProvider),
              ),
              AsyncLoading() =>
                query.isEmpty
                    ? _EmptyState(onPick: _setQuery)
                    : const _Spinner(),
              AsyncData(:final value) => _Results(
                fresh: value,
                query: query,
                onPick: _setQuery,
                onRetry: () => ref.invalidate(searchResultsProvider),
              ),
              // AsyncValue не запечатан: ветка нужна анализатору, а не логике.
              _ => const _Spinner(),
            },
          ),
        ],
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({
    required this.fresh,
    required this.query,
    required this.onPick,
    required this.onRetry,
  });

  final Fresh<List<ProductSummary>> fresh;
  final String query;
  final ValueChanged<String> onPick;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = fresh.value;

    if (query.isEmpty) return _EmptyState(onPick: onPick);

    if (!isSearchable(query)) {
      return _Message(text: l10n.searchTooShort(minQueryLength));
    }

    if (items.isEmpty) {
      return _Message(text: l10n.searchEmpty);
    }

    return Column(
      children: [
        // Плашка идёт ПЕРЕД списком, а не после: цифры без неё выглядят
        // как обычные свежие цены.
        if (fresh.needsStaleWarning)
          StaleBanner(cachedAt: fresh.cachedAt!, onRetry: onRetry),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: Spacing.xxl),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) => _ResultCard(item: items[i]),
          ),
        ),
      ],
    );
  }
}

/// Карточка результата: название, фасовка, минимальная цена, бейдж акции,
/// число сетей.
class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.item});

  final ProductSummary item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final packaging = Packaging(value: item.unitValue, type: item.unitType);

    return InkWell(
      onTap: () => context.push(Routes.productOf(item.productId)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductThumb(name: item.name, imageUrl: item.imageUrl, size: 48),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Spacing.xs),
                  Wrap(
                    spacing: Spacing.sm,
                    runSpacing: Spacing.xs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      PackagingText(
                        packaging: packaging,
                        emphasizePerKilogram: false,
                      ),
                      Text(
                        l10n.chainsCount(item.chainsCount),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      if (item.hasPromo) const _PromoBadge(),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: Spacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (item.bestPriceMinor == null)
                  Text(
                    l10n.needsStoreSelection,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.labelSmall,
                  )
                else
                  PriceText(
                    minor: item.bestPriceMinor!,
                    emphasis: PriceEmphasis.cheapest,
                    size: PriceSize.small,
                    semanticPrefix: item.bestPriceChain,
                  ),
                const SizedBox(height: Spacing.xs),
                // Время наблюдения рядом с ценой — всегда.
                ObservedAtText(observedAt: item.observedAt, prefixed: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoBadge extends StatelessWidget {
  const _PromoBadge();

  @override
  Widget build(BuildContext context) {
    final colors = context.priceColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: colors.promoContainer,
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Text(
        AppLocalizations.of(context).promoBadge,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: colors.promo),
      ),
    );
  }
}

/// Пустое состояние с подсказками. Пустой экран с одним полем ввода не
/// говорит человеку, что тут вообще можно искать.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onPick});

  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: Spacing.xxl),
          Icon(
            Icons.search,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: Spacing.lg),
          Text(
            l10n.searchPrompt,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: Spacing.xl),
          Text(
            l10n.popularQueries,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: Spacing.sm),
          Wrap(
            spacing: Spacing.sm,
            runSpacing: Spacing.sm,
            alignment: WrapAlignment.center,
            children: [
              for (final q in popularQueries)
                ActionChip(label: Text(q), onPressed: () => onPick(q)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.action, this.onAction});

  final String text;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (action != null) ...[
              const SizedBox(height: Spacing.lg),
              FilledButton(onPressed: onAction, child: Text(action!)),
            ],
          ],
        ),
      ),
    );
  }
}
