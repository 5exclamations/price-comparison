import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_selection.freezed.dart';

/// Что выбрал пользователь: сети, в которые он ходит, и конкретный магазин
/// там, где цена от него зависит.
///
/// Почему сетей может быть несколько, а магазин один. Цену меняет только
/// выбор точки у сетей с моделью per_cluster — сейчас это Bravo. У остальных
/// прайс единый на всю сеть, и филиал ни на что не влияет. Поэтому набор
/// сетей — это фильтр показа, а [storeId] — то единственное, что уходит в
/// каждый запрос и реально меняет цифры.
@freezed
abstract class StoreSelection with _$StoreSelection {
  const factory StoreSelection({
    /// Коды выбранных сетей: bravo, araz, spar, neptun, rahat, bazarstore.
    @Default(<String>{}) Set<String> chainCodes,

    /// Выбранный магазин сети, где цена зависит от точки.
    int? pickedStoreId,

    /// Код сети, к которой относится [pickedStoreId]. Хранится рядом, чтобы
    /// при снятии галочки с этой сети сбросить и магазин.
    String? pickedStoreChainCode,

    /// Название магазина — чтобы показать выбор, не ходя в сеть.
    String? pickedStoreName,
  }) = _StoreSelection;

  const StoreSelection._();

  static const empty = StoreSelection();

  /// То, что уходит в API как store_id.
  int? get storeId => pickedStoreId;

  bool contains(String chainCode) => chainCodes.contains(chainCode);

  /// Выбор завершён и его можно сохранить.
  ///
  /// [chainsRequiringStore] — коды сетей, у которых цена привязана к точке.
  /// Приходит снаружи, из списка магазинов: сама модель этого знать не может,
  /// а угадывать по названию сети нельзя — сегодня такая сеть одна, завтра их
  /// станет две, и захардкоженный 'bravo' промолчит.
  ///
  /// Пропустить онбординг нельзя именно из-за второго условия: показать
  /// «цену в Bravo» без магазина значит назвать одну из четырёх разных цен и
  /// выдать её за общую.
  bool isCompleteFor(Set<String> chainsRequiringStore) {
    if (chainCodes.isEmpty) return false;

    final needsPick = chainCodes.intersection(chainsRequiringStore);
    if (needsPick.isEmpty) return true;

    // Выбрана сеть с привязкой цены к точке — магазин обязателен, и он должен
    // принадлежать именно этой сети.
    return pickedStoreId != null &&
        pickedStoreChainCode != null &&
        needsPick.contains(pickedStoreChainCode);
  }

  /// Каких сетей не хватает магазина. Нужно, чтобы подсветить их в списке.
  Set<String> missingStoreFor(Set<String> chainsRequiringStore) {
    final needsPick = chainCodes.intersection(chainsRequiringStore);
    if (needsPick.isEmpty) return const {};
    if (pickedStoreChainCode != null &&
        needsPick.contains(pickedStoreChainCode) &&
        pickedStoreId != null) {
      return needsPick.difference({pickedStoreChainCode!});
    }
    return needsPick;
  }
}
