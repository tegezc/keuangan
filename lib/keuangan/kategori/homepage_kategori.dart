import 'package:flutter/material.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/loading_view.dart';

import '../../main.dart';
import 'add_kategori.dart';
import 'homepage_kategori_bloc.dart';

class HomePageKategori extends StatefulWidget {
  @override
  _HomePageKategoriState createState() => _HomePageKategoriState();
}

class _HomePageKategoriState extends State<HomePageKategori> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BlocHomepageKategori _blocHomepageKategori;
  EnumStatePopulateKategori _enumState;

  @override
  initState() {
    _blocHomepageKategori = new BlocHomepageKategori();
    super.initState();
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
      lW.add(_cellKategori(lKategori[i]));
    }
    return lW;
  }

  Future openPage(context, Widget builder) async {
    // wait until animation finished
    await SwipeBackObserver.promise?.future;

    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => builder),
    );
  }

  @override
  Widget build(BuildContext context) {
   // WidgetsBinding.instance.addPostFrameCallback((_) => _afterBuild(context));
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

            //////////////

            return Scaffold(
              key: _scaffoldKey,
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
                  Navigator.of(context).pop();

                  //prevent snacbar showing
                  if (res == null) {
                    _enumState = null;
                  } else {
                    _blocHomepageKategori.populateAllKategoriFromDb(
                        EnumStatePopulateKategori.savesuccess);
                    String messageSnackBar = 'Kategori berhasil di simpan.';
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: SizedBox(
                          height: 30.0, child: Center(child: Text(messageSnackBar))),
                      duration: Duration(milliseconds: 1000),
                    ));
                  }
                },
                tooltip: 'add kategori',
                child: new Icon(Icons.add),
              ),
            );
          } else {
            _enumState = null;
            return Scaffold(
              appBar: new AppBar(
                title: new Text('Transaksi'),
              ),
              body: LoadingView(),
            );
          }
        });
  }


  _showDialogPilihan(Kategori kategori){
    List<Widget> lw = new List();
    if(kategori.idParent == 0){
      lw.add(new OutlineButton(
        onPressed: (){
          _addSubKategori(kategori);
        },
        child: Text('tambah subkategori'),
      ));

      lw.add(new OutlineButton(
        onPressed: (){
          _edit(kategori);
        },
        child: Text('edit'),
      ));

      lw.add(new OutlineButton(
        onPressed: (){
          Navigator.of(context).pop();
          _showDialogConfirmDelete(kategori);
        },
        child: Text('delete'),
      ));
    }else{
      lw.add(new OutlineButton(
        onPressed: (){
          _edit(kategori);
        },
        child: Text('edit subkategori'),
      ));

      lw.add(new OutlineButton(
        onPressed: (){
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

  _showDialogConfirmDelete(Kategori kategori){
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
          title: Text('Apakah anda yakin akan menghapus record ini?'),
          children: <Widget>[
            new OutlineButton(
              onPressed: (){
                _deleteConfirmed(kategori);
              },
              child: Text('ya'),
            ),
            new OutlineButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text('tidak'),
            ),
          ],
        ));
  }

  _deleteConfirmed(Kategori kategori){


  }

  _edit(Kategori kategori)async{
    int res = await openPage(context, AddCategory.edit(kategori));
    Navigator.of(context).pop();

    //prevent snacbar showing
    if (res == null) {
      _enumState = null;
    } else {
      _blocHomepageKategori.populateAllKategoriFromDb(
          EnumStatePopulateKategori.editsuccess);

      String messageSnackBar = 'Kategori berhasil di update';
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: SizedBox(
            height: 30.0, child: Center(child: Text(messageSnackBar))),
        duration: Duration(milliseconds: 1000),
      ));
    }

  }

  _addSubKategori(Kategori kategori)async{
    int res = await openPage(context, AddCategory.addSubkategori(kategori));
    Navigator.of(context).pop();

    //prevent snacbar showing
    if (res == null) {
      _enumState = null;
    } else {
      _blocHomepageKategori.populateAllKategoriFromDb(
          EnumStatePopulateKategori.editsuccess);

      String messageSnackBar = 'Kategori berhasil di update';
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: SizedBox(
            height: 30.0, child: Center(child: Text(messageSnackBar))),
        duration: Duration(milliseconds: 1000),
      ));
    }

  }
}
