import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:keuangan/database/db_utility.dart';
import 'package:keuangan/keuangan/kategori/subkategori/add_subkategori_bloc.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/common_ui.dart';
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

  _saveSubKategori(Kategori k) async {
    String nama = _txtController.text;
    String catatan = _txtCatatanController.text;
    EnumResultDb enumResultDb =
        await _blocAddKategori.submitKategori(nama, catatan);
    if (enumResultDb == EnumResultDb.success) {
      Navigator.of(context).pop(EnumFinalResult.success);
    } else if (enumResultDb == EnumResultDb.duplicate) {
      _showToast('Kategori sudah ada.');
    } else {
      if (widget.stateAddCategory == StateAddCategory.baru) {
        _showToast('Kategori gagal di simpan');
      } else {
        _showToast('Kategori gagal di di edit');
      }
    }
  }

//  _eksekusiAfterBuild(BuildContext context, ItemUiAddSubKategori data)async{
//    if(data.enumStateFromBloc == EnumStateFromBloc.finish){
//      Navigator.of(context).pop(1);
//    }
//  }

  @override
  Widget build(BuildContext context) {
    if (_counterBuild == 0) {
      _blocAddKategori.loadFirstTime(
          widget.stateAddCategory, widget.kategori, widget.idparent);
      _counterBuild++;
    }

    return CustomToastForMe(
      child: StreamBuilder<ItemUiAddSubKategori>(
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
//            WidgetsBinding.instance.addPostFrameCallback(
//                    (_) => _eksekusiAfterBuild(context, snapshot.data));
              String header = snapshot.data.currentKategori.type ==
                      EnumJenisTransaksi.pemasukan
                  ? "Pemasukan"
                  : 'Pengeluaran';

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
                        _saveSubKategori(snapshot.data.currentKategori);
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
                        Text(
                            '$header - Parent: ${snapshot.data.kategoriParent.nama}'),
                        SizedBox(
                          height: 5,
                        ),
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
          }),
    );
  }

  _showToast(String messageToast) {
    showToast(messageToast,
        context: context,
        duration: Duration(seconds: 1),
        textStyle: TextStyle(fontSize: 16, color: Colors.white),
        backgroundColor: Colors.cyan[600],
        toastHorizontalMargin: 10.0,
        position:
        StyledToastPosition(align: Alignment.topCenter, offset: 70.0));
  }
}
