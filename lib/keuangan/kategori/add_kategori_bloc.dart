import 'package:keuangan/database/db_utility.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/colors_utility.dart';
import 'package:rxdart/subjects.dart';

class BlocAddKategori {
  ItemUiAddKategori _cacheUIKategori;
  StateAddCategory _cacheStateAddCategori;

  final BehaviorSubject<ItemUiAddKategori> _itemUi = BehaviorSubject();

  Stream<ItemUiAddKategori> get uiItemAddKategori => _itemUi.stream;

  void changeDropdownJenisTransaksi(int value) {
    _cacheUIKategori.currentKategori.setType(EnumJenisTransaksi.values[value]);

    this._sinkUIKategori(_cacheUIKategori);
  }

  void loadFirstTime(StateAddCategory stateAddCategory, Kategori kategori,
      int idparent) async {
    _cacheStateAddCategori = stateAddCategory;
    switch (stateAddCategory) {
      case StateAddCategory.baru:
        {
          _cacheUIKategori = _stateBaru();
          _cacheUIKategori.titleBar = 'Tambah Kategori';
          _cacheUIKategori.enumStateFromBloc = EnumStateFromBloc.progress;
          this._sinkUIKategori(_cacheUIKategori);
        }
        break;
      case StateAddCategory.edit:
        {
          this._stateEdit(kategori).then((uiitem) {
            _cacheUIKategori = uiitem;
            _cacheUIKategori.enumStateFromBloc = EnumStateFromBloc.progress;
            _cacheUIKategori.titleBar = 'Edit Kategori';
            this._sinkUIKategori(_cacheUIKategori);
          });
        }

        break;
      default:
        break;
    }
  }

  Future<ItemUiAddKategori> _stateEdit(Kategori kategori) async {
    ItemUiAddKategori itemUiAddKategori =
        new ItemUiAddKategori(kategori, EnumStateFromBloc.progress);

    return itemUiAddKategori;
  }

  ItemUiAddKategori _stateBaru() {
    Kategori newKategori =
        new Kategori('', 0, EnumJenisTransaksi.pengeluaran, '', '');
    ItemUiAddKategori itemUiAddKategori =
        new ItemUiAddKategori(newKategori, EnumStateFromBloc.progress);

    return itemUiAddKategori;
  }

  Future<EnumFinalResult> submitKategori(String nama, String catatan) async {
    ColorManagement colorManagement = new ColorManagement();
    String hexColor = await colorManagement
        .hexColor(_cacheUIKategori.currentKategori.idParent);
    _cacheUIKategori.currentKategori.setColor(hexColor);
    _cacheUIKategori.currentKategori.setNama(nama);
    _cacheUIKategori.currentKategori.setCatatan(catatan);

    if (_cacheStateAddCategori == StateAddCategory.baru) {
      ResultDb resultDb =
          await this._saveKategori(_cacheUIKategori.currentKategori);
      if (resultDb.enumResultDb == EnumResultDb.success) {
        _cacheUIKategori.currentKategori.setId(resultDb.value);
        _cacheUIKategori.enumStateFromBloc = EnumStateFromBloc.finish;
       return EnumFinalResult.success;
      }
    } else if (_cacheStateAddCategori == StateAddCategory.edit) {
      ResultDb resultDb =
          await this._updateKategori(_cacheUIKategori.currentKategori);
      if (resultDb.enumResultDb == EnumResultDb.success) {
        return EnumFinalResult.success;
      }
    }
    return EnumFinalResult.failed;
  }

  Future<ResultDb> _saveKategori(Kategori kategori) async {
    DaoKategori daoKategori = new DaoKategori();
    ResultDb rdb = await daoKategori.saveKategori(kategori);
    return rdb;
  }

  Future<ResultDb> _updateKategori(Kategori kategori) async {
    DaoKategori daoKategori = new DaoKategori();
    ResultDb rdb = await daoKategori.update(kategori);
    return rdb;
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
  EnumStateFromBloc enumStateFromBloc;

  /// kategori yang sedang di kerjakan
  Kategori currentKategori;

  ItemUiAddKategori(this.currentKategori, this.enumStateFromBloc);
}
