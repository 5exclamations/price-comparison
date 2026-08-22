import 'package:flutter/material.dart';

import '../../../core/share_card.dart';
import '../../../design/theme.dart';
import '../../../design/widgets/price_text.dart';
import '../../../domain/models/deal.dart';
import '../../../l10n/app_localizations.dart';
import 'deal_card.dart';

/// Отправить находку картинкой.
///
/// Карточка рисуется заново в offstage-слое, а не снимается со списка. Так
/// в картинку не попадут соседние карточки, скролл и системная строка, а
/// размер и тема будут одинаковыми у всех отправителей.
///
/// Картинка, а не ссылка: находки пересылают в WhatsApp, там картинка
/// разворачивается сразу, а ссылка требует поставить приложение и найти тот же
/// товар. Текст с ценой идёт рядом — на случай, если картинку сожмут.
Future<bool> shareDealCard(BuildContext context, Deal deal) async {
  final l10n = AppLocalizations.of(context);
  final key = GlobalKey();
  final overlay = Overlay.of(context);

  // Рендерим за пределами экрана: пользователь ничего не увидит, а
  // RepaintBoundary получит настоящий слой.
  final entry = OverlayEntry(
    builder: (context) => Positioned(
      left: -10000,
      top: -10000,
      child: RepaintBoundary(
        key: key,
        child: Theme(
          data: AppTheme.light(),
          child: DealCard(deal: deal, forSharing: true),
        ),
      ),
    ),
  );

  overlay.insert(entry);
  try {
    // Даём кадру отрисоваться, иначе toImage вернёт пустоту.
    await WidgetsBinding.instance.endOfFrame;

    final price = PriceFormat.minorToDisplay(
      deal.priceMinor,
      locale: Localizations.localeOf(context).toString(),
    );
    final text = l10n.shareText(
      deal.name,
      price,
      deal.chainCode,
      (deal.realDiscount * 100).round(),
    );

    return await const ShareCard().shareWidget(key, text: text);
  } finally {
    entry.remove();
  }
}
