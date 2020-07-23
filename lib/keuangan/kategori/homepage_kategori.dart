import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:keuangan/keuangan/kategori/subkategori/add_subkategori.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/colors_utility.dart';
import 'package:keuangan/util/common_ui.dart';
import 'package:keuangan/util/loading_view.dart';

import 'add_kategori.dart';
import 'homepage_kategori_bloc.dart';

class HomePageKategori extends StatefulWidget {
  final Widget drawer;

  HomePageKategori({this.drawer});

  @override
  _HomePageKategoriState createState() => _HomePageKategoriState();
}

class _HomePageKategoriState extends State<HomePageKategori> {
  BlocHomepageKategori _blocHomepageKategori;
  EnumStatePopulateKategori _enumState;

  /// COUNTER UI
  int _counterBuild = 0;
  int _counterSaveSuccess = 0;
  int _counterEditSuccess = 0;
  int _counterSaveSubKategoriSuccess = 0;
  int _counterEditSubKategoriSuccess = 0;

  final Color _colorButton = Colors.cyan[600];
  final Color _colorTextBtn = Colors.white;

  @override
  initState() {
    _blocHomepageKategori = new BlocHomepageKategori();
    super.initState();
  }

  @override
  void dispose() {
    _blocHomepageKategori.dispose();
    super.dispose();
  }

  Widget _cellBelumAdaData() {
    return Container(
      height: 40.0,
      width: double.infinity,
      child: Center(
        child: Text(
          'Belum ada data',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11),
        ),
      ),
    );
  }

  Widget _cellHeader(EnumJenisTransaksi enumJenisTransaksi) {
    Color bgColor = Colors.green;
    String text = 'Pemasukan';
    if (enumJenisTransaksi == EnumJenisTransaksi.pengeluaran) {
      bgColor = Colors.red;
      text = 'Pengeluaran';
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: bgColor,
        height: 25.0,
        width: double.infinity,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ),
    );
  }

  Widget _cellKategori(Kategori kategori) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 3.0, left: 8.0, right: 8.0, bottom: 5.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.cyan[600]),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 0, left: 8.0, right: 8.0, bottom: 0),
              child: FlatButton(
                color: HexColor('#c6f0ff'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  // side: BorderSide(color: Colors.lightGreen)
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      '${kategori.nama}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                onPressed: () async {
                  _showDialogPilihan(kategori);
                },
              ),
            ),
            kategori.listKategori.length == 0
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(
                        left: 14.0, right: 8.0, top: 0.0, bottom: 0.0),
                    child: Text(
                        '(${kategori.listKategori.length} Sub-kategori)',
                        style: TextStyle(fontSize: 12)),
                  ),
            kategori.listKategori.length == 0
                ? Container()
                : _cellSubKategori(kategori.listKategori),
            Divider(
              height: 1.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _cellSubKategori(List<Kategori> lsubkategori) {
    List<Widget> lw = new List();
    //lw.add(SizedBox(width: 5,));
    for (int i = 0; i < lsubkategori.length; i++) {
      Kategori kategori = lsubkategori[i];
      String kname = kategori.nama;
      lw.add(ChoiceChip(
        backgroundColor: HexColor('#e3f3fc'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          //  side: BorderSide(color: Colors.lightGreen)
        ),
        label: Text(
          kname,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        selected: false,
        onSelected: (selected) async {
          _showDialogPilihan(kategori);
        },
      ));
    }

    return Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          spacing: 10.0,
          runSpacing: 0.0,
          children: lw,
        ),
      ],
    );
  }

  List<Widget> _listKategori(
      List<Kategori> lkPengeluaran, List<Kategori> lkPemasukan) {
    List<Widget> lW = new List();
    if (lkPemasukan.isEmpty && lkPengeluaran.isEmpty) {
      lW.add(_cellBelumAdaData());
    } else {
      if (lkPengeluaran.isNotEmpty) {
        lW.add(_cellHeader(EnumJenisTransaksi.pengeluaran));
        for (int i = 0; i < lkPengeluaran.length; i++) {
          lW.add(_cellKategori(lkPengeluaran[i]));
        }
      }

      if (lkPemasukan.isNotEmpty) {
        lW.add(_cellHeader(EnumJenisTransaksi.pemasukan));
        for (int i = 0; i < lkPemasukan.length; i++) {
          lW.add(_cellKategori(lkPemasukan[i]));
        }
      }
    }

    lW.add(SizedBox(
      height: 200,
    ));
    return lW;
  }

  Future openPage(context, Widget builder) async {
    // wait until animation finished
    await SwipeBackObserver.promise?.future;

    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => builder),
    );
  }

  _eksekusiAfterBuild(BuildContext context, ItemUIHomepageKategori data) {
    if (data.enumState == EnumStatePopulateKategori.savesuccess &&
        _counterSaveSuccess == 0) {
      _counterSaveSuccess++;
      String messageToast = 'Kategori berhasil di simpan.';
      this._showToast(messageToast);
    } else if (data.enumState == EnumStatePopulateKategori.editsuccess &&
        _counterEditSuccess == 0) {
      _counterEditSuccess++;
      String messageToast = 'Kategori berhasil di ubah.';
      this._showToast(messageToast);
    } else if (data.enumState ==
            EnumStatePopulateKategori.editSubkategorisuccess &&
        _counterEditSubKategoriSuccess == 0) {
      _counterEditSubKategoriSuccess++;
      String messageToast = 'Subkategori berhasil di ubah.';
      this._showToast(messageToast);
    } else if (data.enumState ==
            EnumStatePopulateKategori.saveSubkategorisuccess &&
        _counterSaveSubKategoriSuccess == 0) {
      _counterSaveSubKategoriSuccess++;
      String messageToast = 'Subkategori berhasil di simpan.';
      this._showToast(messageToast);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_counterBuild == 0) {
      _blocHomepageKategori
          .populateAllKategoriFromDb(EnumStatePopulateKategori.firsttime);
      _counterBuild++;
    }
    return StreamBuilder<ItemUIHomepageKategori>(
        stream: _blocHomepageKategori.itemUIHomepageKategori,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ///prevent snacbar show twice
            //_enumState = snapshot.data.enumState;
            if (_enumState != snapshot.data.enumState) {
              _enumState = snapshot.data.enumState;
            } else {
              _enumState = null;
            }
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => _eksekusiAfterBuild(context, snapshot.data));
            final List<Widget> _actionButtons = new List();
            _actionButtons.add(IconButton(
                icon: Icon(Icons.add),
                // color: Colors.blue,
                onPressed: () async {
                  int res = await openPage(context, AddCategory.baru());
                  //prevent snacbar showing
                  if (res == null) {
                    _enumState = null;
                  } else {
                    _counterSaveSuccess = 0;
                    _blocHomepageKategori.populateAllKategoriFromDb(
                        EnumStatePopulateKategori.savesuccess);
                  }
                }));
            return Scaffold(
              drawer: widget.drawer,
              appBar: new AppBar(
                title: new Text('Kategori'),
                actions: _actionButtons,
              ),
              body: ListView(
                scrollDirection: Axis.vertical,
                children: _listKategori(snapshot.data.listKategoriPengeluaran,
                    snapshot.data.listKategoriPemasukan),
              ),
//              floatingActionButton: new FloatingActionButton(
//                onPressed: () async {
//                  int res = await openPage(context, AddCategory.baru());
//                  //prevent snacbar showing
//                  if (res == null) {
//                    _enumState = null;
//                  } else {
//                    _counterSaveSuccess = 0;
//                    _blocHomepageKategori.populateAllKategoriFromDb(
//                        EnumStatePopulateKategori.savesuccess);
//                  }
//                },
//                tooltip: 'add kategori',
//                child: new Icon(Icons.add),
//              ),
            );
          } else {
            _enumState = null;
            return Scaffold(
              drawer: widget.drawer,
              appBar: new AppBar(
                title: new Text('Transaksi'),
              ),
              body: LoadingView(),
            );
          }
        });
  }

  _showDialogPilihan(Kategori kategori) {
    List<Widget> lw = new List();

    if (kategori.idParent == 0) {
      lw.add(
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 3.0),
          child: RaisedButton(
            color: _colorButton,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: BorderSide(color: Colors.cyan)),
            onPressed: () async {
              _addSubKategori(kategori.id);
            },
            child: Text(
              'tambah subkategori',
              style: TextStyle(
                  color: _colorTextBtn,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          ),
        ),
      );
      lw.add(
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 3.0),
          child: RaisedButton(
            color: _colorButton,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: BorderSide(color: Colors.cyan)),
            onPressed: () async {
              _edit(kategori);
            },
            child: Text(
              'edit',
              style: TextStyle(
                  color: _colorTextBtn,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          ),
        ),
      );

      lw.add(
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 3.0),
          child: RaisedButton(
            color: _colorButton,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: BorderSide(color: Colors.cyan)),
            onPressed: () async {
              Navigator.of(context).pop();
              _showDialogConfirmDelete(kategori);
            },
            child: Text(
              'delete',
              style: TextStyle(
                  color: _colorTextBtn,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          ),
        ),
      );
    } else {
      lw.add(
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 3.0),
          child: RaisedButton(
            color: _colorButton,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: BorderSide(color: Colors.cyan)),
            onPressed: () async {
              _editSubKategori(kategori);
            },
            child: Text(
              'edit subkategori',
              style: TextStyle(
                  color: _colorTextBtn,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          ),
        ),
      );

      lw.add(
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 3.0),
          child: RaisedButton(
            color: _colorButton,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: BorderSide(color: Colors.cyan)),
            onPressed: () async {
              Navigator.of(context).pop();
              _showDialogConfirmDelete(kategori);
            },
            child: Text(
              'delete',
              style: TextStyle(
                  color: _colorTextBtn,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          ),
        ),
      );
    }
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              title: Text('Pilihan'),
              children: lw,
            ));
  }

  _showDialogConfirmDelete(Kategori kategori) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text('Apakah anda yakin akan menghapus record ini?'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      right: 16.0, left: 16.0, bottom: 3.0),
                  child: RaisedButton(
                    color: _colorButton,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(color: Colors.cyan)),
                    onPressed: () async {
                      _deleteConfirmed(kategori);
                    },
                    child: Text(
                      'ya',
                      style: TextStyle(
                          color: _colorTextBtn,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 16.0, left: 16.0, bottom: 3.0),
                  child: RaisedButton(
                    color: _colorButton,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(color: Colors.cyan)),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'delete',
                      style: TextStyle(
                          color: _colorTextBtn,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ));
  }

  _deleteConfirmed(Kategori kategori) {
    _blocHomepageKategori.deleteKategori(kategori);

    /// dismiss showDialog
    Navigator.of(context).pop();
  }

  _edit(Kategori kategori) async {
    int res = await openPage(context, AddCategory.edit(kategori));

    /// dismiss showDialog
    Navigator.of(context).pop();

    //prevent snacbar showing
    if (res == null) {
      _enumState = null;
    } else {
      _counterEditSuccess = 0;
      _blocHomepageKategori
          .populateAllKategoriFromDb(EnumStatePopulateKategori.editsuccess);
    }
  }

  _addSubKategori(int idparent) async {
    int res = await openPage(context, AddSubCategory.baru(idparent));
    Navigator.of(context).pop();

    ///prevent snacbar showing
    if (res == null) {
      _enumState = null;
    } else {
      _counterSaveSubKategoriSuccess = 0;
      _blocHomepageKategori.populateAllKategoriFromDb(
          EnumStatePopulateKategori.saveSubkategorisuccess);
    }
  }

  _editSubKategori(Kategori kategori) async {
    int res = await openPage(context, AddSubCategory.edit(kategori));
    Navigator.of(context).pop();

    //prevent snacbar showing
    if (res == null) {
      _enumState = null;
    } else {
      _counterEditSubKategoriSuccess = 0;
      _blocHomepageKategori.populateAllKategoriFromDb(
          EnumStatePopulateKategori.editSubkategorisuccess);
    }
  }

  _showToast(String messageToast) {
    showToast(messageToast,
        context: context,
        toastHorizontalMargin: 10.0,
        position: StyledToastPosition(
            align: Alignment.bottomCenter, offset: 70.0));
  }

}
