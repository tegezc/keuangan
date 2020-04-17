import 'package:keuangan/database/keuangan/dao_itemname.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/database/keuangan/dao_keuangan.dart';
import 'package:keuangan/keuangan/transaksi/model_keuangan_ui.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/process_string.dart';
import 'package:rxdart/subjects.dart';

class BlocHpKeuangan {
  UIHPKeuangan _uihpKeuanganItem;
  int counterJangkrik = 0;
  final BehaviorSubject<UIHPKeuangan> _uiHPKeuangan = BehaviorSubject();

  BlocHpKeuangan() {

    List<Entry> lentry = new List();
    _uihpKeuanganItem = new UIHPKeuangan(0, 0, lentry);
  }

  Stream<UIHPKeuangan> get uiHPKeuangan => _uiHPKeuangan.stream;

  void _sinkUIHPKeuangan(UIHPKeuangan item) {
    _uiHPKeuangan.sink.add(item);
  }

  void dispose() {
    _uiHPKeuangan.close();
  }

  fullReload() async {
    print('jancuk: ${counterJangkrik++}');
    _setupBalance().then((item) {

      this._sinkUIHPKeuangan(item);
    });
  }

  deleteTransaksi(Entry entry){
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    daoKeuangan.deleteKeuangan(entry.keuangan).then((v) {
      if (v == 1) {
       fullReload();
      } else {
        ///TODO delete gagal
      }
    });
  }

  Future<UIHPKeuangan> _setupBalance() async {
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    List<Keuangan> lkp = await daoKeuangan
        .getKeuanganByJenisTransaksi(EnumJenisTransaksi.pemasukan);
    _uihpKeuanganItem.pemasukan = this._hitungTotal(lkp);

    List<Keuangan> lkk = await daoKeuangan
        .getKeuanganByJenisTransaksi(EnumJenisTransaksi.pengeluaran);
    _uihpKeuanganItem.pengeluaran = this._hitungTotal(lkk);
    _uihpKeuanganItem.lentry = await _sortingListKeuangan();
    return _uihpKeuanganItem;
  }

  int _hitungTotal(List<Keuangan> lk) {
    if (lk != null) {
      double tmpJum = 0;
      lk.forEach((k) {
        tmpJum = tmpJum + k.jumlah;
      });
      return tmpJum.toInt();
    } else {
      return 0;
    }
  }

  Future<List<Entry>> _sortingListKeuangan() async {
    DaoKategori daoKategori = new DaoKategori();
    DaoItemName daoItemName = new DaoItemName();
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    ProcessString _processString = new ProcessString();

    Map<int, Kategori> _kategoriMap = await daoKategori.getAllKategoriMap();
    Map<int, ItemName> _itemNameMap = await daoItemName.getAllItemNameMap();
    List<Keuangan> filteredKeuangan = await daoKeuangan.get5LastKeuangan();

    Map<DateTime, List<Keuangan>> mapK = new Map();
    for (int i = 0; i < filteredKeuangan.length; i++) {
      if (mapK[filteredKeuangan[i].tanggal] == null) {
        List<Keuangan> lk = new List();
        lk.add(filteredKeuangan[i]);
        mapK[filteredKeuangan[i].tanggal] = lk;
      } else {
        List<Keuangan> lk = mapK[filteredKeuangan[i].tanggal];
        lk.add(filteredKeuangan[i]);
        mapK[filteredKeuangan[i].tanggal] = lk;
      }
    }

    List<EntrySort> list = new List();
    mapK.forEach((key, value) {
      var entrySort = new EntrySort(key, value);
      list.add(entrySort);
    });

    List<Entry> _listEntry = new List();
    list.forEach((value) {
      String tanggal = _processString.dateToStringDdMmmmYyyy(value.key);
      Entry entry = new Entry('', null, tanggal, null, false, false);
      _listEntry.add(entry);
      int lgth = value.listKeuangan.length;

      for (int i = 0; i < lgth; i++) {
        var k = value.listKeuangan[i];
        var itemName = _itemNameMap[k.idItemName];

        var ktg = _kategoriMap[itemName.idKategori];
        bool isLast = (i + 1) == lgth ? true : false;

        var e = Entry(itemName.nama, ktg, tanggal, k, true, isLast);
        _listEntry.add(e);
      }
    });
    return _listEntry;
  }
}

class UIHPKeuangan {
  int pengeluaran;
  int pemasukan;

  int get balance => pemasukan - pengeluaran;
  List<Entry> lentry;

  UIHPKeuangan(this.pemasukan, this.pengeluaran, this.lentry);
}
