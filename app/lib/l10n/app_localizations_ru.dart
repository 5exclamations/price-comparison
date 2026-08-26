// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'qiymət';

  @override
  String get tabSearch => 'Поиск';

  @override
  String get tabDeals => 'Выгоды';

  @override
  String get tabList => 'Список';

  @override
  String get tabSettings => 'Настройки';

  @override
  String get searchTitle => 'Поиск';

  @override
  String get searchHint => 'Название товара или штрихкод';

  @override
  String get searchPrompt =>
      'Введите название товара или отсканируйте штрихкод';

  @override
  String get searchEmpty => 'Ничего не нашлось';

  @override
  String chainsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'в $count сетях',
      many: 'в $count сетях',
      few: 'в $count сетях',
      one: 'в $count сети',
    );
    return '$_temp0';
  }

  @override
  String get needsStoreSelection => 'Выберите магазин, чтобы увидеть цену';

  @override
  String get chooseStore => 'Выберите магазин';

  @override
  String get productTitle => 'Товар';

  @override
  String get productNotFound => 'Товар не найден';

  @override
  String observedAt(String time) {
    return 'проверено $time';
  }

  @override
  String get dealsTitle => 'Выгоды';

  @override
  String get dealsEmpty => 'Пока нет акций';

  @override
  String realDiscount(int percent) {
    return 'Дешевле рынка на $percent%';
  }

  @override
  String get inflatedWarning => 'Скидка накручена';

  @override
  String get listTitle => 'Список';

  @override
  String get listEmpty =>
      'Список пуст. Добавьте товар — будем следить за ценой';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsTheme => 'Оформление';

  @override
  String get themeSystem => 'Как в системе';

  @override
  String get themeLight => 'Светлое';

  @override
  String get themeDark => 'Тёмное';

  @override
  String get errorGeneric => 'Что-то не получилось. Попробуйте ещё раз';

  @override
  String get storePickerTitle => 'Куда вы ходите?';

  @override
  String get storePickerWhy =>
      'Цены отличаются не только между сетями, но и между магазинами одной сети. Чтобы не показывать вам чужие цены, выберите свои магазины.';

  @override
  String get useMyLocation => 'Определить по геолокации';

  @override
  String get locationWhyTitle => 'Зачем нужно ваше местоположение';

  @override
  String get locationWhyBody =>
      'Чтобы показать магазины рядом с вами. Координаты не уходят с устройства и не сохраняются. Если не дадите доступ, выберете магазин из списка сами.';

  @override
  String get locationAllow => 'Разрешить';

  @override
  String get locationDenied =>
      'Доступ не дали — ничего страшного. Выберите район и магазин ниже.';

  @override
  String get locationDeniedForever =>
      'Доступ запрещён насовсем. Его можно вернуть в настройках телефона.';

  @override
  String get locationServiceOff =>
      'Геолокация выключена на устройстве. Включите её или выберите магазин сами.';

  @override
  String get locationFailed =>
      'Не удалось определить местоположение. Выберите магазин из списка.';

  @override
  String get locationFound => 'Местоположение определено';

  @override
  String get openSettings => 'Открыть настройки';

  @override
  String get district => 'Район';

  @override
  String get allDistricts => 'Все';

  @override
  String get samePriceEverywhere => 'Во всех магазинах одна цена';

  @override
  String get pricesDifferBetweenStores =>
      'Цены отличаются между магазинами — выберите свой';

  @override
  String get pickYourStoreRequired => 'Выберите магазин — от него зависит цена';

  @override
  String get pickAtLeastOneChain => 'Выберите хотя бы одну сеть';

  @override
  String get pickStoreToContinue => 'Выберите магазин у отмеченной сети';

  @override
  String pickStoreForChains(String chains) {
    return 'Выберите магазин для $chains — от него зависит цена';
  }

  @override
  String get continueLabel => 'Продолжить';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get retry => 'Повторить';

  @override
  String get changeLaterInSettings => 'Поменять можно в настройках';

  @override
  String get settingsStores => 'Мои магазины';

  @override
  String get storesNotPicked => 'Магазины не выбраны';

  @override
  String chainsPicked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сети',
      many: '$count сетей',
      few: '$count сети',
      one: '$count сеть',
    );
    return '$_temp0';
  }

  @override
  String get storeChangeInvalidatesPrices =>
      'Если поменять магазин, цены загрузятся заново';

  @override
  String get clear => 'Очистить';

  @override
  String get scanTitle => 'Сканировать штрихкод';

  @override
  String get scanHint => 'Наведите штрихкод в рамку';

  @override
  String scanNotFound(String code) {
    return '$code нет в нашей базе. Попробуйте другой товар';
  }

  @override
  String searchTooShort(int count) {
    return 'Введите хотя бы $count буквы';
  }

  @override
  String get popularQueries => 'Что ищут чаще всего';

  @override
  String get promoBadge => 'Акция';

  @override
  String offlineDataFrom(String time) {
    return 'Нет интернета. Данные от $time';
  }

  @override
  String get pricePerKilogram => 'цена за 1 кг';

  @override
  String get perKilogramExplained =>
      'Это весовой товар: цена указана за 1 килограмм, а не за упаковку.';

  @override
  String get priceHistory => 'История цены';

  @override
  String get historyTooShort =>
      'Истории пока мало. График появится через несколько дней наблюдений';

  @override
  String get historyUnavailable => 'Не удалось загрузить историю';

  @override
  String get watchPrice => 'Следить за ценой';

  @override
  String get watching => 'Следим';

  @override
  String get watchStart => 'Следить';

  @override
  String get watchExplained =>
      'Пришлём уведомление, когда цена упадёт хотя бы на 5%. Можно указать свою цель.';

  @override
  String get currentBestPrice => 'Сейчас лучшая цена';

  @override
  String get targetPriceOptional => 'Целевая цена (необязательно)';

  @override
  String get targetPriceHint => 'например, 13,99';

  @override
  String get targetPriceInvalid => 'Введите цену вида 13,99';

  @override
  String get addToList => 'Добавить в список';

  @override
  String get inList => 'В списке';

  @override
  String get filters => 'Фильтры';

  @override
  String get filtersReset => 'Сбросить';

  @override
  String get filtersApply => 'Показать';

  @override
  String get filterAny => 'Любая';

  @override
  String get filterMinDiscount => 'Скидка не меньше';

  @override
  String get filterMyChainsOnly => 'Только мои сети';

  @override
  String get filterCategory => 'Категория';

  @override
  String get dealsEmptyFiltered => 'С этими фильтрами акций нет';

  @override
  String get dealsEnd => 'Это все акции';

  @override
  String get loadMoreFailed => 'Не удалось загрузить продолжение';

  @override
  String aboveMarket(int percent) {
    return 'Дороже рынка на $percent%';
  }

  @override
  String get marketExplainTitle => 'Что значит «дешевле рынка»';

  @override
  String marketExplainBody(int count) {
    return 'Рынок — это медиана обычных, неакционных цен на товар с тем же штрихкодом в ДРУГИХ сетях. В этом расчёте участвовало $count таких цен. Считаем именно от рынка, а не от зачёркнутой цены, которую сеть рисует сама.';
  }

  @override
  String get marketExplainNow => 'Сейчас';

  @override
  String get marketExplainClaimed => 'Сеть заявляет';

  @override
  String get marketExplainMarket => 'Рынок';

  @override
  String inflatedExplained(int points) {
    return 'Заявленная скидка глубже настоящей на $points пунктов. Значит, старая цена накручена.';
  }

  @override
  String get share => 'Поделиться';

  @override
  String get shareFailed => 'Не получилось сделать картинку';

  @override
  String shareText(String name, String price, String chain, int percent) {
    return '$name — $price в $chain, дешевле рынка на $percent%. Нашёл в qiymət.';
  }

  @override
  String basketTotalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Итог по $count товарам',
      many: 'Итог по $count товарам',
      few: 'Итог по $count товарам',
      one: 'Итог по $count товару',
    );
    return '$_temp0';
  }

  @override
  String basketSplitInto(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'если разбить на $count сети',
      many: 'если разбить на $count сетей',
      few: 'если разбить на $count сети',
      one: 'если разбить на $count сеть',
    );
    return '$_temp0';
  }

  @override
  String basketSaves(String amount) {
    return 'экономия $amount';
  }

  @override
  String get basketSplitDisclaimer =>
      'Обычно разбиение экономит немного. Стоит ли второй магазин этих денег — решать вам.';

  @override
  String get basketOtherChains => 'Остальные сети';

  @override
  String basketMissingItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'нет $count товаров',
      many: 'нет $count товаров',
      few: 'нет $count товаров',
      one: 'нет $count товара',
    );
    return '$_temp0';
  }

  @override
  String get basketNoCompleteChain =>
      'Ни одна сеть не закрывает список целиком — придётся разбивать';

  @override
  String get basketNoPricesYet =>
      'Цены ещё не загружены. Обновятся, когда появится связь';

  @override
  String get basketOnlyManual => 'У строк, добавленных вручную, цены нет';

  @override
  String basketManualExcluded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count строки добавлены вручную',
      many: '$count строк добавлены вручную',
      few: '$count строки добавлены вручную',
      one: '$count строка добавлена вручную',
    );
    return '$_temp0';
  }

  @override
  String basketUnpricedExcluded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'у $count товаров нет цены',
      many: 'у $count товаров нет цены',
      few: 'у $count товаров нет цены',
      one: 'у $count товара нет цены',
    );
    return '$_temp0';
  }

  @override
  String get basketManualItem => 'добавлено вручную';

  @override
  String get basketNoPrice => 'нет в выбранных сетях';

  @override
  String get basketAddManual => 'Добавить вручную';

  @override
  String get basketAddManualHint => 'например, хлеб';

  @override
  String get basketAdd => 'Добавить';

  @override
  String get basketRefreshPrices => 'Обновить цены';

  @override
  String get basketPricesOffline => 'Нет связи. Показаны прежние цены';

  @override
  String get consentTitle => 'Согласие на обработку чеков';

  @override
  String get consentAgree => 'Согласен';

  @override
  String get consentDecline => 'Не сейчас';

  @override
  String get consentScrollToEnd =>
      'Дочитайте текст до конца, чтобы согласиться';

  @override
  String get consentRevokeTitle => 'Отозвать согласие';

  @override
  String get consentRevokeSubtitle => 'Все ваши чеки будут удалены';

  @override
  String get consentRevokeBody =>
      'Если отозвать согласие, все ваши чеки удаляются, а начисленные баллы обнуляются. Обезличенные цены остаются в статистике — об этом сказано в тексте согласия.';

  @override
  String get consentRevokeConfirm => 'Отозвать и удалить';

  @override
  String get receiptScanTitle => 'Сканировать чек';

  @override
  String get receiptScanHint => 'Наведите QR с чека в рамку';

  @override
  String get receiptFailed => 'Не удалось прочитать чек. Попробуйте другой';

  @override
  String get receiptsTitle => 'Мои чеки';

  @override
  String get receiptsEmpty => 'Чеков пока нет';

  @override
  String get receiptsWhy =>
      'Цена на кассе точнее цены на витрине. Ваш чек открывает цены магазинов, куда мы иначе не добираемся.';

  @override
  String get receiptUnknownStore => 'Неизвестный магазин';

  @override
  String receiptsUploaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count чека',
      many: '$count чеков',
      few: '$count чека',
      one: '$count чек',
    );
    return '$_temp0';
  }

  @override
  String get pointsTitle => 'Ваши баллы';

  @override
  String get dataRefreshingTitle => 'Данные обновляются';

  @override
  String get dataRefreshingBody =>
      'Часть цен ещё не проверена. Загляните чуть позже';

  @override
  String get catalogTitle => 'Каталог';

  @override
  String get catalogOpen => 'Посмотреть каталог магазина';

  @override
  String get catalogAllCategories => 'Все';

  @override
  String get catalogEmpty => 'В этом разделе товаров нет';

  @override
  String get catalogPickStore => 'Выберите магазин';

  @override
  String get catalogAllStores => 'Все магазины';
}
