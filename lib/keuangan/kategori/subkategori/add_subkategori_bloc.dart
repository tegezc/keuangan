import 'package:keuangan/database/db_utility.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/colors_utility.dart';
import 'package:rxdart/subjects.dart';

class BlocAddSubKategori {
  ItemUiAddSubKategori _cacheUIKategori;

  StateAddCategory _cacheStateCategiri;

  final BehaviorSubject<ItemUiAddSubKategori> _itemUi = BehaviorSubject();

  Stream<ItemUiAddSubKategori> get uiItemAddKategori => _itemUi.stream;

  void loadFirstTime(StateAddCategory stateAddCategory, Kategori kategori,
      int idparent) async {
    _cacheStateCategiri = stateAddCategory;
    switch (stateAddCategory) {
      case StateAddCategory.baruSubkategori:
        {
          this._stateBaruSubKategori(idparent).then((uiitem) {
            _cacheUIKategori = uiitem;
            _cacheUIKategori.titleBar = 'Tambah SubKategori';
            this._sinkUIKategori(_cacheUIKategori);
          });
        }
        break;
      case StateAddCategory.editSubkategori:
        {
          this._stateEditSubKategori(kategori).then((uiitem) {
            _cacheUIKategori = uiitem;
            _cacheUIKategori.titleBar = 'Edit SubKategori';
            this._sinkUIKategori(_cacheUIKategori);
          });
        }

        break;
      default:
        break;
    }
  }

  Future<ItemUiAddSubKategori> _stateEditSubKategori(Kategori kategori) async {
    DaoKategori daoKategori = new DaoKategori();
    Kategori parentKategori =
        await daoKategori.getKategoriById(kategori.idParent);

    ItemUiAddSubKategori itemUiAddKategori = new ItemUiAddSubKategori(
        kategori, parentKategori, EnumStateFromBloc.progress);
    return itemUiAddKategori;
  }

  Future<ItemUiAddSubKategori> _stateBaruSubKategori(int idparent) async {
    DaoKategori daoKategori = new DaoKategori();
    Kategori kategoriParent = await daoKategori.getKategoriById(idparent);
    Kategori newKategori =
        new Kategori('', idparent, kategoriParent.type, '', '');

    ItemUiAddSubKategori itemUiAddKategori = new ItemUiAddSubKategori(
        newKategori, kategoriParent, EnumStateFromBloc.progress);
//    print('idparent: $idparent');
//
//
//    itemUiAddKategori.listKategori.forEach((k) {
//      print('id: ${k.id}');
//    });
    return itemUiAddKategori;
  }

  Future<EnumResultDb> submitKategori(String nama, String catatan) async {
    ColorManagement colorManagement = new ColorManagement();
    String hexColor = await colorManagement
        .hexColor(_cacheUIKategori.currentKategori.idParent);
    _cacheUIKategori.currentKategori.setColor(hexColor);
    _cacheUIKategori.currentKategori.setNama(nama);
    _cacheUIKategori.currentKategori.setCatatan(catatan);

    if (_cacheStateCategiri == StateAddCategory.baruSubkategori) {
      ResultDb resultDb =
          await this._saveKategori(_cacheUIKategori.currentKategori);
      return resultDb.enumResultDb;
    } else if (_cacheStateCategiri == StateAddCategory.editSubkategori) {
      ResultDb resultDb =
          await this._updateKategori(_cacheUIKategori.currentKategori);
      return resultDb.enumResultDb;
    }
    return EnumResultDb.failed;
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

  void _sinkUIKategori(ItemUiAddSubKategori itemUiAddKategori) {
    this._itemUi.sink.add(itemUiAddKategori);
  }

  void dispose() {
    _itemUi.close();
  }
}

class ItemUiAddSubKategori {
  String titleBar;

  EnumStateFromBloc enumStateFromBloc;

  /// kategori yang sedang di kerjakan
  Kategori currentKategori;

  Kategori kategoriParent;

  ItemUiAddSubKategori(
      this.currentKategori, this.kategoriParent, this.enumStateFromBloc);
}
