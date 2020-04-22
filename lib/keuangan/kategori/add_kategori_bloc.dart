import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/colors_utility.dart';
import 'package:rxdart/subjects.dart';

/// Ada kondisi combobox untuk parent di disable. yaitu saat mengedit kategori
/// level 1 yang memiliki sub kategori.
///  ========================
/// jenis transaksi untuk sub kategori harus sama dengan jenis transaksi parent
/// jadi konsekuensinya:
/// 1. Saat comboBoxjenistransaksi mengikuti comboboxKategoriParent.
/// dan dalam kondisi  disable.
/// 2. comboBoxjenistransaksi enable hanya saat comboboxparent di select 'no parent'
///  CATATAN (tidak dipakai di app ini):  di aplikasi lain -> ada yang membiarkan jenis transaksi subkategori beda
///  dengan jenis transaksi parent.
///
class BlocAddKategori {
  ItemUiAddKategori _cacheUIKategori;
  List<Kategori> _cacheListPengeluaran;
  List<Kategori> _cacheListPemasukan;

  /// variable ini digunakan untuk temp list kategori all non abadi, dimaksudkan
  /// agar tidak selalu akses DB saat ingin mendapatkan kategori level1 by id
  Map<int, Kategori> _cacheMapKategoriAll;

  final BehaviorSubject<ItemUiAddKategori> _itemUi = BehaviorSubject();

  Stream<ItemUiAddKategori> get uiItemAddKategori => _itemUi.stream;

  void changeDropdownKategori(int idparent) {
    _cacheUIKategori.currentKategori.setIdParent(idparent);
    this._sinkUIKategori(_cacheUIKategori);
  }

  void changeDropdownJenisTransaksi(int value) {
    _cacheUIKategori.currentKategori.setType(EnumJenisTransaksi.values[value]);
    if (_cacheUIKategori.currentKategori.type ==
        EnumJenisTransaksi.pengeluaran) {
      _cacheUIKategori.setListKategori(_cacheListPengeluaran);
    } else {
      _cacheUIKategori.setListKategori(_cacheListPemasukan);
    }
    _cacheUIKategori.currentKategori
        .setIdParent(_cacheUIKategori.listKategori[0].id);

    this._sinkUIKategori(_cacheUIKategori);
  }

  void loadFirstTime(StateAddCategory stateAddCategory, Kategori kategori,
      int idparent) async {
    DaoKategori daoKategori = new DaoKategori();
    _cacheListPengeluaran = await daoKategori
        .getMainKategoriByJenisTrxTanpaAbadi(EnumJenisTransaksi.pengeluaran);
    _cacheListPemasukan = await daoKategori
        .getMainKategoriByJenisTrxTanpaAbadi(EnumJenisTransaksi.pemasukan);
    _cacheMapKategoriAll = await daoKategori.getAllKategoriMap();

    switch (stateAddCategory) {
      case StateAddCategory.baru:
        {
          _cacheUIKategori = _stateBaru();
          _cacheUIKategori.titleBar = 'Tambah Kategori';
        }

        break;
      case StateAddCategory.baruSubkategori:
        {
          _cacheUIKategori = this._stateBaruSubKategori(idparent);
          _cacheUIKategori.titleBar = 'Tambah Kategori';
        }

        break;
      case StateAddCategory.edit:
        {
          this._stateEdit(kategori);
          _cacheUIKategori.titleBar = 'Edit Kategori';
        }

        break;
      case StateAddCategory.editSubkategori:
        {
          this._stateEditSubKategori(kategori);
          _cacheUIKategori.titleBar = 'Edit Kategori';
        }

        break;
      default:
        break;
    }

    this._sinkUIKategori(_cacheUIKategori);
  }

  void _stateEdit(Kategori kategori) {}

  void _stateEditSubKategori(Kategori kategori) {}

  ItemUiAddKategori _stateBaruSubKategori(int idparent) {
    Kategori kategoriParent = _cacheMapKategoriAll[idparent];
    Kategori newKategori =
        new Kategori('', idparent, kategoriParent.type, '', '');
    List<Kategori> list = newKategori.type == EnumJenisTransaksi.pemasukan
        ? _cacheListPemasukan
        : _cacheListPengeluaran;

    ItemUiAddKategori itemUiAddKategori =
        new ItemUiAddKategori(newKategori, list, true, true);
    print('idparent: $idparent');


    itemUiAddKategori.listKategori.forEach((k) {
      print('id: ${k.id}');
    });
    return itemUiAddKategori;
  }

  ItemUiAddKategori _stateBaru() {
    Kategori newKategori =
        new Kategori('', 0, EnumJenisTransaksi.pengeluaran, '', '');
    ItemUiAddKategori itemUiAddKategori =
        new ItemUiAddKategori(newKategori, _cacheListPengeluaran, true, true);

    return itemUiAddKategori;
  }

  void submitKategori(
      Kategori kategori, StateAddCategory stateAddCategory) async {
    ColorManagement colorManagement = new ColorManagement();
    String hexColor = await colorManagement.hexColor(kategori.idParent);
    kategori.setColor(hexColor);

    if (stateAddCategory == StateAddCategory.baruSubkategori ||
        stateAddCategory == StateAddCategory.baru) {
      this._saveKategori().then((value) {});
    } else if (stateAddCategory == StateAddCategory.edit ||
        stateAddCategory == StateAddCategory.editSubkategori) {
      this._updateKategori(kategori).then((value) {});
    }
  }

  Future<bool> _saveKategori() async {
    return true;
  }

  Future<bool> _updateKategori(Kategori kategori) async {
    return false;
  }

  void _sinkUIKategori(ItemUiAddKategori itemUiAddKategori) {
    this._itemUi.sink.add(itemUiAddKategori);
  }

  void dispose() {
    _itemUi.close();
  }
}

class ItemUiAddKategori {
  String titleBar;

  /// untuk isi combo box, hanya level 1 (tidak punya parent)
  /// secara static item kategori ke [0] adalah no parent
  List<Kategori> _listKategori;

  /// kategori yang sedang di kerjakan
  Kategori currentKategori;

  /// true jika enable, false jika disable
  bool enableComboBox;

  /// jadi karena jenis transaksi mengikuti parent, maka proses baru atau edit
  /// sub kategori harus di disable
  bool enableComboBoxJenisTransaksi;

  ItemUiAddKategori(this.currentKategori, this._listKategori,
      this.enableComboBoxJenisTransaksi, this.enableComboBox) {
    this.setListKategori(_listKategori);
  }

  List<Kategori> get listKategori => this._listKategori;

  void setListKategori(List<Kategori> list) {
    List<Kategori> lkategori = new List();
    if (this.currentKategori.type == EnumJenisTransaksi.pemasukan) {
      Kategori noparentdummydropbox =
          new Kategori('no parent', 0, EnumJenisTransaksi.pemasukan, '', '');
      noparentdummydropbox.id = 0;

      /// 0 adalah id dummy untuk kategori no parent
      lkategori.add(noparentdummydropbox);
    } else if (this.currentKategori.type == EnumJenisTransaksi.pengeluaran) {
      Kategori noparentdummydropbox =
          new Kategori('no parent', 0, EnumJenisTransaksi.pengeluaran, '', '');
      noparentdummydropbox.id = 0;

      /// 0 adalah id dummy untuk kategori no parent
      lkategori.add(noparentdummydropbox);
    }
    lkategori.addAll(list);

    this._listKategori = lkategori;
  }
}
