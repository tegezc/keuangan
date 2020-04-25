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
    _blocAddKategori.submitKategori(nama,catatan);

  }

  List<DropdownMenuItem<int>> _getDropDownTransaksi() {
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

  _eksekusiAfterBuild(BuildContext context, ItemUiAddKategori data)async{
    if(data.enumStateFromBloc == EnumStateFromBloc.finish){
      Navigator.of(context).pop(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_counterBuild == 0) {
      _blocAddKategori.loadFirstTime(widget.stateAddCategory, widget.kategori,widget.idparent);
      _counterBuild++;
    }

    final List<DropdownMenuItem<int>> dropDownTransaksi =
        _getDropDownTransaksi();
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
            WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _eksekusiAfterBuild(context, snapshot.data));
            _txtController.text = snapshot.data.currentKategori.nama;
            _txtCatatanController.text = snapshot.data.currentKategori.catatan;
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
                        onChanged: _changedDropDownTransaksi,
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
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  void _changedDropDownTransaksi(int selectedTransaksi) {
    _blocAddKategori.changeDropdownJenisTransaksi(selectedTransaksi);
  }
}
