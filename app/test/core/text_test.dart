import 'package:flutter_test/flutter_test.dart';
import 'package:qiymet/core/text.dart';

/// U+0307, комбинирующая точка сверху — та самая, что появляется при
/// неправильном порядке шагов. Здесь и ниже записана escape-последовательностью:
/// живой символ невидим в редакторе и прилипает к соседней букве.
const String combiningDot = '\u0307';

void main() {
  group('normalizeAz — обязательные случаи из задания', () {
    test("normalizeAz('MİLKA') == 'milka'", () {
      expect(normalizeAz('MİLKA'), 'milka');
    });

    test("normalizeAz('ÇUĞUNDUR') == 'cugundur'", () {
      expect(normalizeAz('ÇUĞUNDUR'), 'cugundur');
    });
  });

  group('порядок шагов', () {
    test('İ не превращается в i с комбинирующей точкой', () {
      final result = normalizeAz('İ');
      expect(result, 'i');
      expect(result.codeUnits, [0x69], reason: 'ожидалась одна кодовая точка');
      expect(
        result.contains(combiningDot),
        isFalse,
        reason: 'осталась точка — регистр опустили слишком рано',
      );
    });

    test('порядок не зависит от того, как ведёт себя toLowerCase', () {
      // На Dart 3.13 'İ'.toLowerCase() возвращает голую 'i' без U+0307 —
      // ловушки, описанной в CLAUDE.md, в этом SDK уже нет. Фиксируем факт,
      // а не желаемое: тест, утверждающий обратное, однажды упадёт на ровном
      // месте и заставит «чинить» рабочий код.
      final lowered = 'MİLKA'.toLowerCase();
      final sdkHasTrap = lowered.contains(combiningDot);

      // Порядок шагов держится не на доброте Dart. В JavaScript и в Postgres
      // lower('İ') по-прежнему даёт 'i' + U+0307, а наша нормализация обязана
      // совпадать с серверной qiymet_norm посимвольно.
      expect(normalizeAz('MİLKA'), 'milka');
      expect(
        normalizeAz(lowered),
        'milka',
        reason: sdkHasTrap
            ? 'вход с комбинирующей точкой обязан нормализоваться так же'
            : 'SDK перестал ставить точку, результат обязан совпасть',
      );
    });

    test('уже разложенный ввод даёт тот же результат', () {
      // 'I' + U+0307 вместо готовой 'İ' — то, что отдаёт чужой toLowerCase()
      const decomposed = 'MI${combiningDot}LKA';
      expect(decomposed, isNot('MİLKA'), reason: 'строки обязаны различаться');
      expect(normalizeAz(decomposed), 'milka');
      expect(normalizeAz(decomposed), normalizeAz('MİLKA'));
    });
  });

  group('азербайджанский алфавит', () {
    test('заглавные', () {
      expect(normalizeAz('Ə'), 'a');
      expect(normalizeAz('Ö'), 'o');
      expect(normalizeAz('Ü'), 'u');
      expect(normalizeAz('Ç'), 'c');
      expect(normalizeAz('Ş'), 's');
      expect(normalizeAz('Ğ'), 'g');
      expect(normalizeAz('I'), 'i');
      expect(normalizeAz('İ'), 'i');
    });

    test('строчные', () {
      expect(normalizeAz('ə'), 'a');
      expect(normalizeAz('ı'), 'i');
      expect(normalizeAz('ö'), 'o');
      expect(normalizeAz('ü'), 'u');
      expect(normalizeAz('ç'), 'c');
      expect(normalizeAz('ş'), 's');
      expect(normalizeAz('ğ'), 'g');
    });

    test('контрольная строка целиком', () {
      expect(
        normalizeAz('Çuğundur, göbələk, şəkər tozu, ət və südlü məhsullar'),
        'cugundur, gobalak, sakar tozu, at va sudlu mahsullar',
      );
    });

    test('оба регистра дают одно и то же', () {
      const pairs = [
        ['ÇUĞUNDUR', 'çuğundur'],
        ['ŞƏKƏR', 'şəkər'],
        ['GÖBƏLƏK', 'göbələk'],
        ['SÜDLÜ', 'südlü'],
        ['MİLKA', 'milka'],
      ];
      for (final p in pairs) {
        expect(
          normalizeAz(p[0]),
          normalizeAz(p[1]),
          reason: '${p[0]} и ${p[1]} должны совпасть',
        );
      }
    });

    test('весь алфавит сводится к ASCII', () {
      expect(normalizeAz('ƏİIıĞğŞşÇçÖöÜü'), 'aiiiggssccoouu');
      for (final unit in normalizeAz('ƏİIıĞğŞşÇçÖöÜü').codeUnits) {
        expect(unit, lessThan(128), reason: 'осталась не-ASCII буква');
      }
    });
  });

  group('смесь латиницы с кириллицей', () {
    // Сети мешают алфавиты внутри одного названия. Глазами это одна строка,
    // байтами — две разные, и товар пропадает из поиска.
    //
    // Таблица двойников обязана совпадать с SQL-функцией qiymet_norm
    // (миграция 0005) и с pipeline.norm_name. Если серверная и клиентская
    // нормализации разъедутся, локальный фильтр начнёт прятать то, что сервер
    // уже нашёл, — молча, без единой ошибки в логах.
    test('восемь двойников сворачиваются в латиницу', () {
      const table = {
        'А': 'a',
        'а': 'a',
        'Е': 'e',
        'е': 'e',
        'О': 'o',
        'о': 'o',
        'С': 'c',
        'с': 'c',
        'Р': 'p',
        'р': 'p',
        'Х': 'x',
        'х': 'x',
        'У': 'y',
        'у': 'y',
        'К': 'k',
        'к': 'k',
      };
      table.forEach((cyrillic, latin) {
        expect(
          normalizeAz(cyrillic),
          latin,
          reason: 'кириллическая $cyrillic должна стать латинской $latin',
        );
      });
    });

    test('одно и то же слово двумя алфавитами даёт одну строку', () {
      // Слева кириллические С, о, с, а; справа те же буквы латиницей.
      expect(normalizeAz('Соса-Сola'), normalizeAz('Coca-Cola'));
      expect(normalizeAz('Сосa-Сola'), 'coca-cola');

      // Кириллические Р, е, п, с, и в «Pepsi»: п не двойник, поэтому остаётся.
      expect(normalizeAz('Реpsi'), 'pepsi');
    });

    test('кириллица без латинского двойника остаётся кириллицей', () {
      // Так же ведёт себя SQL: не-двойники только опускаются в нижний регистр.
      //
      // Ожидания записаны кодовыми точками намеренно. Строка 'moлoko' в
      // редакторе неотличима от 'мoлoko', и первый вариант этого теста
      // разошёлся с реальностью именно на этом.
      expect(
        normalizeAz('Молоко').runes.toList(),
        [0x43C, 0x6F, 0x43B, 0x6F, 0x6B, 0x6F], // м o л o k o
      );
      // «Шоколад»: О и А — двойники, Ш Л Д остаются кириллицей.
      expect(
        normalizeAz('Шоколад').runes.toList(),
        [0x448, 0x6F, 0x6B, 0x6F, 0x43B, 0x61, 0x434], // ш o k o л a д
      );
      // А «Сахар» сворачивается целиком: С, а, х, р — все четыре двойники.
      expect(normalizeAz('Сахар'), 'caxap');
    });

    test('регистр кириллицы опускается без помощи локали', () {
      const pairs = [
        ['МОЛОКО', 'молоко'],
        ['ЩЕПОТКА', 'щепотка'],
        ['ЪЫЬЭЮЯ', 'ъыьэюя'],
      ];
      for (final p in pairs) {
        expect(normalizeAz(p[0]), normalizeAz(p[1]), reason: p[0]);
      }
    });

    test('Ё и Й теряют диакритику, как после NFD на сервере', () {
      // Ё разбирается в «е» + U+0308, диакритика снимается, и «е» — двойник,
      // поэтому на выходе ЛАТИНСКАЯ e. Проверяем кодовой точкой: на глаз
      // латинская e и кириллическая е одинаковы.
      expect(normalizeAz('Ё').runes.single, 0x65);
      expect(normalizeAz('ё').runes.single, 0x65);

      // Й разбирается в «и» + U+0306, а «и» двойника не имеет и остаётся
      // кириллической.
      expect(normalizeAz('Й').runes.single, 0x438);
      expect(normalizeAz('й').runes.single, 0x438);
    });

    test('сворачиваются только двойники, остальное остаётся как есть', () {
      // «Кока-Кола» кириллицей и «KOKA-KOLA» латиницей РАЗНЫЕ строки: «л»
      // двойника не имеет и остаётся кириллической. Это не недоделка, а
      // граница правила — таблица двойников совпадает с серверной, и
      // расширять её на клиенте в одиночку нельзя.
      expect(normalizeAz('Кока-Кола Zero 330 ml').runes.toList(), [
        0x6B, 0x6F, 0x6B, 0x61, 0x2D, // k o k a -
        0x6B, 0x6F, 0x43B, 0x61, 0x20, // k o л a
        0x7A, 0x65, 0x72, 0x6F, 0x20, // zero
        0x33, 0x33, 0x30, 0x20, 0x6D, 0x6C, // 330 ml
      ]);
      expect(
        normalizeAz('KOKA-KOLA ZERO 330 ML'),
        isNot(normalizeAz('Кока-Кола Zero 330 ml')),
      );

      // А там, где двойники все до единого, написание перестаёт иметь значение.
      expect(normalizeAz('СОК'), normalizeAz('COK'));
      expect(normalizeAz('РОСА'), normalizeAz('POCA'));
    });

    test('поиск находит вперемешку в обе стороны', () {
      expect(containsAz('Сосa-Сola 330 ml', 'coca'), isTrue);
      expect(containsAz('Coca-Cola 330 ml', 'Сосa'), isTrue);
      expect(containsAz('MİLKA ŞOKOLAD 90 QR', 'şokolad'), isTrue);
    });

    test('идемпотентность держится и на смеси', () {
      // Ё — та самая поломка, ради которой в normalizeAz появился пятый шаг.
      // Первый проход раскладывает Ё в кириллическую «е», второй свернул бы
      // её в латинскую «e». Клиент нормализует запрос у себя, сервер — ещё
      // раз, и «мёд» переставал находить «Мёд».
      const samples = [
        'Сосa-Сola',
        'Кока-Кола Zero',
        'ШОКОЛАД MİLKA',
        'Ёж',
        'мёд',
        'Тёма 3.2%',
      ];
      for (final s in samples) {
        expect(normalizeAz(normalizeAz(s)), normalizeAz(s), reason: s);
      }
    });

    test('Ё нормализуется одинаково, сколько раз ни примени', () {
      // Тот же текст, набранный через «е» и через «ё», обязан совпасть после
      // любого числа прогонок — иначе запрос и индекс расходятся.
      final once = normalizeAz('мёд');
      final twice = normalizeAz(once);
      expect(twice, once);
      expect(once.runes.toList(), [0x43C, 0x65, 0x434]); // м e д
    });
  });

  group('края', () {
    test('пустая строка', () {
      expect(normalizeAz(''), '');
    });

    test('строка без букв не меняется', () {
      expect(normalizeAz('13.99 ₼'), '13.99 ₼');
      expect(normalizeAz('4760000602371'), '4760000602371');
    });

    test('идемпотентность', () {
      const samples = [
        'MİLKA',
        'ÇUĞUNDUR',
        'Çuğundur, göbələk, şəkər tozu',
        'Papia tualet kağızı 32 li',
        '',
      ];
      for (final s in samples) {
        expect(normalizeAz(normalizeAz(s)), normalizeAz(s), reason: s);
      }
    });

    test('пробелы схлопываются только в normalizeAzQuery', () {
      expect(normalizeAz('  ŞƏKƏR   TOZU  '), '  sakar   tozu  ');
      expect(normalizeAzQuery('  ŞƏKƏR   TOZU  '), 'sakar tozu');
    });
  });

  group('containsAz', () {
    test('находит независимо от регистра и диакритики', () {
      expect(containsAz('MİLKA MMMAX 270 Q SÜDLÜ', 'milka'), isTrue);
      expect(containsAz('Milka Eskimo 90qr', 'MİLKA'), isTrue);
      expect(containsAz('ŞƏKƏR TOZU 1 KQ', 'sakar'), isTrue);
      expect(containsAz('Çuğundur', 'cugundur'), isTrue);
    });

    test('не находит чужого', () {
      expect(containsAz('MİLKA', 'nutella'), isFalse);
    });

    test('пустой запрос совпадает со всем', () {
      expect(containsAz('что угодно', ''), isTrue);
      expect(containsAz('что угодно', '   '), isTrue);
    });
  });

  group('looksLikeBarcode', () {
    test('настоящие штрихкоды', () {
      expect(looksLikeBarcode('4760000602371'), isTrue); // EAN-13
      expect(looksLikeBarcode('8699432202179'), isTrue);
      expect(looksLikeBarcode('12345678'), isTrue); // EAN-8
      expect(looksLikeBarcode('4760 0006 0237 1'), isTrue);
      expect(looksLikeBarcode('4760-0006-02371'), isTrue);
    });

    test('не штрихкоды', () {
      expect(looksLikeBarcode('milka'), isFalse);
      expect(looksLikeBarcode('1234567'), isFalse); // коротко
      expect(looksLikeBarcode('123456789012345'), isFalse); // длинно
      expect(looksLikeBarcode(''), isFalse);
      expect(looksLikeBarcode('13.99'), isFalse);
    });
  });
}
