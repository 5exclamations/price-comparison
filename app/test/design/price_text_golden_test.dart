// Golden-тесты PriceText.
//
// Зачем эталонные картинки, если есть юнит-тесты на форматирование: юнит-тест
// ловит неверную строку, а golden — неверный ВИД. Реально ломались именно
// картинки: цена уезжала на вторую строку при 199999 гяпиках, зачёркнутая
// старая цена сливалась с текущей, а на дальтонической схеме дешёвая и дорогая
// отличались только оттенком.
//
// Обязательный набор значений из задания:
//   0 гяпиков       — «бесплатно» не бывает, но парсер такое приносил;
//   5 гяпиков       — младше маната: копейки не должны съесться;
//   199999 гяпиков  — 1 999,99 ₼, самая длинная строка с группировкой.
// Каждое — с акцией и без.
//
// Шрифт грузится настоящий: без FontLoader flutter_test рисует прямоугольники
// вместо букв, и эталон перестаёт что-либо проверять — в частности, ə и ₼.
//
// Эталоны обновляются командой:
//   flutter test --update-goldens test/design/price_text_golden_test.dart
// Обновлять их «чтобы тест позеленел» нельзя: сначала надо посмотреть на
// diff-картинку в test/design/failures/ и понять, что именно изменилось.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qiymet/design/theme.dart';
import 'package:qiymet/design/tokens/spacing.dart';
import 'package:qiymet/design/widgets/price_text.dart';

/// Все требуемые значения на одной картинке.
///
/// Одним файлом, а не шестью: сравнивать между собой их всё равно приходится
/// глазами, а разница в весе шрифта видна только рядом.
class _Board extends StatelessWidget {
  const _Board({required this.emphasis, this.withPromo = false});

  final PriceEmphasis emphasis;
  final bool withPromo;

  static const _cases = <int>[0, 5, 199999];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final minor in _cases)
            for (final size in PriceSize.values)
              Padding(
                padding: const EdgeInsets.only(bottom: Spacing.sm),
                child: PriceText(
                  minor: minor,
                  // Старая цена всегда выше текущей: иначе PriceText её
                  // сознательно не покажет, и «с акцией» ничем не отличалось бы
                  // от «без акции».
                  oldMinor: withPromo ? minor + 5000 : null,
                  emphasis: emphasis,
                  size: size,
                  locale: 'az',
                ),
              ),
        ],
      ),
    );
  }
}

Widget _wrap(Widget child, {required bool dark}) {
  return MaterialApp(
    locale: const Locale('az'),
    supportedLocales: const [Locale('az'), Locale('ru'), Locale('en')],
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: dark ? AppTheme.dark() : AppTheme.light(),
    debugShowCheckedModeBanner: false,
    home: Scaffold(body: Center(child: child)),
  );
}

Future<void> _loadInter() async {
  final loader = FontLoader('Inter');
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    final path = 'assets/fonts/Inter-$weight.ttf';
    loader.addFont(
      File(path).readAsBytes().then((b) => ByteData.view(b.buffer)),
    );
  }
  await loader.load();
}

void main() {
  setUpAll(_loadInter);

  group('PriceText: 0, 5 и 199999 гяпиков', () {
    for (final emphasis in PriceEmphasis.values) {
      for (final withPromo in [false, true]) {
        final promo = withPromo ? 'с акцией' : 'без акции';
        final file =
            'price_text_${emphasis.name}'
            '${withPromo ? '_promo' : ''}.png';

        testWidgets('${emphasis.name}, $promo', (tester) async {
          // Ширина заведомо больше самой длинной строки: цель эталона —
          // поймать перенос, а не зафиксировать конкретный перенос.
          tester.view.physicalSize = const Size(900, 900);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.reset);

          await tester.pumpWidget(
            _wrap(
              _Board(emphasis: emphasis, withPromo: withPromo),
              dark: false,
            ),
          );
          await tester.pumpAndSettle();

          await expectLater(
            find.byType(_Board),
            matchesGoldenFile('goldens/$file'),
          );
        });
      }
    }
  });

  testWidgets('тёмная тема: цены не пропадают на тёмном фоне', (tester) async {
    tester.view.physicalSize = const Size(900, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _wrap(
        const _Board(emphasis: PriceEmphasis.cheapest, withPromo: true),
        dark: true,
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(_Board),
      matchesGoldenFile('goldens/price_text_dark_cheapest_promo.png'),
    );
  });

  group('то, что картинка не докажет', () {
    // Golden видит пиксели, но не знает, ПОЧЕМУ они такие. Дальтонизм —
    // как раз этот случай: два оттенка на картинке различимы, а на глаз
    // человека с дейтеранопией могут слиться. Поэтому вес шрифта проверяется
    // отдельно, числом.
    testWidgets('дешёвая и дорогая различаются весом, а не только цветом', (
      tester,
    ) async {
      final weights = <PriceEmphasis, FontWeight>{};
      final colors = <PriceEmphasis, Color>{};

      for (final emphasis in PriceEmphasis.values) {
        await tester.pumpWidget(
          _wrap(
            PriceText(minor: 199999, emphasis: emphasis, locale: 'az'),
            dark: false,
          ),
        );
        final style = tester
            .widget<Text>(find.textContaining('1.999,99').first)
            .style!;
        weights[emphasis] = style.fontWeight!;
        colors[emphasis] = style.color!;
      }

      expect(
        weights[PriceEmphasis.cheapest],
        isNot(weights[PriceEmphasis.priciest]),
        reason: 'на чёрно-белом экране цены стали неразличимы',
      );
      expect(
        weights[PriceEmphasis.cheapest],
        isNot(weights[PriceEmphasis.neutral]),
      );
      expect(
        colors[PriceEmphasis.cheapest],
        isNot(colors[PriceEmphasis.priciest]),
        reason: 'цвет — второй канал, он тоже обязан отличаться',
      );
    });

    testWidgets('ноль гяпиков рисуется как 0,00 ₼, а не как пустота', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const PriceText(minor: 0, locale: 'az'), dark: false),
      );
      expect(find.text('0,00${PriceFormat.nbsp}₼'), findsOneWidget);
    });

    testWidgets('пять гяпиков не округляются до нуля', (tester) async {
      await tester.pumpWidget(
        _wrap(const PriceText(minor: 5, locale: 'az'), dark: false),
      );
      expect(find.text('0,05${PriceFormat.nbsp}₼'), findsOneWidget);
    });

    testWidgets('199999 гяпиков — это 1 999,99 ₼ и одна строка', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(900, 300);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _wrap(
          const PriceText(minor: 199999, size: PriceSize.large, locale: 'az'),
          dark: false,
        ),
      );

      final text = tester.widget<Text>(find.byType(Text).first);
      expect(text.data, '1.999,99${PriceFormat.nbsp}₼');

      // Перенос на вторую строку — та самая поломка, ради которой заведён
      // golden. Проверяем и числом, чтобы падение было читаемым.
      final box = tester.renderObject<RenderBox>(find.byType(Text).first);
      expect(
        box.size.height,
        lessThan(60),
        reason: 'цена уехала на вторую строку',
      );
    });

    testWidgets('старая цена ниже текущей не показывается', (tester) async {
      // «Было 10, стало 12» — накрутка наоборот. Зачёркивать нечего.
      await tester.pumpWidget(
        _wrap(
          const PriceText(minor: 1200, oldMinor: 1000, locale: 'az'),
          dark: false,
        ),
      );
      expect(find.text('12,00${PriceFormat.nbsp}₼'), findsOneWidget);
      expect(find.text('10,00'), findsNothing);
    });
  });
}
