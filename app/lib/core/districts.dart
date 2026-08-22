import 'text.dart';

/// Районы Баку — запасной путь, когда геолокацию не дали.
///
/// Человек, отказавшийся от доступа к местоположению, не должен остаться
/// с пустым экраном: он выбирает свой район и видит магазины рядом.
///
/// Список — административные районы Баку. Названия на азербайджанском:
/// именно так они написаны на вывесках и в адресах, и переводить их незачем.
const List<String> bakuDistricts = [
  'Binəqədi',
  'Xətai',
  'Xəzər',
  'Qaradağ',
  'Nərimanov',
  'Nəsimi',
  'Nizami',
  'Pirallahı',
  'Sabunçu',
  'Səbail',
  'Suraxanı',
  'Yasamal',
];

/// Относится ли магазин к району.
///
/// Сопоставление идёт по адресу, а если его нет — по названию: у сетей в
/// названии точки часто зашит ориентир («Bravo Ekspress Hovsan»). Сравнение
/// через [normalizeAz], иначе «Xətai» не найдётся в «Xetai» и наоборот.
bool storeInDistrict({
  required String district,
  String? address,
  required String name,
}) {
  final needle = normalizeAz(district);
  final haystack = normalizeAz('${address ?? ''} $name');
  return haystack.contains(needle);
}

/// Районы, для которых в списке магазинов вообще что-то нашлось.
///
/// Показывать чипы районов, ни один из которых ничего не отфильтрует, хуже
/// чем не показывать их вовсе: пользователь потыкает и решит, что приложение
/// сломано. Если данных об адресах нет, вернётся пустой список, и экран
/// покажет магазины без фильтра.
Set<String> districtsWithStores(
  Iterable<({String name, String? address})> stores,
) {
  final found = <String>{};
  for (final district in bakuDistricts) {
    final has = stores.any(
      (s) =>
          storeInDistrict(district: district, address: s.address, name: s.name),
    );
    if (has) found.add(district);
  }
  return found;
}
