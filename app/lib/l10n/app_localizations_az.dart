// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Azerbaijani (`az`).
class AppLocalizationsAz extends AppLocalizations {
  AppLocalizationsAz([String locale = 'az']) : super(locale);

  @override
  String get appTitle => 'qiymət';

  @override
  String get tabSearch => 'Axtarış';

  @override
  String get tabDeals => 'Endirimlər';

  @override
  String get tabList => 'Siyahı';

  @override
  String get tabSettings => 'Tənzimləmələr';

  @override
  String get searchTitle => 'Axtarış';

  @override
  String get searchHint => 'Məhsul adı və ya barkod';

  @override
  String get searchPrompt => 'Məhsulun adını yazın və ya barkodu daxil edin';

  @override
  String get searchEmpty => 'Heç nə tapılmadı';

  @override
  String chainsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count şəbəkədə',
      one: '$count şəbəkədə',
    );
    return '$_temp0';
  }

  @override
  String get needsStoreSelection => 'Qiyməti görmək üçün mağaza seçin';

  @override
  String get chooseStore => 'Mağaza seçin';

  @override
  String get productTitle => 'Məhsul';

  @override
  String get productNotFound => 'Məhsul tapılmadı';

  @override
  String observedAt(String time) {
    return '$time tarixində yoxlanılıb';
  }

  @override
  String get dealsTitle => 'Endirimlər';

  @override
  String get dealsEmpty => 'Hələlik endirim yoxdur';

  @override
  String realDiscount(int percent) {
    return 'Bazardan $percent% ucuz';
  }

  @override
  String get inflatedWarning => 'Endirim şişirdilib';

  @override
  String get listTitle => 'Siyahı';

  @override
  String get listEmpty =>
      'Siyahı boşdur. Məhsul əlavə edin — biz qiyməti izləyəcəyik';

  @override
  String get settingsTitle => 'Tənzimləmələr';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsTheme => 'Görünüş';

  @override
  String get themeSystem => 'Sistemə uyğun';

  @override
  String get themeLight => 'İşıqlı';

  @override
  String get themeDark => 'Qaranlıq';

  @override
  String get errorGeneric => 'Nəsə alınmadı. Bir azdan yenidən cəhd edin';

  @override
  String get storePickerTitle => 'Hara gedirsiniz?';

  @override
  String get storePickerWhy =>
      'Qiymətlər təkcə şəbəkələr arasında yox, eyni şəbəkənin mağazaları arasında da fərqlənir. Sizə yad qiymət göstərməmək üçün öz mağazalarınızı seçin.';

  @override
  String get useMyLocation => 'Yerimi təyin et';

  @override
  String get locationWhyTitle => 'Yeriniz nə üçün lazımdır';

  @override
  String get locationWhyBody =>
      'Yaxın mağazaları göstərmək üçün. Koordinatlar cihazdan kənara çıxmır və saxlanılmır. İcazə verməsəniz, siyahıdan özünüz seçə bilərsiniz.';

  @override
  String get locationAllow => 'İcazə ver';

  @override
  String get locationDenied =>
      'İcazə verilmədi. Aşağıdan rayonu və mağazanı özünüz seçin.';

  @override
  String get locationDeniedForever =>
      'İcazə həmişəlik bağlanıb. Tənzimləmələrdən aça bilərsiniz.';

  @override
  String get locationServiceOff =>
      'Cihazda yer təyini söndürülüb. Onu açın və ya mağazanı özünüz seçin.';

  @override
  String get locationFailed =>
      'Yeri təyin etmək alınmadı. Mağazanı siyahıdan seçin.';

  @override
  String get locationFound => 'Yer təyin edildi';

  @override
  String get openSettings => 'Tənzimləmələri aç';

  @override
  String get district => 'Rayon';

  @override
  String get allDistricts => 'Hamısı';

  @override
  String get samePriceEverywhere => 'Bütün mağazalarda eyni qiymət';

  @override
  String get pricesDifferBetweenStores =>
      'Mağazalar arasında qiymət fərqlənir — öz mağazanızı seçin';

  @override
  String get pickYourStoreRequired => 'Mağazanı seçin — qiymət ondan asılıdır';

  @override
  String get pickAtLeastOneChain => 'Ən azı bir şəbəkə seçin';

  @override
  String get pickStoreToContinue => 'Seçdiyiniz şəbəkə üçün mağazanı da seçin';

  @override
  String pickStoreForChains(String chains) {
    return '$chains üçün mağaza seçin — qiymət mağazadan asılıdır';
  }

  @override
  String get continueLabel => 'Davam et';

  @override
  String get save => 'Yadda saxla';

  @override
  String get cancel => 'İmtina';

  @override
  String get retry => 'Yenidən';

  @override
  String get changeLaterInSettings =>
      'Sonra tənzimləmələrdən dəyişə bilərsiniz';

  @override
  String get settingsStores => 'Mənim mağazalarım';

  @override
  String get storesNotPicked => 'Mağaza seçilməyib';

  @override
  String chainsPicked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count şəbəkə',
      one: '$count şəbəkə',
    );
    return '$_temp0';
  }

  @override
  String get storeChangeInvalidatesPrices =>
      'Mağazanı dəyişsəniz, qiymətlər yenidən yüklənəcək';

  @override
  String get clear => 'Təmizlə';

  @override
  String get scanTitle => 'Barkodu skan et';

  @override
  String get scanHint => 'Barkodu çərçivəyə tutun';

  @override
  String scanNotFound(String code) {
    return '$code bazamızda yoxdur. Başqa məhsul yoxlayın';
  }

  @override
  String searchTooShort(int count) {
    return 'Ən azı $count hərf yazın';
  }

  @override
  String get popularQueries => 'Tez-tez axtarılanlar';

  @override
  String get promoBadge => 'Endirim';

  @override
  String offlineDataFrom(String time) {
    return 'İnternet yoxdur. Məlumatlar $time tarixindəndir';
  }

  @override
  String get pricePerKilogram => '1 kq-ın qiyməti';

  @override
  String get perKilogramExplained =>
      'Bu çəki ilə satılan məhsuldur: qiymət 1 kiloqrama görədir, paketə görə yox.';

  @override
  String get priceHistory => 'Qiymət tarixçəsi';

  @override
  String get historyTooShort =>
      'Tarixçə hələ azdır. Bir neçə gündən sonra qrafik görünəcək';

  @override
  String get historyUnavailable => 'Tarixçəni yükləmək alınmadı';

  @override
  String get watchPrice => 'Qiyməti izlə';

  @override
  String get watching => 'İzlənilir';

  @override
  String get watchStart => 'İzləməyə başla';

  @override
  String get watchExplained =>
      'Qiymət ən azı 5% düşəndə bildiriş göndərəcəyik. İstəsəniz, öz hədəf qiymətinizi də yaza bilərsiniz.';

  @override
  String get currentBestPrice => 'İndiki ən yaxşı qiymət';

  @override
  String get targetPriceOptional => 'Hədəf qiymət (vacib deyil)';

  @override
  String get targetPriceHint => 'məsələn, 13,99';

  @override
  String get targetPriceInvalid => 'Qiyməti düzgün yazın: 13,99';

  @override
  String get addToList => 'Siyahıya əlavə et';

  @override
  String get inList => 'Siyahıdadır';

  @override
  String get filters => 'Süzgəclər';

  @override
  String get filtersReset => 'Sıfırla';

  @override
  String get filtersApply => 'Göstər';

  @override
  String get filterAny => 'Hamısı';

  @override
  String get filterMinDiscount => 'Ən azı endirim';

  @override
  String get filterMyChainsOnly => 'Yalnız mənim şəbəkələrim';

  @override
  String get filterCategory => 'Kateqoriya';

  @override
  String get dealsEmptyFiltered => 'Bu süzgəclərlə endirim tapılmadı';

  @override
  String get dealsEnd => 'Hamısı budur';

  @override
  String get loadMoreFailed => 'Davamını yükləmək alınmadı';

  @override
  String aboveMarket(int percent) {
    return 'Bazardan $percent% baha';
  }

  @override
  String get marketExplainTitle => '«Bazardan ucuz» nə deməkdir';

  @override
  String marketExplainBody(int count) {
    return 'Bazar — eyni barkodlu məhsulun DİGƏR şəbəkələrdəki adi, endirimsiz qiymətlərinin medianı. Bu hesablamada $count belə qiymət iştirak edib. Şəbəkənin öz üstündən xətt çəkdiyi qiymətə görə yox, məhz bazara görə sayırıq.';
  }

  @override
  String get marketExplainNow => 'İndi';

  @override
  String get marketExplainClaimed => 'Şəbəkə deyir';

  @override
  String get marketExplainMarket => 'Bazar';

  @override
  String inflatedExplained(int points) {
    return 'Elan edilən endirim həqiqidən $points bənd dərindir. Yəni köhnə qiymət şişirdilib.';
  }

  @override
  String get share => 'Paylaş';

  @override
  String get shareFailed => 'Şəkil hazırlanmadı';

  @override
  String shareText(String name, String price, String chain, int percent) {
    return '$name — $price $chain-da, bazardan $percent% ucuz. qiymət ilə tapdım.';
  }

  @override
  String basketTotalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count məhsul üçün yekun',
      one: '$count məhsul üçün yekun',
    );
    return '$_temp0';
  }

  @override
  String basketSplitInto(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mağazaya bölsəniz',
      one: '$count mağazaya bölsəniz',
    );
    return '$_temp0';
  }

  @override
  String basketSaves(String amount) {
    return 'qənaət $amount';
  }

  @override
  String get basketSplitDisclaimer =>
      'Adətən bölmək az qazandırır. İkinci mağazaya getməyə dəyərmi — özünüz qərar verin.';

  @override
  String get basketOtherChains => 'Digər şəbəkələr';

  @override
  String basketMissingItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count məhsul yoxdur',
      one: '$count məhsul yoxdur',
    );
    return '$_temp0';
  }

  @override
  String get basketNoCompleteChain =>
      'Heç bir şəbəkə siyahını tam bağlamır — bölmək lazım gələcək';

  @override
  String get basketNoPricesYet =>
      'Qiymətlər hələ yüklənməyib. İnternet olanda yenilənəcək';

  @override
  String get basketOnlyManual => 'Əl ilə yazılan sətirlərin qiyməti olmur';

  @override
  String basketManualExcluded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sətir əl ilə yazılıb',
      one: '$count sətir əl ilə yazılıb',
    );
    return '$_temp0';
  }

  @override
  String basketUnpricedExcluded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count məhsulun qiyməti yoxdur',
      one: '$count məhsulun qiyməti yoxdur',
    );
    return '$_temp0';
  }

  @override
  String get basketManualItem => 'əl ilə yazılıb';

  @override
  String get basketNoPrice => 'seçdiyiniz şəbəkələrdə yoxdur';

  @override
  String get basketAddManual => 'Əl ilə əlavə et';

  @override
  String get basketAddManualHint => 'məsələn, çörək';

  @override
  String get basketAdd => 'Əlavə et';

  @override
  String get basketRefreshPrices => 'Qiymətləri yenilə';

  @override
  String get basketPricesOffline =>
      'İnternet yoxdur. Köhnə qiymətlər göstərilir';

  @override
  String get consentTitle => 'Çeklərin emalına razılıq';

  @override
  String get consentAgree => 'Razıyam';

  @override
  String get consentDecline => 'İndi yox';

  @override
  String get consentScrollToEnd => 'Razılaşmaq üçün mətni sonadək oxuyun';

  @override
  String get consentRevokeTitle => 'Razılığı geri götür';

  @override
  String get consentRevokeSubtitle => 'Bütün çekləriniz silinəcək';

  @override
  String get consentRevokeBody =>
      'Razılığı geri götürsəniz, bütün çekləriniz silinir və toplanan ballar sıfırlanır. Şəxssizləşdirilmiş qiymətlər statistikada qalır — razılıq mətnində bu barədə yazılıb.';

  @override
  String get consentRevokeConfirm => 'Geri götür və sil';

  @override
  String get receiptScanTitle => 'Çeki skan et';

  @override
  String get receiptScanHint => 'Çekdəki QR kodu çərçivəyə tutun';

  @override
  String get receiptFailed => 'Çeki oxumaq alınmadı. Başqa çek yoxlayın';

  @override
  String get receiptsTitle => 'Çeklərim';

  @override
  String get receiptsEmpty => 'Hələ çek yoxdur';

  @override
  String get receiptsWhy =>
      'Kassadakı qiymət vitrindəkindən dəqiqdir. Çekiniz bizim çata bilmədiyimiz mağazaların qiymətlərini açır.';

  @override
  String get receiptUnknownStore => 'Naməlum mağaza';

  @override
  String receiptsUploaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count çek',
      one: '$count çek',
    );
    return '$_temp0';
  }

  @override
  String get pointsTitle => 'Ballarınız';

  @override
  String get dataRefreshingTitle => 'Məlumatlar yenilənir';

  @override
  String get dataRefreshingBody =>
      'Bəzi qiymətlər hələ yoxlanılmayıb. Bir azdan yenidən baxın';

  @override
  String get catalogTitle => 'Kataloq';

  @override
  String get catalogOpen => 'Mağazanın kataloquna baxın';

  @override
  String get catalogAllCategories => 'Hamısı';

  @override
  String get catalogEmpty => 'Bu bölmədə məhsul yoxdur';

  @override
  String get catalogPickStore => 'Mağaza seçin';

  @override
  String get catalogAllStores => 'Bütün mağazalar';
}
