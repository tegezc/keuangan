import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:keuangan/database/keuangan/dao_itemname.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/database/keuangan/dao_keuangan.dart';
import 'package:keuangan/keuangan/report/reporting_by_kategori/component_reporting.dart';
import 'package:keuangan/keuangan/transaksi/model_keuangan_ui.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/adsmob.dart';
import 'package:keuangan/util/common_ui.dart';
import 'package:keuangan/util/datepicker/calender/calendar_range.dart';
import 'package:keuangan/util/global_data.dart';
import 'package:keuangan/util/loading_view.dart';
import 'package:keuangan/util/process_string.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../entry_item/keuangan_item.dart';
import 'dart:math' as math;

class TransactionKeuangan extends StatefulWidget {
  final List<EntryCombobox> listCombobox;
  final int posisiCombobox;
  final Kategori kategori;
  final ItemName itemName;
  final EnumStateTransaksi stateTransaksi;
  final Widget drawer;

  TransactionKeuangan.byDefault({this.drawer})
      : this.stateTransaksi = EnumStateTransaksi.byDefault,
        this.posisiCombobox = null,
        this.kategori = null,
        this.itemName = null,
        this.listCombobox = null;

  TransactionKeuangan.byKategori(
      {this.kategori, this.listCombobox, this.posisiCombobox})
      : this.stateTransaksi = EnumStateTransaksi.byKategori,
        this.itemName = null,
        this.drawer = null;

  TransactionKeuangan.byItemName(
      {this.itemName, this.listCombobox, this.posisiCombobox})
      : this.stateTransaksi = EnumStateTransaksi.byItemName,
        this.kategori = null,
        this.drawer = null;

  @override
  _TransactionKeuanganState createState() => _TransactionKeuanganState();
}

class _TransactionKeuanganState extends State<TransactionKeuangan>
    with TickerProviderStateMixin {
  List<Keuangan> _listKeuangan;
  List<ForCellTransaksi> _listEntry;

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

  static const List<IconData> icons = const [
    Icons.monetization_on,
    Icons.money_off
  ];

  bool _isNeedHeader = false;
  bool _isItemName = false;

  AnimationController _controller;
  BannerAd _bannerAd;

  void _loadBannerAd() {
    if (AdManager.isAdmobOn()) {
      if (_bannerAd == null) {
        _bannerAd = BannerAd(
          adUnitId: AdManager.bannerAdUnitId(EnumBannerId.hpTransaksi),
          size: AdSize.banner,
        );
        _bannerAd
          ..load().then((value) {
            if (value) {
              _bannerAd..show(anchorType: AnchorType.bottom);
            }
          });
      }
    }
  }

  void _disposeBanner() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  void _baruAction(int index) async {
    this._disposeBanner();

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

    if (res == null) {
      _fullReload();
    } else if (res == EnumFinalResult.success) {
      _fullReload();
      _showToast('Transaksi berhasil disimpan.');
    } else {
      /// TODO gagal
    }
    _loadBannerAd();
  }

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _valueTanggalFrom = new DateTime.now();
    _valueTanggalTo = new DateTime.now();
    _processString = new ProcessString();

    _reloadFirstTime();

    // TODO: Load a Banner Ad
    _loadBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    this._disposeBanner();
    super.dispose();
  }

  _callbackActionDelete(String s) {
    _fullReload();
  }

  _callbackActionUpdateStart() {
    this._disposeBanner();
  }

  _callbackActionUpdateFinish(EnumFinalResult enumFinalResult) {
    if (enumFinalResult == null) {
      _fullReload();
    } else if (enumFinalResult == EnumFinalResult.success) {
      _fullReload();
      _showToast('Transaksi berhasil di update');
    }

    this._loadBannerAd();
  }

  _setupIsNeedHeader() {
    if (widget.stateTransaksi == EnumStateTransaksi.byKategori) {
      _isNeedHeader = true;
    } else if (widget.stateTransaksi == EnumStateTransaksi.byItemName) {
      _isNeedHeader = true;
      _isItemName = true;
    }
  }

  _reloadFirstTime() {
    /// setup dalam kondisi bykategori atau byItemName maka perlu header di baris
    /// pertama listview
    _setupIsNeedHeader();

    DaoKategori daoKategori = new DaoKategori();
    DaoItemName daoItemName = new DaoItemName();
    daoKategori.getAllKategoriMap().then((Map<int, Kategori> kMap) {
      _kategoriMap = new Map();
      _kategoriMap.addAll(kMap);
      daoItemName.getAllItemNameMap().then((Map<int, ItemName> inMap) {
        _itemNameMap = new Map();
        _itemNameMap.addAll(inMap);
        switch (widget.stateTransaksi) {
          case EnumStateTransaksi.byDefault:
            {
              _initialComboboxByDefault();
            }
            break;
          case EnumStateTransaksi.byKategori:
            {
              _initialComboboxByVar();
            }
            break;
          case EnumStateTransaksi.byItemName:
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
      _kategoriMap.clear();
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
      case EnumStateTransaksi.byDefault:
        {
          filteredKeuangan.addAll(listK);
        }
        break;
      case EnumStateTransaksi.byKategori:
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
      case EnumStateTransaksi.byItemName:
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
      DateTime dt = value.key;
      String tanggal = _processString.dateToStringDdMmmmYyyy(dt);
      String namaHari = GlobalData.nhari[dt.weekday];
      String namaBulan = GlobalData.namaBulan[dt.month];
      int lgth = value.listKeuangan.length;

      List<Entry> le = new List();
      for (int i = 0; i < lgth; i++) {
        var k = value.listKeuangan[i];
        var itemName = _itemNameMap[k.idItemName];

        var ktg = _kategoriMap[itemName.idKategori];
        bool isLast = (i + 1) == lgth ? true : false;

        var e = Entry(itemName.nama, ktg, tanggal, value.key, k, true, isLast);
        le.add(e);
      }
      ForCellTransaksi forCellTransaksi =
          new ForCellTransaksi(dt, namaHari, namaBulan, le);
      _listEntry.add(forCellTransaksi);
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

  void _changedDropDownEntry(EntryCombobox selectedECombo) async {
    /// user pick custome periode
    if (selectedECombo.startDate == null) {
      TgzDateRangeValue tgzDateRangeValue =
          await openPage(context, TgzRangeDatePicker(_startDate, _endDate));
      if (tgzDateRangeValue != null) {
        if (tgzDateRangeValue.isValid()) {
          _valueTanggalFrom = tgzDateRangeValue.dateStart;
          _valueTanggalTo = tgzDateRangeValue.dateFinish;
          print('tanggal awal: ${_valueTanggalFrom.toString()}');
          print('tanggal selesai: ${_valueTanggalTo.toString()}');

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
    }

    /// user pick constant periode (7 hari terakhir, 30 hari terakhir
    else {
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

  Widget _headerByKategori(Kategori kategori) {
    return Container(
      width: double.infinity,
      color: Colors.cyan[600],
      child: Padding(
        padding:
        const EdgeInsets.only(top: 12.0, left: 12, right: 10, bottom: 10),
        child: Column(
          children: <Widget>[
            Text(
              'Transaksi pada periode tersebut khusus',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
            ),
            Text(
              'Kategori: ${kategori.nama}',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerByItemName(ItemName itemName) {
    return Container(
      width: double.infinity,
      color: Colors.cyan[600],
      child: Padding(
        padding:
            const EdgeInsets.only(top: 12.0, left: 12, right: 10, bottom: 10),
        child: Column(
          children: <Widget>[
            Text(
              'Transaksi pada periode tersebut khusus',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
            ),
            Text(
              'Item: ${itemName.nama}',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bodyTransaksi(Size dimensi) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            // height: 59,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 20, bottom: 0, right: 10),
                  child: _widgetComboBoxTanggal(),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 2,
          ),
          new Container(
            height: dimensi.height - 200,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                int idxArray = index;

                if (index == 0 && _isNeedHeader) {
                  idxArray = index - 1;
                  if (_isItemName) {
                    return _headerByItemName(widget.itemName);
                  } else {
                    return _headerByKategori(widget.kategori);
                  }
                } else if (idxArray < _listEntry.length) {
                  ForCellTransaksi e = _listEntry[idxArray];
                  return StickyHeader(
                    header: HeaderCellTanggalTransaksi(
                        e.date, e.namaHari, e.namaBulan),
                    content: Column(
                      children: this._listCellTransaksi(e.lEntry),
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 150,
                  );
                }
              },
              itemCount:
                  _isNeedHeader ? _listEntry.length + 2 : _listEntry.length + 1,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _listCellTransaksi(List<Entry> lEntry) {
    List<Widget> lw = new List();
    lEntry.forEach((element) {
      lw.add(CellKeuangan(
        entry: element,
        callbackDelete: _callbackActionDelete,
        callbackUpdateFinish: _callbackActionUpdateFinish,
        callbackUpdateStart: _callbackActionUpdateStart,
      ));
    });

    return lw;
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
      return CustomToastForMe(
        child: Scaffold(
          drawer: widget.drawer,
          appBar: new AppBar(
            title: new Text('Transaksi'),
          ),
          body: _bodyTransaksi(mediaQueryData.size),
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
                    curve: new Interval(0.0, 1.0 - index / icons.length / 2.0,
                        curve: Curves.easeOut),
                  ),
                  child: new FloatingActionButton.extended(
                    onPressed: () async {
                      _baruAction(index);
                    },
                    label: Text('${index == 0 ? 'Pemasukan' : 'Pengeluaran'}'),
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
                        child: new Icon(
                            _controller.isDismissed ? Icons.add : Icons.close),
                      );
                    },
                  ),
                  onPressed: () {
                    if (_controller.isDismissed) {
                      print('contoller dismiss');
                      _controller.forward();
                    } else {
                      print('controller tdk dismiss');
                      _controller.reverse();
                    }
                  },
                ),
              )
              ..add(Container(
                height: 40,
              )),
          ),
        ),
      );
    }
  }

  _showToast(String messageToast) {
    showToast(messageToast,
        context: context,
        duration: Duration(seconds: 2),
        textStyle: TextStyle(fontSize: 16, color: Colors.white),
        backgroundColor: Colors.cyan[600],
        toastHorizontalMargin: 10.0,
        position:
            StyledToastPosition(align: Alignment.topCenter, offset: 70.0));
  }
}

enum EnumStateTransaksi {
  byDefault,
  byKategori,
  byItemName,
}

class ForCellTransaksi {
  DateTime date;
  String namaBulan;
  String namaHari;
  List<Entry> lEntry;

  ForCellTransaksi(this.date, this.namaHari, this.namaBulan, this.lEntry);
}
