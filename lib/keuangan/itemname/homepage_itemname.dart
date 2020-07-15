import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keuangan/keuangan/itemname/bloc_hpitemname.dart';
import 'package:keuangan/keuangan/itemname/itemname_entry.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/common_ui.dart';
import 'package:keuangan/util/loading_view.dart';

class HomePageItemName extends StatefulWidget {
  final Widget drawer;

  HomePageItemName({this.drawer});

  @override
  _HomePageItemNameState createState() => _HomePageItemNameState();
}

class _HomePageItemNameState extends State<HomePageItemName> {
  BlocHomepageItemName _blocHomepageItemName;
  EnumStatePopulateItemName _enumState;
  int _counterBuild = 0;
  CommonUi _commonUi;
  FlutterToast _flutterToast;
  @override
  initState() {
    _flutterToast = FlutterToast(context);
    _commonUi = new CommonUi();
    _blocHomepageItemName = new BlocHomepageItemName();
    super.initState();
  }

  Widget _itemNameCellPengeluaran(ItemName itemName) {
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
              Text('${itemName.kategori.nama}',
                  style: TextStyle(fontSize: 15, color: Colors.red)),
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

  Widget _itemNameCellPemasukan(ItemName itemName) {
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
              Text('${itemName.kategori.nama}',
                  style: TextStyle(fontSize: 15, color: Colors.green)),
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

  List<Widget> _listWidgetItemName(
      List<ItemName> lpengeluaaran, List<ItemName> lPemasukan) {
    List<Widget> lW = new List();
    if (lpengeluaaran.isEmpty && lPemasukan.isEmpty) {
      lW.add(Center(
          child: Text('Belum ada data', style: TextStyle(fontSize: 15))));
    } else {
      for (int i = 0; i < lpengeluaaran.length; i++) {
        lW.add(_itemNameCellPengeluaran(lpengeluaaran[i]));
      }

      for (int i = 0; i < lPemasukan.length; i++) {
        lW.add(_itemNameCellPemasukan(lPemasukan[i]));
      }
    }

    lW.add(SizedBox(height: 200.0,));

    return lW;
  }

  @override
  Widget build(BuildContext context) {
    if (_counterBuild == 0) {
      _counterBuild++;
      _blocHomepageItemName
          .populateSemuaItemNameFromDb(EnumStatePopulateItemName.firsttime);
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

            final List<Widget> _actionButtons = new List();
            _actionButtons.add(IconButton(
                icon: Icon(Icons.add),
                onPressed: () async{
                  int res =
                      await _commonUi.openPage(context, ItemNameEntry.baru());

                  //prevent snacbar showing
                  if (res == null) {
                    _enumState = null;
                  } else if (res == 1) {
                    /// 1 konstanta penanda save success
                    _blocHomepageItemName.populateSemuaItemNameFromDb(
                        EnumStatePopulateItemName.savesuccess);
                    String messageToast = 'Item berhasil di simpan.';
                    this._showToast(messageToast);
                  }
                }));
            return Scaffold(
              drawer: widget.drawer,
              appBar: new AppBar(
                title: new Text('Item Cepat'),
                actions: _actionButtons,
              ),
              body: ListView(
                scrollDirection: Axis.vertical,
                children: _listWidgetItemName(
                    snapshot.data.listPengeluaran, snapshot.data.listPemasukan),
              ),
//              floatingActionButton: new FloatingActionButton(
//                onPressed: () async {
//                  int res =
//                      await _commonUi.openPage(context, ItemNameEntry.baru());
//
//                  //prevent snacbar showing
//                  if (res == null) {
//                    _enumState = null;
//                  } else if (res == 1) {
//                    /// 1 konstanta penanda save success
//                    _blocHomepageItemName.populateSemuaItemNameFromDb(
//                        EnumStatePopulateItemName.savesuccess);
//                    String messageToast = 'Item berhasil di simpan.';
//                    _commonUi.showToastBottom(messageToast);
//                  }
//                },
//                tooltip: 'add Item',
//                child: new Icon(Icons.add),
//              ),
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

  _showDialogPilihan(ItemName itemName) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text('Pilihan'),
              children: <Widget>[
                new OutlineButton(
                  onPressed: () {
                    _edit(itemName);
                  },
                  child: Text('edit'),
                ),
                new OutlineButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showDialogConfirmDelete(itemName);
                  },
                  child: Text('delete'),
                ),
              ],
            ));
  }

  _showDialogConfirmDelete(ItemName itemName) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text('Apakah anda yakin akan menghapus record ini?'),
              children: <Widget>[
                new OutlineButton(
                  onPressed: () {
                    _deleteConfirmed(itemName);
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

  _deleteConfirmed(ItemName itemName) {
    if (itemName != null) {
      _blocHomepageItemName.deleteAction(
          itemName, EnumStatePopulateItemName.deleteSuccess);
      Navigator.of(context).pop();
    }
  }

  _edit(ItemName itemname) async {
    int res = await _commonUi.openPage(context, ItemNameEntry.edit(itemname));
    Navigator.of(context).pop();

    //prevent snacbar showing
    if (res == null) {
      _enumState = null;
    } else if (res == 2) {
      /// 2 konstanta penanda proses update
      _blocHomepageItemName
          .populateSemuaItemNameFromDb(EnumStatePopulateItemName.editsuccess);

      String messageToast = 'Item berhasil di update';
      this._showToast(messageToast);
    }
  }

  _showToast(String messageToast) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text(messageToast),
        ],
      ),
    );


    _flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
}
