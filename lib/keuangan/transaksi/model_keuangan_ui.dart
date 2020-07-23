import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:keuangan/database/keuangan/dao_keuangan.dart';
import 'package:keuangan/keuangan/entry_item/keuangan_item.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/colors_utility.dart';
import 'package:keuangan/util/common_ui.dart';
import 'package:keuangan/util/global_string_database.dart';

class Entry {
  Entry(this.title, this.kategori, this.tanggal, this.date, this.keuangan,
      this.flag, this.isLast);

  final String title;
  final Kategori kategori;
  final String tanggal;

  ///ex: 23 Maret 2019
  final DateTime date;
  final Keuangan keuangan;
  final bool flag;
  final bool isLast;
}

class CellKeuangan extends StatefulWidget {
  final Entry entry;
  final ValueChanged<String> callbackDelete;
  final Function callbackUpdate;

  CellKeuangan({this.entry, this.callbackDelete,this.callbackUpdate});

  @override
  _CellKeuanganState createState() => _CellKeuanganState();
}

class _CellKeuanganState extends State<CellKeuangan> {
  final TbKeuangan tbKeuangan = new TbKeuangan();

  final styleTextItem = TextStyle(fontWeight: FontWeight.normal, fontSize: 14);

  final styleTextKategori = TextStyle(fontSize: 10, color: Colors.blueAccent);
  final Color colorButton = Colors.cyan[600];
  final Color colorTextBtn = Colors.white;

  @override
  Widget build(BuildContext context) {
    final formatCurrency = new NumberFormat("#,##0", "idr");
    int uang = widget.entry.keuangan.jumlah.toInt();
    TextStyle textStyle;
    if (widget.entry.kategori.type == EnumJenisTransaksi.pemasukan) {
      textStyle = TextStyle(color: Colors.green);
    } else {
      textStyle = TextStyle(color: Colors.red);
    }
    return FlatButton(
      onPressed: () {
        _showDialogPilihan();
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  widget.entry.title,
                  style: styleTextItem,
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
              widget.entry.kategori.nama,
              style: styleTextKategori,
            ),
            SizedBox(
              height: 3,
            ),
            widget.entry.isLast
                ? SizedBox(
                    height: 2,
                  )
                : Divider(),
          ],
        ),
      ),
    );
  }

  _showDialogPilihan() {

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
                      _edit(widget.entry);
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
                      _showDialogConfirmDelete();
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

  _showDialogConfirmDelete() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text('Apakah anda yakin akan menghapus record ini?'),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                      _deleteConfirmed(widget.entry);
                    },
                    child: Text(
                      'ya',
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
      widget.callbackUpdate(res);
    } else {
      /// TODO gagal
    }
    Navigator.of(context).pop();
  }

  _deleteConfirmed(Entry entry) {
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    daoKeuangan.deleteKeuangan(entry.keuangan).then((v) {
      if (v == 1) {
        Navigator.of(context).pop();
        widget.callbackDelete('');
      } else {
        ///TODO delete gagal
      }
    });
  }

  Future openPage(context, Widget builder) async {
    // wait until animation finished
    await SwipeBackObserver.promise?.future;

    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => builder),
    );
  }
}

class HeaderCellTanggalTransaksi extends StatelessWidget {
  final DateTime date;
  final String namaBulan;
  final String namaHari;

  HeaderCellTanggalTransaksi(this.date, this.namaHari, this.namaBulan);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 80,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: HexColor('#5E5E5E'),
                border: Border(
                  top: BorderSide(color: HexColor('#808080'), width: 0.5),
                )),
            height: 40.0,
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Text(
                  date.day.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white),
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      namaHari,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white),
                    ),
                    Text(
                      '$namaBulan ${date.year}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      //color: Colors.blueGrey[700],
    );
  }
}

class EntrySort implements Comparable<EntrySort> {
  DateTime key;
  List<Keuangan> listKeuangan;

  EntrySort(this.key, this.listKeuangan);

  @override
  int compareTo(EntrySort other) {
    int order = key.compareTo(other.key);
    return order;
  }
}

class EntryCombobox {
  String text;
  DateTime startDate;
  DateTime endDate;

  EntryCombobox(this.text, this.startDate, this.endDate);
}
