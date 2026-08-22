import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../tokens/colors.dart';

/// Время последней проверки цены.
///
/// Правило, ради которого этот виджет существует: рядом с каждым числом,
/// которое видит пользователь, должно стоять время наблюдения. Цену
/// трёхчасовой давности человек простит, если видит, когда её проверяли.
/// Молча устаревшую не простит — съездит в магазин, не найдёт цену и удалит
/// приложение.
class ObservedAtText extends StatelessWidget {
  const ObservedAtText({
    super.key,
    required this.observedAt,
    this.style,
    this.prefixed = true,
  });

  final DateTime? observedAt;
  final TextStyle? style;

  /// «проверено 14:20» или просто «14:20».
  final bool prefixed;

  @override
  Widget build(BuildContext context) {
    final at = observedAt;
    if (at == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final text = formatObservedAt(at, locale: locale);

    return Text(
      prefixed ? l10n.observedAt(text) : text,
      style: (style ?? Theme.of(context).textTheme.labelSmall)?.copyWith(
        color: context.priceColors.staleData,
      ),
    );
  }
}

/// Сегодня — только время, иначе дата и время.
///
/// «14:20» без даты для позавчерашней цены было бы враньём в чистом виде:
/// человек прочитает это как «сегодня в 14:20».
String formatObservedAt(DateTime at, {String? locale, DateTime? now}) {
  final local = at.toLocal();
  final today = (now ?? DateTime.now()).toLocal();
  final sameDay =
      local.year == today.year &&
      local.month == today.month &&
      local.day == today.day;

  final time = DateFormat.Hm(locale).format(local);
  if (sameDay) return time;

  final yesterday = today.subtract(const Duration(days: 1));
  final isYesterday =
      local.year == yesterday.year &&
      local.month == yesterday.month &&
      local.day == yesterday.day;
  if (isYesterday) return '${DateFormat.MMMd(locale).format(local)}, $time';

  return '${DateFormat.MMMd(locale).format(local)}, $time';
}
