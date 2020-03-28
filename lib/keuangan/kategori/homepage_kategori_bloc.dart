import 'dart:async';

import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:rxdart/subjects.dart';

class BlocHomepageKategori {
  List<Kategori> _cacheListKategori;
  final BehaviorSubject<ItemUIHomepageKategori> _itemUi = BehaviorSubject();

  BlocHomepageKategori() {
    _cacheListKategori = new List();

    this.populateAllKategoriFromDb(EnumStatePopulateKategori.firsttime);
  }

  void populateAllKategoriFromDb(EnumStatePopulateKategori enumState) {
    DaoKategori daoKategori = new DaoKategori();
    daoKategori.getAllKategori().then((v) {
      if (v != null) {
        _cacheListKategori.clear();
        _cacheListKategori.addAll(_processKategori(v));
      }

      ItemUIHomepageKategori itemUIHomepageKategori =
          new ItemUIHomepageKategori(enumState, _cacheListKategori);
      _itemUi.sink.add(itemUIHomepageKategori);
    });
  }

  List<Kategori> _processKategori(List<Kategori> lk) {
    List<Kategori> listParent = new List();
    Map<int, List<Kategori>> mapKategori = new Map();
    for (int i = 0; i < lk.length; i++) {
      if (lk[i].idParent == 0) {
        listParent.add(lk[i]);
        if (mapKategori[lk[i].id] == null) {
          List<Kategori> subkategori = new List();
          mapKategori[lk[i].id] = subkategori;
        }
      } else {
        List<Kategori> subkategori;
        if (mapKategori[lk[i].idParent] == null) {
          subkategori = new List();
        } else {
          subkategori = mapKategori[lk[i].idParent];
        }
        subkategori.add(lk[i]);
        mapKategori[lk[i].idParent] = subkategori;
      }
    }

    List<Kategori> returnList = new List();
    for (int i = 0; i < listParent.length; i++) {
      Kategori kategori = listParent[i];
      if (mapKategori[kategori.id] != null) {
        kategori.listKategori = mapKategori[kategori.id];
        returnList.add(kategori);
      }
    }
    return returnList;
  }

  Stream<ItemUIHomepageKategori> get listKategoriStream => _itemUi.stream;

  void dispose() {
    _itemUi.close();
  }

}



class ItemUIHomepageKategori {
  EnumStatePopulateKategori enumState;
  List<Kategori> listKategori;

  ItemUIHomepageKategori(this.enumState, this.listKategori);
}
