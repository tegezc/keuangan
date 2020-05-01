import 'dart:async';
import 'dart:html';

import 'package:keuangan/database/db_utility.dart';
import 'package:keuangan/database/keuangan/dao_itemname.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:rxdart/subjects.dart';

class BlocHomepageKategori {
  List<Kategori> _cacheListKategori;
  final BehaviorSubject<ItemUIHomepageKategori> _itemUi = BehaviorSubject();

  BlocHomepageKategori() {
    _cacheListKategori = new List();
  }

  void populateAllKategoriFromDb(EnumStatePopulateKategori enumState) {
    DaoKategori daoKategori = new DaoKategori();
    daoKategori.getAllKategoriNonAbadi().then((v) {
      if (v != null) {
        _cacheListKategori.clear();
        _cacheListKategori.addAll(_processKategori(v));
      }

      ItemUIHomepageKategori itemUIHomepageKategori =
          new ItemUIHomepageKategori(enumState, _cacheListKategori);
      _itemUi.sink.add(itemUIHomepageKategori);
    });
  }

  void populateAllKategoriSaveEditSuccess(EnumStatePopulateKategori enumState) {
    DaoKategori daoKategori = new DaoKategori();
    daoKategori.getAllKategoriNonAbadi().then((v) {
      if (v != null) {
        _cacheListKategori.clear();
        _cacheListKategori.addAll(_processKategori(v));
      }

      ItemUIHomepageKategori itemUIHomepageKategori =
          new ItemUIHomepageKategori(enumState, _cacheListKategori);
      _itemUi.sink.add(itemUIHomepageKategori);
    });
  }

  /// Delete kategori memiliki 2 kondisi:
  /// 1. Kategori level 1
  /// 2. Kategori level 2
  ///
  /// MENGHAPUS LEVEL 1: seluruh sub kategori otomatis akan menjadi level 1
  /// sedangkan itemName(all baik isdeleted 0 dan 1) yang berafiliasi dengan kategori
  /// tersebut akan di arahkan kategori 'Other'.
  ///
  /// MENGHAPUS LEVEL 2: itemName(all baik isdeleted 0 dan 1) yang berafiliasi dengan kategori
  /// tersebut akan di arahkan kategori 'Other'.
  ///
  void deleteKategori(Kategori kategori) async {
    DaoKategori daoKategori = new DaoKategori();
    DaoItemName daoItemName = new DaoItemName();

    /// update itemname yang berafiliasi dengan kategori , diarahkan ke Other
    daoItemName.getItemNameByIdKategori(kategori.id).then((litem) {
      if (litem.isNotEmpty) {
        daoKategori.getDefaultKategori(kategori.type).then((k) {
          for (int i = 0; i < litem.length; i++) {
            ItemName itemName = litem[i];
            itemName.setKategori(k);
            daoItemName.update(itemName);
          }
        });
      }
    });

    /// cek level
    ///  [kategori.idParent == 0] adalah level 1, jika punya subkategori, maka
    ///  subkategori akan menjadi level 1
    if (kategori.idParent == 0) {
      daoKategori.getSubkategori(kategori.idParent).then((lktg) {
        if (lktg.isNotEmpty) {
          for (int i = 0; i < lktg.length; i++) {
            Kategori ktg = lktg[i];

            /// set subkategori ke level 1
            ktg.setIdParent(0);

            daoKategori.update(ktg);
          }
        }
      });
    }
  }

  Future<bool> _updateItemNameKeOther(Kategori kategori) async {
    DaoKategori daoKategori = new DaoKategori();
    DaoItemName daoItemName = new DaoItemName();

    bool success = true;
    /// update itemname yang berafiliasi dengan kategori , diarahkan ke Other
    List<ItemName> litemName =
        await daoItemName.getItemNameByIdKategori(kategori.id);
    if (litemName.isNotEmpty) {
      Kategori k = await daoKategori.getDefaultKategori(kategori.type);
      for (int i = 0; i < litemName.length; i++) {
        ItemName itemName = litemName[i];
        itemName.setKategori(k);
        EnumResultDb erdb = await daoItemName.update(itemName);
        if(erdb == EnumResultDb.failed){}
      }
    }
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

enum EnumStatePopulateKategori {
  firsttime,
  savesuccess,
  editsuccess,
  saveSubkategorisuccess,
  editSubkategorisuccess,
}
