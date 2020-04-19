import 'package:flutter/material.dart';
import 'package:keuangan/database/keuangan/dao_itemname.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/database/keuangan/dao_keuangan.dart';
import 'package:keuangan/keuangan/transaksi/model_keuangan_ui.dart';
import 'package:keuangan/keuangan/reporting_by_kategori/component_reporting.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/datepicker_singlescrollview.dart';
import 'package:keuangan/util/loading_view.dart';
import 'package:keuangan/util/process_string.dart';

import '../../main.dart';
import '../entry_item/keuangan_item.dart';

class TransactionKeuangan extends StatefulWidget {
  final List<EntryCombobox> listCombobox;
  final int posisiCombobox;
  final Kategori kategori;
  final ItemName itemName;
  final StateTransaksi stateTransaksi;
  final Widget drawer;

  TransactionKeuangan.byDefault({this.drawer})
      : this.stateTransaksi = StateTransaksi.byDefault,
        this.posisiCombobox = null,
        this.kategori = null,
        this.itemName = null,
        this.listCombobox = null;

  TransactionKeuangan.byKategori(
      {this.kategori, this.listCombobox, this.posisiCombobox})
      : this.stateTransaksi = StateTransaksi.byKategori,
        this.itemName = null,
        this.drawer = null;

  TransactionKeuangan.byItemName(
      {this.itemName, this.listCombobox, this.posisiCombobox})
      : this.stateTransaksi = StateTransaksi.byItemName,
        this.kategori = null,
        this.drawer = null;

  @override
  _TransactionKeuanganState createState() => _TransactionKeuanganState();
}

class _TransactionKeuanganState extends State<TransactionKeuangan> {
  List<Keuangan> _listKeuangan;
  List<Entry> _listEntry;

  List<DropdownMenuItem<EntryCombobox>> _dropDownEntry;
  EntryCombobox _currentEntryCombo;
  List<EntryCombobox> _listCombobox;

  Map<int, ItemName> _itemNameMap;
  Map<int, Kategori> _kategoriMap;

  ProcessString _processString;
  DateTime _valueTanggalFrom;
  DateTime _valueTanggalTo;

  final int _startDate = 1990;
  final int _endDate = 2050;

  @override
  void initState() {
    _valueTanggalFrom = new DateTime.now();
    _valueTanggalTo = new DateTime.now();
    _processString = new ProcessString();
    _reloadFirstTime();
    super.initState();
  }

  _callbackActionDelete(String s) {
    _fullReload();
  }

  _reloadFirstTime() {
    DaoKategori daoKategori = new DaoKategori();
    DaoItemName daoItemName = new DaoItemName();
    daoKategori.getAllKategoriMap().then((Map<int, Kategori> kMap) {
      _kategoriMap = new Map();
      _kategoriMap.addAll(kMap);
      daoItemName.getAllItemNameMap().then((Map<int, ItemName> inMap) {
        _itemNameMap = new Map();
        _itemNameMap.addAll(inMap);
        switch (widget.stateTransaksi) {
          case StateTransaksi.byDefault:
            {
              _initialComboboxByDefault();
            }
            break;
          case StateTransaksi.byKategori:
            {
              _initialComboboxByVar();
            }
            break;
          case StateTransaksi.byItemName:
            {
              _initialComboboxByVar();
            }
            break;
          default:
            break;
        }
        _populateKeuangan();
      });
    });
  }

  _fullReload() {
    DaoKategori daoKategori = new DaoKategori();
    DaoItemName daoItemName = new DaoItemName();
    daoKategori.getAllKategoriMap().then((Map<int, Kategori> kMap) {
      _kategoriMap = new Map();
      _kategoriMap.addAll(kMap);
      daoItemName.getAllItemNameMap().then((Map<int, ItemName> inMap) {
        _itemNameMap.clear();
        _itemNameMap.addAll(inMap);
        _populateKeuangan();
      });
    });
  }

  _populateKeuangan() {
    EntryCombobox entryCombobox = _currentEntryCombo;
    _getDataKeuanganByPeriode(entryCombobox.startDate, entryCombobox.endDate);
  }

  _getDataKeuanganByPeriode(DateTime startDate, DateTime endDate) {
    DaoKeuangan daoKeuangan = new DaoKeuangan();

    daoKeuangan
        .getKeuanganByPeriode(startDate, endDate)
        .then((List<Keuangan> list) {
      if (_listKeuangan == null) {
        _listKeuangan = new List();
      } else {
        _listKeuangan.clear();
      }
      _listKeuangan.addAll(list);
      _sortingListKeuangan(_listKeuangan);
      setState(() {});
    });
  }

  _sortingListKeuangan(List<Keuangan> listK) {
    List<Keuangan> filteredKeuangan = new List();
    switch (widget.stateTransaksi) {
      case StateTransaksi.byDefault:
        {
          filteredKeuangan.addAll(listK);
        }
        break;
      case StateTransaksi.byKategori:
        {
          listK.forEach((k) {
            ItemName itemName = _itemNameMap[k.idItemName];
            Kategori kategori = _kategoriMap[itemName.idKategori];
            if (kategori.idParent == widget.kategori.id ||
                kategori.id == widget.kategori.id) {
              filteredKeuangan.add(k);
            }
          });
        }
        break;
      case StateTransaksi.byItemName:
        {
          listK.forEach((k) {
            ItemName itemName = _itemNameMap[k.idItemName];
            if (itemName.id == widget.itemName.id) {
              filteredKeuangan.add(k);
            }
          });
        }
        break;
    }

    Map<DateTime, List<Keuangan>> mapK = new Map();
    for (int i = 0; i < filteredKeuangan.length; i++) {
      if (mapK[filteredKeuangan[i].tanggal] == null) {
        List<Keuangan> lk = new List();
        lk.add(filteredKeuangan[i]);
        mapK[filteredKeuangan[i].tanggal] = lk;
      } else {
        List<Keuangan> lk = mapK[filteredKeuangan[i].tanggal];
        lk.add(filteredKeuangan[i]);
        mapK[filteredKeuangan[i].tanggal] = lk;
      }
    }

    List<EntrySort> list = new List();
    mapK.forEach((key, value) {
      var entrySort = new EntrySort(key, value);
      list.add(entrySort);
    });

    _listEntry = new List();
    list.forEach((value) {
      String tanggal = _processString.dateToStringDdMmmmYyyy(value.key);
      Entry entry = new Entry('', null, tanggal, null, false, false);
      _listEntry.add(entry);
      int lgth = value.listKeuangan.length;

      for (int i = 0; i < lgth; i++) {
        var k = value.listKeuangan[i];
        var itemName = _itemNameMap[k.idItemName];

        var ktg = _kategoriMap[itemName.idKategori];
        bool isLast = (i + 1) == lgth ? true : false;

        var e = Entry(itemName.nama, ktg, tanggal, k, true, isLast);
        _listEntry.add(e);
      }
    });
  }

  _initialComboboxByDefault() {
    UtilUiRepByKategori utilUiRepByKategori = new UtilUiRepByKategori();
    _listCombobox = utilUiRepByKategori.initialCombobox();

    _currentEntryCombo = _listCombobox[2];

    _reloadComboBox();
  }

  _initialComboboxByVar() {
    _listCombobox = new List();
    _listCombobox.addAll(widget.listCombobox);

    _currentEntryCombo = _listCombobox[widget.posisiCombobox];

    _reloadComboBox();
  }

  _reloadComboBox() {
    _dropDownEntry = _getDropDownEntry();
  }

  List<DropdownMenuItem<EntryCombobox>> _getDropDownEntry() {
    List<DropdownMenuItem<EntryCombobox>> items = new List();
    for (EntryCombobox eCombo in _listCombobox) {
      items.add(new DropdownMenuItem(
        value: eCombo,
        child: new Text(eCombo.text),
      ));
    }
    return items;
  }

  void _changedDropDownEntry(EntryCombobox selectedECombo) {
    if (selectedECombo.startDate == null) {
      _selectDateFrom();
    } else {
      _getDataKeuanganByPeriode(
          selectedECombo.startDate, selectedECombo.endDate);
      setState(() {
        _currentEntryCombo = selectedECombo;
      });
    }
  }

  Widget _widgetComboBoxTanggal() {
    return new DropdownButton(
      value: _currentEntryCombo,
      items: _dropDownEntry,
      onChanged: _changedDropDownEntry,
    );
  }

  Future _selectDateFrom() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(_startDate),
        lastDate: new DateTime(_endDate),
        builder: (context, child) {
          return CustomeDatePicker(child);
        });
    if (picked != null) {
      _valueTanggalFrom = picked;
      _selectDateTo();
    }
  }

  Future _selectDateTo() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(_startDate),
        lastDate: new DateTime(_endDate),
        builder: (context, child) {
          return CustomeDatePicker(child);
        });
    if (picked != null) {
      _valueTanggalTo = picked;
      String strStartDate =
          _processString.dateToStringDdMmmmYyyy(_valueTanggalFrom);
      String strEndDate =
          _processString.dateToStringDdMmmmYyyy(_valueTanggalTo);
      _listCombobox.insert(
          1,
          EntryCombobox('$strStartDate - $strEndDate', _valueTanggalFrom,
              _valueTanggalTo));
      _getDataKeuanganByPeriode(_valueTanggalFrom, _valueTanggalTo);
      _reloadComboBox();
      setState(() {
        _currentEntryCombo = _listCombobox[1];
      });
    }
  }

  Widget _bodyTransaksi(Size dimensi) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            height: 59,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 20, bottom: 0, right: 10),
                  child: _widgetComboBoxTanggal(),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.blueAccent,
            thickness: 10,
          ),
          new Container(
            height: dimensi.height - 200,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                if (index < _listEntry.length) {
                  Entry e = _listEntry[index];
                  if(e.flag){
                    return CellKeuangan(
                      entry: _listEntry[index],
                      callbackDelete: _callbackActionDelete,
                    );
                  }else{
                    return HeaderCellTanggalTransaksi(e.tanggal);
                  }

                } else {
                  return SizedBox(
                    height: 70,
                  );
                }
              },
              itemCount: _listEntry.length + 1,
            ),
          ),
        ],
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
    final mediaQueryData = MediaQuery.of(context);

    if (_listEntry == null) {
      return Scaffold(
        drawer: widget.drawer,
        appBar: new AppBar(
          title: new Text('Transaksi'),
        ),
        body: LoadingView(),
      );
    } else {
      return Scaffold(
        drawer: widget.drawer,
        appBar: new AppBar(
          title: new Text('Transaksi'),
        ),
        body: _bodyTransaksi(mediaQueryData.size),
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
              _fullReload();
            } else {
              /// TODO gagal
            }
          },
          tooltip: 'add Transaksi',
          child: new Icon(Icons.add),
        ),
      );
    }
  }
}
