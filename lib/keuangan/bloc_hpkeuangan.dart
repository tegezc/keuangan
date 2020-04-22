import 'package:keuangan/database/keuangan/dao_keuangan.dart';
import 'package:keuangan/keuangan/transaksi/model_keuangan_ui.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:rxdart/subjects.dart';

class BlocHpKeuangan {
  UIHPKeuangan _uihpKeuanganItem;
  final BehaviorSubject<UIHPKeuangan> _uiHPKeuangan = BehaviorSubject();

  BlocHpKeuangan() {
    _uihpKeuanganItem = new UIHPKeuangan(0, 0, null);
  }

  Stream<UIHPKeuangan> get uiHPKeuangan => _uiHPKeuangan.stream;

  void _sinkUIHPKeuangan(UIHPKeuangan item) {
    _uiHPKeuangan.sink.add(item);
  }

  void dispose() {
    _uiHPKeuangan.close();
  }

  fullReload() async {
    _setupBalance().then((item) {
      this._sinkUIHPKeuangan(item);
    });
  }

  deleteTransaksi(Entry entry) {
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
    _uihpKeuanganItem.listKeuangan = await _getLazyListKeuangan();
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

  Future<List<Keuangan>> _getLazyListKeuangan() async {
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    List<Keuangan> filteredKeuangan = await daoKeuangan.get5LastKeuanganLazy();
    return filteredKeuangan;
  }
}

class UIHPKeuangan {
  int pengeluaran;
  int pemasukan;

  int get balance => pemasukan - pengeluaran;
  List<Keuangan> listKeuangan;

  UIHPKeuangan(this.pemasukan, this.pengeluaran, this.listKeuangan);
}
