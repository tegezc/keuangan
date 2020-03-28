//import 'package:flutter/material.dart';
//import 'package:keotramobile/database/dao_keuangan.dart';
//import 'package:keotramobile/model/keuangan.dart';
//import 'package:keotramobile/util/loading_view.dart';
//
//class EventItemView extends StatefulWidget {
//  @override
//  _EventItemViewState createState() => _EventItemViewState();
//}
//
//class _EventItemViewState extends State<EventItemView> {
//  List<Kategori> listKategory;
//  List<DropdownMenuItem<Kategori>> _dropDownKategory;
//  Kategori _currentCatogery;
//
//  List jenisTransaksi =["Pengeluaran", "Pemasukan"];
//  List<DropdownMenuItem<int>> _dropDownTransaksi;
//  int _currentTransaksi;
//
//  TextEditingController _txtController;
//
//
//  @override
//  void initState() {
//    _txtController = new TextEditingController();
//    _populateKategori();
//    _dropDownTransaksi = getDropDownTransaksi();
//    _currentTransaksi = 0;
//    super.initState();
//  }
//
//  @override
//  void dispose(){
//    _txtController.dispose();
//    super.dispose();
//  }
//
//  _populateKategori() {
//    listKategory = new List();
//    DaoKategori daoKategori = new DaoKategori();
//    daoKategori.getAllKategori().then((List<Kategori> kategories) {
//      if (kategories != null) {
//        listKategory.addAll(kategories);
//        if(listKategory.length>0){
//          _dropDownKategory = getDropDownKategori();
//          _currentCatogery = _dropDownKategory[0].value;
//
//        }
//        setState(() {
//
//        });
//
//      }
//    });
//  }
//
//  _saveKategori(){
//    String nama = _txtController.text;
//    Kategori k = new Kategori(nama, _currentCatogery.id, _currentTransaksi);
//    DaoKategori daoKategori = new DaoKategori();
//    daoKategori.saveKategori(k).then((int value){
//      if (value != null){
//        Navigator.of(context).pop(null);
//      }
//    });
//  }
//
//  List<DropdownMenuItem<Kategori>> getDropDownKategori() {
//    List<DropdownMenuItem<Kategori>> items = new List();
//    for (Kategori ktgori in listKategory) {
//      items.add(new DropdownMenuItem(
//        value: ktgori,
//        child: new Text(ktgori.nama),
//      ));
//    }
//    return items;
//  }
//
//  List<DropdownMenuItem<int>> getDropDownTransaksi() {
//    List<DropdownMenuItem<int>> items = new List();
//    for (int i=0;i < 2;i++) {
//      items.add(new DropdownMenuItem(
//        value: i,
//        child: new Text(jenisTransaksi[i]),
//      ));
//    }
//    return items;
//  }
//  @override
//  Widget build(BuildContext context) {
//    if(listKategory == null){
//      return LoadingView();
//    }else{
//      return Scaffold(
//        appBar: AppBar(
//          title: Text('Kategori Baru'),
//          actions: <Widget>[
//            // action button
//            IconButton(
//              color: Colors.green[900],
//              icon: Icon(Icons.done),
//              onPressed: () {
//                _saveKategori();
//              },
//            ),
//            // overflow menu
//          ],
//        ),
//        body: new Container(
//          padding: EdgeInsets.only(top: 15,left: 20,right: 15,bottom: 0),
//          height: double.infinity,
//          width: double.infinity,
//          child: SingleChildScrollView(
//            child: Column(
//              mainAxisSize: MainAxisSize.max,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: <Widget>[
//                Text('Induk'),
//                new DropdownButton(
//                  value: _currentCatogery,
//                  items: _dropDownKategory,
//                  onChanged: changedDropDownKategori,
//                ),
//                Text('Nama Kategori'),
//                TextField(
//                  controller: _txtController,
//                  maxLines: 1,
//                ),
//                Text('Keterangan (Optional)'),
//                TextField(
//                  maxLines: null,
//                ),
//                Text('Jenis Transaksi'),
//                new DropdownButton(
//                  value: _currentTransaksi,
//                  items: _dropDownTransaksi,
//                  onChanged: changedDropDownTransaksi,
//                ),
//
//              ],
//            ),
//          ),
//
//        ),
//      );
//    }
//
//  }
//
//  void changedDropDownKategori(Kategori selectedCategory) {
//    setState(() {
//      _currentCatogery = selectedCategory;
//    });
//  }
//
//  void changedDropDownTransaksi(int selectedTransaksi) {
//    setState(() {
//      _currentTransaksi = selectedTransaksi;
//    });
//  }
//}
// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// This demo is based on
// https://material.io/design/components/dialogs.html#full-screen-dialog

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class DateTimeItem extends StatelessWidget {
  DateTimeItem({ Key key, DateTime dateTime, @required this.onChanged })
      : assert(onChanged != null),
        date = DateTime(dateTime.year, dateTime.month, dateTime.day),
        time = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        super(key: key);

  final DateTime date;
  final TimeOfDay time;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return DefaultTextStyle(
      style: theme.textTheme.subhead,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: theme.dividerColor))
              ),
              child: InkWell(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: date.subtract(const Duration(days: 30)),
                    lastDate: date.add(const Duration(days: 30)),
                  )
                      .then<void>((DateTime value) {
                    if (value != null)
                      onChanged(DateTime(value.year, value.month, value.day, time.hour, time.minute));
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(DateFormat('EEE, MMM d yyyy').format(date)),
                    const Icon(Icons.arrow_drop_down, color: Colors.black54),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8.0),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: theme.dividerColor))
            ),
            child: InkWell(
              onTap: () {
                showTimePicker(
                  context: context,
                  initialTime: time,
                )
                    .then<void>((TimeOfDay value) {
                  if (value != null)
                    onChanged(DateTime(date.year, date.month, date.day, value.hour, value.minute));
                });
              },
              child: Row(
                children: <Widget>[
                  Text('${time.format(context)}'),
                  const Icon(Icons.arrow_drop_down, color: Colors.black54),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenDialogDemo extends StatefulWidget {
  @override
  FullScreenDialogDemoState createState() => FullScreenDialogDemoState();
}

class FullScreenDialogDemoState extends State<FullScreenDialogDemo> {
  DateTime _fromDateTime = DateTime.now();
  DateTime _toDateTime = DateTime.now();
  bool _allDayValue = false;
  bool _saveNeeded = false;
  bool _hasLocation = false;
  bool _hasName = false;
  String _eventName;

  Future<bool> _onWillPop() async {
    _saveNeeded = _hasLocation || _hasName || _saveNeeded;
    if (!_saveNeeded)
      return true;

    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);

    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            'Discard new event?',
            style: dialogTextStyle,
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(false); // Pops the confirmation dialog but not the page.
              },
            ),
            FlatButton(
              child: const Text('DISCARD'),
              onPressed: () {
                Navigator.of(context).pop(true); // Returning true to _onWillPop will pop again.
              },
            ),
          ],
        );
      },
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_hasName ? _eventName : 'Event Name TBD'),
        actions: <Widget> [
          FlatButton(
            child: Text('SAVE', style: theme.textTheme.body1.copyWith(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context, DismissDialogAction.save);
            },
          ),
        ],
      ),
      body: Form(
        onWillPop: _onWillPop,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              alignment: Alignment.bottomLeft,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Event name',
                  filled: true,
                ),
                style: theme.textTheme.headline,
                onChanged: (String value) {
                  setState(() {
                    _hasName = value.isNotEmpty;
                    if (_hasName) {
                      _eventName = value;
                    }
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              alignment: Alignment.bottomLeft,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'Where is the event?',
                  filled: true,
                ),
                onChanged: (String value) {
                  setState(() {
                    _hasLocation = value.isNotEmpty;
                  });
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('From', style: theme.textTheme.caption),
                DateTimeItem(
                  dateTime: _fromDateTime,
                  onChanged: (DateTime value) {
                    setState(() {
                      _fromDateTime = value;
                      _saveNeeded = true;
                    });
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('To', style: theme.textTheme.caption),
                DateTimeItem(
                  dateTime: _toDateTime,
                  onChanged: (DateTime value) {
                    setState(() {
                      _toDateTime = value;
                      _saveNeeded = true;
                    });
                  },
                ),
                const Text('All-day'),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: theme.dividerColor))
              ),
              child: Row(
                children: <Widget> [
                  Checkbox(
                    value: _allDayValue,
                    onChanged: (bool value) {
                      setState(() {
                        _allDayValue = value;
                        _saveNeeded = true;
                      });
                    },
                  ),
                  const Text('All-day'),
                ],
              ),
            ),
          ]
              .map<Widget>((Widget child) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              height: 96.0,
              child: child,
            );
          })
              .toList(),
        ),
      ),
    );
  }
}