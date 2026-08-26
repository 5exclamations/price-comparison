// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'qiymət';

  @override
  String get tabSearch => 'Search';

  @override
  String get tabDeals => 'Deals';

  @override
  String get tabList => 'List';

  @override
  String get tabSettings => 'Settings';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchHint => 'Product name or barcode';

  @override
  String get searchPrompt => 'Type a product name or scan a barcode';

  @override
  String get searchEmpty => 'Nothing found';

  @override
  String chainsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count chains',
      one: 'in $count chain',
    );
    return '$_temp0';
  }

  @override
  String get needsStoreSelection => 'Pick a store to see the price';

  @override
  String get chooseStore => 'Pick a store';

  @override
  String get productTitle => 'Product';

  @override
  String get productNotFound => 'Product not found';

  @override
  String observedAt(String time) {
    return 'checked $time';
  }

  @override
  String get dealsTitle => 'Deals';

  @override
  String get dealsEmpty => 'No deals yet';

  @override
  String realDiscount(int percent) {
    return '$percent% below market';
  }

  @override
  String get inflatedWarning => 'Inflated discount';

  @override
  String get listTitle => 'List';

  @override
  String get listEmpty =>
      'The list is empty. Add a product and we will watch its price';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Appearance';

  @override
  String get themeSystem => 'Follow system';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get errorGeneric => 'Something went wrong. Please try again';

  @override
  String get storePickerTitle => 'Where do you shop?';

  @override
  String get storePickerWhy =>
      'Prices differ not only between chains, but between stores of the same chain. Pick your stores so we never show you someone else\'s prices.';

  @override
  String get useMyLocation => 'Use my location';

  @override
  String get locationWhyTitle => 'Why we ask for your location';

  @override
  String get locationWhyBody =>
      'To show the stores near you. Coordinates never leave your device and are not stored. If you decline, you can pick a store from the list.';

  @override
  String get locationAllow => 'Allow';

  @override
  String get locationDenied =>
      'No access — that\'s fine. Pick your district and store below.';

  @override
  String get locationDeniedForever =>
      'Access is permanently denied. You can restore it in system settings.';

  @override
  String get locationServiceOff =>
      'Location is turned off on this device. Turn it on or pick a store yourself.';

  @override
  String get locationFailed =>
      'Could not determine your location. Pick a store from the list.';

  @override
  String get locationFound => 'Location found';

  @override
  String get openSettings => 'Open settings';

  @override
  String get district => 'District';

  @override
  String get allDistricts => 'All';

  @override
  String get samePriceEverywhere => 'Same price in every store';

  @override
  String get pricesDifferBetweenStores =>
      'Prices differ between stores — pick yours';

  @override
  String get pickYourStoreRequired => 'Pick a store — the price depends on it';

  @override
  String get pickAtLeastOneChain => 'Pick at least one chain';

  @override
  String get pickStoreToContinue => 'Pick a store for the chain you selected';

  @override
  String pickStoreForChains(String chains) {
    return 'Pick a store for $chains — the price depends on it';
  }

  @override
  String get continueLabel => 'Continue';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get retry => 'Retry';

  @override
  String get changeLaterInSettings => 'You can change this in settings';

  @override
  String get settingsStores => 'My stores';

  @override
  String get storesNotPicked => 'No stores picked';

  @override
  String chainsPicked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chains',
      one: '$count chain',
    );
    return '$_temp0';
  }

  @override
  String get storeChangeInvalidatesPrices =>
      'Changing the store reloads prices';

  @override
  String get clear => 'Clear';

  @override
  String get scanTitle => 'Scan barcode';

  @override
  String get scanHint => 'Point the barcode at the frame';

  @override
  String scanNotFound(String code) {
    return '$code is not in our database. Try another product';
  }

  @override
  String searchTooShort(int count) {
    return 'Type at least $count letters';
  }

  @override
  String get popularQueries => 'Most searched';

  @override
  String get promoBadge => 'Deal';

  @override
  String offlineDataFrom(String time) {
    return 'No internet. Data from $time';
  }

  @override
  String get pricePerKilogram => 'price per 1 kg';

  @override
  String get perKilogramExplained =>
      'This is sold by weight: the price is for 1 kilogram, not for a pack.';

  @override
  String get priceHistory => 'Price history';

  @override
  String get historyTooShort =>
      'Not enough history yet. The chart appears after a few days of readings';

  @override
  String get historyUnavailable => 'Could not load the history';

  @override
  String get watchPrice => 'Watch price';

  @override
  String get watching => 'Watching';

  @override
  String get watchStart => 'Watch';

  @override
  String get watchExplained =>
      'We will notify you when the price drops by at least 5%. You can set your own target.';

  @override
  String get currentBestPrice => 'Best price now';

  @override
  String get targetPriceOptional => 'Target price (optional)';

  @override
  String get targetPriceHint => 'for example, 13.99';

  @override
  String get targetPriceInvalid => 'Enter a price like 13.99';

  @override
  String get addToList => 'Add to list';

  @override
  String get inList => 'In the list';

  @override
  String get filters => 'Filters';

  @override
  String get filtersReset => 'Reset';

  @override
  String get filtersApply => 'Show';

  @override
  String get filterAny => 'Any';

  @override
  String get filterMinDiscount => 'Discount at least';

  @override
  String get filterMyChainsOnly => 'My chains only';

  @override
  String get filterCategory => 'Category';

  @override
  String get dealsEmptyFiltered => 'No deals match these filters';

  @override
  String get dealsEnd => 'That is all the deals';

  @override
  String get loadMoreFailed => 'Could not load more';

  @override
  String aboveMarket(int percent) {
    return '$percent% above market';
  }

  @override
  String get marketExplainTitle => 'What “below market” means';

  @override
  String marketExplainBody(int count) {
    return 'The market is the median of regular, non-promo prices for the same barcode in OTHER chains. $count such prices went into this number. We measure against the market, not against the struck-through price the chain draws itself.';
  }

  @override
  String get marketExplainNow => 'Now';

  @override
  String get marketExplainClaimed => 'The chain claims';

  @override
  String get marketExplainMarket => 'Market';

  @override
  String inflatedExplained(int points) {
    return 'The claimed discount is $points points deeper than the real one. The old price is inflated.';
  }

  @override
  String get share => 'Share';

  @override
  String get shareFailed => 'Could not create the image';

  @override
  String shareText(String name, String price, String chain, int percent) {
    return '$name — $price at $chain, $percent% below market. Found with qiymət.';
  }

  @override
  String basketTotalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Total for $count items',
      one: 'Total for $count item',
    );
    return '$_temp0';
  }

  @override
  String basketSplitInto(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'if split across $count stores',
      one: 'if split across $count store',
    );
    return '$_temp0';
  }

  @override
  String basketSaves(String amount) {
    return 'saves $amount';
  }

  @override
  String get basketSplitDisclaimer =>
      'Splitting usually saves little. Whether a second store is worth it is your call.';

  @override
  String get basketOtherChains => 'Other chains';

  @override
  String basketMissingItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items missing',
      one: '$count item missing',
    );
    return '$_temp0';
  }

  @override
  String get basketNoCompleteChain =>
      'No single chain covers the whole list — you will have to split';

  @override
  String get basketNoPricesYet =>
      'Prices are not loaded yet. They will refresh when you are online';

  @override
  String get basketOnlyManual => 'Items added by hand have no price';

  @override
  String basketManualExcluded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lines added by hand',
      one: '$count line added by hand',
    );
    return '$_temp0';
  }

  @override
  String basketUnpricedExcluded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items have no price',
      one: '$count item has no price',
    );
    return '$_temp0';
  }

  @override
  String get basketManualItem => 'added by hand';

  @override
  String get basketNoPrice => 'not in your chains';

  @override
  String get basketAddManual => 'Add by hand';

  @override
  String get basketAddManualHint => 'for example, bread';

  @override
  String get basketAdd => 'Add';

  @override
  String get basketRefreshPrices => 'Refresh prices';

  @override
  String get basketPricesOffline => 'No connection. Showing previous prices';

  @override
  String get consentTitle => 'Consent to receipt processing';

  @override
  String get consentAgree => 'I agree';

  @override
  String get consentDecline => 'Not now';

  @override
  String get consentScrollToEnd => 'Read to the end to agree';

  @override
  String get consentRevokeTitle => 'Withdraw consent';

  @override
  String get consentRevokeSubtitle => 'All your receipts will be deleted';

  @override
  String get consentRevokeBody =>
      'Withdrawing consent deletes all your receipts and zeroes your points. Anonymised prices stay in the statistics — the consent text says so.';

  @override
  String get consentRevokeConfirm => 'Withdraw and delete';

  @override
  String get receiptScanTitle => 'Scan receipt';

  @override
  String get receiptScanHint => 'Point the receipt QR at the frame';

  @override
  String get receiptFailed => 'Could not read the receipt. Try another one';

  @override
  String get receiptsTitle => 'My receipts';

  @override
  String get receiptsEmpty => 'No receipts yet';

  @override
  String get receiptsWhy =>
      'The price at the till is more accurate than a shelf listing. Your receipt opens up prices for shops we cannot otherwise reach.';

  @override
  String get receiptUnknownStore => 'Unknown shop';

  @override
  String receiptsUploaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count receipts',
      one: '$count receipt',
    );
    return '$_temp0';
  }

  @override
  String get pointsTitle => 'Your points';

  @override
  String get dataRefreshingTitle => 'Data is refreshing';

  @override
  String get dataRefreshingBody =>
      'Some prices are not verified yet. Check back shortly';

  @override
  String get catalogTitle => 'Catalogue';

  @override
  String get catalogOpen => 'Browse a store catalogue';

  @override
  String get catalogAllCategories => 'All';

  @override
  String get catalogEmpty => 'No products in this section';

  @override
  String get catalogPickStore => 'Pick a store';

  @override
  String get catalogAllStores => 'All stores';
}
