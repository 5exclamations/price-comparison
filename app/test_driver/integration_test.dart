// Драйвер для снимков экрана.
//
// Сам тест снимает картинку через takeScreenshot, но записать её на диск может
// только эта сторона: тест живёт на устройстве, а файловая система, куда
// поедут артефакты сборки, — на машине сборки.
//
//   flutter drive --driver=test_driver/integration_test.dart \
//     --target=integration_test/app_flow_test.dart \
//     --dart-define=QIYMET_SCREENSHOTS=true
import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  await integrationDriver(
    onScreenshot:
        (String name, List<int> bytes, [Map<String, Object?>? args]) async {
          final dir = Directory('build/screenshots')
            ..createSync(recursive: true);
          final file = File('${dir.path}/$name.png')..writeAsBytesSync(bytes);

          // Пустой файл технически успешен и на артефактах выглядит как снимок.
          // Проверяем размер: чёрный экран из-за незакрытой поверхности Android
          // весит подозрительно мало.
          if (file.lengthSync() < 1024) {
            // ignore: avoid_print
            print(
              'снимок $name весит ${file.lengthSync()} байт — похоже, пустой',
            );
            return false;
          }
          return true;
        },
  );
}
