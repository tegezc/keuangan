

import 'package:keuangan/util/global_string_database.dart';

class Setup{
  TbSetup tb = new TbSetup();
  int id;
  String _nama;
  String _value;
  int _tglInput;

  Setup(this._nama,this._value,this._tglInput);

  String get nama => _nama;
  int get tglInput => _tglInput;
  String get value => _value;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[tb.fNama] = _nama;
    map[tb.fValue] = _value;
    map[tb.fTglInput] = _tglInput;

    return map;
  }

  void setId(int id){
    this.id = id;
  }

  void setTanggalInput(int tgl){
    this._tglInput = tgl;
  }
}