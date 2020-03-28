import 'dart:async';

import 'package:keuangan/database/keuangan/dao_itemname.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:rxdart/subjects.dart';

class BlocHomepageItemName {

  final BehaviorSubject<ItemUIHomepageItemName> _itemUi = BehaviorSubject();

  BlocHomepageItemName() {

    this.populateAllKategoriFromDb(EnumStatePopulateItemName.firsttime);
  }

  void populateAllKategoriFromDb(EnumStatePopulateItemName enumState) {
    DaoItemName daoItemName = new DaoItemName();
    daoItemName.getAllItemName().then((v) {
      List<ItemName> litemname = new List();
      if (v != null) {
        litemname.addAll(v);
      }

      ItemUIHomepageItemName itemUIHomepageKategori =
      new ItemUIHomepageItemName(enumState, litemname);
      _itemUi.sink.add(itemUIHomepageKategori);
    });
  }

  deleteActioni(ItemName itemName,EnumStatePopulateItemName enumState){
    DaoItemName daoItemName = new DaoItemName();
    daoItemName.deleteItemName(itemName).then((v){
      if(v == 1){
        daoItemName.getAllItemName().then((v) {
          List<ItemName> litemname = new List();
          if (v != null) {
            litemname.addAll(v);
          }

          ItemUIHomepageItemName itemUIHomepageKategori =
          new ItemUIHomepageItemName(enumState, litemname);
          _itemUi.sink.add(itemUIHomepageKategori);
        });
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
