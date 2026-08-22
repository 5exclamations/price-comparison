import 'package:freezed_annotation/freezed_annotation.dart';

part 'packaging.freezed.dart';

/// Фасовка товара.
///
/// Отдельный тип, а не пара полей, из-за весовых товаров. У них
/// `unitType == 'kg_bulk'`: штрихкода нет, а цена указана ЗА КИЛОГРАММ.
/// Если этого не написать явно, человек сравнит цену килограмма помидоров
/// с ценой пачки — и решит, что помидоры дороже сыра.
@freezed
abstract class Packaging with _$Packaging {
  const factory Packaging({double? value, String? type}) = _Packaging;

  const Packaging._();

  /// Весовой товар: цена за килограмм, фасовки как таковой нет.
  bool get isPerKilogram => type == 'kg_bulk';

  /// Есть ли что показывать вообще.
  bool get isKnown => isPerKilogram || (value != null && type != null);
}

/// Единицы, как их отдаёт пайплайн и как их показывать.
///
/// Пайплайн пишет базовые единицы (`g`, `ml`, `pcs`, `kg_bulk`), а
/// канонический товар может нести и `l`, `kg`, `ədəd`. Поддерживаем оба
/// набора: молчаливый пропуск незнакомой единицы хуже, чем её показ как есть.
const Map<String, String> unitSuffixAz = {
  'g': 'q',
  'gr': 'q',
  'q': 'q',
  'kg': 'kq',
  'kq': 'kq',
  'ml': 'ml',
  'l': 'l',
  'lt': 'l',
  'pcs': 'ədəd',
  'ədəd': 'ədəd',
  'eded': 'ədəd',
};
