import 'dart:async';

import 'package:keuangan/model/enum_db.dart';
import 'package:keuangan/database/keuangan/dao_itemname.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:rxdart/subjects.dart';

class BlocHomepageItemName {

  final BehaviorSubject<ItemUIHomepageItemName> _itemUi = BehaviorSubject();

  BlocHomepageItemName() {

    this.populateSemuaItemNameFromDb(EnumStatePopulateItemName.firsttime);
  }

  void populateSemuaItemNameFromDb(EnumStatePopulateItemName enumState) {
    DaoItemName daoItemName = new DaoItemName();
    daoItemName.getAllItemNameVisible().then((v) {
      List<ItemName> litemname = new List();
      if (v != null) {
        litemname.addAll(v);
      }

      ItemUIHomepageItemName itemUIHomepageKategori =
      new ItemUIHomepageItemName(enumState, litemname);
      _itemUi.sink.add(itemUIHomepageKategori);
    });
  }

  /// itemname yang didelete user sebenarnya tidak di delete dari database.
  /// hanya isDeleted di set 1. (jika di delete maka referensi transaksi akan hilang)
  deleteActioni(ItemName itemName,EnumStatePopulateItemName enumState){
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
  List<ItemName> listItemName;

  ItemUIHomepageItemName(this.enumState, this.listItemName);
}
