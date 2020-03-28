

import 'package:keuangan/util/global_string_database.dart';

class Setup{
  TbSetup tb = new TbSetup();
  int id;
  String _nama;
  DateTime _tglInput;
  bool _isSuccess;

  Setup(this._nama,this._tglInput,this._isSuccess);

  String get nama => _nama;
  DateTime get tglInput => _tglInput;
  bool get isSuccess => _isSuccess;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[tb.fNama] = _nama;
    map[tb.fTglInput] = _tglInput;
    map[tb.fIsSuccess] = _isSuccess;

    return map;
  }

  void setId(int id){
    this.id = id;
  }
}