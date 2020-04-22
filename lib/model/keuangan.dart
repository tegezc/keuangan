import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/util/global_string_database.dart';
import 'package:keuangan/util/process_string.dart';

class Kategori {
  TbKategori tb = new TbKategori();
  int id;
  String _nama;
  int _idParent;
  EnumJenisTransaksi _type;
  String _catatan;
  List<Kategori> listKategori;
  int isAbadi;
  String _color;

  Kategori(this._nama, this._idParent, this._type, this._catatan, this._color)
      : assert(_nama != null &&
            _idParent != null &&
            _type != null &&
            _catatan != null) {
    if (isAbadi == null) {
      isAbadi = 0;
    }
  }

  String get nama => this._nama;

  int get idParent => this._idParent;

  EnumJenisTransaksi get type => this._type;

  String get catatan => this._catatan;

  String get color => this._color;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[tb.fNama] = _nama;
    map[tb.fIdParent] = _idParent;
    map[tb.fType] = _type.index;
    map[tb.fCatatan] = _catatan;
    map[tb.fIsAbadi] = isAbadi;
    map[tb.fColor] = _color;

    return map;
  }

  void setId(int id) {
    this.id = id;
  }

  void setNama(String nama) {
    this._nama = nama;
  }

  void setIdParent(int idp){
    this._idParent = idp;
  }

  void setType(EnumJenisTransaksi jTrx){
    this._type = jTrx;
  }

  void setColor(String hex){
    this._color = hex;
  }

  @override
  String toString() {
    return '|ID: $id |nama: $_nama |Catatan: $catatan |ID Parent: $_idParent |Type: $_type | abadi: $isAbadi |color: $_color';
  }
}

class ItemName {
  TbItemName tb = new TbItemName();
  int id;
  String _nama;
  int _idKategori;
  Kategori _kategori;
  int _isDeleted;

  ItemName(this._nama, this._idKategori, this._isDeleted)
      : assert(_nama != null && _idKategori != null && _isDeleted != null);

  Kategori get kategori => this._kategori;

  String get nama => this._nama;

  int get idKategori => this._idKategori;

  int get isDeleted => this._isDeleted;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[tb.fNama] = _nama;
    map[tb.fIdKategori] = _idKategori;
    map[tb.fDeleted] = _isDeleted;
    return map;
  }

  void setId(int id) {
    this.id = id;
  }

  void setNama(String nm) {
    this._nama = nm;
  }

  void setIsDeleted(int value) {
    this._isDeleted = value;
  }

  void setKategori(Kategori k) {
    this._kategori = k;
    this._idKategori = k.id;
  }

  @override
  String toString() {
    return '$id | $_nama | $_idKategori | $_isDeleted';
  }
}

class Keuangan {
  TbKeuangan tb = new TbKeuangan();
  int id;
  DateTime _tanggal;
  int _idItemName;
  ItemName lazyItemName;
  double _jumlah;
  String _catatan;
  int _lastupdate;

  Keuangan();

  Keuangan.fromUI(
      DateTime tanggal, int idItemName, double jumlah, String catatan) {
    this._tanggal = tanggal;
    this._idItemName = idItemName;
    this._jumlah = jumlah;
    this._catatan = catatan;
    this._lastupdate = DateTime.now().millisecondsSinceEpoch;
  }

  Keuangan.fromDB(String tanggal, int idItemName, double jumlah, String catatan,
      int newlastupdate) {
    ProcessString processString = new ProcessString();
    this._tanggal = processString.dateFromDbToDateTime(tanggal);
    this._idItemName = idItemName;
    this._jumlah = jumlah;
    this._catatan = catatan;
    this._lastupdate = newlastupdate;
  }

  DateTime get tanggal => this._tanggal;

  int get idItemName => this._idItemName;

  double get jumlah => this._jumlah;

  String get catatan => _catatan;

  int get lastupdate => this._lastupdate;

  Map<String, dynamic> toMap() {
    ProcessString processString = new ProcessString();
    var map = new Map<String, dynamic>();
    map[tb.fTgl] = processString.dateFormatForDB(_tanggal);
    map[tb.fIdItemName] = _idItemName;
    map[tb.fJumlah] = _jumlah;
    map[tb.fCatatan] = _catatan;
    map[tb.fLastUpdate] = _lastupdate;

    return map;
  }

  void setId(int id) {
    this.id = id;
  }

  void setIdItemName(int id) {
    this._idItemName = id;
  }

  void setTanggal(DateTime dateTime) {
    this._tanggal = dateTime;
  }

  void setJumlah(double jml) {
    this._jumlah = jml;
  }

  void setCatatan(String ctt) {
    this._catatan = ctt;
  }

  void setLastupdate(int newvalue) {
    this._lastupdate = newvalue;
  }

  bool isValid() {
    if (_idItemName > 0 && _tanggal != null) {
      return true;
    }
    return false;
  }

  String toString() {
    return 'idkeuangan: $id| iditemname: $_idItemName| jumlah: $_jumlah| tanggal: $_tanggal| catatan: $_catatan';
  }
}
