import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/colors_utility.dart';
import 'package:rxdart/subjects.dart';


class BlocAddKategori {
  ItemUiAddKategori _cacheUIKategori;

  final BehaviorSubject<ItemUiAddKategori> _itemUi = BehaviorSubject();

  Stream<ItemUiAddKategori> get uiItemAddKategori => _itemUi.stream;

  void changeDropdownJenisTransaksi(int value) {
    _cacheUIKategori.currentKategori.setType(EnumJenisTransaksi.values[value]);

    this._sinkUIKategori(_cacheUIKategori);
  }

  void loadFirstTime(StateAddCategory stateAddCategory, Kategori kategori,
      int idparent) async {


    switch (stateAddCategory) {
      case StateAddCategory.baru:
        {
          _cacheUIKategori = _stateBaru();
          _cacheUIKategori.titleBar = 'Tambah Kategori';
          this._sinkUIKategori(_cacheUIKategori);
        }
        break;
      case StateAddCategory.edit:
        {
          this._stateEdit(kategori).then((uiitem) {
            _cacheUIKategori = uiitem;
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
        new ItemUiAddKategori(kategori);

    return itemUiAddKategori;
  }

  ItemUiAddKategori _stateBaru() {
    Kategori newKategori =
        new Kategori('', 0, EnumJenisTransaksi.pengeluaran, '', '');
    ItemUiAddKategori itemUiAddKategori =
        new ItemUiAddKategori(newKategori);

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

  /// kategori yang sedang di kerjakan
  Kategori currentKategori;

  ItemUiAddKategori(this.currentKategori) ;
}
