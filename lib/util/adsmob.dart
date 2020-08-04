import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class AdMobUtil {
  BannerAd createBanner(EnumBannerId enumBannerId) {
    return BannerAd(
        adUnitId: AdManager.bannerAdUnitId(enumBannerId),
    size: AdSize.banner,);
  }

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    // testDevices: testDevice != null ? <String>[testDevice] : null,
    //   testDevices: <String>[], //null jika release
    testDevices: null, //null jika release
    nonPersonalizedAds: true,
    keywords: <String>[
      'expense',
      'finance',
      'productivity'
    ],
  );
// static const testDeviceId = '41a7e42d654ad81c'; //xiaomi guwa haha
}

enum LokasiBanner { hpcalender, hptodolist, hpspecialday, hpsampah }

class AdManager {
  static final String bannerHpKeuangan = '';
  static final String bannerHpTransaksi = '';
  static final String bannerHpLaporan = '';
  static final String bannerHpKategori = '';
  static final String bannerHpItemName = '';

  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-9748508337477728~7838475963";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_ADMOB_APP_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static bool isAdmobOn(){
    return false;
  }

  static String bannerAdUnitId(EnumBannerId enumBannerId) {
    String bannerId = '';
    switch (enumBannerId) {
      case EnumBannerId.hpKeuangan:
        // TODO: Handle this case.
        bannerId = '';
        break;
      case EnumBannerId.hpTransaksi:
        // TODO: Handle this case.
        bannerId = '';
        break;
      case EnumBannerId.hpLaporan:
        // TODO: Handle this case.
        bannerId = '';
        break;
      case EnumBannerId.hpItemName:
        // TODO: Handle this case.
        bannerId = '';
        break;
      case EnumBannerId.hpKategori:
        // TODO: Handle this case.
        bannerId = '';
        break;
    }

    bannerId = 'ca-app-pub-3940256099942544/6300978111';
    if (Platform.isAndroid) {
      return bannerId;
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_BANNER_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}

enum EnumBannerId { hpKeuangan, hpTransaksi, hpLaporan, hpItemName, hpKategori }
