import 'package:flutter/material.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/model/keuangan.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class ColorManagement{
  static final  colors = [
    "aca23f",
    "623fcd",
    "80db3b",
    "ca49da",
    "64d76e",
    "843498",
    "d7da44",
    "3f2b7a",
    "b2dc8b",
    "d54aa5",
    "63dfb4",
    "d84670",
    "518a32",
    "9b73de",
    "dd953d",
    "5e7bca",
    "dd5035",
    "88d2d2",
    "93312d",
    "519576",
    "7e3666",
    "d9cda0",
    "2f2543",
    "dc9f96",
    "334428",
    "ce93cb",
    "996030",
    "92b1d6",
    "522826",
    "7f7d51",
    "4f6c82",
    "a16772"];

  Map<String,int> _colorsToMap(){
    Map<String,int> map = new Map();
    for(int i =0;i<colors.length;i++){
      map[colors[i]] = 0;
    }

    return map;
  }

  Future<String> hexColor(int idParentKategori) async{

    Map<String,int> mapColors = this._colorsToMap();
    DaoKategori daoKategori = new DaoKategori();
    List<Kategori> lKategori;
    if(idParentKategori == 0){
      lKategori = await daoKategori.getAllMainKategori();
    }else{
      lKategori = await daoKategori.getSubkategori(idParentKategori);
    }
    if(lKategori == null){
      return colors[0];
    }else{
      for(int i =0;i < lKategori.length;i++){
        int tmp = mapColors[lKategori[i].color];
        mapColors[lKategori[i].color] = tmp+1;
      }
      int div = lKategori.length ~/ colors.length;
      for(int i =0;i<colors.length;i++){
        if(mapColors[colors[i]] == div){
          return colors[i];
        }
      }

      ///jika jumlah lkategori pas kelipatan 32
      return colors[0];
    }

  }
}