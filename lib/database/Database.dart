import 'dart:async';
import 'dart:io' as io;

import 'package:keuangan/util/global_string_database.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

//  void _onUpgrade(Database db, int versio) async {
//    await db.execute("DROP TABLE ${GSD.tableSpecialDay}");
//    await db.execute(
//        "CREATE TABLE ${GSD.tableSpecialDay}(${GSD.sdId} INTEGER PRIMARY KEY, ${GSD.sdTanggal} TEXT,${GSD.sdArrayTanggal} TEXT, ${GSD.sdStringTanggal} TEXT)");
//  }

  void _onCreate(Database db, int version) async {
    TbTodolistItem tbTodolistItem = new TbTodolistItem();
    TbTodolist tbTodolist = new TbTodolist();
    TbKategori tbKategori = new TbKategori();
    TbItemName tbItemName = new TbItemName();
    TbKeuangan tbKeuangan = new TbKeuangan();
    TbSetup tbSetup = new TbSetup();
    // When creating the db, create the table

//    await db.execute(
//        "CREATE TABLE ${GSD.tableEvent}(${GSD.evId} INTEGER PRIMARY KEY, ${GSD.evArrayTanggal} TEXT, ${GSD.evStringEvent} TEXT)");
//    await db.execute(
//        "CREATE TABLE ${GSD.tableEventBulan}(${GSD.evBlnId} INTEGER PRIMARY KEY, ${GSD.evBlnKeyEvent} INTEGER, ${GSD.evBlnTanggal} TEXT)");
//    await db.execute(
//        "CREATE TABLE ${GSD.tableSpecialDay}(${GSD.sdId} INTEGER PRIMARY KEY, ${GSD.sdTanggal} TEXT,${GSD.sdArrayTanggal} TEXT, ${GSD.sdStringTanggal} TEXT)");
    await db.execute(
        "CREATE TABLE ${tbTodolist.name}(${tbTodolist.fId} INTEGER PRIMARY KEY, "
            "${tbTodolist.fTanggal} TEXT)");
    await db.execute(
        "CREATE TABLE ${tbTodolistItem.name}(${tbTodolistItem.fId} INTEGER PRIMARY KEY, "
            "${tbTodolistItem.fIdTodolist} INTEGER,"
            "${tbTodolistItem.fNoUrut} INTEGER,"
            "${tbTodolistItem.fText} TEXT,"
            "${tbTodolistItem.fIsChecked} INTEGER)");
    await db.execute(
        "CREATE TABLE "
            "${tbKategori.name}(${tbKategori.fId} INTEGER PRIMARY KEY, "
            "${tbKategori.fNama} TEXT, "
            "${tbKategori.fIdParent} INTEGER ,"
            "${tbKategori.fType} INTEGER,"
            "${tbKategori.fCatatan} TEXT,"
            "${tbKategori.fColor} TEXT)");
    await db.execute(
        "CREATE TABLE ${tbItemName.name}(${tbItemName.fId} INTEGER PRIMARY KEY, "
            "${tbItemName.fNama} TEXT, "
            "${tbItemName.fIdKategori} INTEGER)");
    await db.execute(
        "CREATE TABLE ${tbKeuangan.name}(${tbKeuangan.fId} INTEGER PRIMARY KEY, "
            "${tbKeuangan.fTgl} TEXT, "
            "${tbKeuangan.fIdItemName} INTEGER,"
            "${tbKeuangan.fJumlah} REAL,"
            "${tbKeuangan.fCatatan} TEXT)");

    await db.execute(
        "CREATE TABLE ${tbSetup.name}(${tbSetup.fId} INTEGER PRIMARY KEY, "
            "${tbSetup.fNama} TEXT, "
            "${tbSetup.fTglInput} TEXT,"
            "${tbSetup.fIsSuccess} INTEGER)");
  }
}
