import 'package:keuangan/database/Database.dart';
import 'package:keuangan/model/setup.dart';
import 'package:keuangan/util/global_string_database.dart';

class DaoSetup {
  TbSetup tb = new TbSetup();

  Future<int> saveSetup(Setup setup) async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient.insert(tb.name, setup.toMap());
    return res;
  }


  Future<List<Setup>> getAllSetup() async {
    var dbClient = await DatabaseHelper().db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM ${tb.name} ORDER BY ${tb.fTglInput} ASC');

    List<Setup> listOfSetup = new List();
    for (int i = 0; i < list.length; i++) {
      var setup = new Setup(list[i][tb.fNama],list[i][tb.fTglInput],list[i][tb.fIsSuccess]);

      setup.setId(list[i][tb.fId]);

      listOfSetup.add(setup);
    }

    return listOfSetup;
  }

  Future<int> deleteSetup(Setup setup) async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient.rawDelete(
        'DELETE FROM ${tb.name} WHERE ${tb.fId} = ?', [setup.id]);
    return res;
  }


  Future<int> deleteAllSetup() async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient.rawDelete(
        'DELETE FROM ${tb.name}');
    return res;
  }

  Future<bool> update(Setup setup) async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient.update(tb.name, setup.toMap(),
        where: "${tb.fId} = ?", whereArgs: <int>[setup.id]);
    return res > 0 ? true : false;
  }
}

