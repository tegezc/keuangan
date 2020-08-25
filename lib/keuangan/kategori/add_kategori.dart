import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:keuangan/database/db_utility.dart';
import 'package:keuangan/keuangan/kategori/add_kategori_bloc.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/common_ui.dart';
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
  final TextStyle _styleTextDesc =
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue);
  final _decorationNama = InputDecoration(
    // border: OutlineInputBorder(),
    hintText: 'nama kategori',
  );

  final _decorationKet = InputDecoration(
    // border: OutlineInputBorder(),
    hintText: 'keterangan',
  );

  bool isHaveSubkategori;

  @override
  void initState() {
    isHaveSubkategori = widget.kategori.listKategori.length > 0;
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

  @override
  Widget build(BuildContext context) {
    if (_counterBuild == 0) {
      _blocAddKategori.loadFirstTime(
          widget.stateAddCategory, widget.kategori, widget.idparent);
      _counterBuild++;
    }

    final List<DropdownMenuItem<int>> dropDownTransaksi =
        _getDropDownTransaksi();
    return CustomToastForMe(
      child: StreamBuilder<ItemUiAddKategori>(
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
              _txtController.text = snapshot.data.currentKategori.nama;
              _txtCatatanController.text =
                  snapshot.data.currentKategori.catatan;
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
                        Text(
                          'Jenis Transaksi:',
                          style: _styleTextDesc,
                        ),
                        isHaveSubkategori
                            ? Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(top:3.0,bottom: 8.0),
                                  child: Text(
                                      '${widget.kategori.type == EnumJenisTransaksi.pengeluaran ? 'Pengeluaran' : 'Pemasukan'}',
                                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                ),
                              )
                            : new DropdownButton(
                                value: snapshot.data.currentKategori.type.index,
                                items: dropDownTransaksi,
                                onChanged: _changedDropDownTransaksi,
                              ),
                        Text(
                          'Nama Kategori:',
                          style: _styleTextDesc,
                        ),
                        TextField(
                          decoration: _decorationNama,
                          controller: _txtController,
                          maxLines: 1,
                        ),
                        Text(
                          'Keterangan (Optional):',
                          style: _styleTextDesc,
                        ),
                        TextField(
                          decoration: _decorationKet,
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

  void _changedDropDownTransaksi(int selectedTransaksi) {
    _blocAddKategori.changeDropdownJenisTransaksi(selectedTransaksi);
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
