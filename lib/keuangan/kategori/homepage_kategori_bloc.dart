import 'dart:async';

import 'package:keuangan/database/db_utility.dart';
import 'package:keuangan/database/keuangan/dao_itemname.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:rxdart/subjects.dart';

class BlocHomepageKategori {
  final BehaviorSubject<ItemUIHomepageKategori> _itemUi = BehaviorSubject();

  void populateAllKategoriFromDb(EnumStatePopulateKategori enumState) {
    this._getData(enumState).then((itemUIHomepageKategori) {
      _itemUi.sink.add(itemUIHomepageKategori);
    });
  }

  Future<ItemUIHomepageKategori> _getData(
      EnumStatePopulateKategori enumState) async {
    DaoKategori daoKategori = new DaoKategori();
    List<Kategori> lkPengeluaran = await daoKategori.getAllKategoriNonAbadi(EnumJenisTransaksi.pengeluaran);
    List<Kategori> lkPemasukan = await daoKategori.getAllKategoriNonAbadi(EnumJenisTransaksi.pemasukan);
    List<Kategori> lkPeng = this._processKategori(lkPengeluaran);
    List<Kategori> lkPem = this._processKategori(lkPemasukan);

    ItemUIHomepageKategori itemUIHomepageKategori =
        new ItemUIHomepageKategori(enumState, lkPeng, lkPem);
    return itemUIHomepageKategori;
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
  ///
  /// [PERBAIKAN] NEXT VERSION SELURUH TRX INI HARUS DLM SATU BATCH SUPAYA JIKA SATU GAGAL
  /// BISA DILAKUKAN ROLLBACK
  void deleteKategori(Kategori kategori) async {
    DaoKategori daoKategori = new DaoKategori();
    this._updateItemNameKeOther(kategori).then((isSuccess) {
      if (isSuccess) {
        this._updateSubkategorikeLevel1(kategori).then((scc) {
          if (scc) {
            daoKategori.deleteKategori(kategori).then((res) {
              if (res > 0) {
                this.populateAllKategoriFromDb(
                    EnumStatePopulateKategori.deleteSuccess);
              }
            });
          } else {
            //TODO gagal update kategori
          }
        });
      } else {
        // TODO gagal update itemname
      }
    });
  }

  /// update itemname yang berafiliasi dengan kategori , diarahkan ke Other
  /// jika duplikasi, maka ubah isdeleted menjadi 1
  Future<bool> _updateItemNameKeOther(Kategori kategori) async {
    DaoKategori daoKategori = new DaoKategori();
    DaoItemName daoItemName = new DaoItemName();

    bool isSuccess = true;
    List<ItemName> litemName =
        await daoItemName.getItemNameByIdKategori(kategori.id);
    if (litemName.isNotEmpty) {
      Kategori k = await daoKategori.getDefaultKategori(kategori.type);
      for (int i = 0; i < litemName.length; i++) {
        ItemName itemName = litemName[i];
        litemName[i].setKategori(k);
        bool isduplicate = await daoItemName.isDuplicate(itemName);
        if (isduplicate) {
          litemName[i].setIsDeleted(1);
        }
      }
      if (litemName.length > 1) {
        ResultDb resultDb = await daoItemName.updateBatch(litemName);
        if (resultDb.enumResultDb == EnumResultDb.failed) {
          isSuccess = false;
        }
      } else {
        EnumResultDb enumResultDb = await daoItemName.update(litemName[0]);
        if (enumResultDb == EnumResultDb.success) {
          isSuccess = true;
        } else {
          isSuccess = false;
        }
      }
    }
    return isSuccess;
  }

  /// cek level
  ///  [kategori.idParent == 0] adalah level 1, jika punya subkategori, maka
  ///  subkategori akan menjadi level 1
  Future<bool> _updateSubkategorikeLevel1(Kategori kategori) async {
    DaoKategori daoKategori = new DaoKategori();
    bool isSuccess = true;
    if (kategori.idParent == 0) {
      List<Kategori> lktg = await daoKategori.getSubkategori(kategori.id);
      if (lktg.isNotEmpty) {
        for (int i = 0; i < lktg.length; i++) {
          /// set subkategori ke level 1
          lktg[i].setIdParent(0);
        }
        if (lktg.length > 1) {
          ResultDb resultDb = await daoKategori.updateBatchNoDuplicate(lktg);
          if (resultDb.enumResultDb == EnumResultDb.failed) {
            isSuccess = false;
          }
        } else {
          ResultDb resultDb = await daoKategori.update(lktg[0]);
          if (resultDb.enumResultDb == EnumResultDb.failed) {
            isSuccess = false;
          }
        }
      }
    }
    return isSuccess;
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

  Stream<ItemUIHomepageKategori> get itemUIHomepageKategori => _itemUi.stream;

  void dispose() {
    _itemUi.close();
  }
}

class ItemUIHomepageKategori {
  EnumStatePopulateKategori enumState;
  List<Kategori> listKategoriPengeluaran;
  List<Kategori> listKategoriPemasukan;

  ItemUIHomepageKategori(
      this.enumState, this.listKategoriPengeluaran, this.listKategoriPemasukan);
}

enum EnumStatePopulateKategori {
  firsttime,
  savesuccess,
  editsuccess,
  saveSubkategorisuccess,
  editSubkategorisuccess,
  deleteSuccess,
}
