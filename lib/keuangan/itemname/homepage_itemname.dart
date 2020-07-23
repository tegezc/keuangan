import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
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

  final Color _colorButton = Colors.cyan[600];
  final Color _colorTextBtn = Colors.white;

  @override
  initState() {

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

    lW.add(SizedBox(
      height: 200.0,
    ));

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
                onPressed: () async {
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
                      _edit(itemName);
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
                      _showDialogConfirmDelete(itemName);
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

  _showDialogConfirmDelete(ItemName itemName) {
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
                      _deleteConfirmed(itemName);
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
                      'tidak',
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
    showToast(messageToast,
        context: context,
        toastHorizontalMargin: 10.0,
        position: StyledToastPosition(
            align: Alignment.bottomCenter, offset: 70.0));
  }
}
