import 'package:keuangan/database/Database.dart';
import 'package:keuangan/database/db_utility.dart';
import 'package:keuangan/database/keuangan/dao_itemname.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/global_string_database.dart';
import 'package:keuangan/util/process_string.dart';

class DaoKeuangan {
  TbKeuangan tb = new TbKeuangan();
  DbUtility _dbUtility = new DbUtility();

  Future<int> saveKeuangan(Keuangan keuangan) async {
    /// set jenis transaksi
    DaoItemName daoItemName = new DaoItemName();
    ItemName itemName = await daoItemName.getItemNameById(keuangan.idItemName);
    DaoKategori daoKategori = new DaoKategori();
    Kategori kategori = await daoKategori.getKategoriById(itemName.idKategori);
    int jnsTransaksi = 1; // nilai lihat dimodel keuangan
    if (kategori.type == EnumJenisTransaksi.pengeluaran) {
      jnsTransaksi = 0;
    }

    keuangan.setJenisTransaksi(jnsTransaksi);

    /// set lastupdate
    keuangan.setLastupdate(_dbUtility.generateDateToMiliseconds());

    ///  set realId
    keuangan.setRealId(_dbUtility.generateId());

    if (keuangan.isValid()) {
      var dbClient = await DatabaseHelper().db;
      int res = await dbClient.insert(tb.name, keuangan.toMap());

      return res;
    }
    return 0;
  }

  Future<int> saveKeuanganForTesting(Keuangan keuangan) async {
    /// set jenis transaksi
    DaoItemName daoItemName = new DaoItemName();
    ItemName itemName = await daoItemName.getItemNameById(keuangan.idItemName);
    DaoKategori daoKategori = new DaoKategori();
    Kategori kategori = await daoKategori.getKategoriById(itemName.idKategori);
    int jnsTransaksi = 1; // nilai lihat dimodel keuangan
    if (kategori.type == EnumJenisTransaksi.pengeluaran) {
      jnsTransaksi = 0;
    }

    keuangan.setJenisTransaksi(jnsTransaksi);

    /// set lastupdate
    keuangan.setLastupdate(_dbUtility.generateDateToMiliseconds());


    if (keuangan.isValid()) {
      var dbClient = await DatabaseHelper().db;
      int res = await dbClient.insert(tb.name, keuangan.toMap());

      return res;
    }
    return 0;
  }

//  Future<List<Keuangan>> getAllKeuangan() async {
//    var dbClient = await DatabaseHelper().db;
//    List<Map> list = await dbClient.rawQuery('SELECT * FROM ${tb.name}');
//    List<Keuangan> keuangans = new List();
//    for (int i = 0; i < list.length; i++) {
//      var keuangan = new Keuangan.fromDB(
//          list[i][tb.fTgl],
//          list[i][tb.fIdItemName],
//          list[i][tb.fJumlah],
//          list[i][tb.fCatatan],
//          list[i][tb.fLastUpdate]);
//      keuangan.setId(list[i][tb.fId]);
//
//      keuangans.add(keuangan);
//    }
//    return keuangans;
//  }

  Future<List<Keuangan>> get5LastKeuanganLazy() async {
    DaoItemName daoItemName = new DaoItemName();
    DaoKategori daoKategori = new DaoKategori();
    var dbClient = await DatabaseHelper().db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM ${tb.name} ORDER BY ${tb.fLastUpdate} DESC limit 5');
    List<Keuangan> keuangans = new List();
    for (int i = 0; i < list.length; i++) {
      Keuangan keuangan = new Keuangan.fromDB(
          list[i][tb.realId],
          list[i][tb.fTgl],
          list[i][tb.fIdItemName],
          list[i][tb.fJumlah],
          list[i][tb.fCatatan],
          list[i][tb.fLastUpdate],
          list[i][tb.fJenisTransaksi]);
      keuangan.setId(list[i][tb.fId]);

      /// lazy di process
      int iditemname = keuangan.idItemName;
      ItemName itemName = await daoItemName.getItemNameById(iditemname);
      Kategori k = await daoKategori.getKategoriById(itemName.idKategori);
      itemName.setKategori(k);
      keuangan.lazyItemName = itemName;
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
        'SELECT * FROM ${tb.name} WHERE ${tb.fTgl} BETWEEN \'$strStartDate\' AND \'$strEndDate\'  ORDER BY date(${tb.fTgl}) DESC');
    List<Keuangan> keuangans = new List();
    for (int i = 0; i < list.length; i++) {
      Keuangan keuangan = new Keuangan.fromDB(
          list[i][tb.realId],
          list[i][tb.fTgl],
          list[i][tb.fIdItemName],
          list[i][tb.fJumlah],
          list[i][tb.fCatatan],
          list[i][tb.fLastUpdate],
          list[i][tb.fJenisTransaksi]);
      keuangan.setId(list[i][tb.fId]);

      keuangans.add(keuangan);
    }
    return keuangans;
  }

  Future<List<Keuangan>> getKeuanganByPeriodeAndJenisTransaksi(
      EnumJenisTransaksi enumJenisTransaksi,
      DateTime startDate,
      DateTime endDate) async {
    ProcessString processString = new ProcessString();
    String strStartDate = processString.dateFormatForDB(startDate);
    String strEndDate = processString.dateFormatForDB(endDate);

    int jnsTransaksi = 1; // nilai lihat di model keuangan
    if (enumJenisTransaksi == EnumJenisTransaksi.pengeluaran) {
      jnsTransaksi = 0;
    }

    var dbClient = await DatabaseHelper().db;

    String sql =
        'SELECT * FROM ${tb.name} WHERE ${tb.fJenisTransaksi}=$jnsTransaksi AND ${tb.fTgl} BETWEEN \'$strStartDate\' AND \'$strEndDate\' ORDER BY date(${tb.fTgl}) DESC';

    List<Map> list = await dbClient.rawQuery(sql);
    List<Keuangan> keuangans = new List();
    for (int i = 0; i < list.length; i++) {
      Keuangan keuangan = new Keuangan.fromDB(
          list[i][tb.realId],
          list[i][tb.fTgl],
          list[i][tb.fIdItemName],
          list[i][tb.fJumlah],
          list[i][tb.fCatatan],
          list[i][tb.fLastUpdate],
          list[i][tb.fJenisTransaksi]);
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
            list[0][tb.realId],
            list[0][tb.fTgl],
            list[0][tb.fIdItemName],
            list[0][tb.fJumlah],
            list[0][tb.fCatatan],
            list[0][tb.fLastUpdate],
            list[0][tb.fJenisTransaksi]);
        keuangan.setId(list[0][tb.fId]);
      }
    }

    return keuangan;
  }

  Future<double> getSum(EnumJenisTransaksi jt)async{
    var dbClient = await DatabaseHelper().db;

    int type = 0; // nilai check di model keuangan
    if (jt == EnumJenisTransaksi.pemasukan) {
      type = 1;
    }

    String str = 'SELECT SUM(jumlah) as total FROM ${tb.name} WHERE ${tb.fJenisTransaksi}=$type';

    List<dynamic> list = await dbClient.rawQuery(str);

   if(list != null){
     if(list.isNotEmpty){
       double sumtotal = list[0]['total'];
       return sumtotal;
     }
   }
   return 0.0;
  }

  Future<List<Keuangan>> getKeuanganByJenisTransaksi(
      EnumJenisTransaksi jt) async {
    var dbClient = await DatabaseHelper().db;

    int type = 0; // nilai check di model keuangan
    if (jt == EnumJenisTransaksi.pemasukan) {
      type = 1;
    }
//    TbKategori tbKategori = new TbKategori();
//    TbItemName tbItemName = new TbItemName();
//    String str = 'SELECT * FROM ${tb.name} k '
//        'JOIN ${tbItemName.name} itn ON k.${tb.fIdItemName}=itn.${tbItemName.fId} '
//        'JOIN ${tbKategori.name} kt ON itn.${tbItemName.fIdKategori}=kt.${tbKategori.fId} where kt.${tbKategori.fType}=$type';

    String str = 'SELECT * FROM ${tb.name} WHERE ${tb.fJenisTransaksi}=$type ORDER BY date(${tb.fTgl}) DESC';

    List<Map> list = await dbClient.rawQuery(str);

    List<Keuangan> keuangans = new List();
    for (int i = 0; i < list.length; i++) {
      Keuangan keuangan = new Keuangan.fromDB(
          list[i][tb.realId],
          list[i][tb.fTgl],
          list[i][tb.fIdItemName],
          list[i][tb.fJumlah],
          list[i][tb.fCatatan],
          list[i][tb.fLastUpdate],
          list[i][tb.fJenisTransaksi]);
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

  Future<bool> update1(Keuangan keuangan) async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient.update(tb.name, keuangan.toMap(),
        where: "${tb.fId} = ?", whereArgs: <int>[keuangan.id]);
    return res > 0 ? true : false;
  }
}
