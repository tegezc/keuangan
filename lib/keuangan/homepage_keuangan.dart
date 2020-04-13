import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keuangan/database/keuangan/dao_keuangan.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';

import '../main.dart';
import 'transaksi/keuangan_transaksi.dart';

class HomepageKeuangan extends StatefulWidget {
  final Widget drawer;

  HomepageKeuangan({this.drawer});

  @override
  _HomepageKeuanganState createState() => _HomepageKeuanganState();
}

class _HomepageKeuanganState extends State<HomepageKeuangan> {
  final TextStyle _textStyleSmall = new TextStyle(fontSize: 10);

  int pengeluaran = 0;
  int pemasukan = 0;
  int balance = 0;

  @override
  void initState() {
    _setupBalance();
    super.initState();
  }

  _setupBalance() {
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    daoKeuangan
        .getKeuanganByJenisTransaksi(EnumJenisTransaksi.pemasukan)
        .then((lkp) {
      pemasukan = this._hitungTotal(lkp);
      daoKeuangan
          .getKeuanganByJenisTransaksi(EnumJenisTransaksi.pengeluaran)
          .then((lkk) {
        pengeluaran = this._hitungTotal(lkk);
        balance = pemasukan - pengeluaran;
        setState(() {});
      });
    });
  }

  int _hitungTotal(List<Keuangan> lk) {
    if (lk != null) {
      double tmpJum = 0;
      lk.forEach((k) {
        tmpJum = tmpJum + k.jumlah;
      });
      return tmpJum.toInt();
    } else {
      return 0;
    }
  }

  Widget _textSmall(String text) {
    return Text(
      text,
      style: _textStyleSmall,
    );
  }

  Widget _textNormal(String text, Color color) {
    final TextStyle _textStyleM = new TextStyle(fontSize: 13, color: color);
    return Padding(
      padding: const EdgeInsets.only(top: 3.0, bottom: 5.0),
      child: Text(
        text,
        style: _textStyleM,
      ),
    );
  }

  Widget _textL(String text, Color color) {
    final TextStyle _textStyleL = new TextStyle(fontSize: 20, color: color);
    return Text(
      text,
      style: _textStyleL,
    );
  }

  Widget _widgetBalance(Size sizeWidget, int pmsk, int pngl, int blc) {
    final formatCurrency = new NumberFormat("#,##0", "idr");
    final txtPemasukan = formatCurrency.format(pmsk);
    final txtPengeluran = formatCurrency.format(pngl);
    final txtBalance = formatCurrency.format(blc);
    Color color = Colors.green;
    if (blc < 0) {
      color = Colors.red;
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
              child: _textL('Rp $txtBalance', color),
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
                  _textNormal('Rp $txtPengeluran', Colors.red),
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
                  _textNormal('Rp $txtPemasukan', Colors.green),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _spaceBetweenButton() {
    return SizedBox(
      height: 10,
    );
  }

  Widget _buttonNav(
      String text, Size sizeWidget, BuildContext context, int page) {
    return SizedBox(
      width: sizeWidget.width - 20,
      child: RaisedButton(
        onPressed: () async {
          await openPage(context, TransactionKeuangan.byDefault());
        },
        textColor: Colors.white,
        color: Colors.blue,
        padding: const EdgeInsets.all(0.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Text(text, style: TextStyle(fontSize: 15)),
        ),
      ),
    );
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
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size _sizeWidget = mediaQueryData.size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Keuangan'),
      ),
      drawer: widget.drawer,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _widgetBalance(_sizeWidget, pemasukan, pengeluaran, balance),
            Divider(
              height: 10.0,
            ),
            _buttonNav('Transaksi', _sizeWidget, context, 1),
            _spaceBetweenButton(),
          ],
        ),
      ),
    );
  }
}
