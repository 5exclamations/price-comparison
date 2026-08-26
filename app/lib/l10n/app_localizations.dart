import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_az.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('az'),
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In az, this message translates to:
  /// **'qiymət'**
  String get appTitle;

  /// No description provided for @tabSearch.
  ///
  /// In az, this message translates to:
  /// **'Axtarış'**
  String get tabSearch;

  /// No description provided for @tabDeals.
  ///
  /// In az, this message translates to:
  /// **'Endirimlər'**
  String get tabDeals;

  /// No description provided for @tabList.
  ///
  /// In az, this message translates to:
  /// **'Siyahı'**
  String get tabList;

  /// No description provided for @tabSettings.
  ///
  /// In az, this message translates to:
  /// **'Tənzimləmələr'**
  String get tabSettings;

  /// No description provided for @searchTitle.
  ///
  /// In az, this message translates to:
  /// **'Axtarış'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In az, this message translates to:
  /// **'Məhsul adı və ya barkod'**
  String get searchHint;

  /// No description provided for @searchPrompt.
  ///
  /// In az, this message translates to:
  /// **'Məhsulun adını yazın və ya barkodu daxil edin'**
  String get searchPrompt;

  /// No description provided for @searchEmpty.
  ///
  /// In az, this message translates to:
  /// **'Heç nə tapılmadı'**
  String get searchEmpty;

  /// No description provided for @chainsCount.
  ///
  /// In az, this message translates to:
  /// **'{count, plural, one{{count} şəbəkədə} other{{count} şəbəkədə}}'**
  String chainsCount(int count);

  /// No description provided for @needsStoreSelection.
  ///
  /// In az, this message translates to:
  /// **'Qiyməti görmək üçün mağaza seçin'**
  String get needsStoreSelection;

  /// No description provided for @chooseStore.
  ///
  /// In az, this message translates to:
  /// **'Mağaza seçin'**
  String get chooseStore;

  /// No description provided for @productTitle.
  ///
  /// In az, this message translates to:
  /// **'Məhsul'**
  String get productTitle;

  /// No description provided for @productNotFound.
  ///
  /// In az, this message translates to:
  /// **'Məhsul tapılmadı'**
  String get productNotFound;

  /// No description provided for @observedAt.
  ///
  /// In az, this message translates to:
  /// **'{time} tarixində yoxlanılıb'**
  String observedAt(String time);

  /// No description provided for @dealsTitle.
  ///
  /// In az, this message translates to:
  /// **'Endirimlər'**
  String get dealsTitle;

  /// No description provided for @dealsEmpty.
  ///
  /// In az, this message translates to:
  /// **'Hələlik endirim yoxdur'**
  String get dealsEmpty;

  /// No description provided for @realDiscount.
  ///
  /// In az, this message translates to:
  /// **'Bazardan {percent}% ucuz'**
  String realDiscount(int percent);

  /// No description provided for @inflatedWarning.
  ///
  /// In az, this message translates to:
  /// **'Endirim şişirdilib'**
  String get inflatedWarning;

  /// No description provided for @listTitle.
  ///
  /// In az, this message translates to:
  /// **'Siyahı'**
  String get listTitle;

  /// No description provided for @listEmpty.
  ///
  /// In az, this message translates to:
  /// **'Siyahı boşdur. Məhsul əlavə edin — biz qiyməti izləyəcəyik'**
  String get listEmpty;

  /// No description provided for @settingsTitle.
  ///
  /// In az, this message translates to:
  /// **'Tənzimləmələr'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In az, this message translates to:
  /// **'Dil'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In az, this message translates to:
  /// **'Görünüş'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In az, this message translates to:
  /// **'Sistemə uyğun'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In az, this message translates to:
  /// **'İşıqlı'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In az, this message translates to:
  /// **'Qaranlıq'**
  String get themeDark;

  /// No description provided for @errorGeneric.
  ///
  /// In az, this message translates to:
  /// **'Nəsə alınmadı. Bir azdan yenidən cəhd edin'**
  String get errorGeneric;

  /// No description provided for @storePickerTitle.
  ///
  /// In az, this message translates to:
  /// **'Hara gedirsiniz?'**
  String get storePickerTitle;

  /// No description provided for @storePickerWhy.
  ///
  /// In az, this message translates to:
  /// **'Qiymətlər təkcə şəbəkələr arasında yox, eyni şəbəkənin mağazaları arasında da fərqlənir. Sizə yad qiymət göstərməmək üçün öz mağazalarınızı seçin.'**
  String get storePickerWhy;

  /// No description provided for @useMyLocation.
  ///
  /// In az, this message translates to:
  /// **'Yerimi təyin et'**
  String get useMyLocation;

  /// No description provided for @locationWhyTitle.
  ///
  /// In az, this message translates to:
  /// **'Yeriniz nə üçün lazımdır'**
  String get locationWhyTitle;

  /// No description provided for @locationWhyBody.
  ///
  /// In az, this message translates to:
  /// **'Yaxın mağazaları göstərmək üçün. Koordinatlar cihazdan kənara çıxmır və saxlanılmır. İcazə verməsəniz, siyahıdan özünüz seçə bilərsiniz.'**
  String get locationWhyBody;

  /// No description provided for @locationAllow.
  ///
  /// In az, this message translates to:
  /// **'İcazə ver'**
  String get locationAllow;

  /// No description provided for @locationDenied.
  ///
  /// In az, this message translates to:
  /// **'İcazə verilmədi. Aşağıdan rayonu və mağazanı özünüz seçin.'**
  String get locationDenied;

  /// No description provided for @locationDeniedForever.
  ///
  /// In az, this message translates to:
  /// **'İcazə həmişəlik bağlanıb. Tənzimləmələrdən aça bilərsiniz.'**
  String get locationDeniedForever;

  /// No description provided for @locationServiceOff.
  ///
  /// In az, this message translates to:
  /// **'Cihazda yer təyini söndürülüb. Onu açın və ya mağazanı özünüz seçin.'**
  String get locationServiceOff;

  /// No description provided for @locationFailed.
  ///
  /// In az, this message translates to:
  /// **'Yeri təyin etmək alınmadı. Mağazanı siyahıdan seçin.'**
  String get locationFailed;

  /// No description provided for @locationFound.
  ///
  /// In az, this message translates to:
  /// **'Yer təyin edildi'**
  String get locationFound;

  /// No description provided for @openSettings.
  ///
  /// In az, this message translates to:
  /// **'Tənzimləmələri aç'**
  String get openSettings;

  /// No description provided for @district.
  ///
  /// In az, this message translates to:
  /// **'Rayon'**
  String get district;

  /// No description provided for @allDistricts.
  ///
  /// In az, this message translates to:
  /// **'Hamısı'**
  String get allDistricts;

  /// No description provided for @samePriceEverywhere.
  ///
  /// In az, this message translates to:
  /// **'Bütün mağazalarda eyni qiymət'**
  String get samePriceEverywhere;

  /// No description provided for @pricesDifferBetweenStores.
  ///
  /// In az, this message translates to:
  /// **'Mağazalar arasında qiymət fərqlənir — öz mağazanızı seçin'**
  String get pricesDifferBetweenStores;

  /// No description provided for @pickYourStoreRequired.
  ///
  /// In az, this message translates to:
  /// **'Mağazanı seçin — qiymət ondan asılıdır'**
  String get pickYourStoreRequired;

  /// No description provided for @pickAtLeastOneChain.
  ///
  /// In az, this message translates to:
  /// **'Ən azı bir şəbəkə seçin'**
  String get pickAtLeastOneChain;

  /// No description provided for @pickStoreToContinue.
  ///
  /// In az, this message translates to:
  /// **'Seçdiyiniz şəbəkə üçün mağazanı da seçin'**
  String get pickStoreToContinue;

  /// No description provided for @pickStoreForChains.
  ///
  /// In az, this message translates to:
  /// **'{chains} üçün mağaza seçin — qiymət mağazadan asılıdır'**
  String pickStoreForChains(String chains);

  /// No description provided for @continueLabel.
  ///
  /// In az, this message translates to:
  /// **'Davam et'**
  String get continueLabel;

  /// No description provided for @save.
  ///
  /// In az, this message translates to:
  /// **'Yadda saxla'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In az, this message translates to:
  /// **'İmtina'**
  String get cancel;

  /// No description provided for @retry.
  ///
  /// In az, this message translates to:
  /// **'Yenidən'**
  String get retry;

  /// No description provided for @changeLaterInSettings.
  ///
  /// In az, this message translates to:
  /// **'Sonra tənzimləmələrdən dəyişə bilərsiniz'**
  String get changeLaterInSettings;

  /// No description provided for @settingsStores.
  ///
  /// In az, this message translates to:
  /// **'Mənim mağazalarım'**
  String get settingsStores;

  /// No description provided for @storesNotPicked.
  ///
  /// In az, this message translates to:
  /// **'Mağaza seçilməyib'**
  String get storesNotPicked;

  /// No description provided for @chainsPicked.
  ///
  /// In az, this message translates to:
  /// **'{count, plural, one{{count} şəbəkə} other{{count} şəbəkə}}'**
  String chainsPicked(int count);

  /// No description provided for @storeChangeInvalidatesPrices.
  ///
  /// In az, this message translates to:
  /// **'Mağazanı dəyişsəniz, qiymətlər yenidən yüklənəcək'**
  String get storeChangeInvalidatesPrices;

  /// No description provided for @clear.
  ///
  /// In az, this message translates to:
  /// **'Təmizlə'**
  String get clear;

  /// No description provided for @scanTitle.
  ///
  /// In az, this message translates to:
  /// **'Barkodu skan et'**
  String get scanTitle;

  /// No description provided for @scanHint.
  ///
  /// In az, this message translates to:
  /// **'Barkodu çərçivəyə tutun'**
  String get scanHint;

  /// No description provided for @scanNotFound.
  ///
  /// In az, this message translates to:
  /// **'{code} bazamızda yoxdur. Başqa məhsul yoxlayın'**
  String scanNotFound(String code);

  /// No description provided for @searchTooShort.
  ///
  /// In az, this message translates to:
  /// **'Ən azı {count} hərf yazın'**
  String searchTooShort(int count);

  /// No description provided for @popularQueries.
  ///
  /// In az, this message translates to:
  /// **'Tez-tez axtarılanlar'**
  String get popularQueries;

  /// No description provided for @promoBadge.
  ///
  /// In az, this message translates to:
  /// **'Endirim'**
  String get promoBadge;

  /// No description provided for @offlineDataFrom.
  ///
  /// In az, this message translates to:
  /// **'İnternet yoxdur. Məlumatlar {time} tarixindəndir'**
  String offlineDataFrom(String time);

  /// No description provided for @pricePerKilogram.
  ///
  /// In az, this message translates to:
  /// **'1 kq-ın qiyməti'**
  String get pricePerKilogram;

  /// No description provided for @perKilogramExplained.
  ///
  /// In az, this message translates to:
  /// **'Bu çəki ilə satılan məhsuldur: qiymət 1 kiloqrama görədir, paketə görə yox.'**
  String get perKilogramExplained;

  /// No description provided for @priceHistory.
  ///
  /// In az, this message translates to:
  /// **'Qiymət tarixçəsi'**
  String get priceHistory;

  /// No description provided for @historyTooShort.
  ///
  /// In az, this message translates to:
  /// **'Tarixçə hələ azdır. Bir neçə gündən sonra qrafik görünəcək'**
  String get historyTooShort;

  /// No description provided for @historyUnavailable.
  ///
  /// In az, this message translates to:
  /// **'Tarixçəni yükləmək alınmadı'**
  String get historyUnavailable;

  /// No description provided for @watchPrice.
  ///
  /// In az, this message translates to:
  /// **'Qiyməti izlə'**
  String get watchPrice;

  /// No description provided for @watching.
  ///
  /// In az, this message translates to:
  /// **'İzlənilir'**
  String get watching;

  /// No description provided for @watchStart.
  ///
  /// In az, this message translates to:
  /// **'İzləməyə başla'**
  String get watchStart;

  /// No description provided for @watchExplained.
  ///
  /// In az, this message translates to:
  /// **'Qiymət ən azı 5% düşəndə bildiriş göndərəcəyik. İstəsəniz, öz hədəf qiymətinizi də yaza bilərsiniz.'**
  String get watchExplained;

  /// No description provided for @currentBestPrice.
  ///
  /// In az, this message translates to:
  /// **'İndiki ən yaxşı qiymət'**
  String get currentBestPrice;

  /// No description provided for @targetPriceOptional.
  ///
  /// In az, this message translates to:
  /// **'Hədəf qiymət (vacib deyil)'**
  String get targetPriceOptional;

  /// No description provided for @targetPriceHint.
  ///
  /// In az, this message translates to:
  /// **'məsələn, 13,99'**
  String get targetPriceHint;

  /// No description provided for @targetPriceInvalid.
  ///
  /// In az, this message translates to:
  /// **'Qiyməti düzgün yazın: 13,99'**
  String get targetPriceInvalid;

  /// No description provided for @addToList.
  ///
  /// In az, this message translates to:
  /// **'Siyahıya əlavə et'**
  String get addToList;

  /// No description provided for @inList.
  ///
  /// In az, this message translates to:
  /// **'Siyahıdadır'**
  String get inList;

  /// No description provided for @filters.
  ///
  /// In az, this message translates to:
  /// **'Süzgəclər'**
  String get filters;

  /// No description provided for @filtersReset.
  ///
  /// In az, this message translates to:
  /// **'Sıfırla'**
  String get filtersReset;

  /// No description provided for @filtersApply.
  ///
  /// In az, this message translates to:
  /// **'Göstər'**
  String get filtersApply;

  /// No description provided for @filterAny.
  ///
  /// In az, this message translates to:
  /// **'Hamısı'**
  String get filterAny;

  /// No description provided for @filterMinDiscount.
  ///
  /// In az, this message translates to:
  /// **'Ən azı endirim'**
  String get filterMinDiscount;

  /// No description provided for @filterMyChainsOnly.
  ///
  /// In az, this message translates to:
  /// **'Yalnız mənim şəbəkələrim'**
  String get filterMyChainsOnly;

  /// No description provided for @filterCategory.
  ///
  /// In az, this message translates to:
  /// **'Kateqoriya'**
  String get filterCategory;

  /// No description provided for @dealsEmptyFiltered.
  ///
  /// In az, this message translates to:
  /// **'Bu süzgəclərlə endirim tapılmadı'**
  String get dealsEmptyFiltered;

  /// No description provided for @dealsEnd.
  ///
  /// In az, this message translates to:
  /// **'Hamısı budur'**
  String get dealsEnd;

  /// No description provided for @loadMoreFailed.
  ///
  /// In az, this message translates to:
  /// **'Davamını yükləmək alınmadı'**
  String get loadMoreFailed;

  /// No description provided for @aboveMarket.
  ///
  /// In az, this message translates to:
  /// **'Bazardan {percent}% baha'**
  String aboveMarket(int percent);

  /// No description provided for @marketExplainTitle.
  ///
  /// In az, this message translates to:
  /// **'«Bazardan ucuz» nə deməkdir'**
  String get marketExplainTitle;

  /// No description provided for @marketExplainBody.
  ///
  /// In az, this message translates to:
  /// **'Bazar — eyni barkodlu məhsulun DİGƏR şəbəkələrdəki adi, endirimsiz qiymətlərinin medianı. Bu hesablamada {count} belə qiymət iştirak edib. Şəbəkənin öz üstündən xətt çəkdiyi qiymətə görə yox, məhz bazara görə sayırıq.'**
  String marketExplainBody(int count);

  /// No description provided for @marketExplainNow.
  ///
  /// In az, this message translates to:
  /// **'İndi'**
  String get marketExplainNow;

  /// No description provided for @marketExplainClaimed.
  ///
  /// In az, this message translates to:
  /// **'Şəbəkə deyir'**
  String get marketExplainClaimed;

  /// No description provided for @marketExplainMarket.
  ///
  /// In az, this message translates to:
  /// **'Bazar'**
  String get marketExplainMarket;

  /// No description provided for @inflatedExplained.
  ///
  /// In az, this message translates to:
  /// **'Elan edilən endirim həqiqidən {points} bənd dərindir. Yəni köhnə qiymət şişirdilib.'**
  String inflatedExplained(int points);

  /// No description provided for @share.
  ///
  /// In az, this message translates to:
  /// **'Paylaş'**
  String get share;

  /// No description provided for @shareFailed.
  ///
  /// In az, this message translates to:
  /// **'Şəkil hazırlanmadı'**
  String get shareFailed;

  /// No description provided for @shareText.
  ///
  /// In az, this message translates to:
  /// **'{name} — {price} {chain}-da, bazardan {percent}% ucuz. qiymət ilə tapdım.'**
  String shareText(String name, String price, String chain, int percent);

  /// No description provided for @basketTotalTitle.
  ///
  /// In az, this message translates to:
  /// **'{count, plural, one{{count} məhsul üçün yekun} other{{count} məhsul üçün yekun}}'**
  String basketTotalTitle(int count);

  /// No description provided for @basketSplitInto.
  ///
  /// In az, this message translates to:
  /// **'{count, plural, one{{count} mağazaya bölsəniz} other{{count} mağazaya bölsəniz}}'**
  String basketSplitInto(int count);

  /// No description provided for @basketSaves.
  ///
  /// In az, this message translates to:
  /// **'qənaət {amount}'**
  String basketSaves(String amount);

  /// No description provided for @basketSplitDisclaimer.
  ///
  /// In az, this message translates to:
  /// **'Adətən bölmək az qazandırır. İkinci mağazaya getməyə dəyərmi — özünüz qərar verin.'**
  String get basketSplitDisclaimer;

  /// No description provided for @basketOtherChains.
  ///
  /// In az, this message translates to:
  /// **'Digər şəbəkələr'**
  String get basketOtherChains;

  /// No description provided for @basketMissingItems.
  ///
  /// In az, this message translates to:
  /// **'{count, plural, one{{count} məhsul yoxdur} other{{count} məhsul yoxdur}}'**
  String basketMissingItems(int count);

  /// No description provided for @basketNoCompleteChain.
  ///
  /// In az, this message translates to:
  /// **'Heç bir şəbəkə siyahını tam bağlamır — bölmək lazım gələcək'**
  String get basketNoCompleteChain;

  /// No description provided for @basketNoPricesYet.
  ///
  /// In az, this message translates to:
  /// **'Qiymətlər hələ yüklənməyib. İnternet olanda yenilənəcək'**
  String get basketNoPricesYet;

  /// No description provided for @basketOnlyManual.
  ///
  /// In az, this message translates to:
  /// **'Əl ilə yazılan sətirlərin qiyməti olmur'**
  String get basketOnlyManual;

  /// No description provided for @basketManualExcluded.
  ///
  /// In az, this message translates to:
  /// **'{count, plural, one{{count} sətir əl ilə yazılıb} other{{count} sətir əl ilə yazılıb}}'**
  String basketManualExcluded(int count);

  /// No description provided for @basketUnpricedExcluded.
  ///
  /// In az, this message translates to:
  /// **'{count, plural, one{{count} məhsulun qiyməti yoxdur} other{{count} məhsulun qiyməti yoxdur}}'**
  String basketUnpricedExcluded(int count);

  /// No description provided for @basketManualItem.
  ///
  /// In az, this message translates to:
  /// **'əl ilə yazılıb'**
  String get basketManualItem;

  /// No description provided for @basketNoPrice.
  ///
  /// In az, this message translates to:
  /// **'seçdiyiniz şəbəkələrdə yoxdur'**
  String get basketNoPrice;

  /// No description provided for @basketAddManual.
  ///
  /// In az, this message translates to:
  /// **'Əl ilə əlavə et'**
  String get basketAddManual;

  /// No description provided for @basketAddManualHint.
  ///
  /// In az, this message translates to:
  /// **'məsələn, çörək'**
  String get basketAddManualHint;

  /// No description provided for @basketAdd.
  ///
  /// In az, this message translates to:
  /// **'Əlavə et'**
  String get basketAdd;

  /// No description provided for @basketRefreshPrices.
  ///
  /// In az, this message translates to:
  /// **'Qiymətləri yenilə'**
  String get basketRefreshPrices;

  /// No description provided for @basketPricesOffline.
  ///
  /// In az, this message translates to:
  /// **'İnternet yoxdur. Köhnə qiymətlər göstərilir'**
  String get basketPricesOffline;

  /// No description provided for @consentTitle.
  ///
  /// In az, this message translates to:
  /// **'Çeklərin emalına razılıq'**
  String get consentTitle;

  /// No description provided for @consentAgree.
  ///
  /// In az, this message translates to:
  /// **'Razıyam'**
  String get consentAgree;

  /// No description provided for @consentDecline.
  ///
  /// In az, this message translates to:
  /// **'İndi yox'**
  String get consentDecline;

  /// No description provided for @consentScrollToEnd.
  ///
  /// In az, this message translates to:
  /// **'Razılaşmaq üçün mətni sonadək oxuyun'**
  String get consentScrollToEnd;

  /// No description provided for @consentRevokeTitle.
  ///
  /// In az, this message translates to:
  /// **'Razılığı geri götür'**
  String get consentRevokeTitle;

  /// No description provided for @consentRevokeSubtitle.
  ///
  /// In az, this message translates to:
  /// **'Bütün çekləriniz silinəcək'**
  String get consentRevokeSubtitle;

  /// No description provided for @consentRevokeBody.
  ///
  /// In az, this message translates to:
  /// **'Razılığı geri götürsəniz, bütün çekləriniz silinir və toplanan ballar sıfırlanır. Şəxssizləşdirilmiş qiymətlər statistikada qalır — razılıq mətnində bu barədə yazılıb.'**
  String get consentRevokeBody;

  /// No description provided for @consentRevokeConfirm.
  ///
  /// In az, this message translates to:
  /// **'Geri götür və sil'**
  String get consentRevokeConfirm;

  /// No description provided for @receiptScanTitle.
  ///
  /// In az, this message translates to:
  /// **'Çeki skan et'**
  String get receiptScanTitle;

  /// No description provided for @receiptScanHint.
  ///
  /// In az, this message translates to:
  /// **'Çekdəki QR kodu çərçivəyə tutun'**
  String get receiptScanHint;

  /// No description provided for @receiptFailed.
  ///
  /// In az, this message translates to:
  /// **'Çeki oxumaq alınmadı. Başqa çek yoxlayın'**
  String get receiptFailed;

  /// No description provided for @receiptsTitle.
  ///
  /// In az, this message translates to:
  /// **'Çeklərim'**
  String get receiptsTitle;

  /// No description provided for @receiptsEmpty.
  ///
  /// In az, this message translates to:
  /// **'Hələ çek yoxdur'**
  String get receiptsEmpty;

  /// No description provided for @receiptsWhy.
  ///
  /// In az, this message translates to:
  /// **'Kassadakı qiymət vitrindəkindən dəqiqdir. Çekiniz bizim çata bilmədiyimiz mağazaların qiymətlərini açır.'**
  String get receiptsWhy;

  /// No description provided for @receiptUnknownStore.
  ///
  /// In az, this message translates to:
  /// **'Naməlum mağaza'**
  String get receiptUnknownStore;

  /// No description provided for @receiptsUploaded.
  ///
  /// In az, this message translates to:
  /// **'{count, plural, one{{count} çek} other{{count} çek}}'**
  String receiptsUploaded(int count);

  /// No description provided for @pointsTitle.
  ///
  /// In az, this message translates to:
  /// **'Ballarınız'**
  String get pointsTitle;

  /// No description provided for @dataRefreshingTitle.
  ///
  /// In az, this message translates to:
  /// **'Məlumatlar yenilənir'**
  String get dataRefreshingTitle;

  /// No description provided for @dataRefreshingBody.
  ///
  /// In az, this message translates to:
  /// **'Bəzi qiymətlər hələ yoxlanılmayıb. Bir azdan yenidən baxın'**
  String get dataRefreshingBody;

  /// No description provided for @catalogTitle.
  ///
  /// In az, this message translates to:
  /// **'Kataloq'**
  String get catalogTitle;

  /// No description provided for @catalogOpen.
  ///
  /// In az, this message translates to:
  /// **'Mağazanın kataloquna baxın'**
  String get catalogOpen;

  /// No description provided for @catalogAllCategories.
  ///
  /// In az, this message translates to:
  /// **'Hamısı'**
  String get catalogAllCategories;

  /// No description provided for @catalogEmpty.
  ///
  /// In az, this message translates to:
  /// **'Bu bölmədə məhsul yoxdur'**
  String get catalogEmpty;

  /// No description provided for @catalogPickStore.
  ///
  /// In az, this message translates to:
  /// **'Mağaza seçin'**
  String get catalogPickStore;

  /// No description provided for @catalogAllStores.
  ///
  /// In az, this message translates to:
  /// **'Bütün mağazalar'**
  String get catalogAllStores;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['az', 'en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'az':
      return AppLocalizationsAz();
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
