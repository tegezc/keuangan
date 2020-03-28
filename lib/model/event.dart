import 'package:keuangan/util/global_string_database.dart';

class Event {
  TbEvent tb = new TbEvent();
  int id;
  String _arrayTanggal;
  String _stringEvent;

  Event( this._arrayTanggal, this._stringEvent);

  String get arrayTanggal => _arrayTanggal;

  String get stringEvent => _stringEvent;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[tb.fArrayTanggal] = _arrayTanggal;
    map[tb.fStringEvent] = _stringEvent;
    return map;
  }

  void setId(int id) {
    this.id = id;
  }
}

class EventTanggal {
  TbEventBulan tb = new TbEventBulan();
  int id;
  int _keyEvent;//1 or 2 or 3 dst
  String _tanggalEvent; //2019-01

  EventTanggal(this._keyEvent, this._tanggalEvent);

  int get keyEvent => _keyEvent;

  String get tanggalEvent => _tanggalEvent;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[tb.fKeyEvent] = _keyEvent;
    map[tb.fTanggal] = _tanggalEvent;
    return map;
  }

  void setId(int id) {
    this.id = id;
  }

}

class SpecialDay{
  TbSpecialDay tb = new TbSpecialDay();
  int id;
  String _tanggal;
  String _arrayTanggal;
  String _stringDay;

  SpecialDay(this._tanggal, this._arrayTanggal, this._stringDay);

  String get keyTanggal => _tanggal;

  String get arrayTanggal => _arrayTanggal;

  String get stringDay => _stringDay;
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[tb.sdTanggal] = _tanggal;
    map[tb.sdArrayTanggal] = _arrayTanggal;
    map[tb.sdStringTanggal] = _stringDay;
    return map;
  }

  void setId(int id) {
    this.id = id;
  }

  @override
  String toString() {
    return '$_tanggal - $_arrayTanggal - $stringDay';
  }
}
