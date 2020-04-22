import 'package:keuangan/model/enum_db.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/global_string_database.dart';

import '../Database.dart';
import '../db_utility.dart';

class DaoKategori {
  TbKategori tb = new TbKategori();

  Future<ResultDb> saveKategori(Kategori kategori) async {
    ResultDb rdb = new ResultDb(null);
    Kategori k = await this.getKategoriByNameAndCategori(
        kategori.nama, kategori.idParent, kategori.type);

    if (k == null) {
      var dbClient = await DatabaseHelper().db;
      int res = await dbClient.insert(tb.name, kategori.toMap());

      if (res > 1) {
        rdb.enumResultDb = EnumResultDb.success;
        rdb.value = res;
      } else {
        rdb.enumResultDb = EnumResultDb.failed;
      }
    } else {
      rdb.enumResultDb = EnumResultDb.duplicate;
    }

    return rdb;
  }

  Future<Kategori> getDefaultKategori(EnumJenisTransaksi enumJenisTransaksi) async {
    var dbClient = await DatabaseHelper().db;
    int i = 1;
    if(enumJenisTransaksi == EnumJenisTransaksi.pengeluaran){
      i = 0;
    }
    List<Map> list =
    await dbClient.rawQuery('SELECT * FROM ${tb.name} WHERE ${tb.fIsAbadi}=1 AND ${tb.fType}=$i');
    Kategori kategori;
    if (list.length > 0) {
      EnumJenisTransaksi type = EnumJenisTransaksi.values[list[0][tb.fType]];
      kategori = new Kategori(list[0][tb.fNama], list[0][tb.fIdParent],
          type, list[0][tb.fCatatan],list[0][tb.fColor]);
      kategori.setId(list[0][tb.fId]);
    }
    return kategori;
  }

  Future<List<Kategori>> getAllKategori() async {
    var dbClient = await DatabaseHelper().db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM ${tb.name}');

    List<Kategori> kategories = new List();
    for (int i = 0; i < list.length; i++) {
      EnumJenisTransaksi type = EnumJenisTransaksi.values[list[i][tb.fType]];
      var kategori = new Kategori(list[i][tb.fNama], list[i][tb.fIdParent],
          type, list[i][tb.fCatatan],list[i][tb.fColor]);
      kategori.setId(list[i][tb.fId]);

      kategories.add(kategori);
    }

    return kategories;
  }

  Future<List<Kategori>> getMainKategoriByJenisTrxTanpaAbadi(EnumJenisTransaksi enumJenisTransaksi) async {
    var dbClient = await DatabaseHelper().db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM ${tb.name} WHERE ${tb.fIdParent}=0 AND ${tb.fType}=${enumJenisTransaksi.index} AND ${tb.fIsAbadi}=0');

    List<Kategori> kategories = new List();
    for (int i = 0; i < list.length; i++) {
      EnumJenisTransaksi type = EnumJenisTransaksi.values[list[i][tb.fType]];
      var kategori = new Kategori(list[i][tb.fNama], list[i][tb.fIdParent],
          type, list[i][tb.fCatatan],list[i][tb.fColor]);
      kategori.setId(list[i][tb.fId]);

      kategories.add(kategori);
    }

    return kategories;
  }

  Future<List<Kategori>> getAllMainKategori() async {
    var dbClient = await DatabaseHelper().db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM ${tb.name} WHERE ${tb.fIdParent}=0');

    List<Kategori> kategories = new List();
    for (int i = 0; i < list.length; i++) {
      EnumJenisTransaksi type = EnumJenisTransaksi.values[list[i][tb.fType]];
      var kategori = new Kategori(list[i][tb.fNama], list[i][tb.fIdParent],
          type, list[i][tb.fCatatan],list[i][tb.fColor]);
      kategori.setId(list[i][tb.fId]);

      kategories.add(kategori);
    }

    return kategories;
  }

  Future<List<Kategori>> getSubkategori(int idParent) async {
    var dbClient = await DatabaseHelper().db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM ${tb.name} WHERE ${tb.fIdParent}=$idParent');

    List<Kategori> kategories = new List();
    for (int i = 0; i < list.length; i++) {
      EnumJenisTransaksi type = EnumJenisTransaksi.values[list[i][tb.fType]];
      var kategori = new Kategori(list[i][tb.fNama], list[i][tb.fIdParent],
          type, list[i][tb.fCatatan],list[i][tb.fColor]);
      kategori.setId(list[i][tb.fId]);

      kategories.add(kategori);
    }

    return kategories;
  }

  Future<Map<int, Kategori>> getAllKategoriMap() async {
    var dbClient = await DatabaseHelper().db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM ${tb.name}');

    Map<int, Kategori> mapKtgr = new Map();
    for (int i = 0; i < list.length; i++) {
      EnumJenisTransaksi type = EnumJenisTransaksi.values[list[i][tb.fType]];
      var kategori = new Kategori(list[i][tb.fNama], list[i][tb.fIdParent],
          type, list[i][tb.fCatatan],list[i][tb.fColor]);
      kategori.setId(list[i][tb.fId]);

      mapKtgr[list[i][tb.fId]] = kategori;
    }

    return mapKtgr;
  }

  Future<Kategori> getKategoriByNameAndCategori(
      String name, int idparent, EnumJenisTransaksi tp) async {
    int type = tp.index;
    String lowerName = name.toLowerCase().trim();
    var dbClient = await DatabaseHelper().db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM ${tb.name} WHERE ${tb.fIdParent}=$idparent AND ${tb.fType}=$type AND ${tb.fNama} = \'$lowerName\' COLLATE NOCASE');
    Kategori kategori;
    if (list.length > 0) {
      EnumJenisTransaksi type = EnumJenisTransaksi.values[list[0][tb.fType]];
      kategori = new Kategori(list[0][tb.fNama], list[0][tb.fIdParent],
          type, list[0][tb.fCatatan],list[0][tb.fColor]);
      kategori.setId(list[0][tb.fId]);
    }
    return kategori;
  }

  Future<Kategori> getKategoriById(int id) async {
    var dbClient = await DatabaseHelper().db;
    List<Map> list =
    await dbClient.rawQuery('SELECT * FROM ${tb.name} WHERE ${tb.fId}=$id');
    Kategori kategori;
    if (list.length > 0) {
      EnumJenisTransaksi type = EnumJenisTransaksi.values[list[0][tb.fType]];
      kategori = new Kategori(list[0][tb.fNama], list[0][tb.fIdParent],
          type, list[0][tb.fCatatan],list[0][tb.fColor]);
      kategori.setId(list[0][tb.fId]);
    }
    return kategori;
  }

  Future<int> deleteKategori(Kategori kategori) async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient
        .rawDelete('DELETE FROM ${tb.name} WHERE ${tb.fId} = ?', [kategori.id]);
    return res;
  }

  Future<int> deleteAllKategori() async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient.rawDelete('DELETE FROM ${tb.name}');
    return res;
  }

  /// pada case: kategori di edit, dimana hasil editannya ternyata duplikat.
  Future<EnumResultDb> update(Kategori kategori) async {
    Kategori k = await this.getKategoriByNameAndCategori(
        kategori.nama, kategori.idParent, kategori.type);
    var dbClient = await DatabaseHelper().db;
    if (k == null) {
      int res = await dbClient.update(tb.name, kategori.toMap(),
          where: "${tb.fId} = ?", whereArgs: <int>[kategori.id]);
      return res > 0 ? EnumResultDb.success : EnumResultDb.failed;
    } else {
      if (k.id == kategori.id) {
        int res = await dbClient.update(tb.name, kategori.toMap(),
            where: "${tb.fId} = ?", whereArgs: <int>[kategori.id]);
        return res > 0 ? EnumResultDb.success : EnumResultDb.failed;
      } else {
        return EnumResultDb.duplicate;
      }
    }
  }
}