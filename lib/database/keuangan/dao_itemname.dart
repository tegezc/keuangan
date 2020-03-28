import 'package:keuangan/model/enum_db.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/global_string_database.dart';

import '../Database.dart';

class DaoItemName {
  TbItemName tb = new TbItemName();

  Future<int> saveItemName(ItemName itemName) async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient.insert(tb.name, itemName.toMap());

    return res;
  }

  Future<List<ItemName>> getAllItemName() async {
    var dbClient = await DatabaseHelper().db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM ${tb.name}');

    List<ItemName> itemNames = new List();
    for (int i = 0; i < list.length; i++) {
      var itemName = new ItemName(list[i][tb.fNama], list[i][tb.fIdKategori]);
      itemName.setId(list[i][tb.fId]);

      itemNames.add(itemName);
    }
    return itemNames;
  }

  Future<Map<int, ItemName>> getAllItemNameMap() async {
    var dbClient = await DatabaseHelper().db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM ${tb.name}');

    Map<int, ItemName> itemNameMap = new Map();
    for (int i = 0; i < list.length; i++) {
      var itemName = new ItemName(list[i][tb.fNama], list[i][tb.fIdKategori]);
      itemName.setId(list[i][tb.fId]);

      itemNameMap[list[i][tb.fId]] = itemName;
    }
    return itemNameMap;
  }

  Future<ItemName> getItemNameById(int id) async {
    var dbClient = await DatabaseHelper().db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM ${tb.name} WHERE ${tb.fId}=$id');
    ItemName itemName;
    if (list.length > 0) {
      itemName = new ItemName(list[0][tb.fNama], list[0][tb.fIdKategori]);
      itemName.setId(list[0][tb.fId]);
    }
    return itemName;
  }

  Future<ItemName> getItemNameByNamaNIdKategori(
      String nama, int idKategori) async {
    String lowerName = nama.toLowerCase().trim();
    var dbClient = await DatabaseHelper().db;
    String query =
        'SELECT * FROM ${tb.name} WHERE ${tb.fIdKategori}=$idKategori AND ${tb.fNama} = \'$lowerName\' COLLATE NOCASE';
    List<Map> list = await dbClient.rawQuery(query);

    ItemName itemName;
    if (list.length > 0) {
      itemName = new ItemName(list[0][tb.fNama], list[0][tb.fIdKategori]);
      itemName.setId(list[0][tb.fId]);
    }
    return itemName;
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
    ItemName k = await this
        .getItemNameByNamaNIdKategori(itemName.nama, itemName.idKategori);
    var dbClient = await DatabaseHelper().db;
    if (k == null) {
      int res = await dbClient.update(tb.name, itemName.toMap(),
          where: "${tb.fId} = ?", whereArgs: <int>[itemName.id]);
      return res > 0 ? EnumResultDb.success : EnumResultDb.failed;
    } else {
      if (k.id == itemName.id) {
        return EnumResultDb.success;
      } else {
        return EnumResultDb.duplicate;
      }
    }
  }
}
