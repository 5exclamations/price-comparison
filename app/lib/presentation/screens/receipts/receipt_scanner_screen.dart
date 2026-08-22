import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../design/tokens/spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/receipt_providers.dart';
import 'consent_screen.dart';

/// Сканирование QR с чека.
///
/// В QR лежит полная ссылка на портал — приложение её не разбирает и не
/// «улучшает», а отправляет как есть. Разбор на сервере: там и проверка
/// домена, и защита от подмены адреса, и обновление парсера без выпуска
/// новой версии приложения.
class ReceiptScannerScreen extends ConsumerStatefulWidget {
  const ReceiptScannerScreen({super.key});

  @override
  ConsumerState<ReceiptScannerScreen> createState() =>
      _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends ConsumerState<ReceiptScannerScreen> {
  final _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.normal,
  );

  bool _busy = false;
  String? _message;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_busy) return;

    final url = capture.barcodes
        .map((b) => b.rawValue)
        .firstWhere(
          (v) => v != null && v.contains('e-kassa.gov.az'),
          orElse: () => null,
        );
    if (url == null) return;

    setState(() {
      _busy = true;
      _message = null;
    });
    await _controller.stop();

    // Согласие спрашиваем ЗДЕСЬ, а не на первом запуске: человек уже понимает,
    // о чём речь, потому что держит чек в руках. Согласие, выданное «на всякий
    // случай» до того, как стало ясно зачем, — плохое согласие.
    final state = await ref.read(consentStateProvider.future);
    if (!mounted) return;

    if (!state.granted) {
      final agreed = await Navigator.of(
        context,
      ).push<bool>(MaterialPageRoute(builder: (_) => const ConsentScreen()));
      if (!mounted) return;
      if (agreed != true) {
        setState(() => _busy = false);
        await _controller.start();
        return;
      }
    }

    try {
      final receipt = await ref.read(receiptActionsProvider).submit(url);
      if (!mounted) return;
      Navigator.of(context).pop(receipt);
    } on Object {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      setState(() {
        _busy = false;
        _message = l10n.receiptFailed;
      });
      await _controller.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.receiptScanTitle)),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white70, width: Borders.thick),
                borderRadius: BorderRadius.circular(Radii.md),
              ),
            ),
          ),
          Positioned(
            left: Spacing.lg,
            right: Spacing.lg,
            bottom: Spacing.xxl,
            child: Container(
              padding: const EdgeInsets.all(Spacing.lg),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(Radii.md),
              ),
              child: _busy
                  ? const Center(child: CircularProgressIndicator())
                  : Text(
                      _message ?? l10n.receiptScanHint,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _message == null
                            ? Colors.white
                            : Colors.orangeAccent,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
