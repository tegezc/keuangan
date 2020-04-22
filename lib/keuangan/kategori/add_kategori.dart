import 'package:flutter/material.dart';
import 'package:keuangan/keuangan/kategori/add_kategori_bloc.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/loading_view.dart';

class AddCategory extends StatefulWidget {
  final Kategori kategori;
  final StateAddCategory stateAddCategory;
  final int idparent;

  AddCategory.baru()
      : stateAddCategory = StateAddCategory.baru,
        kategori = null,
        idparent = null;

  AddCategory.addSubkategori(this.idparent)
      : stateAddCategory = StateAddCategory.baruSubkategori,
        kategori = null;

  AddCategory.edit(this.kategori)
      : stateAddCategory = StateAddCategory.edit,
        idparent = null;

  AddCategory.editsubkategori(this.kategori)
      : stateAddCategory = StateAddCategory.editSubkategori,
        idparent = null;

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _txtController;
  TextEditingController _txtCatatanController;
  String txtNoParent = 'tidak punya induk';

  BlocAddKategori _blocAddKategori;
  int _counterBuild = 0;

  @override
  void initState() {
    _blocAddKategori = new BlocAddKategori();
    _txtController = new TextEditingController();
    _txtCatatanController = new TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _txtController.dispose();
    _txtCatatanController.dispose();
    _blocAddKategori.dispose();
    super.dispose();
  }

  _saveKategori(ItemUiAddKategori itemUi) async {
    String nama = _txtController.text;
    String catatan = _txtCatatanController.text;
    Kategori kategori = Kategori(nama, itemUi.currentKategori.idParent,
        itemUi.currentKategori.type, catatan, '');
    _blocAddKategori.submitKategori(kategori, widget.stateAddCategory);
  }

  List<DropdownMenuItem<int>> getDropDownKategori(List<Kategori> lKategori) {
    List<DropdownMenuItem<int>> items = new List();
    for (Kategori ktgori in lKategori) {
      items.add(new DropdownMenuItem(
        value: ktgori.id,
        child: new Text(ktgori.nama),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<int>> getDropDownTransaksi() {
    List<DropdownMenuItem<int>> items = new List();

    items.add(new DropdownMenuItem(
      value: 0,
      child: new Text('Pengeluaran'),
    ));

    items.add(new DropdownMenuItem(
      value: 1,
      child: new Text('Pemasukan'),
    ));

    return items;
  }

  @override
  Widget build(BuildContext context) {
    if (_counterBuild == 0) {
      _blocAddKategori.loadFirstTime(widget.stateAddCategory, widget.kategori,widget.idparent);
      _counterBuild++;
    }

    final List<DropdownMenuItem<int>> dropDownTransaksi =
        getDropDownTransaksi();
    return StreamBuilder<ItemUiAddKategori>(
        stream: _blocAddKategori.uiItemAddKategori,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                    title: Text(
                  'tunggu sebentar...',
                )),
                body: LoadingView());
          } else {
            List<DropdownMenuItem<int>> dropDownKategory =
                this.getDropDownKategori(snapshot.data.listKategori);
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text(snapshot.data.titleBar),
                actions: <Widget>[
                  // action button
                  IconButton(
                    color: Colors.green[900],
                    icon: Icon(Icons.done),
                    onPressed: () {
                      _saveKategori(snapshot.data);
                    },
                  ),
                  // overflow menu
                ],
              ),
              body: new Container(
                padding:
                    EdgeInsets.only(top: 15, left: 20, right: 15, bottom: 0),
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Jenis Transaksi'),
                      new DropdownButton(
                        value: snapshot.data.currentKategori.type.index,
                        items: dropDownTransaksi,
                        onChanged: changedDropDownTransaksi,
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
                      Text('Induk'),
                      new DropdownButton(
                        disabledHint: Text(txtNoParent),
                        value: snapshot.data.currentKategori.idParent,
                        items: dropDownKategory,
                        onChanged: snapshot.data.enableComboBox
                            ? changedDropDownKategori
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  void changedDropDownKategori(int selectedCategory) {
    _blocAddKategori.changeDropdownKategori(selectedCategory);
  }

  void changedDropDownTransaksi(int selectedTransaksi) {
    _blocAddKategori.changeDropdownJenisTransaksi(selectedTransaksi);
  }
}
