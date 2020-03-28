import 'dart:async';

import 'package:keuangan/database/Database.dart';
import 'package:keuangan/model/event.dart';
import 'package:keuangan/util/global_string_database.dart';

class DaoEvent {
  TbEvent tb = new TbEvent();
  Future<int> saveEvent(Event event) async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient.insert(tb.name, event.toMap());
    return res;
  }

  Future<Map<int, Event>> getAllEvent() async {
    var dbClient = await DatabaseHelper().db;
    // var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM ${tb.name}');
    Map<int, Event> mapEvent = new Map();
    for (int i = 0; i < list.length; i++) {
      var event =
          new Event(list[i][tb.fArrayTanggal], list[i][tb.fStringEvent]);
      event.setId(list[i][tb.fId]);
      mapEvent[list[i][tb.fId]] = event;
    }
    return mapEvent;
  }

  Future<int> deleteEvents(Event event) async {
    var dbClient = await DatabaseHelper().db;

    int res = await dbClient.rawDelete(
        'DELETE FROM ${tb.name} WHERE ${tb.fId} = ?', [event.id]);
    return res;
  }

  Future<bool> update(Event event) async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient.update(tb.name, event.toMap(),
        where: "${tb.fId} = ?", whereArgs: <int>[event.id]);
    return res > 0 ? true : false;
  }
}

//=======================================================
class DaoEventTanggal {
  TbEventBulan tb = new TbEventBulan();
  Future<int> saveEventTanggal(EventTanggal eventTanggal) async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient.insert(tb.name, eventTanggal.toMap());
    return res;
  }

  Future<Map<String, List<EventTanggal>>> getAllEventTanggal() async {
    var dbClient = await DatabaseHelper().db;
    // var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM ${tb.name}');
    Map<String, List<EventTanggal>> mapBlnTanggal = new Map();
    for (int i = 0; i < list.length; i++) {
      var eventTanggal = new EventTanggal(
          list[i][tb.fKeyEvent], list[i][tb.fTanggal]);
      eventTanggal.setId(list[i][tb.fId]);

      if (mapBlnTanggal[list[i][tb.fTanggal]] == null) {
        List<EventTanggal> lEB = new List();
        lEB.add(eventTanggal);
        mapBlnTanggal[list[i][tb.fTanggal]] = lEB;
      } else {
        List<EventTanggal> lEB = mapBlnTanggal[list[i][tb.fTanggal]];
        lEB.add(eventTanggal);
        mapBlnTanggal[list[i][tb.fTanggal]] = lEB;
      }
    }
    return mapBlnTanggal;
  }

  Future<List<EventTanggal>> getEventTanggal(String tanggal) async {
    var dbClient = await DatabaseHelper().db;
    // var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM  ${tb.name} WHERE ${tb.fTanggal}=$tanggal');
    List<EventTanggal> listETanggal = new List();
    for (int i = 0; i < list.length; i++) {
      var eventTanggal = new EventTanggal(
          list[i][tb.fKeyEvent], list[i][tb.fTanggal]);
      eventTanggal.setId(list[i][tb.fId]);
      listETanggal.add(eventTanggal);
    }
    return listETanggal;
  }

  Future<int> deleteEvents(EventTanggal eventTanggal) async {
    var dbClient = await DatabaseHelper().db;

    int res = await dbClient.rawDelete(
        'DELETE FROM ${tb.name} WHERE ${tb.fId} = ?',
        [eventTanggal.id]);
    return res;
  }

  Future<bool> update(EventTanggal eventTanggal) async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient.update(tb.name, eventTanggal.toMap(),
        where: "${tb.fId} = ?", whereArgs: <int>[eventTanggal.id]);
    return res > 0 ? true : false;
  }
}

//============================
class DaoSpecialDay {
  TbSpecialDay tb = new TbSpecialDay();
  Future<int> saveSpecialDay(SpecialDay specialDay) async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient.insert(tb.tableSpecialDay, specialDay.toMap());
    return res;
  }

  Future<List<dynamic>> saveBatchSpecialDay(
      List<SpecialDay> specialDays) async {
    var dbClient = await DatabaseHelper().db;
    var batch = dbClient.batch();
    for (int i = 0; i < specialDays.length; i++) {
      batch.insert(tb.tableSpecialDay, specialDays[i].toMap());
    }
    var results = await batch.commit();
    return results;
  }

  Future<Map<String, SpecialDay>> getAllSpecialDay() async {
    var dbClient = await DatabaseHelper().db;
    // var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM ${tb.tableSpecialDay}');

    Map<String, SpecialDay> mapSD = new Map();
    for (int i = 0; i < list.length; i++) {
      var specialDay = new SpecialDay(list[i][tb.sdTanggal],
          list[i][tb.sdArrayTanggal], list[i][tb.sdStringTanggal]);
      specialDay.setId(list[i][tb.sdId]);

      mapSD[specialDay.keyTanggal] = specialDay;
    }

    return mapSD;
  }

  Future<int> deleteSpecialDay(SpecialDay specialDay) async {
    var dbClient = await DatabaseHelper().db;

    int res = await dbClient.rawDelete(
        'DELETE FROM ${tb.tableSpecialDay} WHERE ${tb.sdId} = ?',
        [specialDay.id]);
    return res;
  }

  Future<bool> update(SpecialDay specialDay) async {
    var dbClient = await DatabaseHelper().db;
    int res = await dbClient.update(tb.tableSpecialDay, specialDay.toMap(),
        where: "${tb.sdId} = ?", whereArgs: <int>[specialDay.id]);
    return res > 0 ? true : false;
  }
}

