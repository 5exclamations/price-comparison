import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design/tokens/colors.dart';
import '../../../design/tokens/spacing.dart';
import '../../../design/tokens/typography.dart';
import '../../../design/widgets/observed_at_text.dart';
import '../../../design/widgets/packaging_text.dart';
import '../../../design/widgets/price_sparkline.dart';
import '../../../design/widgets/price_text.dart';
import '../../../design/widgets/product_thumb.dart';
import '../../../domain/models/packaging.dart';
import '../../../domain/models/product_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/basket_providers.dart';
import '../../providers/product_providers.dart';
import '../../providers/store_providers.dart';
import 'watch_dialog.dart';

/// Карточка товара: цены по всем сетям.
///
/// Для сети с привязкой цены к точке показывается цена выбранного магазина.
/// Без выбранного магазина такие строки помечаются и не участвуют в подсчёте
/// лучшей цены — у сети несколько разных прайсов, и любой из них, поданный
/// как «цена сети», был бы выдумкой.
class ProductScreen extends ConsumerWidget {
  const ProductScreen({super.key, required this.productId});

  /// Экран для мусора в адресе: /product/абв. Отдельного класса не нужно —
  /// несуществующий id и так даёт «товар не найден».
  const ProductScreen.invalid({super.key}) : productId = -1;

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final card = ref.watch(productCardProvider(productId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.productTitle)),
      body: card.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.productNotFound)),
        data: (data) => data == null
            ? Center(child: Text(l10n.productNotFound))
            : _Card(card: data),
      ),
    );
  }
}

class _Card extends ConsumerWidget {
  const _Card({required this.card});

  final ProductCard card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final packaging = Packaging(value: card.unitValue, type: card.unitType);

    // Крайние цены нужны, чтобы отметить самую дешёвую и самую дорогую.
    // Считаем только по строкам, чью цену вообще можно назвать.
    final showable = card.prices
        .where((p) => !p.requiresStoreSelection)
        .toList();
    final cheapest = showable.isEmpty
        ? null
        : showable.map((p) => p.priceMinor).reduce((a, b) => a < b ? a : b);
    final priciest = showable.isEmpty
        ? null
        : showable.map((p) => p.priceMinor).reduce((a, b) => a > b ? a : b);

    return ListView(
      padding: const EdgeInsets.all(Spacing.lg),
      children: [
        // Картинка крупнее, чем в ленте: здесь человек уже выбирает конкретный
        // товар, и разглядеть упаковку важнее, чем уместить больше строк.
        // Но не во весь экран: цены — то, ради чего сюда пришли, и уводить их
        // за нижний край ради картинки нельзя.
        Center(
          child: ProductThumb(
            name: card.name,
            imageUrl: card.imageUrl,
            size: 128,
          ),
        ),
        const SizedBox(height: Spacing.lg),
        Text(card.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: Spacing.sm),
        Wrap(
          spacing: Spacing.md,
          runSpacing: Spacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (card.brand != null)
              Text(
                card.brand!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            PackagingText(
              packaging: packaging,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        if (card.ean != null) ...[
          const SizedBox(height: Spacing.xs),
          // Штрихкод мелким шрифтом: он нужен, чтобы сверить с пачкой в руке,
          // а не чтобы на него смотрели.
          Text(
            card.ean!,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: context.priceColors.staleData,
              fontFeatures: AppFonts.tabularFigures,
            ),
          ),
        ],
        if (packaging.isPerKilogram) ...[
          const SizedBox(height: Spacing.md),
          _Notice(text: l10n.perKilogramExplained, icon: Icons.scale_outlined),
        ],
        const SizedBox(height: Spacing.xl),

        if (card.needsStoreSelection.isNotEmpty) ...[
          _Notice(
            text: l10n.pickStoreForChains(card.needsStoreSelection.join(', ')),
            icon: Icons.info_outline,
          ),
          const SizedBox(height: Spacing.lg),
        ],

        _PriceTable(
          prices: card.prices,
          cheapest: cheapest,
          priciest: priciest,
        ),

        const SizedBox(height: Spacing.xxl),
        _HistorySection(productId: card.productId),

        const SizedBox(height: Spacing.xxl),
        _Actions(card: card),
        const SizedBox(height: Spacing.xxl),
      ],
    );
  }
}

/// Таблица цен по сетям.
class _PriceTable extends StatelessWidget {
  const _PriceTable({
    required this.prices,
    required this.cheapest,
    required this.priciest,
  });

  final List<ChainPrice> prices;
  final int? cheapest;
  final int? priciest;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final price in prices)
          _PriceRow(
            price: price,
            emphasis: price.requiresStoreSelection
                ? PriceEmphasis.neutral
                : price.priceMinor == cheapest
                ? PriceEmphasis.cheapest
                : price.priceMinor == priciest
                ? PriceEmphasis.priciest
                : PriceEmphasis.neutral,
          ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.price, required this.emphasis});

  final ChainPrice price;
  final PriceEmphasis emphasis;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isCheapest = emphasis == PriceEmphasis.cheapest;
    final colors = context.priceColors;

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        // Строка «дешевле всех» выделена фоном И жирным шрифтом внутри
        // PriceText. Одного цвета мало: он не читается в чёрно-белом режиме
        // и не различается при дальтонизме.
        color: isCheapest ? colors.cheapestContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price.chainName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: isCheapest ? FontWeights.semiBold : null,
                  ),
                ),
                if (price.storeName != null && price.storeName!.isNotEmpty)
                  Text(
                    price.storeName!,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                const SizedBox(height: Spacing.xs),
                // Время последней проверки — у КАЖДОЙ цены.
                ObservedAtText(observedAt: price.observedAt),
              ],
            ),
          ),
          const SizedBox(width: Spacing.md),
          if (price.requiresStoreSelection)
            Text(
              l10n.chooseStore,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.labelSmall,
            )
          else
            PriceText(
              minor: price.priceMinor,
              oldMinor: price.oldPriceMinor,
              emphasis: emphasis,
              semanticPrefix: price.chainName,
            ),
        ],
      ),
    );
  }
}

/// График цены за 30 дней либо честная строка о нехватке данных.
class _HistorySection extends ConsumerWidget {
  const _HistorySection({required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final history = ref.watch(priceHistoryProvider(productId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.priceHistory, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: Spacing.md),
        history.when(
          loading: () => const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text(
            l10n.historyUnavailable,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          data: (data) => data.isDrawable
              ? PriceSparkline(history: data)
              // Пустой график хуже отсутствующего: он читается как
              // утверждение «цена не менялась», хотя мы просто ещё не
              // накопили наблюдений.
              : Text(
                  l10n.historyTooShort,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.priceColors.staleData,
                  ),
                ),
        ),
      ],
    );
  }
}

class _Actions extends ConsumerWidget {
  const _Actions({required this.card});

  final ProductCard card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final watched = ref.watch(watchedProductsProvider);
    final inList = ref.watch(inShoppingListProvider(card.productId));
    final actions = ref.read(productActionsProvider);
    final storeId = ref.watch(selectedStoreIdProvider);

    final isWatched = watched.maybeWhen(
      data: (ids) => ids.contains(card.productId),
      orElse: () => false,
    );
    final isInList = inList.maybeWhen(data: (v) => v, orElse: () => false);

    return Column(
      children: [
        FilledButton.icon(
          icon: Icon(
            isWatched ? Icons.notifications_active : Icons.notifications_none,
          ),
          label: Text(isWatched ? l10n.watching : l10n.watchPrice),
          onPressed: () async {
            if (isWatched) {
              await actions.unwatch(card.productId);
            } else {
              final target = await showWatchDialog(
                context,
                currentBestMinor: card.bestPriceMinor,
              );
              if (target == null) return;
              await actions.watch(
                productId: card.productId,
                storeId: storeId,
                targetPriceMinor: target.targetPriceMinor,
              );
            }
            ref.invalidate(watchedProductsProvider);
          },
        ),
        const SizedBox(height: Spacing.md),
        OutlinedButton.icon(
          icon: Icon(isInList ? Icons.check : Icons.add_shopping_cart),
          label: Text(isInList ? l10n.inList : l10n.addToList),
          onPressed: () async {
            final basket = ref.read(basketActionsProvider);
            if (isInList) {
              await basket.removeByProduct(card.productId);
            } else {
              await basket.addProduct(
                productId: card.productId,
                name: card.name,
                unitValue: card.unitValue,
                unitType: card.unitType,
              );
            }
          },
        ),
      ],
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
