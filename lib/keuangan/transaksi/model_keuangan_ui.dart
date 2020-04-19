import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:keuangan/database/keuangan/dao_keuangan.dart';
import 'package:keuangan/keuangan/entry_item/keuangan_item.dart';
import 'package:keuangan/main.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/global_string_database.dart';

class Entry {
  Entry(this.title, this.kategori, this.tanggal, this.keuangan, this.flag,
      this.isLast);

  final String title;
  final Kategori kategori;
  final String tanggal; ///ex: 23 Maret 2019
  final Keuangan keuangan;
  final bool flag;
  final bool isLast;
}

class CellKeuangan extends StatefulWidget {
  final Entry entry;
  final ValueChanged<String> callbackDelete;

  CellKeuangan({this.entry, this.callbackDelete});

  @override
  _CellKeuanganState createState() => _CellKeuanganState();
}

class _CellKeuanganState extends State<CellKeuangan> {
  final TbKeuangan tbKeuangan = new TbKeuangan();

  final styleTextItem = TextStyle(fontWeight: FontWeight.normal, fontSize: 14);

  final styleTextKategori = TextStyle(fontSize: 10, color: Colors.blueAccent);

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
              children: <Widget>[
                new OutlineButton(
                  onPressed: () {
                    _edit(widget.entry);
                  },
                  child: Text('edit'),
                ),
                new OutlineButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showDialogConfirmDelete();
                  },
                  child: Text('delete'),
                ),
              ],
            ));
  }

  _showDialogConfirmDelete() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text('Apakah anda yakin akan menghapus record ini?'),
              children: <Widget>[
                new OutlineButton(
                  onPressed: () {
                    _deleteConfirmed(widget.entry);
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
    Navigator.of(context).pop(res);
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
  final String tanggal;

  HeaderCellTanggalTransaksi(this.tanggal);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(
            height: 1.0,
            color: Colors.blue,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 3, left: 8),
              child: Text(
                tanggal,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
