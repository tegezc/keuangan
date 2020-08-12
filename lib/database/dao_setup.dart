import 'package:keuangan/database/Database.dart';
import 'package:keuangan/database/db_utility.dart';
import 'package:keuangan/model/setup.dart';
import 'package:keuangan/util/global_string_database.dart';

/// DOKUMENTASI NILAI VARIABLE
/// [FLAG_FIRSTIME] penanda install pertama kali
class DaoSetup {
  TbSetup tb = new TbSetup();
  DbUtility _dbUtility = new DbUtility();

  Future<int> saveSetup(Setup setup) async {
    setup.setTanggalInput(_dbUtility.generateDateToMiliseconds());
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient.insert(tb.name, setup.toMap());
    return res;
  }

  Future<Setup> getSetupByNama(String nama) async {
    var dbClient = await DatabaseHelper().db;
    String lowerName = nama.toLowerCase().trim();
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM ${tb.name} WHERE ${tb.fNama} = \'$lowerName\' COLLATE NOCASE');
    Setup setup;
    if (list.length > 0) {
      setup = new Setup(
          list[0][tb.fNama], list[0][tb.fValue], list[0][tb.fTglInput]);
    }
    return setup;
  }

  Future<List<Setup>> getAllSetup() async {
    var dbClient = await DatabaseHelper().db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM ${tb.name} ORDER BY ${tb.fTglInput} ASC');

    List<Setup> listOfSetup = new List();
    for (int i = 0; i < list.length; i++) {
      var setup = new Setup(
          list[i][tb.fNama], list[i][tb.fValue], list[i][tb.fTglInput]);

      setup.setId(list[i][tb.fId]);

      listOfSetup.add(setup);
    }

    return listOfSetup;
  }

  Future<int> deleteSetup(Setup setup) async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient
        .rawDelete('DELETE FROM ${tb.name} WHERE ${tb.fId} = ?', [setup.id]);
    return res;
  }

  Future<int> deleteAllSetup() async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient.rawDelete('DELETE FROM ${tb.name}');
    return res;
  }

  Future<bool> update(Setup setup) async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient.update(tb.name, setup.toMap(),
        where: "${tb.fId} = ?", whereArgs: <int>[setup.id]);
    return res > 0 ? true : false;
  }
}
