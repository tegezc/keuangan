import 'package:flutter/material.dart';
import 'package:keuangan/database/db_utility.dart';
import 'package:keuangan/database/keuangan/dao_itemname.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/common_ui.dart';
import 'package:keuangan/util/loading_view.dart';

class ItemNameEntry extends StatefulWidget {
  final ItemName itemName;
  final StateItemNameEntry stateItemName;

  ItemNameEntry.baru()
      : stateItemName = StateItemNameEntry.baru,
        itemName = null;

  ItemNameEntry.edit(this.itemName) : stateItemName = StateItemNameEntry.edit;

  @override
  _ItemNameEntryState createState() => _ItemNameEntryState();
}

class _ItemNameEntryState extends State<ItemNameEntry> {
  List<Kategori> _listKategori;
  List<DropdownMenuItem<Kategori>> _dropDownKategory;
  Kategori _currentCatogery;

  TextEditingController _txtController;
  CommonUi _commonUi;

  @override
  void initState() {
    _commonUi = new CommonUi();
    print(widget.itemName.toString());
    _txtController = new TextEditingController();
    _populateKategori();
    super.initState();
  }

  @override
  void dispose() {
    _txtController.dispose();
    super.dispose();
  }

  _populateKategori() {
    _listKategori = new List();
    DaoKategori daoKategori = new DaoKategori();
    daoKategori.getAllKategori().then((kategories) {
      if (kategories != null) {
        _listKategori.addAll(kategories);
        if (_listKategori.length > 0) {
          _dropDownKategory = this._getDropDownKategori();
          _currentCatogery = _dropDownKategory[0].value;
        }
        if (widget.stateItemName == StateItemNameEntry.edit) {
          for (int i = 0; i < _dropDownKategory.length; i++) {
            Kategori k = _dropDownKategory[i].value;

            if (k.id == widget.itemName.idKategori) {
              _currentCatogery = _dropDownKategory[i].value;
              break;
            }
          }
          _txtController.text = widget.itemName.nama;
        }
        setState(() {});
      }
    });
  }

  /// ada 2 kondisi
  /// 1. itemname baru maka cek item name dgn isDeleted 0 apakah duplikasi atau tidak.
  /// jika tidak maka insert baru
  /// 2. kondisi edit: maka cek data isDeleted 0 apakah duplikasi, jika tidak,
  /// maka insert baru itemname dan yang ori di edit dengan isDeleted menjadi 1.
  _saveItemName() {
    bool isShowToast = false;
    String messageToast = '';
    String nama = _txtController.text;
    DaoItemName daoItemName = new DaoItemName();
    if (widget.stateItemName == StateItemNameEntry.baru) {
      ItemName iname;
      if (_currentCatogery.idParent == null) {
        iname = new ItemName(nama, 0, 0);
      } else {
        iname = new ItemName(nama, _currentCatogery.id, 0);
      }

      daoItemName
          .getItemNameByNamaNIdKategoriVisible(iname.nama, iname.idKategori)
          .then((itemName) {
        if (itemName == null) {
          daoItemName.saveItemName(iname).then((value) {
            if (value > 0) {
              Navigator.of(context).pop(1);
            } else {
              isShowToast = true;
              messageToast = 'Item gagal disimpan';
            }
          });
        } else {
          isShowToast = true;
          messageToast = 'Item sudah ada';
        }
        if (isShowToast) {
          _commonUi.showToast(messageToast);
        }
      });
    } else {
      if (nama.trim() == widget.itemName.nama &&
          widget.itemName.idKategori == _currentCatogery.id) {
        /// kondisi user klik edit, namun tidak melakukan perubahan apapun
        Navigator.of(context).pop(3);
      } else {
        ItemName k;
        if (_currentCatogery.idParent == null) {
          k = new ItemName(nama, 0, 0);
        } else {
          k = new ItemName(nama, _currentCatogery.id, 0);
        }
        ItemName oldItemName = widget.itemName;
        oldItemName.setIsDeleted(1);
        daoItemName
            .getItemNameByNamaNIdKategoriVisible(k.nama, k.idKategori)
            .then((itemName) {
          if (itemName == null) {
            daoItemName.saveItemName(k);
            daoItemName.update(oldItemName).then((value) {
              if (value == EnumResultDb.success) {
                Navigator.of(context).pop(2);
              } else {
                isShowToast = true;
                messageToast = 'Item gagal disimpan';
              }
            });
          } else {
            isShowToast = true;
            messageToast = 'Item sudah ada';
          }
          if (isShowToast) {
            _commonUi.showToast(messageToast);
          }
        });
      }
    }
  }

  List<DropdownMenuItem<Kategori>> _getDropDownKategori() {
    List<DropdownMenuItem<Kategori>> items = new List();
    for (Kategori ktgori in _listKategori) {
      items.add(new DropdownMenuItem(
        value: ktgori,
        child: new Text(ktgori.nama),
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    // controll disable dropdown kategori
    String title = 'Ubah Item';
    if (widget.stateItemName == StateItemNameEntry.baru) {
      title = 'Item Baru';
    } else if (widget.stateItemName == StateItemNameEntry.edit &&
        widget.itemName == null) {}

    if (_listKategori.isEmpty) {
      return LoadingView();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            // action button
            IconButton(
              color: Colors.green[900],
              icon: Icon(Icons.done),
              onPressed: () {
                _saveItemName();
              },
            ),
            // overflow menu
          ],
        ),
        body: new Container(
          padding: EdgeInsets.only(top: 15, left: 20, right: 15, bottom: 0),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Kategori'),
                new DropdownButton(
                  disabledHint: Text(""),
                  value: _currentCatogery,
                  items: _dropDownKategory,
                  onChanged: changedDropDownKategori,
                ),
                Text('Nama item'),
                TextField(
                  controller: _txtController,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void changedDropDownKategori(Kategori selectedCategory) {
    setState(() {
      _currentCatogery = selectedCategory;
    });
  }
}

enum StateItemNameEntry { edit, baru }
