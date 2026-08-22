import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qiymet/design/theme.dart';
import 'package:qiymet/design/tokens/typography.dart';

/// Контрольная строка из задания. Если шрифт не покрывает эти буквы, текст
/// молча дорисовывается запасным шрифтом — и азербайджанский заголовок
/// выглядит склеенным из двух разных гарнитур.
const probe = 'Çuğundur, göbələk, şəkər tozu, ət və südlü məhsullar';

/// Азербайджанский алфавит в обоих регистрах плюс отдельно ə — самая частая
/// из «особых» букв и самая частая пропажа в шрифтах.
const alphabet = 'əƏıIİiğĞşŞçÇöÖüÜ';

void main() {
  group('шрифт Inter', () {
    test('файлы шрифта лежат в assets и не пустые', () async {
      for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
        final bytes = await _load('assets/fonts/Inter-$weight.ttf');
        expect(
          bytes.lengthInBytes,
          greaterThan(100000),
          reason: 'Inter-$weight.ttf подозрительно мал',
        );
        // Заголовок TrueType: 0x00010000 либо 'true'/'OTTO'
        final tag = bytes.getUint32(0);
        expect(
          tag == 0x00010000 || tag == 0x74727565 || tag == 0x4F54544F,
          isTrue,
          reason: 'Inter-$weight.ttf не похож на шрифт',
        );
      }
    });

    test('cmap покрывает азербайджанский алфавит', () async {
      final bytes = await _load('assets/fonts/Inter-Regular.ttf');
      final covered = _codepointsInCmap(bytes);

      final missing = <String>[];
      for (final ch in alphabet.runes) {
        if (!covered.contains(ch)) {
          missing.add(
            'U+${ch.toRadixString(16).toUpperCase().padLeft(4, '0')}',
          );
        }
      }
      expect(missing, isEmpty, reason: 'нет глифов: $missing');
    });

    test('cmap покрывает контрольную строку целиком', () async {
      final bytes = await _load('assets/fonts/Inter-Regular.ttf');
      final covered = _codepointsInCmap(bytes);

      final missing = <String>[];
      for (final ch in probe.runes) {
        if (ch == 0x20) continue;
        if (!covered.contains(ch)) {
          missing.add(String.fromCharCode(ch));
        }
      }
      expect(missing, isEmpty, reason: 'не отрисуются: $missing');
    });

    test('cmap покрывает кириллицу для русской локали', () async {
      final bytes = await _load('assets/fonts/Inter-Regular.ttf');
      final covered = _codepointsInCmap(bytes);
      const ru = 'Дешевле рынка на 60% — цена упала';

      for (final ch in ru.runes) {
        if (ch == 0x20) continue;
        expect(
          covered.contains(ch),
          isTrue,
          reason: 'нет глифа для ${String.fromCharCode(ch)}',
        );
      }
    });

    test('знак маната есть', () async {
      final bytes = await _load('assets/fonts/Inter-Regular.ttf');
      expect(
        _codepointsInCmap(bytes).contains(0x20BC),
        isTrue,
        reason: 'нет U+20BC ₼ — цену будет нечем подписать',
      );
    });
  });

  group('тема', () {
    testWidgets('текст рисуется семейством Inter', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: Text(probe)),
        ),
      );
      final text = tester.widget<Text>(find.text(probe));
      final style = DefaultTextStyle.of(tester.element(find.text(probe))).style;
      expect(text.style?.fontFamily ?? style.fontFamily, AppFonts.family);
    });

    testWidgets('светлая и тёмная темы обе собираются', (tester) async {
      for (final theme in [AppTheme.light(), AppTheme.dark()]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: const Scaffold(body: Text(probe)),
          ),
        );
        expect(find.text(probe), findsOneWidget);
      }
    });
  });
}

Future<ByteData> _load(String path) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  return rootBundle.load(path);
}

/// Разбирает таблицу cmap и возвращает покрытые кодовые точки.
///
/// Формат 4 (BMP) и формат 12 (полный диапазон) — этого достаточно: всё, что
/// нам нужно, лежит в BMP, а формат 12 встречается у шрифтов с эмодзи.
Set<int> _codepointsInCmap(ByteData font) {
  final numTables = font.getUint16(4);
  int? cmapOffset;

  for (var i = 0; i < numTables; i++) {
    final rec = 12 + i * 16;
    final tag = String.fromCharCodes([
      font.getUint8(rec),
      font.getUint8(rec + 1),
      font.getUint8(rec + 2),
      font.getUint8(rec + 3),
    ]);
    if (tag == 'cmap') {
      cmapOffset = font.getUint32(rec + 8);
      break;
    }
  }
  if (cmapOffset == null) return {};

  final numSubtables = font.getUint16(cmapOffset + 2);
  final result = <int>{};

  for (var i = 0; i < numSubtables; i++) {
    final enc = cmapOffset + 4 + i * 8;
    final subtable = cmapOffset + font.getUint32(enc + 4);
    final format = font.getUint16(subtable);

    if (format == 4) {
      final segX2 = font.getUint16(subtable + 6);
      final segs = segX2 ~/ 2;
      final endBase = subtable + 14;
      final startBase = endBase + segX2 + 2;
      final deltaBase = startBase + segX2;
      final rangeBase = deltaBase + segX2;

      for (var s = 0; s < segs; s++) {
        final end = font.getUint16(endBase + s * 2);
        final start = font.getUint16(startBase + s * 2);
        if (start > end) continue;
        final delta = font.getUint16(deltaBase + s * 2);
        final rangeOffset = font.getUint16(rangeBase + s * 2);

        for (var c = start; c <= end && c != 0xFFFF; c++) {
          int glyph;
          if (rangeOffset == 0) {
            glyph = (c + delta) & 0xFFFF;
          } else {
            final gi = rangeBase + s * 2 + rangeOffset + (c - start) * 2;
            if (gi + 1 >= font.lengthInBytes) continue;
            glyph = font.getUint16(gi);
            if (glyph != 0) glyph = (glyph + delta) & 0xFFFF;
          }
          if (glyph != 0) result.add(c);
        }
      }
    } else if (format == 12) {
      final groups = font.getUint32(subtable + 12);
      for (var g = 0; g < groups; g++) {
        final base = subtable + 16 + g * 12;
        final start = font.getUint32(base);
        final end = font.getUint32(base + 4);
        for (var c = start; c <= end && c - start < 0x10000; c++) {
          result.add(c);
        }
      }
    }
  }
  return result;
}
