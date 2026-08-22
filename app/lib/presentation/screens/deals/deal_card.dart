import 'package:flutter/material.dart';

import '../../../design/tokens/colors.dart';
import '../../../design/tokens/spacing.dart';
import '../../../design/tokens/typography.dart';
import '../../../design/widgets/observed_at_text.dart';
import '../../../design/widgets/price_text.dart';
import '../../../domain/models/deal.dart';
import '../../../l10n/app_localizations.dart';

/// Карточка акции.
///
/// Главная строка здесь не «−60%» с ценника, а «дешевле рынка на 60%»: первое
/// сеть может нарисовать сама, второе считается от медианы обычных цен на тот
/// же штрихкод в других сетях. Именно это отличает ленту от витрины скидок.
class DealCard extends StatelessWidget {
  const DealCard({
    super.key,
    required this.deal,
    this.onTap,
    this.onExplain,
    this.onShare,
    this.forSharing = false,
  });

  final Deal deal;
  final VoidCallback? onTap;
  final VoidCallback? onExplain;
  final VoidCallback? onShare;

  /// Вариант для снимка: без кнопок и без ряби, зато с подписью приложения.
  final bool forSharing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.priceColors;

    final card = Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Photo(),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deal.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      _where(deal),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),

          // Цена крупно, старая зачёркнутая рядом.
          PriceText(
            minor: deal.priceMinor,
            oldMinor: deal.oldPriceMinor,
            emphasis: PriceEmphasis.cheapest,
            size: PriceSize.large,
            semanticPrefix: deal.chainCode,
          ),
          const SizedBox(height: Spacing.md),

          // Главная строка. По тапу — объяснение, что такое «рынок».
          _MarketLine(deal: deal, onExplain: forSharing ? null : onExplain),

          if (deal.inflated) ...[
            const SizedBox(height: Spacing.sm),
            const _InflatedBadge(),
          ],

          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(child: ObservedAtText(observedAt: deal.observedAt)),
              if (forSharing)
                Text(
                  'qiymət',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeights.bold,
                    color: colors.cheapest,
                  ),
                )
              else if (onShare != null)
                IconButton(
                  icon: const Icon(Icons.ios_share),
                  tooltip: l10n.share,
                  onPressed: onShare,
                ),
            ],
          ),
        ],
      ),
    );

    if (forSharing) {
      return Material(
        color: Theme.of(context).colorScheme.surface,
        child: SizedBox(width: 380, child: card),
      );
    }

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.lg),
        onTap: onTap,
        child: card,
      ),
    );
  }

  /// «Где»: сеть и, если цена зависит от точки, конкретный магазин.
  static String _where(Deal deal) {
    final store = deal.storeName;
    if (store == null || store.isEmpty) return deal.chainCode;
    return '${deal.chainCode} · $store';
  }
}

/// Место под фото.
///
/// Картинок в данных сейчас нет: их не хранит ни схема, ни API, и коннекторы
/// их не собирают. Поэтому вместо серой заглушки в полкарточки — компактная
/// иконка, а вёрстка не рассыплется, когда картинки появятся.
class _Photo extends StatelessWidget {
  // Ссылку сюда пока никто не передаёт: картинок нет ни в схеме, ни в API,
  // ни у коннекторов. Ветка с Image.network оставлена сознательно — когда
  // картинки появятся, менять придётся одно место, а не вёрстку карточки.
  // ignore: unused_element_parameter
  const _Photo({this.url});

  final String? url;

  static const _size = 56.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (url == null || url!.isEmpty) {
      return Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(Radii.sm),
        ),
        child: Icon(
          Icons.shopping_basket_outlined,
          size: 24,
          color: scheme.outline,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(Radii.sm),
      child: Image.network(
        url!,
        width: _size,
        height: _size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _Photo(),
      ),
    );
  }
}

class _MarketLine extends StatelessWidget {
  const _MarketLine({required this.deal, this.onExplain});

  final Deal deal;
  final VoidCallback? onExplain;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.priceColors;
    final percent = (deal.realDiscount * 100).round();

    // Отрицательная «скидка» — цена выше рынка. Такое бывает, и молчать
    // об этом нельзя: лента честная или никакая.
    final belowMarket = deal.realDiscount > 0;

    return InkWell(
      onTap: onExplain,
      borderRadius: BorderRadius.circular(Radii.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
        child: Row(
          children: [
            Flexible(
              child: Text(
                belowMarket
                    ? l10n.realDiscount(percent)
                    : l10n.aboveMarket(-percent),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  // Вес, а не только цвет: разница видна и в чёрно-белом.
                  fontWeight: FontWeights.bold,
                  color: belowMarket ? colors.promo : colors.priciest,
                ),
              ),
            ),
            if (onExplain != null) ...[
              const SizedBox(width: Spacing.xs),
              Icon(
                Icons.help_outline,
                size: 16,
                color: Theme.of(context).colorScheme.outline,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// «Старая цена накручена».
///
/// Такие позиции не прячем. Спрятать значило бы стать ещё одной витриной
/// скидок; пометить — единственное, что отличает нас от остальных.
class _InflatedBadge extends StatelessWidget {
  const _InflatedBadge();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.priceColors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radii.pill),
        border: Border.all(
          color: colors.inflatedWarning,
          width: Borders.hairline,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_outlined,
            size: 14,
            color: colors.inflatedWarning,
          ),
          const SizedBox(width: Spacing.xs),
          Text(
            l10n.inflatedWarning,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colors.inflatedWarning,
              fontWeight: FontWeights.medium,
            ),
          ),
        ],
      ),
    );
  }
}
