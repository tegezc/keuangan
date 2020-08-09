import 'package:keuangan/database/db_utility.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/global_string_database.dart';

import '../Database.dart';

class DaoItemName {
  TbItemName tb = new TbItemName();
  DbUtility _dbUtility = new DbUtility();
  Future<ResultDb> saveItemName(ItemName itemName) async {
    ResultDb resultDb = new ResultDb(null);
    bool isDuplicate = await this.isDuplicate(itemName);
    if (isDuplicate) {
      resultDb.enumResultDb = EnumResultDb.duplicate;
      return resultDb;
    } else {
      itemName.setIsDeleted(0);
      int realId = _dbUtility.generateId();
      itemName.setRealId(realId);
      var dbClient = await DatabaseHelper().db;
      int res = await dbClient.insert(tb.name, itemName.toMap());
      if (res > 0) {
        ItemName itm = await this._getItemNameById(res);
        resultDb.enumResultDb = EnumResultDb.success;
        resultDb.value = itm.realId;
        return resultDb;
      } else {
        resultDb.enumResultDb = EnumResultDb.failed;
        return resultDb;
      }
    }
  }

  Future<List<ItemName>> getAllItemName() async {
    var dbClient = await DatabaseHelper().db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM ${tb.name} WHERE ${tb.fDeleted}=0');

    List<ItemName> itemNames = new List();
    for (int i = 0; i < list.length; i++) {
      ItemName itemName = new ItemName(list[i][tb.realId], list[i][tb.fNama],
          list[i][tb.fIdKategori], list[i][tb.fDeleted]);
      itemName.setId(list[i][tb.fId]);
      itemNames.add(itemName);
    }
    return itemNames;
  }

  Future<List<ItemName>> getAllItemNameVisible() async {
    var dbClient = await DatabaseHelper().db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM ${tb.name} WHERE ${tb.fDeleted}=0');

    List<ItemName> itemNames = new List();
    for (int i = 0; i < list.length; i++) {
      ItemName itemName = new ItemName(list[i][tb.realId], list[i][tb.fNama],
          list[i][tb.fIdKategori], list[i][tb.fDeleted]);
      itemName.setId(list[i][tb.fId]);
      itemNames.add(itemName);
    }
    return itemNames;
  }

  Future<UiItemNamesLazy> getAllItemNameVisibleLazy() async {
    DaoKategori daoKategori = new DaoKategori();
    var dbClient = await DatabaseHelper().db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM ${tb.name} WHERE ${tb.fDeleted}=0 ORDER BY ${tb.fNama}');

    List<ItemName> itemNamesPengeluaran = new List();
    List<ItemName> itemNamesPemasukan = new List();
    for (int i = 0; i < list.length; i++) {
      ItemName itemName = new ItemName(list[i][tb.realId], list[i][tb.fNama],
          list[i][tb.fIdKategori], list[i][tb.fDeleted]);
      itemName.setId(list[i][tb.fId]);

      Kategori kategori =
          await daoKategori.getKategoriById(itemName.idKategori);
      itemName.setKategori(kategori);
      if (kategori.type == EnumJenisTransaksi.pemasukan) {
        itemNamesPemasukan.add(itemName);
      } else {
        itemNamesPengeluaran.add(itemName);
      }
    }
    UiItemNamesLazy uiItemNamesLazy =
        new UiItemNamesLazy(itemNamesPengeluaran, itemNamesPemasukan);
    return uiItemNamesLazy;
  }

  Future<Map<int, ItemName>> getAllItemNameMap() async {
    var dbClient = await DatabaseHelper().db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM ${tb.name}');

    Map<int, ItemName> itemNameMap = new Map();
    for (int i = 0; i < list.length; i++) {
      ItemName itemName = new ItemName(list[i][tb.realId], list[i][tb.fNama],
          list[i][tb.fIdKategori], list[i][tb.fDeleted]);
      itemName.setId(list[i][tb.fId]);

      itemNameMap[list[i][tb.fId]] = itemName;
    }
    return itemNameMap;
  }

  Future<Map<int, ItemName>> getAllItemNameMapVisible() async {
    var dbClient = await DatabaseHelper().db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM ${tb.name} WHERE ${tb.fDeleted}=0');

    Map<int, ItemName> itemNameMap = new Map();
    for (int i = 0; i < list.length; i++) {
      ItemName itemName = new ItemName(list[i][tb.realId], list[i][tb.fNama],
          list[i][tb.fIdKategori], list[i][tb.fDeleted]);
      itemName.setId(list[i][tb.fId]);

      itemNameMap[list[i][tb.fId]] = itemName;
    }
    return itemNameMap;
  }

  Future<ItemName> getItemNameById(int id) async {
    var dbClient = await DatabaseHelper().db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM ${tb.name} WHERE ${tb.realId}=$id');
    ItemName itemName;
    if (list.length > 0) {
       itemName = new ItemName(list[0][tb.realId], list[0][tb.fNama],
          list[0][tb.fIdKategori], list[0][tb.fDeleted]);
      itemName.setId(list[0][tb.fId]);
    }
    return itemName;
  }

  Future<ItemName> _getItemNameById(int id) async {
    var dbClient = await DatabaseHelper().db;
    List<Map> list =
    await dbClient.rawQuery('SELECT * FROM ${tb.name} WHERE ${tb.fId}=$id');
    ItemName itemName;
    if (list.length > 0) {
      itemName = new ItemName(list[0][tb.realId], list[0][tb.fNama],
          list[0][tb.fIdKategori], list[0][tb.fDeleted]);
      itemName.setId(list[0][tb.fId]);
    }
    return itemName;
  }

  /// baik visible atau tidak akan di dapatkan
  Future<ItemName> getItemNameByNamaNIdKategori(
      String nama, int idKategori) async {
    String lowerName = nama.toLowerCase().trim();
    var dbClient = await DatabaseHelper().db;
    String query =
        'SELECT * FROM ${tb.name} WHERE ${tb.fIdKategori}=$idKategori AND ${tb.fNama} = \'$lowerName\' COLLATE NOCASE';
    List<Map> list = await dbClient.rawQuery(query);

    ItemName itemName;
    if (list.length > 0) {
       itemName = new ItemName(list[0][tb.realId], list[0][tb.fNama],
          list[0][tb.fIdKategori], list[0][tb.fDeleted]);
      itemName.setId(list[0][tb.fId]);
    }
    return itemName;
  }

  /// baik visible atau tidak akan di dapatkan
  Future<List<ItemName>> getItemNameByIdKategori(int idKategori) async {
    var dbClient = await DatabaseHelper().db;
    String query =
        'SELECT * FROM ${tb.name} WHERE ${tb.fIdKategori}=$idKategori';
    List<Map> list = await dbClient.rawQuery(query);

    List<ItemName> litem = new List();
    if (litem != null) {
      for (int i = 0; i < list.length; i++) {
        ItemName itemName = new ItemName(list[i][tb.realId], list[i][tb.fNama],
            list[i][tb.fIdKategori], list[i][tb.fDeleted]);
        itemName.setId(list[i][tb.fId]);
        litem.add(itemName);
      }
    }

    return litem;
  }

  Future<ItemName> getItemNameByNamaNIdKategoriVisible(
      String nama, int idKategori) async {
    String lowerName = nama.toLowerCase().trim();
    var dbClient = await DatabaseHelper().db;
    String query =
        'SELECT * FROM ${tb.name} WHERE ${tb.fIdKategori}=$idKategori AND ${tb.fDeleted}=0 AND ${tb.fNama} = \'$lowerName\' COLLATE NOCASE';
    List<Map> list = await dbClient.rawQuery(query);

    ItemName itemName;
    if (list.length > 0) {
      itemName = new ItemName(list[0][tb.realId],
          list[0][tb.fNama], list[0][tb.fIdKategori], list[0][tb.fDeleted]);
      itemName.setId(list[0][tb.fId]);
    }
    return itemName;
  }

  Future<bool> isDuplicate(ItemName itemName) async {
    String lowerName = itemName.nama.toLowerCase().trim();
    var dbClient = await DatabaseHelper().db;
    String query =
        'SELECT * FROM ${tb.name} WHERE ${tb.fIdKategori}=${itemName.idKategori} AND ${tb.realId}!=${itemName.realId} AND ${tb.fDeleted}=0 AND ${tb.fNama} = \'$lowerName\' COLLATE NOCASE';
    List<Map> list = await dbClient.rawQuery(query);

    if (list.length > 0) {
      return true;
    }
    return false;
  }

  Future<int> deleteItemName(ItemName itemName) async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient
        .rawDelete('DELETE FROM ${tb.name} WHERE ${tb.fId} = ?', [itemName.id]);
    return res;
  }

  Future<int> deleteAllItemName() async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient.rawDelete('DELETE FROM ${tb.name}');
    return res;
  }

  Future<EnumResultDb> update(ItemName itemName) async {

    bool isDup = await this.isDuplicate(itemName);
    if(isDup){
      return EnumResultDb.duplicate;
    }else{
      var dbClient = await DatabaseHelper().db;

      int res = await dbClient.update(tb.name, itemName.toMap(),
          where: "${tb.fId} = ?", whereArgs: <int>[itemName.id]);
      return res > 0 ? EnumResultDb.success : EnumResultDb.failed;
    }

  }

  Future<ResultDb> updateBatch(List<ItemName> litemName) async {
    ResultDb resultDb = new ResultDb(null);
    try {
      var dbClient = await DatabaseHelper().db;
      var batch = dbClient.batch();
      for (int i = 0; i < litemName.length; i++) {
        ItemName itemName = litemName[i];
        batch.update(tb.name, itemName.toMap(),
            where: "${tb.fId} = ?", whereArgs: <int>[itemName.id]);
      }
      await batch.commit(noResult: true);
      resultDb.enumResultDb = EnumResultDb.success;
      return resultDb;
    } catch (e) {
      resultDb.enumResultDb = EnumResultDb.failed;
      return resultDb;
    }
  }

//  Future<EnumResultDb> updateKeOtherKategori(ItemName itemName) async {
//    var dbClient = await DatabaseHelper().db;
//
//    int res = await dbClient.update(tb.name, itemName.toMap(),
//        where: "${tb.fId} = ?", whereArgs: <int>[itemName.id]);
//    return res > 0 ? EnumResultDb.success : EnumResultDb.failed;
//  }
}

class UiItemNamesLazy {
  List<ItemName> listPengeluaran;
  List<ItemName> listPemasukan;

  UiItemNamesLazy(this.listPengeluaran, this.listPemasukan);
}
