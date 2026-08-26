import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../design/tokens/colors.dart';
import '../../design/tokens/spacing.dart';
import '../../design/widgets/observed_at_text.dart';
import '../../design/widgets/packaging_text.dart';
import '../../design/widgets/price_text.dart';
import '../../design/widgets/product_thumb.dart';
import '../../domain/models/packaging.dart';
import '../../domain/models/product_summary.dart';
import '../../l10n/app_localizations.dart';
import '../router.dart';

/// Строка товара: картинка, название, фасовка, лучшая цена и время наблюдения.
///
/// Общая для поиска и каталога. Раньше жила приватным классом внутри экрана
/// поиска — каталогу пришлось бы её скопировать, и дальше две копии разъезжались
/// бы по мелочам, которых никто не заметит до жалобы.
class ProductRow extends StatelessWidget {
  const ProductRow({super.key, required this.item});

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
