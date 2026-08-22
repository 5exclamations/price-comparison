import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../design/tokens/spacing.dart';
import '../../../design/widgets/price_text.dart';
import '../../../l10n/app_localizations.dart';

/// Что выбрал пользователь в диалоге подписки.
class WatchChoice {
  const WatchChoice({this.targetPriceMinor});

  /// null = достаточно падения на 5%, целевой цены нет.
  final int? targetPriceMinor;
}

/// Диалог «Следить за ценой» с необязательной целевой ценой.
///
/// Целевая цена именно необязательна: большинству нужно просто «скажи, когда
/// подешевеет», и требовать от них число значило бы отсечь их от механики,
/// ради которой приложение открывают второй раз.
Future<WatchChoice?> showWatchDialog(
  BuildContext context, {
  int? currentBestMinor,
}) {
  return showDialog<WatchChoice>(
    context: context,
    builder: (context) => _WatchDialog(currentBestMinor: currentBestMinor),
  );
}

class _WatchDialog extends StatefulWidget {
  const _WatchDialog({this.currentBestMinor});

  final int? currentBestMinor;

  @override
  State<_WatchDialog> createState() => _WatchDialogState();
}

class _WatchDialogState extends State<_WatchDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Ввод в манатах -> гяпики.
  ///
  /// Единственное место, кроме PriceText, где деньги пересекают границу между
  /// текстом и числом. Считаем целочисленно: «13,99» -> 1399, без double.
  int? _parseMinor(String raw) {
    final text = raw.trim().replaceAll(',', '.');
    if (text.isEmpty) return null;

    final parts = text.split('.');
    if (parts.length > 2) return null;

    final whole = int.tryParse(parts[0]);
    if (whole == null || whole < 0) return null;

    if (parts.length == 1) return whole * 100;

    final fracRaw = parts[1];
    if (fracRaw.isEmpty || fracRaw.length > 2) return null;
    final frac = int.tryParse(fracRaw.padRight(2, '0'));
    if (frac == null) return null;

    return whole * 100 + frac;
  }

  void _submit() {
    final raw = _controller.text.trim();
    if (raw.isEmpty) {
      Navigator.pop(context, const WatchChoice());
      return;
    }

    final minor = _parseMinor(raw);
    if (minor == null || minor <= 0) {
      setState(() => _error = AppLocalizations.of(context).targetPriceInvalid);
      return;
    }
    Navigator.pop(context, WatchChoice(targetPriceMinor: minor));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.watchPrice),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.watchExplained,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (widget.currentBestMinor != null) ...[
            const SizedBox(height: Spacing.md),
            Row(
              children: [
                Text(
                  '${l10n.currentBestPrice}: ',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                PriceText(
                  minor: widget.currentBestMinor!,
                  size: PriceSize.small,
                ),
              ],
            ),
          ],
          const SizedBox(height: Spacing.lg),
          TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            decoration: InputDecoration(
              labelText: l10n.targetPriceOptional,
              hintText: l10n.targetPriceHint,
              suffixText: PriceFormat.currencySymbol,
              errorText: _error,
            ),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.watchStart)),
      ],
    );
  }
}
