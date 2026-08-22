import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Отрисовка виджета в PNG и отправка в мессенджер.
///
/// Картинка, а не ссылка: в Азербайджане находки пересылают в WhatsApp, и
/// картинка там разворачивается сразу, а ссылка требует от получателя открыть
/// её, поставить приложение и найти тот же товар. Текст с ценой прикладываем
/// рядом — на случай, если картинка не дойдёт.
///
/// Рендер идёт через RepaintBoundary из самого Flutter, без библиотеки
/// скриншотов: виджет уже нарисован, остаётся попросить его слой в растр.
class ShareCard {
  const ShareCard();

  /// Снять PNG с поддерева под [key].
  ///
  /// [pixelRatio] 3 — чтобы картинка не мылилась на экранах получателей;
  /// у отправителя плотность может быть ниже, чем у того, кто смотрит.
  Future<Uint8List?> capture(GlobalKey key, {double pixelRatio = 3}) async {
    final object = key.currentContext?.findRenderObject();
    if (object is! RenderRepaintBoundary) return null;

    final image = await object.toImage(pixelRatio: pixelRatio);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return data?.buffer.asUint8List();
  }

  /// Снять и отправить. Возвращает false, если снять не удалось.
  Future<bool> shareWidget(
    GlobalKey key, {
    required String text,
    String fileName = 'qiymet.png',
  }) async {
    final bytes = await capture(key);
    if (bytes == null) return false;

    final dir = await getTemporaryDirectory();
    final file = XFile.fromData(
      bytes,
      name: fileName,
      mimeType: 'image/png',
      path: '${dir.path}/$fileName',
    );

    await Share.shareXFiles([file], text: text);
    return true;
  }
}
