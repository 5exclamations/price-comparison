import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../design/tokens/spacing.dart';
import '../../../design/widgets/questionable_data_banner.dart';
import '../../../design/widgets/stale_banner.dart';
import '../../../domain/models/deal.dart';
import '../../../domain/models/deal_filters.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/deals_providers.dart';
import '../../router.dart';
import 'deal_card.dart';
import 'deal_filters_sheet.dart';
import 'market_explanation.dart';
import 'share_deal.dart';

/// Лента акций, отсортированная по НАСТОЯЩЕЙ скидке от рынка.
///
/// Базовые цены сетей почти одинаковы: у 62% товаров из трёх и более сетей они
/// совпадают, медианная выгода 2.9%. На акциях медиана 26.7%. Поэтому лента —
/// главный экран, а сортировка по настоящей скидке — его единственный смысл.
///
/// Никакой персонализации и рекомендаций. Сначала честный порядок по выгоде;
/// подмешивать в него «интересное вам» значит терять единственное, чем эта
/// лента отличается от витрины скидок.
class DealsScreen extends ConsumerStatefulWidget {
  const DealsScreen({super.key});

  @override
  ConsumerState<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends ConsumerState<DealsScreen> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    // Догружаем заранее, за пол-экрана до конца: иначе человек упирается
    // в спиннер и ждёт.
    final remaining =
        _scroll.position.maxScrollExtent - _scroll.position.pixels;
    if (remaining < MediaQuery.of(context).size.height / 2) {
      ref.read(dealsFeedProvider.notifier).loadMore();
    }
  }

  Future<void> _share(Deal deal) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final ok = await shareDealCard(context, deal);
    if (!ok && mounted) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.shareFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final feed = ref.watch(dealsFeedProvider);
    final filters = ref.watch(dealFiltersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dealsTitle),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: filters.activeCount > 0,
              label: Text('${filters.activeCount}'),
              child: const Icon(Icons.tune),
            ),
            tooltip: l10n.filters,
            onPressed: () => showDealFiltersSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const QuestionableDataBanner(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(dealsFeedProvider.notifier).refresh(),
              child: switch (feed) {
                AsyncLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                AsyncError() => _Retry(
                  text: l10n.errorGeneric,
                  onRetry: () => ref.read(dealsFeedProvider.notifier).refresh(),
                ),
                AsyncData(:final value) when value.items.isEmpty => _Retry(
                  text: filters.isEmpty
                      ? l10n.dealsEmpty
                      : l10n.dealsEmptyFiltered,
                  action: filters.isEmpty ? null : l10n.filtersReset,
                  onRetry: filters.isEmpty
                      ? null
                      : () => ref.read(dealFiltersProvider.notifier).state =
                            DealFilters.none,
                ),
                AsyncData(:final value) => ListView.separated(
                  controller: _scroll,
                  // AlwaysScrollable, иначе pull-to-refresh не сработает на
                  // коротком списке.
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(Spacing.lg),
                  itemCount: value.items.length + 1,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: Spacing.md),
                  itemBuilder: (context, i) {
                    if (i == value.items.length) {
                      return _Footer(state: value);
                    }
                    final deal = value.items[i];
                    return Column(
                      children: [
                        if (i == 0 && value.needsStaleWarning)
                          StaleBanner(
                            cachedAt: value.cachedAt!,
                            onRetry: () =>
                                ref.read(dealsFeedProvider.notifier).refresh(),
                          ),
                        DealCard(
                          deal: deal,
                          onTap: () =>
                              context.push(Routes.productOf(deal.productId)),
                          onExplain: () => showMarketExplanation(context, deal),
                          onShare: () => _share(deal),
                        ),
                      ],
                    );
                  },
                ),
                // AsyncValue не запечатан, поэтому анализатор требует эту ветку.
                // Достижимой она быть не может: выше перечислены все три подтипа.
                _ => const SizedBox.shrink(),
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Подвал списка: спиннер догрузки, ошибка догрузки либо конец ленты.
class _Footer extends ConsumerWidget {
  const _Footer({required this.state});

  final DealsFeedState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    if (state.error != null) {
      // Список остаётся на экране: человек прокрутил до конца, а не потерял
      // всё, что уже прочитал.
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
        child: Column(
          children: [
            Text(
              l10n.loadMoreFailed,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: Spacing.sm),
            OutlinedButton(
              onPressed: () => ref.read(dealsFeedProvider.notifier).loadMore(),
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    if (state.loadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: Spacing.xl),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (!state.hasMore && state.items.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.xl),
        child: Center(
          child: Text(
            l10n.dealsEnd,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      );
    }

    return const SizedBox(height: Spacing.xl);
  }
}

class _Retry extends StatelessWidget {
  const _Retry({required this.text, this.action, this.onRetry});

  final String text;
  final String? action;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // ListView, а не Center: RefreshIndicator требует прокручиваемого потомка,
    // иначе жест «потянуть вниз» не долетает.
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.xxl,
        vertical: Spacing.huge,
      ),
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (onRetry != null) ...[
          const SizedBox(height: Spacing.lg),
          FilledButton(onPressed: onRetry, child: Text(action ?? l10n.retry)),
        ],
      ],
    );
  }
}
