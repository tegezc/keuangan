import 'package:flutter/material.dart';
import 'package:keuangan/keuangan/kategori/subkategori/add_subkategori_bloc.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/loading_view.dart';

class AddSubCategory extends StatefulWidget {
  final Kategori kategori;
  final StateAddCategory stateAddCategory;
  final int idparent;

  AddSubCategory.baru(this.idparent)
      : stateAddCategory = StateAddCategory.baruSubkategori,
        kategori = null;

  AddSubCategory.edit(this.kategori)
      : stateAddCategory = StateAddCategory.editSubkategori,
        idparent = null;

  @override
  _AddSubCategoryState createState() => _AddSubCategoryState();
}

class _AddSubCategoryState extends State<AddSubCategory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _txtController;
  TextEditingController _txtCatatanController;

  BlocAddSubKategori _blocAddKategori;
  int _counterBuild = 0;

  @override
  void initState() {
    _blocAddKategori = new BlocAddSubKategori();
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

  _saveKategori(Kategori k) async {
    String nama = _txtController.text;
    String catatan = _txtCatatanController.text;
    Kategori kategori = Kategori(nama, k.idParent,
        k.type, catatan, '');
    _blocAddKategori.submitKategori(kategori, widget.stateAddCategory);
  }

  @override
  Widget build(BuildContext context) {
    if (_counterBuild == 0) {
      _blocAddKategori.loadFirstTime(widget.stateAddCategory, widget.kategori,widget.idparent);
      _counterBuild++;
    }

    return StreamBuilder<ItemUiAddSubKategori>(
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
            String header = snapshot.data.currentKategori.type==EnumJenisTransaksi.pemasukan?"Pemasukan":'Pengeluaran';

            _txtCatatanController.text = snapshot.data.currentKategori.catatan;
            _txtController.text = snapshot.data.currentKategori.nama;

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
                      _saveKategori(snapshot.data.currentKategori);
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
                      Text('$header - Parent: ${snapshot.data.kategoriParent.nama}'),
                      SizedBox(height: 5,),
                      Text('Nama Sub Kategori'),
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

}
