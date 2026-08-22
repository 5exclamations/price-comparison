// Генератор иконки и сплэша. Запускается руками:
//
//   flutter test tool/make_icons_test.dart
//
// Почему тестом, а не отдельной программой: рисовать надо тем же движком,
// каким приложение рисует всё остальное, и тем же шрифтом. flutter_test —
// единственный способ получить настоящий Canvas без устройства.
//
// Почему не flutter_launcher_icons: пакет тянется из сети и делает ровно это
// же — берёт один PNG и раскладывает по размерам. Исходный PNG всё равно надо
// откуда-то взять, а здесь он рождается из токенов дизайн-системы: цвет и
// шрифт совпадут с приложением по определению, а не по внимательности.
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qiymet/design/tokens/colors.dart';

/// Размеры Android (mipmap) и iOS (AppIcon.appiconset).
const _android = <String, int>{
  'mipmap-mdpi': 48,
  'mipmap-hdpi': 72,
  'mipmap-xhdpi': 96,
  'mipmap-xxhdpi': 144,
  'mipmap-xxxhdpi': 192,
};

const _ios = <String, int>{
  'Icon-App-20x20@1x.png': 20,
  'Icon-App-20x20@2x.png': 40,
  'Icon-App-20x20@3x.png': 60,
  'Icon-App-29x29@1x.png': 29,
  'Icon-App-29x29@2x.png': 58,
  'Icon-App-29x29@3x.png': 87,
  'Icon-App-40x40@1x.png': 40,
  'Icon-App-40x40@2x.png': 80,
  'Icon-App-40x40@3x.png': 120,
  'Icon-App-60x60@2x.png': 120,
  'Icon-App-60x60@3x.png': 180,
  'Icon-App-76x76@1x.png': 76,
  'Icon-App-76x76@2x.png': 152,
  'Icon-App-83.5x83.5@2x.png': 167,
  'Icon-App-1024x1024@1x.png': 1024,
};

Future<void> _loadInter() async {
  final loader = FontLoader('Inter');
  for (final weight in ['Regular', 'Bold']) {
    final path = 'assets/fonts/Inter-$weight.ttf';
    loader.addFont(
      File(path).readAsBytes().then((b) => ByteData.view(b.buffer)),
    );
  }
  await loader.load();
}

/// Иконка: знак маната на фирменной зелени.
///
/// ₼ вместо буквы «q» намеренно: приложение про деньги, знак валюты читается
/// с первого взгляда и на азербайджанском, и на русском экране. Ещё он
/// проверяет то, что проверить больше нечем, — что выбранный шрифт этот
/// символ вообще содержит.
Future<Uint8List> _drawIcon(int size, {required bool rounded}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final rect = Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble());

  // Android сам скругляет и обрезает, iOS требует квадрат без прозрачности.
  if (rounded) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(size * 0.22)),
      Paint()..color = Seed.brand,
    );
  } else {
    canvas.drawRect(rect, Paint()..color = Seed.brand);
  }

  final painter = TextPainter(
    text: TextSpan(
      text: '₼',
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: size * 0.62,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();

  painter.paint(
    canvas,
    Offset((size - painter.width) / 2, (size - painter.height) / 2),
  );

  final picture = recorder.endRecording();
  final image = picture.toImageSync(size, size);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  return data!.buffer.asUint8List();
}

void main() {
  setUpAll(_loadInter);

  test('иконки Android', () async {
    for (final e in _android.entries) {
      final dir = Directory('android/app/src/main/res/${e.key}')
        ..createSync(recursive: true);
      File(
        '${dir.path}/ic_launcher.png',
      ).writeAsBytesSync(await _drawIcon(e.value, rounded: true));
    }
    // Отдельно — крупный вариант для сплэша.
    File(
      'android/app/src/main/res/mipmap-xxxhdpi/splash_logo.png',
    ).writeAsBytesSync(await _drawIcon(384, rounded: true));
  });

  _iosLaunchImages();

  test('иконки iOS', () async {
    final dir = Directory('ios/Runner/Assets.xcassets/AppIcon.appiconset');
    for (final e in _ios.entries) {
      // Прозрачности в iOS-иконке быть не должно: App Store отклоняет.
      File(
        '${dir.path}/${e.key}',
      ).writeAsBytesSync(await _drawIcon(e.value, rounded: false));
    }
  });
}

/// Сплэш iOS. Storyboard показывает эту картинку по центру на фоне цвета
/// бренда; сам цвет задан в LaunchScreen.storyboard.
void _iosLaunchImages() {
  test('сплэш iOS', () async {
    final dir = Directory('ios/Runner/Assets.xcassets/LaunchImage.imageset');
    dir.createSync(recursive: true);
    const sizes = {
      'LaunchImage.png': 128,
      'LaunchImage@2x.png': 256,
      'LaunchImage@3x.png': 384,
    };
    for (final e in sizes.entries) {
      File(
        '${dir.path}/${e.key}',
      ).writeAsBytesSync(await _drawIcon(e.value, rounded: true));
    }
  });
}
