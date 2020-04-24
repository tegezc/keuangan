import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/colors_utility.dart';
import 'package:rxdart/subjects.dart';

class BlocAddSubKategori {
  ItemUiAddSubKategori _cacheUIKategori;

  final BehaviorSubject<ItemUiAddSubKategori> _itemUi = BehaviorSubject();

  Stream<ItemUiAddSubKategori> get uiItemAddKategori => _itemUi.stream;

  void loadFirstTime(StateAddCategory stateAddCategory, Kategori kategori,
      int idparent) async {
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
    Kategori parentKategori = await daoKategori.getKategoriById(kategori.idParent);

    ItemUiAddSubKategori itemUiAddKategori = new ItemUiAddSubKategori(kategori,parentKategori);
    return itemUiAddKategori;
  }

  Future<ItemUiAddSubKategori> _stateBaruSubKategori(int idparent) async {
    DaoKategori daoKategori = new DaoKategori();
    Kategori kategoriParent = await daoKategori.getKategoriById(idparent);
    Kategori newKategori =
        new Kategori('', idparent, kategoriParent.type, '', '');

    ItemUiAddSubKategori itemUiAddKategori =
        new ItemUiAddSubKategori(newKategori,kategoriParent);
//    print('idparent: $idparent');
//
//
//    itemUiAddKategori.listKategori.forEach((k) {
//      print('id: ${k.id}');
//    });
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

  void _sinkUIKategori(ItemUiAddSubKategori itemUiAddKategori) {
    this._itemUi.sink.add(itemUiAddKategori);
  }

  void dispose() {
    _itemUi.close();
  }
}

class ItemUiAddSubKategori {
  String titleBar;

  /// kategori yang sedang di kerjakan
  Kategori currentKategori;

  Kategori kategoriParent;

  ItemUiAddSubKategori(this.currentKategori,this.kategoriParent);
}
