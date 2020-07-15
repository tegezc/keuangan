import 'package:flutter/material.dart';
import 'package:keuangan/util/colors_utility.dart';

/// untuk style yang tak terpengaruh baik mode normal maupun mode dark
class StyleUi {
  static final Color colorPengeluaran = Color(0xFFcc0000);
  static final Color colorPemasukan = Color(0xFF005800);
  static final Color colorSubtitle = Color(0xFF104E8B);

  static final textStylePengeluaran =
      TextStyle(fontSize: 11, color: colorPengeluaran);
  static final textStylePemasukan =
      TextStyle(fontSize: 11, color: colorPemasukan);

  static final textStyleBalanceBesarPositif =
      new TextStyle(fontSize: 20, color: colorPemasukan);
  static final textStyleBalanceBesarNegatif =
      new TextStyle(fontSize: 20, color: colorPengeluaran);

  static final textStyleBalanceMediumPemasukan =
      new TextStyle(fontSize: 13, color: colorPemasukan);
  static final textStyleBalanceMediumPengeluaran =
      new TextStyle(fontSize: 13, color: colorPengeluaran);
}

extension CustomColorScheme on ColorScheme {}

extension CustomTextScheme on TextTheme {}

class AppTheme {
  AppTheme._();

  static const Color _colorSubtitle = Color(0xFF104E8B);

  static final _tRxstyleTextItem = TextStyle(
      fontWeight: FontWeight.normal, fontSize: 13, color: Colors.black);

  static final _tRxstyleTextKategori =
      TextStyle(fontSize: 10, color: _colorSubtitle);

  static final _smallText = new TextStyle(fontSize: 10, color: Colors.black);

  static final _tRxstyleTextItemDark = TextStyle(
      fontWeight: FontWeight.normal, fontSize: 13, color: Colors.white);

  static final _tRxstyleTextKategoriDark =
  TextStyle(fontSize: 10, color: _colorSubtitle);

  static final _smallTextDark = new TextStyle(fontSize: 10, color: Colors.white);

  static final _caption = new TextStyle(fontSize: 16 ,color: Colors.black,fontWeight: FontWeight.bold);
  static final _captionDark = new TextStyle(fontSize: 14, color: Colors.white);

  static Color _iconColor = Colors.cyan[600];
//  static Color _iconColor = HexColor('#00acee');

//  static const Color _lightPrimaryColor = Colors.white;
//  static const Color _lightPrimaryVariantColor = Color(0XFFE1E1E1);
//  static const Color _lightSecondaryColor = Colors.green;
//  static const Color _lightOnPrimaryColor = Colors.black;

  static const Color _darkPrimaryColor = Colors.white;
  static const Color _darkPrimaryVariantColor = Colors.black;
  static const Color _darkSecondaryColor = Colors.white;
  static const Color _darkOnPrimaryColor = Colors.white;

  static final ThemeData lightTheme = ThemeData(

    primaryColor: Colors.white,
    accentColor: Colors.cyan[600],
    fontFamily: 'Opensans',
 //   textTheme: TextTheme(),
//    scaffoldBackgroundColor: _lightPrimaryVariantColor,
//    appBarTheme: AppBarTheme(
//      color: _lightPrimaryVariantColor,
//      iconTheme: IconThemeData(color: _lightOnPrimaryColor),
//    ),
//    colorScheme: ColorScheme.light(
//      primary: _lightPrimaryColor,
//      primaryVariant: _lightPrimaryVariantColor,
//      secondary: _lightSecondaryColor,
//      onPrimary: _lightOnPrimaryColor,
 //   ),
//    iconTheme: IconThemeData(
//      color: _iconColor,
//    ),
    textTheme: _lightTextTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: _darkPrimaryVariantColor,
    appBarTheme: AppBarTheme(
      color: _darkPrimaryVariantColor,
      iconTheme: IconThemeData(color: _darkOnPrimaryColor),
    ),
    colorScheme: ColorScheme.light(
      primary: _darkPrimaryColor,
      primaryVariant: _darkPrimaryVariantColor,
      secondary: _darkSecondaryColor,
      onPrimary: _darkOnPrimaryColor,
    ),
    iconTheme: IconThemeData(
      color: _iconColor,
    ),
    textTheme: _darkTextTheme,
  );

  static final TextTheme _lightTextTheme = TextTheme(
    headline4: _smallText,
    headline3: _tRxstyleTextItem,
    headline2: _caption,
    subtitle2: _tRxstyleTextKategori,
  );

  static final TextTheme _darkTextTheme = TextTheme(
    headline4: _smallTextDark,
    headline3: _tRxstyleTextItemDark,
    headline2: _captionDark,
    subtitle2: _tRxstyleTextKategoriDark,
  );

}
