import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:keuangan/keuangan/itemname/bloc_hpitemname.dart';
import 'package:keuangan/keuangan/itemname/itemname_entry.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/adsmob.dart';
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

  BannerAd _bannerAd;

  @override
  initState() {
    _commonUi = new CommonUi();
    _blocHomepageItemName = new BlocHomepageItemName();
    _loadBannerAd();
    super.initState();
  }

  @override
  dispose(){
    _blocHomepageItemName.dispose();
    this._disposeBanner();
    super.dispose();
  }

  void _loadBannerAd() {
    if(AdManager.isAdmobOn()){
    if (_bannerAd == null) {
      _bannerAd = BannerAd(
        adUnitId: AdManager.bannerAdUnitId(EnumBannerId.hpItemName),
        size: AdSize.banner,
      );
      _bannerAd
        ..load().then((value) {
          if (value) {
            _bannerAd..show(anchorType: AnchorType.bottom);
          }
        });
    }}
  }

  void _disposeBanner() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  _baruAction() async {
    EnumFinalResult res =
    await _commonUi.openPage(context, ItemNameEntry.baru());
    print('res: $res');
    if (res != null) {
      if (res == EnumFinalResult.success) {
        _blocHomepageItemName.populateSemuaItemNameFromDb(
            EnumStatePopulateItemName.savesuccess);
        _showToast('Item berhasil di disimpan.');
      }
    }
    // Navigator.of(context).pop();
  }

  _actionPushPage(ItemName itemName) {
    /// setiap push ke entry transaksi, banner di dispose
    this._disposeBanner();

    /// proses baru
    if (itemName == null) {
      _baruAction();
    }
    ///proses edit
    else {
      _edit(itemName);
    }

    /// setiap kembali ke page ini, banner di load kembali
    _loadBannerAd();
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

    return CustomToastForMe(
      child: StreamBuilder<ItemUIHomepageItemName>(
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
                    _actionPushPage(null);
                  }));
              return Scaffold(
                drawer: widget.drawer,
                appBar: new AppBar(
                  title: new Text('Item Cepat'),
                  actions: _actionButtons,
                ),
                body: ListView(
                  scrollDirection: Axis.vertical,
                  children: _listWidgetItemName(snapshot.data.listPengeluaran,
                      snapshot.data.listPemasukan),
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
          }),
    );
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
                      _actionPushPage(itemName);
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
    EnumFinalResult res =
        await _commonUi.openPage(context, ItemNameEntry.edit(itemname));

    if (res != null) {
      if (res == EnumFinalResult.success) {
        _blocHomepageItemName
            .populateSemuaItemNameFromDb(EnumStatePopulateItemName.editsuccess);
        _showToast('Item berhasil di update.');
      }
    }
    Navigator.of(context).pop();
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
