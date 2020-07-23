import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:intl/intl.dart';
import 'package:keuangan/keuangan/bloc_hpkeuangan.dart';
import 'package:keuangan/keuangan/entry_item/keuangan_item.dart';
import 'package:keuangan/keuangan/transaksi/model_keuangan_ui.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/adsmob.dart';
import 'package:keuangan/util/common_ui.dart';
import 'package:keuangan/util/loading_view.dart';
import 'package:keuangan/util/process_string.dart';
import 'package:keuangan/util/style.dart';
import 'dart:math' as math;

class HomepageKeuangan extends StatefulWidget {
  final Widget drawer;

  HomepageKeuangan({this.drawer});

  @override
  _HomepageKeuanganState createState() => _HomepageKeuanganState();
}

class _HomepageKeuanganState extends State<HomepageKeuangan>
    with TickerProviderStateMixin {
  int _counterBuild = 0;
  BlocHpKeuangan _blocHpKeuangan;
  final Color colorButton = Colors.cyan[600];
  final Color colorTextBtn = Colors.white;

  AnimationController _controller;

  static const List<IconData> icons = const [
    Icons.monetization_on,
    Icons.money_off
  ];

  BannerAd _bannerAd;

  @override
  void initState() {
    _blocHpKeuangan = new BlocHpKeuangan();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // TODO: Load a Banner Ad
    //_loadBannerAd();
    super.initState();
  }

  @override
  void dispose(){
    _controller.dispose();
    _blocHpKeuangan.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
    );
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  Widget _textSmall(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
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
              child: Text(
                'Rp $txtBalance',
                style: styleBesar,
              ),
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
                  Text('Rp $txtPengeluran',
                      style: StyleUi.textStyleBalanceMediumPengeluaran),
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
                  Text('Rp $txtPemasukan',
                      style: StyleUi.textStyleBalanceMediumPemasukan),
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
    Entry entry =
        new Entry(inm.nama, inm.kategori, tanggal, k.tanggal, k, true, true);

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
                    color: colorButton,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(color: Colors.cyan)),
                    onPressed: () async {
                      _edit(entry);
                    },
                    child: Text(
                      'edit',
                      style: TextStyle(
                          color: colorTextBtn,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 16.0, left: 16.0, bottom: 3.0),
                  child: RaisedButton(
                    color: colorButton,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(color: Colors.cyan)),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      _showDialogConfirmDelete(entry);
                    },
                    child: Text(
                      'delete',
                      style: TextStyle(
                          color: colorTextBtn,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ));
  }

  _showDialogConfirmDelete(Entry entry) {
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
                    color: colorButton,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(color: Colors.cyan)),
                    onPressed: () async {
                      _deleteConfirmed(entry);
                    },
                    child: Text(
                      'ya',
                      style: TextStyle(
                          color: colorTextBtn,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 16.0, left: 16.0, bottom: 3.0),
                  child: RaisedButton(
                    color: colorButton,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(color: Colors.cyan)),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'tidak',
                      style: TextStyle(
                          color: colorTextBtn,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ));
  }

  _edit(Entry entry) async {
    EnumJenisTransaksi enumJenisTransaksi;
    if (entry.keuangan.jenisTransaksi == 0) {
      enumJenisTransaksi = EnumJenisTransaksi.pengeluaran;
    } else {
      enumJenisTransaksi = EnumJenisTransaksi.pemasukan;
    }
    EnumFinalResult res = await openPage(
        context,
        KeuanganItemView(
          dateTime: DateTime.now(),
          isEditMode: true,
          keuangan: entry.keuangan,
          enumJenisTransaksi: enumJenisTransaksi,
        ));
    if (res == EnumFinalResult.success) {
      _blocHpKeuangan.fullReload();
      _showToast('Transaksi berhasil di update.');
    } else {
      /// TODO gagal
    }
    Navigator.of(context).pop();
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
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(
            'Transaksi terakhir',
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.left,
          ),
        ),
      ),
    ));
    lw.add(SizedBox(
      height: 3,
    ));
    if (data.listKeuangan != null) {
      List<Keuangan> lKeuangan = data.listKeuangan;
      for (int i = 0; i < lKeuangan.length; i++) {
        Keuangan ke = lKeuangan[i];

//      Keuangan copyKeuangan = new Keuangan.fromUI(ke.tanggal, ke.idItemName, ke.jumlah, ke.catatan);
//      copyKeuangan.lazyItemName = ke.lazyItemName;

        lw.add(FlatButton(
            onPressed: () {

              _showDialogPilihan(ke);
            },
            child: CellKeuanganStateLess(ke)));
      }
    }

    /// berikan space untuk scroll (karena dapat tertutup oleh ads dan FAB
    lw.add(Container(height: 220,));
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

    return CustomToastForMe(
      child: StreamBuilder<UIHPKeuangan>(
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
                floatingActionButton: new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: new List.generate(icons.length, (int index) {
                    Widget child = new Container(
                      height: 60.0,
                      width: 160.0,
                      alignment: FractionalOffset.topCenter,
                      child: new ScaleTransition(
                        scale: new CurvedAnimation(
                          parent: _controller,
                          curve: new Interval(
                              0.0, 1.0 - index / icons.length / 2.0,
                              curve: Curves.easeOut),
                        ),
                        child: new FloatingActionButton.extended(
                          onPressed: () async {
                            /// Kembalikan FAB ke posisi normal
                            if (!_controller.isDismissed) {
                              _controller.reverse();
                            }
                            EnumJenisTransaksi enumJns;
                            /// index == 0 : pemasukan
                            if (index == 0) {

                              enumJns = EnumJenisTransaksi.pemasukan;
                            } else {
                              enumJns = EnumJenisTransaksi.pengeluaran;
                            }
                            EnumFinalResult res = await openPage(
                                context,
                                KeuanganItemView(
                                  dateTime: DateTime.now(),
                                  isEditMode: false,
                                  keuangan: null,
                                  enumJenisTransaksi: enumJns,
                                ));

                            if(res == null){
                              _blocHpKeuangan.fullReload();
                            }else if (res == EnumFinalResult.success) {
                              _blocHpKeuangan.fullReload();
                              _showToast('Transaksi berhasil di simpan.');
                            } else {
                              /// TODO gagal
                            }
                          },
                          label:
                              Text('${index == 0 ? 'Pemasukan' : 'Pengeluaran'}'),
                          icon: index == 0
                              ? Icon(Icons.monetization_on)
                              : Icon(Icons.money_off),
                          backgroundColor: index == 0 ? Colors.green : Colors.red,
                          foregroundColor: Colors.white,
                          heroTag: null,
                        ),
                      ),
                    );
                    return child;
                  }).toList()
                    ..add(
                      new FloatingActionButton(
                        child: new AnimatedBuilder(
                          animation: _controller,
                          builder: (BuildContext context, Widget child) {
                            return new Transform(
                              transform: new Matrix4.rotationZ(
                                  _controller.value * 0.5 * math.pi),
                              alignment: FractionalOffset.center,
                              child: new Icon(_controller.isDismissed
                                  ? Icons.add
                                  : Icons.close),
                            );
                          },
                        ),
                        onPressed: () {
                          if (_controller.isDismissed) {
                            _controller.forward();
                          } else {
                            _controller.reverse();
                          }
                        },
                      ),
                    )
                  ..add(Container(height: 40,)),
                ),
              );
            } else {
              return Scaffold(
                  appBar: AppBar(
                    title: Text('Keuangan'),
                  ),
                  body: LoadingView());
            }
          }),
    );
  }

  _showToast(String messageToast) {
    showToast(messageToast,
        context: context,
        duration: Duration(seconds: 1),
        textStyle: TextStyle(fontSize: 16,color: Colors.white),
        backgroundColor: Colors.cyan[600],
        toastHorizontalMargin: 10.0,
        position: StyledToastPosition(
            align: Alignment.topCenter, offset: 70.0));
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
    String tanggal =
        _processString.dateToStringDdMmmYyyyPendek(widget.keuangan.tanggal);

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