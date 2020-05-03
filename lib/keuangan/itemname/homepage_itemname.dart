import 'package:flutter/material.dart';
import 'package:keuangan/keuangan/itemname/itemname_bloc.dart';
import 'package:keuangan/keuangan/itemname/itemname_entry.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/loading_view.dart';

import '../../main.dart';

class HomePageItemName extends StatefulWidget {
  final Widget drawer;
  HomePageItemName({this.drawer});
  @override
  _HomePageItemNameState createState() => _HomePageItemNameState();
}

class _HomePageItemNameState extends State<HomePageItemName> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BlocHomepageItemName _blocHomepageItemName;
  EnumStatePopulateItemName _enumState;
  int _counterBuild = 0;

  @override
  initState() {

    _blocHomepageItemName = new BlocHomepageItemName();
    super.initState();
  }

  Widget _itemNameCell(ItemName itemName) {
   // print(itemName);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FlatButton(
          child: Row(
            children: <Widget>[
              Text(
                '${itemName.nama}',
                style: TextStyle(fontSize: 15),
              ),
              Spacer(),
              Text('${itemName.kategori.nama}',style: TextStyle(fontSize: 15,color: Colors.lightGreen)),
            ],
          ),
          onPressed: () async {
              _showDialogPilihan(itemName);
          },
        ),
        Divider(
          height: 1.0,
        ),
      ],
    );
  }

  List<Widget> _listWidgetItemName(List<ItemName> lin) {
    List<Widget> lW = new List();
    if(lin.isEmpty){
      lW.add(Center(child: Text('Belum ada data',style: TextStyle(fontSize: 15))));
    }
    for (int i = 0; i < lin.length; i++) {
      lW.add(_itemNameCell(lin[i]));
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
    if(_counterBuild == 0){
      _counterBuild++;
      _blocHomepageItemName.populateSemuaItemNameFromDb(EnumStatePopulateItemName.firsttime);
    }
    return StreamBuilder<ItemUIHomepageItemName>(
        stream: _blocHomepageItemName.listItemNameStream,
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
              drawer: widget.drawer,
              appBar: new AppBar(
                title: new Text('Item Cepat'),
              ),
              body: ListView(
                scrollDirection: Axis.vertical,
                children: _listWidgetItemName(snapshot.data.listItemName),
              ),
              floatingActionButton: new FloatingActionButton(
                onPressed: () async {
                  int res = await openPage(context, ItemNameEntry.baru());

                  //prevent snacbar showing
                  if (res == null) {
                    _enumState = null;
                  } else {
                    _blocHomepageItemName.populateSemuaItemNameFromDb(
                        EnumStatePopulateItemName.savesuccess);
                    String messageSnackBar = 'Item berhasil di simpan.';
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: SizedBox(
                          height: 30.0, child: Center(child: Text(messageSnackBar))),
                      duration: Duration(milliseconds: 1000),
                    ));
                  }
                },
                tooltip: 'add Item',
                child: new Icon(Icons.add),
              ),
            );
          } else {
            _enumState = null;
            return Scaffold(
              drawer: widget.drawer,
              appBar: new AppBar(
                title: new Text('Item Cepat'),
              ),
              body: LoadingView(),
            );
          }
        });
  }

  _showDialogPilihan(ItemName itemName){
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
          title: Text('Pilihan'),
          children: <Widget>[
            new OutlineButton(
              onPressed: (){
                _edit(itemName);
              },
              child: Text('edit'),
            ),
            new OutlineButton(
              onPressed: (){
                Navigator.of(context).pop();
                _showDialogConfirmDelete(itemName);
              },
              child: Text('delete'),
            ),
          ],
        ));
  }

  _showDialogConfirmDelete(ItemName itemName){
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
          title: Text('Apakah anda yakin akan menghapus record ini?'),
          children: <Widget>[
            new OutlineButton(
              onPressed: (){
                _deleteConfirmed(itemName);
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

  _deleteConfirmed(ItemName itemName){
    if(itemName != null){
      _blocHomepageItemName.deleteActioni(itemName,EnumStatePopulateItemName.deleteSuccess);
      Navigator.of(context).pop();
    }

  }

  _edit(ItemName itemname)async{
    int res = await openPage(context, ItemNameEntry.edit(itemname));
    Navigator.of(context).pop();

    //prevent snacbar showing
    if (res == null) {
      _enumState = null;
    } else if(res == 2){
      _blocHomepageItemName.populateSemuaItemNameFromDb(
          EnumStatePopulateItemName.editsuccess);

      String messageSnackBar = 'Item berhasil di update';
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: SizedBox(
            height: 30.0, child: Center(child: Text(messageSnackBar))),
        duration: Duration(milliseconds: 1000),
      ));
    }
  }
}
