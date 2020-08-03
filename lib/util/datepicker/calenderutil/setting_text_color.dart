import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:keuangan/util/colors_utility.dart';

class SettingTextColor {
  ///------------------------------------------------
  /// COLOR
  /// -----------------------------------------------

  ///general app
  static final Color colorHeaderApp = HexColor('00695C');

  ///calender
  static final Color colorHeaderTanggal = HexColor('#E0F2F1');
  static final Color colorFontJumat = HexColor('#43A047');
  static final Color colorFontLibur = HexColor('#8b0000');
  static final Color colorKotakCurrentDate = HexColor('#00695C');
  static final Color colorFontNamaBulan = Colors.black;
  static final Color colorFontNamaBulanHijriah = Colors.black;
  static final Color colorFontHariNormal = Colors.black;
  static final Color colorFontNamaHari = Colors.black;
  static final Color colorIconFlagHariActive = Colors.deepOrange;
  static final Color colorIconFlagHariNonActive = Colors.transparent;
  static final Color calClrBorderCalendar = Colors.blueGrey;
  static final Color calColorPengumuman = HexColor('#8b0000');

  ///calendar
  static final calStNmBlnJumpDate = TextStyle(fontSize: 16);
  static final calStNmThnJumpDate = TextStyle(fontSize: 16);
  static final calStTitleNmBulan = new TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: colorFontNamaBulan,
  );

  static final calStNmBlnHij = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.bold,
    color: colorFontNamaBulanHijriah,
  );

  static final calStNmHr = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.bold,
    color: colorFontNamaHari,
  );

}
