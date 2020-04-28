import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keuangan/keuangan/kategori/subkategori/add_subkategori.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/loading_view.dart';

import '../../main.dart';
import 'add_kategori.dart';
import 'homepage_kategori_bloc.dart';

class HomePageKategori extends StatefulWidget {
  final Widget drawer;

  HomePageKategori({this.drawer});

  @override
  _HomePageKategoriState createState() => _HomePageKategoriState();
}

class _HomePageKategoriState extends State<HomePageKategori> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BlocHomepageKategori _blocHomepageKategori;
  EnumStatePopulateKategori _enumState;

  /// COUNTER UI
  int _counterBuild = 0;
  int _counterSaveSuccess = 0;
  int _counterEditSuccess = 0;
  int _counterSaveSubKategoriSuccess = 0;
  int _counterEditSubKategoriSuccess = 0;


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

  Widget _cellKategori(Kategori kategori) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FlatButton(
          child: Row(
            children: <Widget>[
              Text(
                '${kategori.nama}',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
          onPressed: () async {
            _showDialogPilihan(kategori);
          },
        ),
        kategori.listKategori.length == 0
            ? Container()
            : _cellSubKategori(kategori.listKategori),
        Divider(
          height: 1.0,
        ),
      ],
    );
  }

  Widget _cellSubKategori(List<Kategori> lsubkategori) {
    List<Widget> lw = new List();
    //lw.add(SizedBox(width: 5,));
    for (int i = 0; i < lsubkategori.length; i++) {
      Kategori kategori = lsubkategori[i];
      String kname = kategori.nama;
      lw.add(ChoiceChip(
        label: Text(
          kname,
          style: TextStyle(fontSize: 10),
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

  List<Widget> _listKategori(List<Kategori> lKategori) {
    List<Widget> lW = new List();
    for (int i = 0; i < lKategori.length; i++) {
      print('${lKategori[i].toString()}');
      lW.add(_cellKategori(lKategori[i]));
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
      _counterEditSuccess ++;
      String messageToast = 'Kategori berhasil di ubah.';
      this._showToast(messageToast);
    }else if (data.enumState == EnumStatePopulateKategori.editSubkategorisuccess &&
        _counterEditSubKategoriSuccess == 0){
      _counterEditSubKategoriSuccess++;
      String messageToast = 'Subkategori berhasil di ubah.';
      this._showToast(messageToast);
    }else if (data.enumState == EnumStatePopulateKategori.saveSubkategorisuccess &&
        _counterSaveSubKategoriSuccess == 0){
      _counterSaveSubKategoriSuccess++;
      String messageToast = 'Subkategori berhasil di simpan.';
      this._showToast(messageToast);
    }
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    if (_counterBuild == 0) {
      _blocHomepageKategori
          .populateAllKategoriFromDb(EnumStatePopulateKategori.firsttime);
      _counterBuild++;
    }
    return StreamBuilder<ItemUIHomepageKategori>(
        stream: _blocHomepageKategori.listKategoriStream,
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
            return Scaffold(
              key: _scaffoldKey,
              drawer: widget.drawer,
              appBar: new AppBar(
                title: new Text('Kategori'),
              ),
              body: ListView(
                scrollDirection: Axis.vertical,
                children: _listKategori(snapshot.data.listKategori),
              ),
              floatingActionButton: new FloatingActionButton(
                onPressed: () async {
                  int res = await openPage(context, AddCategory.baru());
                  //prevent snacbar showing
                  if (res == null) {
                    _enumState = null;
                  } else {
                    _counterSaveSuccess = 0;
                    _blocHomepageKategori.populateAllKategoriSaveEditSuccess(
                        EnumStatePopulateKategori.savesuccess);
                  }
                },
                tooltip: 'add kategori',
                child: new Icon(Icons.add),
              ),
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
      lw.add(new OutlineButton(
        onPressed: () {
          _addSubKategori(kategori.id);
        },
        child: Text('tambah subkategori'),
      ));

      lw.add(new OutlineButton(
        onPressed: () {
          _edit(kategori);
        },
        child: Text('edit'),
      ));

      lw.add(new OutlineButton(
        onPressed: () {
          Navigator.of(context).pop();
          _showDialogConfirmDelete(kategori);
        },
        child: Text('delete'),
      ));
    } else {
      lw.add(new OutlineButton(
        onPressed: () {
          _editSubKategori(kategori);
        },
        child: Text('edit subkategori'),
      ));

      lw.add(new OutlineButton(
        onPressed: () {
          Navigator.of(context).pop();
          _showDialogConfirmDelete(kategori);
        },
        child: Text('delete'),
      ));
    }
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text('Pilihan'),
              children: lw,
            ));
  }

  _showDialogConfirmDelete(Kategori kategori) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text('Apakah anda yakin akan menghapus record ini?'),
              children: <Widget>[
                new OutlineButton(
                  onPressed: () {
                    _deleteConfirmed(kategori);
                  },
                  child: Text('ya'),
                ),
                new OutlineButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('tidak'),
                ),
              ],
            ));
  }

  _deleteConfirmed(Kategori kategori) {}

  _edit(Kategori kategori) async {
    int res = await openPage(context, AddCategory.edit(kategori));
    Navigator.of(context).pop();

    //prevent snacbar showing
    if (res == null) {
      _enumState = null;
    } else {
      _counterEditSuccess = 0;
      _blocHomepageKategori
          .populateAllKategoriSaveEditSuccess(EnumStatePopulateKategori.editsuccess);
    }
  }

  _addSubKategori(int idparent) async {
    int res = await openPage(context, AddSubCategory.baru(idparent));
    Navigator.of(context).pop();

    //prevent snacbar showing
    if (res == null) {
      _enumState = null;
    } else {
      _counterSaveSubKategoriSuccess = 0;
      _blocHomepageKategori
          .populateAllKategoriFromDb(EnumStatePopulateKategori.saveSubkategorisuccess);

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
      _blocHomepageKategori
          .populateAllKategoriFromDb(EnumStatePopulateKategori.editSubkategorisuccess);
    }
  }
}
