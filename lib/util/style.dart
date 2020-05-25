import 'package:flutter/material.dart';

class StyleUi{
  static final Color colorPengeluaran = Color(0xFFcc0000);
  static final Color colorPemasukan = Color(0xFF005800);
  static final Color colorSubtitle = Color(0xFF104E8B);

  static final textStylePengeluaran =  TextStyle(fontSize:11,color: colorPengeluaran);
  static final textStylePemasukan =  TextStyle(fontSize:11,color: colorPemasukan);

  static final tRxstyleTextItem = TextStyle(fontWeight: FontWeight.normal, fontSize: 13);

  static final tRxstyleTextKategori = TextStyle(fontSize: 10, color: colorSubtitle);

}

extension CustomColorScheme on ColorScheme {
  Color get success => const Color(0xFF28a745);
  Color get info => const Color(0xFF17a2b8);
  Color get warning => const Color(0xFFffc107);
  Color get danger => const Color(0xFFdc3545);
}

extension CustomTextScheme on TextTheme {}