import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../presentation/providers/health_providers.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';

/// Плашка «данные обновляются».
///
/// Появляется, когда последний прогон проверок данных на сервере упал: медиана
/// цены сети уехала, разбор фасовки просел, склейки потерялись или сеть не
/// обновлялась сутки.
///
/// Смысл именно в том, чтобы НЕ показывать подозрительные цифры молча. Человек
/// простит «данные обновляются»; он не простит поездку в магазин по цене,
/// которой там нет.
///
/// Текст не объясняет, какая проверка упала: пользователю это ничего не даёт.
/// Имена упавших проверок приходят в ответе и годятся для лога, а не для
/// показа.
class QuestionableDataBanner extends ConsumerWidget {
  const QuestionableDataBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(dataQuestionableProvider)) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final colors = context.priceColors;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        Spacing.lg,
        Spacing.sm,
        Spacing.lg,
        Spacing.md,
      ),
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(
          color: colors.inflatedWarning,
          width: Borders.hairline,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.sync_problem_outlined,
            size: 20,
            color: colors.inflatedWarning,
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.dataRefreshingTitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  l10n.dataRefreshingBody,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
