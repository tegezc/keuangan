import 'package:flutter/material.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/keuangan/kategori/add_kategori_bloc.dart';
import 'package:keuangan/model/enum_db.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/colors_utility.dart';
import 'package:keuangan/util/loading_view.dart';

class AddCategory extends StatefulWidget {
  final Kategori kategori;
  final StateAddCategory stateAddCategory;

  AddCategory.baru()
      : stateAddCategory = StateAddCategory.baru,
        kategori = null;

  AddCategory.edit(this.kategori) : stateAddCategory = StateAddCategory.edit;

  AddCategory.addSubkategori(this.kategori)
      : stateAddCategory = StateAddCategory.baruSubkategori;

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Kategori> _listKategory;
  List<DropdownMenuItem<Kategori>> _dropDownKategory;
  Kategori _currentParentCatogery;

  List _jenisTransaksi = ["Pengeluaran", "Pemasukan"];
  List<DropdownMenuItem<int>> _dropDownTransaksi;
  EnumJenisTransaksi _currentTransaksi;

  TextEditingController _txtController;
  TextEditingController _txtCatatanController;
  String txtNoParent = 'tidak punya induk';

  Kategori _cacheKategori;

  @override
  void initState() {
    _txtController = new TextEditingController();
    _txtCatatanController = new TextEditingController();
    if (widget.kategori != null) {
      _cacheKategori = new Kategori(
          widget.kategori.nama,
          widget.kategori.idParent,
          widget.kategori.type,
          widget.kategori.catatan,
          widget.kategori.color);
    }
    if (widget.kategori.listKategori == null) {
      _cacheKategori.listKategori = new List();
    } else {
      _cacheKategori.listKategori = widget.kategori.listKategori;
    }

    if (widget.kategori.id != null) {
      _cacheKategori.setId(widget.kategori.id);
    }
    _populateKategori(_cacheKategori);
    super.initState();
  }

  @override
  void dispose() {
    _txtController.dispose();
    _txtCatatanController.dispose();
    super.dispose();
  }

  _populateKategori(Kategori kt) {
    _listKategory = new List();
    Kategori kategori = new Kategori(txtNoParent, null, null, '', '');

    DaoKategori daoKategori = new DaoKategori();
    daoKategori.getAllMainKategori().then((List<Kategori> kategories) {
      if (kategories != null) {
        _dropDownTransaksi = getDropDownTransaksi();
        _currentTransaksi = EnumJenisTransaksi.pengeluaran;
        _listKategory.add(kategori);
        _listKategory.addAll(kategories);
        if (_listKategory.length > 0) {
          _dropDownKategory = getDropDownKategori();
          _currentParentCatogery = _dropDownKategory[0].value;
        }
        if (widget.stateAddCategory == StateAddCategory.edit) {
          if (kt.idParent != 0) {
            for (int i = 0; i < _dropDownKategory.length; i++) {
              Kategori k = _dropDownKategory[i].value;

              if (k.id == kt.idParent) {
                _currentParentCatogery = _dropDownKategory[i].value;
                break;
              }
            }
          }

          _currentTransaksi = kt.type;
          _txtController.text = kt.nama;
          _txtCatatanController.text = kt.catatan;
        } else if (widget.stateAddCategory ==
            StateAddCategory.baruSubkategori) {
          for (int i = 0; i < _dropDownKategory.length; i++) {
            Kategori k = _dropDownKategory[i].value;

            if (k.id == kt.id) {
              _currentParentCatogery = _dropDownKategory[i].value;
              break;
            }
          }

          _currentTransaksi = kt.type;
          _txtController.text = '';
          _txtCatatanController.text = '';
        }
        setState(() {});
      }
    });
  }

  _saveKategori(Kategori kategori) async {
    ColorManagement colorManagement = new ColorManagement();

    bool isShowSnackbar = false;
    String messageSnackBar = '';
    String nama = _txtController.text;
    String catatan = _txtCatatanController.text;
    DaoKategori daoKategori = new DaoKategori();

    if (widget.stateAddCategory == StateAddCategory.baru) {
      int idparent;
      if (_currentParentCatogery.idParent == null) {
        idparent = 0;
      } else {
        idparent = _currentParentCatogery.id;
      }
      String hexColor = await colorManagement.hexColor(idparent);
      Kategori k =
          new Kategori(nama, idparent, _currentTransaksi, catatan, hexColor);

      daoKategori.saveKategori(k).then((value) {
        if (value.enumResultDb == EnumResultDb.success) {
          Navigator.of(context).pop(1);
        } else if (value.enumResultDb == EnumResultDb.duplicate) {
          isShowSnackbar = true;
          messageSnackBar = 'Kategori sudah ada';
        } else {
          isShowSnackbar = true;
          messageSnackBar = 'Kategori gagal disimpan';
        }

        if (isShowSnackbar) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(messageSnackBar),
            duration: Duration(seconds: 3),
          ));
        }
      });
    } else {
      Kategori k;
      if (_currentParentCatogery.idParent == null) {
        k = new Kategori(nama, 0, _currentTransaksi, catatan, kategori.color);
      } else {
        k = new Kategori(nama, _currentParentCatogery.id, _currentTransaksi,
            catatan, kategori.color);
      }
      k.setId(kategori.id);
      daoKategori.update(k).then((v) {
        if (v == EnumResultDb.duplicate) {
          isShowSnackbar = true;
          messageSnackBar = 'Kategori sudah ada';
        } else if (v == EnumResultDb.failed) {
          isShowSnackbar = true;
          messageSnackBar = 'Kategori gagal diupdate';
        } else {
          Navigator.of(context).pop(2);
        }

        if (isShowSnackbar) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(messageSnackBar),
            duration: Duration(seconds: 3),
          ));
        }
      });
    }
  }

  List<DropdownMenuItem<Kategori>> getDropDownKategori() {
    List<DropdownMenuItem<Kategori>> items = new List();
    for (Kategori ktgori in _listKategory) {
      items.add(new DropdownMenuItem(
        value: ktgori,
        child: new Text(ktgori.nama),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<int>> getDropDownTransaksi() {
    List<DropdownMenuItem<int>> items = new List();
    for (int i = 0; i < 2; i++) {
      items.add(new DropdownMenuItem(
        value: i,
        child: new Text(_jenisTransaksi[i]),
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    // controll disable dropdown kategori
    bool isEnableParentKategori = false;
    String title = 'Ubah Kategori';
    if (widget.stateAddCategory == StateAddCategory.baru) {
      title = 'Kategori Baru';
      isEnableParentKategori = true;
    } else if (widget.stateAddCategory == StateAddCategory.edit &&
        _cacheKategori.listKategori.length == 0) {
      title = 'Ubah Kategori';
      isEnableParentKategori = true;
    } else if (widget.stateAddCategory == StateAddCategory.baruSubkategori) {
      title = 'Subkategori baru';
    }

    if (_listKategory.isEmpty) {
      return LoadingView();
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            // action button
            IconButton(
              color: Colors.green[900],
              icon: Icon(Icons.done),
              onPressed: () {
                _saveKategori(_cacheKategori);
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
                Text('Induk'),
                new DropdownButton(
                  disabledHint: Text(txtNoParent),
                  value: _currentParentCatogery,
                  items: _dropDownKategory,
                  onChanged:
                      isEnableParentKategori ? changedDropDownKategori : null,
                ),
                Text('Nama Kategori'),
                TextField(
                  controller: _txtController,
                  maxLines: 1,
                ),
                Text('Keterangan (Optional)'),
                TextField(
                  controller: _txtCatatanController,
                  maxLines: null,
                ),
                Text('Jenis Transaksi'),
                new DropdownButton(
                  value: _currentTransaksi.index,
                  items: _dropDownTransaksi,
                  onChanged: changedDropDownTransaksi,
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
      _currentParentCatogery = selectedCategory;
    });
  }

  void changedDropDownTransaksi(int selectedTransaksi) {
    setState(() {
      _currentTransaksi = EnumJenisTransaksi.values[selectedTransaksi];
    });
  }
}

class AddCategory1 extends StatefulWidget {
  final Kategori kategori;
  final StateAddCategory stateAddCategory;

  AddCategory1.baru()
      : stateAddCategory = StateAddCategory.baru,
        kategori = null;

  AddCategory1.edit(this.kategori) : stateAddCategory = StateAddCategory.edit;

  AddCategory1.addSubkategori(this.kategori)
      : stateAddCategory = StateAddCategory.baruSubkategori;

  @override
  _AddCategoryState1 createState() => _AddCategoryState1();
}

class _AddCategoryState1 extends State<AddCategory1> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Kategori> _listKategory;
  List<DropdownMenuItem<Kategori>> _dropDownKategory;
  Kategori _currentParentCatogery;

  List _jenisTransaksi = ["Pengeluaran", "Pemasukan"];
  List<DropdownMenuItem<int>> _dropDownTransaksi;
  EnumJenisTransaksi _currentTransaksi;

  TextEditingController _txtController;
  TextEditingController _txtCatatanController;
  String txtNoParent = 'tidak punya induk';

  Kategori _cacheKategori;

  BlocAddKategori _blocAddKategori;

  @override
  void initState() {
    _blocAddKategori = new BlocAddKategori();
    _txtController = new TextEditingController();
    _txtCatatanController = new TextEditingController();
    if (widget.kategori != null) {
      _cacheKategori = new Kategori(
          widget.kategori.nama,
          widget.kategori.idParent,
          widget.kategori.type,
          widget.kategori.catatan,
          widget.kategori.color);
    }
    if (widget.kategori.listKategori == null) {
      _cacheKategori.listKategori = new List();
    } else {
      _cacheKategori.listKategori = widget.kategori.listKategori;
    }

    if (widget.kategori.id != null) {
      _cacheKategori.setId(widget.kategori.id);
    }
    _populateKategori(_cacheKategori);
    super.initState();
  }

  @override
  void dispose() {
    _txtController.dispose();
    _txtCatatanController.dispose();
    _blocAddKategori.dispose();
    super.dispose();
  }

  _populateKategori(Kategori kt) {
    _listKategory = new List();
    Kategori kategori = new Kategori(txtNoParent, null, null, '', '');

    DaoKategori daoKategori = new DaoKategori();
    daoKategori.getAllMainKategori().then((List<Kategori> kategories) {
      if (kategories != null) {
        _dropDownTransaksi = getDropDownTransaksi();
        _currentTransaksi = EnumJenisTransaksi.pengeluaran;
        _listKategory.add(kategori);
        _listKategory.addAll(kategories);
        if (_listKategory.length > 0) {
          _dropDownKategory = getDropDownKategori();
          _currentParentCatogery = _dropDownKategory[0].value;
        }
        if (widget.stateAddCategory == StateAddCategory.edit) {
          if (kt.idParent != 0) {
            for (int i = 0; i < _dropDownKategory.length; i++) {
              Kategori k = _dropDownKategory[i].value;

              if (k.id == kt.idParent) {
                _currentParentCatogery = _dropDownKategory[i].value;
                break;
              }
            }
          }

          _currentTransaksi = kt.type;
          _txtController.text = kt.nama;
          _txtCatatanController.text = kt.catatan;
        } else if (widget.stateAddCategory ==
            StateAddCategory.baruSubkategori) {
          for (int i = 0; i < _dropDownKategory.length; i++) {
            Kategori k = _dropDownKategory[i].value;

            if (k.id == kt.id) {
              _currentParentCatogery = _dropDownKategory[i].value;
              break;
            }
          }

          _currentTransaksi = kt.type;
          _txtController.text = '';
          _txtCatatanController.text = '';
        }
        setState(() {});
      }
    });
  }

  _saveKategori(Kategori kategori) async {
    ColorManagement colorManagement = new ColorManagement();

    bool isShowSnackbar = false;
    String messageSnackBar = '';
    String nama = _txtController.text;
    String catatan = _txtCatatanController.text;
    DaoKategori daoKategori = new DaoKategori();

    if (widget.stateAddCategory == StateAddCategory.baru) {
      int idparent;
      if (_currentParentCatogery.idParent == null) {
        idparent = 0;
      } else {
        idparent = _currentParentCatogery.id;
      }
      String hexColor = await colorManagement.hexColor(idparent);
      Kategori k =
          new Kategori(nama, idparent, _currentTransaksi, catatan, hexColor);

      daoKategori.saveKategori(k).then((value) {
        if (value.enumResultDb == EnumResultDb.success) {
          Navigator.of(context).pop(1);
        } else if (value.enumResultDb == EnumResultDb.duplicate) {
          isShowSnackbar = true;
          messageSnackBar = 'Kategori sudah ada';
        } else {
          isShowSnackbar = true;
          messageSnackBar = 'Kategori gagal disimpan';
        }

        if (isShowSnackbar) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(messageSnackBar),
            duration: Duration(seconds: 3),
          ));
        }
      });
    } else {
      Kategori k;
      if (_currentParentCatogery.idParent == null) {
        k = new Kategori(nama, 0, _currentTransaksi, catatan, kategori.color);
      } else {
        k = new Kategori(nama, _currentParentCatogery.id, _currentTransaksi,
            catatan, kategori.color);
      }
      k.setId(kategori.id);
      daoKategori.update(k).then((v) {
        if (v == EnumResultDb.duplicate) {
          isShowSnackbar = true;
          messageSnackBar = 'Kategori sudah ada';
        } else if (v == EnumResultDb.failed) {
          isShowSnackbar = true;
          messageSnackBar = 'Kategori gagal diupdate';
        } else {
          Navigator.of(context).pop(2);
        }

        if (isShowSnackbar) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(messageSnackBar),
            duration: Duration(seconds: 3),
          ));
        }
      });
    }
  }

  List<DropdownMenuItem<Kategori>> getDropDownKategori() {
    List<DropdownMenuItem<Kategori>> items = new List();
    for (Kategori ktgori in _listKategory) {
      items.add(new DropdownMenuItem(
        value: ktgori,
        child: new Text(ktgori.nama),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<int>> getDropDownTransaksi() {
    List<DropdownMenuItem<int>> items = new List();
    for (int i = 0; i < 2; i++) {
      items.add(new DropdownMenuItem(
        value: i,
        child: new Text(_jenisTransaksi[i]),
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    // controll disable dropdown kategori
    bool isEnableParentKategori = false;
    String title = 'Ubah Kategori';
    if (widget.stateAddCategory == StateAddCategory.baru) {
      title = 'Kategori Baru';
      isEnableParentKategori = true;
    } else if (widget.stateAddCategory == StateAddCategory.edit &&
        _cacheKategori.listKategori.length == 0) {
      title = 'Ubah Kategori';
      isEnableParentKategori = true;
    } else if (widget.stateAddCategory == StateAddCategory.baruSubkategori) {
      title = 'Subkategori baru';
    }

    return StreamBuilder<ItemUiAddKategori>(
        stream: _blocAddKategori.uiItemAddKategori,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text(title),
                actions: <Widget>[
                  // action button
                  IconButton(
                    color: Colors.green[900],
                    icon: Icon(Icons.done),
                    onPressed: () async{
                      String nama = _txtController.text;
                      int idParent = _currentParentCatogery.id;
                      EnumJenisTransaksi type = _currentTransaksi;
                      String catatan = _txtCatatanController.text;
                      ColorManagement colorm = new ColorManagement();
                      String color = await colorm.hexColor(idParent);
                      Kategori kategori = new Kategori(nama, idParent, type, catatan, color);
                      _blocAddKategori.submitKategori(kategori);
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
                      Text('Induk'),
                      new DropdownButton(
                        disabledHint: Text(txtNoParent),
                        value: _currentParentCatogery,
                        items: _dropDownKategory,
                        onChanged:
                        isEnableParentKategori ? changedDropDownKategori : null,
                      ),
                      Text('Nama Kategori'),
                      TextField(
                        controller: _txtController,
                        maxLines: 1,
                      ),
                      Text('Keterangan (Optional)'),
                      TextField(
                        controller: _txtCatatanController,
                        maxLines: null,
                      ),
                      Text('Jenis Transaksi'),
                      new DropdownButton(
                        value: _currentTransaksi.index,
                        items: _dropDownTransaksi,
                        onChanged: changedDropDownTransaksi,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }else{
            return LoadingView();
          }
        });
  }

  void changedDropDownKategori(Kategori selectedCategory) {
    setState(() {
      _currentParentCatogery = selectedCategory;
    });
  }

  void changedDropDownTransaksi(int selectedTransaksi) {
    setState(() {
      _currentTransaksi = EnumJenisTransaksi.values[selectedTransaksi];
    });
  }
}
