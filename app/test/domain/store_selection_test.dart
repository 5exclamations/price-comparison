import 'package:flutter_test/flutter_test.dart';
import 'package:qiymet/domain/models/store_selection.dart';

/// Коды сетей, у которых цена привязана к точке. В боевом коде приходят с
/// сервера (`price_model == 'per_cluster'`), здесь заданы явно.
const requiring = {'bravo'};

void main() {
  group('пропустить выбор нельзя', () {
    test('пустой выбор не завершён', () {
      expect(StoreSelection.empty.isCompleteFor(requiring), isFalse);
    });

    test('сеть с единой ценой — магазин не нужен', () {
      const s = StoreSelection(chainCodes: {'araz'});
      expect(s.isCompleteFor(requiring), isTrue);
      expect(s.storeId, isNull);
    });

    test('несколько сетей с единой ценой — тоже достаточно', () {
      const s = StoreSelection(chainCodes: {'araz', 'spar', 'neptun'});
      expect(s.isCompleteFor(requiring), isTrue);
    });

    test('ГЛАВНОЕ: сеть с привязкой к точке без магазина не завершена', () {
      // Ровно тот случай, ради которого онбординг обязателен. Показать
      // «цену в Bravo» без магазина значит взять одну из четырёх разных цен
      // и выдать её за общую.
      const s = StoreSelection(chainCodes: {'bravo'});
      expect(s.isCompleteFor(requiring), isFalse);
    });

    test('и не спасает, если рядом отмечена сеть с единой ценой', () {
      const s = StoreSelection(chainCodes: {'bravo', 'araz'});
      expect(
        s.isCompleteFor(requiring),
        isFalse,
        reason: 'Araz не закрывает дыру в цене Bravo',
      );
    });

    test('с выбранным магазином — завершена', () {
      const s = StoreSelection(
        chainCodes: {'bravo'},
        pickedStoreId: 3,
        pickedStoreChainCode: 'bravo',
        pickedStoreName: 'Bravo Superstore 28 Mall',
      );
      expect(s.isCompleteFor(requiring), isTrue);
      expect(s.storeId, 3);
    });

    test('магазин чужой сети не засчитывается', () {
      // Выбран магазин Araz, а требует выбора Bravo.
      const s = StoreSelection(
        chainCodes: {'bravo'},
        pickedStoreId: 5,
        pickedStoreChainCode: 'araz',
      );
      expect(s.isCompleteFor(requiring), isFalse);
    });

    test(
      'если сеть, требующая выбора, вообще не отмечена — магазин не нужен',
      () {
        const s = StoreSelection(chainCodes: {'araz'});
        expect(s.isCompleteFor(requiring), isTrue);
      },
    );

    test('когда таких сетей нет вовсе, хватает любой', () {
      const s = StoreSelection(chainCodes: {'bravo'});
      expect(s.isCompleteFor(const {}), isTrue);
    });
  });

  group('missingStoreFor', () {
    test('называет сеть, которой не хватает магазина', () {
      const s = StoreSelection(chainCodes: {'bravo', 'araz'});
      expect(s.missingStoreFor(requiring), {'bravo'});
    });

    test('после выбора магазина не жалуется', () {
      const s = StoreSelection(
        chainCodes: {'bravo'},
        pickedStoreId: 3,
        pickedStoreChainCode: 'bravo',
      );
      expect(s.missingStoreFor(requiring), isEmpty);
    });

    test('две сети с привязкой — вторая остаётся в списке', () {
      const s = StoreSelection(
        chainCodes: {'bravo', 'oba'},
        pickedStoreId: 3,
        pickedStoreChainCode: 'bravo',
      );
      expect(s.missingStoreFor(const {'bravo', 'oba'}), {'oba'});
    });

    test('ничего не требует — список пуст', () {
      const s = StoreSelection(chainCodes: {'araz'});
      expect(s.missingStoreFor(requiring), isEmpty);
    });
  });

  group('storeId — то, что уходит в запрос', () {
    test('у сетей с единой ценой его нет', () {
      const s = StoreSelection(chainCodes: {'araz', 'spar'});
      expect(s.storeId, isNull);
    });

    test('это магазин той сети, где цена от него зависит', () {
      const s = StoreSelection(
        chainCodes: {'araz', 'bravo'},
        pickedStoreId: 4,
        pickedStoreChainCode: 'bravo',
      );
      expect(s.storeId, 4);
    });
  });

  group('contains', () {
    test('видит отмеченные сети', () {
      const s = StoreSelection(chainCodes: {'araz', 'bravo'});
      expect(s.contains('araz'), isTrue);
      expect(s.contains('bravo'), isTrue);
      expect(s.contains('rahat'), isFalse);
    });
  });
}
