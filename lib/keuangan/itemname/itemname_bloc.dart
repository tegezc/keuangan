import 'dart:async';

import 'package:keuangan/database/db_utility.dart';
import 'package:keuangan/database/keuangan/dao_itemname.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:rxdart/subjects.dart';

class BlocHomepageItemName {

  final BehaviorSubject<ItemUIHomepageItemName> _itemUi = BehaviorSubject();

  void populateSemuaItemNameFromDb(EnumStatePopulateItemName enumState) {
    DaoItemName daoItemName = new DaoItemName();
    daoItemName.getAllItemNameVisibleLazy().then((v) {

      ItemUIHomepageItemName itemUIHomepageKategori =
      new ItemUIHomepageItemName(enumState, v.listPengeluaran,v.listPemasukan);
      _itemUi.sink.add(itemUIHomepageKategori);
    });
  }

  /// itemname yang didelete user sebenarnya tidak di delete dari database.
  /// hanya isDeleted di set 1. untuk menjaga referensi transaksi ke itemname
  /// tidak terganggu. di perkirakan jumlah itemname ini tidak akan banyak. jadi
  /// layak dengan cara seperti ini.
  deleteAction(ItemName itemName,EnumStatePopulateItemName enumState){
    DaoItemName daoItemName = new DaoItemName();
    itemName.setIsDeleted(1);
    daoItemName.update(itemName).then((v){
      if(v == EnumResultDb.success){
       this.populateSemuaItemNameFromDb(enumState);
      }
    });
  }

  Stream<ItemUIHomepageItemName> get listItemNameStream => _itemUi.stream;

  void dispose() {
    _itemUi.close();
  }
}



class ItemUIHomepageItemName {
  EnumStatePopulateItemName enumState;
  List<ItemName> listPengeluaran;
  List<ItemName> listPemasukan;


  ItemUIHomepageItemName(this.enumState, this.listPengeluaran,this.listPemasukan);
}

enum EnumStatePopulateItemName {
  firsttime,
  savesuccess,
  editsuccess,
  deleteSuccess,
}