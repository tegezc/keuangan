import 'package:keuangan/database/Database.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/global_string_database.dart';
import 'package:keuangan/util/process_string.dart';

class DaoKeuangan {
  TbKeuangan tb = new TbKeuangan();

  Future<int> saveKeuangan(Keuangan keuangan) async {
    if (keuangan.isValid()) {
      var dbClient = await DatabaseHelper().db;
      int res = await dbClient.insert(tb.name, keuangan.toMap());

      return res;
    }
    return 0;

    ///failed save record
  }

  Future<List<Keuangan>> getAllKeuangan() async {
    var dbClient = await DatabaseHelper().db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM ${tb.name}');
    List<Keuangan> keuangans = new List();
    for (int i = 0; i < list.length; i++) {
      var keuangan = new Keuangan.fromDB(
          list[i][tb.fTgl],
          list[i][tb.fIdItemName],
          list[i][tb.fJumlah],
          list[i][tb.fCatatan],
          list[i][tb.fLastUpdate]);
      keuangan.setId(list[i][tb.fId]);

      keuangans.add(keuangan);
    }
    return keuangans;
  }

  Future<List<Keuangan>> get5LastKeuangan() async {
    var dbClient = await DatabaseHelper().db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM ${tb.name} ORDER BY ${tb.fLastUpdate} DESC limit 5');
    List<Keuangan> keuangans = new List();
    for (int i = 0; i < list.length; i++) {
      var keuangan = new Keuangan.fromDB(
          list[i][tb.fTgl],
          list[i][tb.fIdItemName],
          list[i][tb.fJumlah],
          list[i][tb.fCatatan],
          list[i][tb.fLastUpdate]);
      keuangan.setId(list[i][tb.fId]);

      keuangans.add(keuangan);
    }
    return keuangans;
  }

  Future<List<Keuangan>> getKeuanganByPeriode(
      DateTime startDate, DateTime endDate) async {
    ProcessString processString = new ProcessString();
    String strStartDate = processString.dateFormatForDB(startDate);
    String strEndDate = processString.dateFormatForDB(endDate);
    var dbClient = await DatabaseHelper().db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM ${tb.name} WHERE ${tb.fTgl} BETWEEN \'$strStartDate\' AND \'$strEndDate\'  ORDER BY date(${tb.fTgl}) ASC');
    List<Keuangan> keuangans = new List();
    for (int i = 0; i < list.length; i++) {
      var keuangan = new Keuangan.fromDB(
          list[i][tb.fTgl],
          list[i][tb.fIdItemName],
          list[i][tb.fJumlah],
          list[i][tb.fCatatan],
          list[i][tb.fLastUpdate]);
      keuangan.setId(list[i][tb.fId]);

      keuangans.add(keuangan);
    }
    return keuangans;
  }

  Future<Keuangan> getKeuanganById(int id) async {
    var dbClient = await DatabaseHelper().db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM ${tb.name} WHERE ${tb.fId}=$id');

    Keuangan keuangan;
    if (list != null) {
      if (list.length > 0) {
        keuangan = new Keuangan.fromDB(
            list[0][tb.fTgl],
            list[0][tb.fIdItemName],
            list[0][tb.fJumlah],
            list[0][tb.fCatatan],
            list[0][tb.fLastUpdate]);
        keuangan.setId(list[0][tb.fId]);
      }
    }

    return keuangan;
  }

  Future<List<Keuangan>> getKeuanganByJenisTransaksi(
      EnumJenisTransaksi jt) async {
    TbKategori tbKategori = new TbKategori();
    TbItemName tbItemName = new TbItemName();
    var dbClient = await DatabaseHelper().db;
    int type = jt.index;
    String str = 'SELECT * FROM ${tb.name} k '
        'JOIN ${tbItemName.name} itn ON k.${tb.fIdItemName}=itn.${tbItemName.fId} '
        'JOIN ${tbKategori.name} kt ON itn.${tbItemName.fIdKategori}=kt.${tbKategori.fId} where kt.${tbKategori.fType}=$type';

    List<Map> list = await dbClient.rawQuery(str);

    List<Keuangan> keuangans = new List();
    for (int i = 0; i < list.length; i++) {
      var keuangan = new Keuangan.fromDB(
          list[i][tb.fTgl],
          list[i][tb.fIdItemName],
          list[i][tb.fJumlah],
          list[i][tb.fCatatan],
          list[i][tb.fLastUpdate]);
      keuangan.setId(list[i][tb.fId]);

      keuangans.add(keuangan);
    }
    return keuangans;
  }

  Future<int> deleteKeuangan(Keuangan keuangan) async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient
        .rawDelete('DELETE FROM ${tb.name} WHERE ${tb.fId} = ?', [keuangan.id]);
    return res;
  }

  Future<int> deleteAllKeuangan() async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient.rawDelete('DELETE FROM ${tb.name}');
    return res;
  }

  Future<bool> update(Keuangan keuangan) async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient.update(tb.name, keuangan.toMap(),
        where: "${tb.fId} = ?", whereArgs: <int>[keuangan.id]);
    return res > 0 ? true : false;
  }
}
