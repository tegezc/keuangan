import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

class AdMobUtil {
  BannerAd createBanner(LokasiBanner lokasiBanner) {
    AdSize adSize = AdSize.smartBanner;
    String idUnitAd = '';
    if (lokasiBanner == LokasiBanner.hpcalender) {
      idUnitAd = unitAdIdFootHpCalender;
    } else if (lokasiBanner == LokasiBanner.hpspecialday) {
      idUnitAd = unitAdIdFootHpSpecialDay;
    } else if (lokasiBanner == LokasiBanner.hptodolist) {
      idUnitAd = unitAdIdFootHpTodolist;
    }

    idUnitAd = unitAdTestBannerAndroid;

    return BannerAd(
        adUnitId: idUnitAd,
        //Change BannerAd adUnitId with Admob ID
        size: adSize,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("BannerAd $event");
        });
  }

  static final isAdOn = true;

  static final addAppId = 'ca-app-pub-9748508337477728~2663384646';
  static final unitAdIdFootHpCalender =
      'ca-app-pub-9748508337477728/6540036894';
  static final unitAdIdFootHpTodolist =
      'ca-app-pub-9748508337477728/8974628540';
  static final unitAdIdFootHpSpecialDay =
      'ca-app-pub-9748508337477728/3913873552';
  static final unitAdIdFootHpSampah = 'ca-app-pub-9748508337477728/2920549604';

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    // testDevices: testDevice != null ? <String>[testDevice] : null,
    //   testDevices: <String>[], //null jika release
    testDevices: null, //null jika release
    nonPersonalizedAds: true,
    keywords: <String>[
      'Kalender',
      'Kalendar',
      'Calender',
      'Calendar',
      'Nasional',
      'Libur',
      'Ticket',
      'Tiket',
      'Schedule',
      'Jadwal',
      'Holiday',
      'Todo',
      'Todolist',
      'Traveling',
      'Hotel',
      'Libur'
    ],
  );

  /// JANGAN LUPA COMMENT DI BAWAH INI JIKA RELEASE
  static final unitAdTestBannerAndroid =
      'ca-app-pub-3940256099942544/6300978111';
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
