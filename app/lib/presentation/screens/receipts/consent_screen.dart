import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design/tokens/spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/receipt_providers.dart';

/// Экран согласия на обработку чеков.
///
/// Текст берётся С СЕРВЕРА и показывается целиком, без сокращений и без
/// «подробнее». Согласие на то, чего человек не видел, согласием не является —
/// а по закону «О персональных данных» доказывать придётся именно то, что ему
/// показали.
///
/// Кнопка согласия неактивна, пока текст не долистан до конца. Это не
/// формальность: галочка под нечитанным текстом — ровно та практика, из-за
/// которой согласия и оспаривают.
class ConsentScreen extends ConsumerStatefulWidget {
  const ConsentScreen({super.key});

  @override
  ConsumerState<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends ConsumerState<ConsentScreen> {
  final _scroll = ScrollController();
  bool _readToEnd = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (!_readToEnd &&
          _scroll.position.pixels >= _scroll.position.maxScrollExtent - 24) {
        setState(() => _readToEnd = true);
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _agree(String lang, int version) async {
    setState(() => _busy = true);
    try {
      await ref.read(receiptActionsProvider).grant(lang, version);
      if (mounted) Navigator.of(context).pop(true);
    } on Object {
      if (!mounted) return;
      setState(() => _busy = false);
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final consent = ref.watch(consentTextProvider(lang));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.consentTitle)),
      body: consent.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorGeneric)),
        data: (data) => Column(
          children: [
            Expanded(
              child: Scrollbar(
                controller: _scroll,
                child: SingleChildScrollView(
                  controller: _scroll,
                  padding: const EdgeInsets.all(Spacing.xxl),
                  child: Text(
                    data.text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            SafeArea(
              minimum: const EdgeInsets.all(Spacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_readToEnd)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Spacing.sm),
                      child: Text(
                        l10n.consentScrollToEnd,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  FilledButton(
                    onPressed: _readToEnd && !_busy
                        ? () => _agree(data.locale, data.version)
                        : null,
                    child: _busy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.consentAgree),
                  ),
                  const SizedBox(height: Spacing.sm),
                  TextButton(
                    onPressed: _busy
                        ? null
                        : () => Navigator.of(context).pop(false),
                    child: Text(l10n.consentDecline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
