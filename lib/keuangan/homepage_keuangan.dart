import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keuangan/keuangan/bloc_hpkeuangan.dart';
import 'package:keuangan/keuangan/entry_item/keuangan_item.dart';
import 'package:keuangan/keuangan/transaksi/model_keuangan_ui.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/common_ui.dart';
import 'package:keuangan/util/loading_view.dart';
import 'package:keuangan/util/process_string.dart';
import 'package:keuangan/util/style.dart';

class HomepageKeuangan extends StatefulWidget {
  final Widget drawer;

  HomepageKeuangan({this.drawer});

  @override
  _HomepageKeuanganState createState() => _HomepageKeuanganState();
}

class _HomepageKeuanganState extends State<HomepageKeuangan> {
  int _counterBuild = 0;
  BlocHpKeuangan _blocHpKeuangan;

  @override
  void initState() {
    _blocHpKeuangan = new BlocHpKeuangan();
    super.initState();
  }

  Widget _textSmall(String text) {
    return Padding(
      padding: const EdgeInsets.only(top:5.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }

  Widget _widgetBalance(Size sizeWidget, int pmsk, int pngl, int blc) {
    final formatCurrency = new NumberFormat("#,##0", "idr");
    final txtPemasukan = formatCurrency.format(pmsk);
    final txtPengeluran = formatCurrency.format(pngl);
    final txtBalance = formatCurrency.format(blc);
    TextStyle styleBesar = StyleUi.textStyleBalanceBesarPositif;

    if (blc < 0) {
      styleBesar = StyleUi.textStyleBalanceBesarNegatif;
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            _textSmall('Balance'),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('Rp $txtBalance',style: styleBesar,),
            ),
          ],
        ),
        Divider(
          height: 5.0,
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  _textSmall('Pengeluaran'),
                  Text('Rp $txtPengeluran', style:StyleUi.textStyleBalanceMediumPengeluaran),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 20,
              color: Colors.grey,
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  _textSmall('Pemasukan'),
                  Text('Rp $txtPemasukan',style: StyleUi.textStyleBalanceMediumPemasukan),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _showDialogPilihan(Keuangan k) {
    ProcessString processString = new ProcessString();
    ItemName inm = k.lazyItemName;
    String tanggal = processString.dateToStringDdMmmmYyyy(k.tanggal);
    Entry entry = new Entry(inm.nama, inm.kategori, tanggal,k.tanggal, k, true, true);
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text('Pilihan'),
              children: <Widget>[
                new OutlineButton(
                  onPressed: () {
                    _edit(entry);
                  },
                  child: Text('edit'),
                ),
                new OutlineButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showDialogConfirmDelete(entry);
                  },
                  child: Text('delete'),
                ),
              ],
            ));
  }

  _showDialogConfirmDelete(Entry entry) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text('Apakah anda yakin akan menghapus record ini?'),
              children: <Widget>[
                new OutlineButton(
                  onPressed: () {
                    _deleteConfirmed(entry);
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

  _showDialogConfirmDeleteBeautifull(Entry entry) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
          title: Text('Apakah anda yakin akan menghapus record ini?'),
          children: <Widget>[
            new OutlineButton(
              onPressed: () {
                _deleteConfirmed(entry);
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

  _edit(Entry entry) async {
    int res = await openPage(
        context,
        KeuanganItemView(
          dateTime: DateTime.now(),
          isEditMode: true,
          keuangan: entry.keuangan,
        ));
    print('res : $res');
    Navigator.of(context).pop(res);
  }

  _deleteConfirmed(Entry entry) {
    _blocHpKeuangan.deleteTransaksi(entry);
    Navigator.of(context).pop();
  }

  Future openPage(context, Widget builder) async {
    // wait until animation finished
    await SwipeBackObserver.promise?.future;

    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => builder),
    );
  }

  List<Widget> listWidget(Size sizeWidget, UIHPKeuangan data) {
    List<Widget> lw = new List();
    lw.add(_widgetBalance(
        sizeWidget, data.pemasukan, data.pengeluaran, data.balance));
    lw.add(Divider());
    lw.add(Align(
      alignment: Alignment.centerLeft,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left:12.0),
          child: Text('Transaksi terakhir',style: Theme.of(context).textTheme.headline2,textAlign: TextAlign.left,),
        ),
      ),
    ));
    lw.add(SizedBox(
      height: 3,
    ));
    if (data.listKeuangan != null) {
     List<Keuangan> lKeuangan = data.listKeuangan;
      for(int i = 0; i< lKeuangan.length;i++){
        Keuangan ke = lKeuangan[i];
      Keuangan copyKeuangan = new Keuangan.fromUI(ke.tanggal, ke.idItemName, ke.jumlah, ke.catatan,ke.jenisTransaksi);
      copyKeuangan.lazyItemName = ke.lazyItemName;

        lw.add(FlatButton(
            onPressed: () {
              _showDialogPilihan(copyKeuangan);
            },
            child: CellKeuanganStateLess(copyKeuangan)));
      }
    }
    return lw;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size sizeWidget = mediaQueryData.size;
    if (_counterBuild == 0) {
      _blocHpKeuangan.fullReload();
      _counterBuild++;
    }

    return StreamBuilder<UIHPKeuangan>(
        stream: _blocHpKeuangan.uiHPKeuangan,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Keuangan'),
              ),
              drawer: widget.drawer,
              body: Container(
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: listWidget(sizeWidget, snapshot.data),
                  ),
                ),
              ),
              floatingActionButton: new FloatingActionButton(
                onPressed: () async {
                  EnumFinalResult res = await openPage(
                      context,
                      KeuanganItemView(
                        dateTime: DateTime.now(),
                        isEditMode: false,
                        keuangan: null,
                      ));
                  if (res == EnumFinalResult.success) {
                    _blocHpKeuangan.fullReload();
                  } else {
                    /// TODO gagal
                  }
                },
                tooltip: 'add Item',
                child: new Icon(Icons.add),
              ),
            );
          } else {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Keuangan'),
                ),
                body: LoadingView());
          }
        });
  }
}

class CellKeuanganStateLess extends StatefulWidget {
  final Keuangan keuangan;

  CellKeuanganStateLess(this.keuangan);

  @override
  _CellKeuanganStateLessState createState() => _CellKeuanganStateLessState();
}

class _CellKeuanganStateLessState extends State<CellKeuanganStateLess> {
  ProcessString _processString = ProcessString();

  @override
  Widget build(BuildContext context) {
    final formatCurrency = new NumberFormat("#,##0", "idr");
    int uang = widget.keuangan.jumlah.toInt();
    String tanggal = _processString.dateToStringDdMmmYyyyPendek(widget.keuangan.tanggal);

    ItemName itemName = widget.keuangan.lazyItemName;
    String subTitle = '${itemName.kategori.nama} ($tanggal)';
    TextStyle textStyle;
    if (itemName.kategori.type == EnumJenisTransaksi.pemasukan) {
      textStyle = StyleUi.textStylePemasukan;
    } else {
      textStyle = StyleUi.textStylePengeluaran;
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Divider(),
          Row(
            children: <Widget>[
              Text(
                itemName.nama,
                style: Theme.of(context).textTheme.headline3,
              ),
              Spacer(),
              Text(
                'Rp ${formatCurrency.format(uang)}',
                style: textStyle,
              ),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }
}
