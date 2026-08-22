import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/text.dart';
import '../../../design/tokens/spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/scanner_providers.dart';

/// Сканер штрихкода.
///
/// Самый быстрый путь к цене: человек стоит у полки с пачкой в руке. Поэтому
/// отсканированный EAN сразу ведёт на карточку товара, без промежуточного
/// экрана результатов с одной строкой.
///
/// Возвращает найденный productId через Navigator.pop, либо null.
class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  final _controller = MobileScannerController(
    // Штрихкоды на упаковке — это EAN и UPC. Остальные форматы только
    // добавляют ложных срабатываний на ценниках и рекламе.
    formats: const [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
    ],
    detectionSpeed: DetectionSpeed.normal,
  );

  bool _handling = false;
  String? _notFound;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handling) return;

    final raw = capture.barcodes
        .map((b) => b.rawValue)
        .firstWhere(
          (v) => v != null && looksLikeBarcode(v),
          orElse: () => null,
        );
    if (raw == null) return;

    setState(() {
      _handling = true;
      _notFound = null;
    });
    await _controller.stop();

    final productId = await ref.read(resolveBarcodeProvider(raw).future);
    if (!mounted) return;

    if (productId != null) {
      Navigator.of(context).pop(productId);
      return;
    }

    // Товара нет в базе. Не выкидываем человека с экрана: пусть попробует
    // другую упаковку, не начиная сначала.
    setState(() {
      _handling = false;
      _notFound = raw;
    });
    await _controller.start();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.scanTitle)),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          const _ScanFrame(),
          Positioned(
            left: Spacing.lg,
            right: Spacing.lg,
            bottom: Spacing.xxl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_handling)
                  const CircularProgressIndicator()
                else
                  _Hint(
                    text: _notFound == null
                        ? l10n.scanHint
                        : l10n.scanNotFound(_notFound!),
                    warning: _notFound != null,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Рамка прицела. Без неё непонятно, куда наводить.
class _ScanFrame extends StatelessWidget {
  const _ScanFrame();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 260,
        height: 160,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white70, width: Borders.thick),
          borderRadius: BorderRadius.circular(Radii.md),
        ),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.text, required this.warning});

  final String text;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: warning ? Colors.orangeAccent : Colors.white,
        ),
      ),
    );
  }
}
