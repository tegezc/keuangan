import 'package:flutter/material.dart';
import 'package:keuangan/database/keuangan/dao_itemname.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/database/keuangan/dao_keuangan.dart';
import 'package:keuangan/keuangan/report/reporting_by_kategori/component_reporting.dart';
import 'package:keuangan/keuangan/transaksi/keuangan_transaksi.dart';
import 'package:keuangan/keuangan/transaksi/model_keuangan_ui.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/common_ui.dart';
import 'package:keuangan/util/loading_view.dart';

class ReportingByItems extends StatefulWidget {
  final Kategori katkegoridetail;
  final int posisiCombobox;
  final List<EntryCombobox> listCombobox;

  ReportingByItems(
      this.katkegoridetail, this.posisiCombobox, this.listCombobox);

  @override
  _ReportingByItemsState createState() => _ReportingByItemsState();
}

class _ReportingByItemsState extends State<ReportingByItems> {
  List<Keuangan> _listKeuangan;

  List<EntryCombobox> _listCombobox;
  int _posisiCombobox;

  Map<int, ItemName> _itemNameMap;
  Map<int, Kategori> _kategoriMap;

  List<ItemChartReporting> _lItemChart;
  UtilUiRepByKategori utilUiRepByKategori;

  @override
  void initState() {
    _posisiCombobox = widget.posisiCombobox;
    _listCombobox = widget.listCombobox;
    utilUiRepByKategori = new UtilUiRepByKategori();
    _populateKeuangan();

    super.initState();
  }

  _populateKeuangan() {
    EntryCombobox entryCombobox = _listCombobox[_posisiCombobox];
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    DaoKategori daoKategori = new DaoKategori();
    DaoItemName daoItemName = new DaoItemName();
    daoKeuangan
        .getKeuanganByPeriode(entryCombobox.startDate, entryCombobox.endDate)
        .then((List<Keuangan> list) {
      _listKeuangan = new List();
      _listKeuangan.addAll(list);

      daoKategori.getAllKategoriMap().then((Map<int, Kategori> kMap) {
        _kategoriMap = new Map();
        _kategoriMap.addAll(kMap);
        daoItemName.getAllItemNameMap().then((Map<int, ItemName> inMap) {
          _itemNameMap = new Map();
          _itemNameMap.addAll(inMap);
          _lItemChart = utilUiRepByKategori.ayakBaseonItemName(_listKeuangan,
              _kategoriMap, _itemNameMap, widget.katkegoridetail);
          setState(() {});
        });
      });
    });
  }

  _getDataKeuanganByPeriode(DateTime startDate, DateTime endDate) {
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    daoKeuangan
        .getKeuanganByPeriode(startDate, endDate)
        .then((List<Keuangan> list) {
      _listKeuangan.clear();
      _listKeuangan.addAll(list);
      _lItemChart = utilUiRepByKategori.ayakBaseonItemName(_listKeuangan,
          _kategoriMap, _itemNameMap, widget.katkegoridetail);
      setState(() {});
    });
  }


  _funcBtnClick(ItemChartReporting itm) async {
    await openPage(
        context,
        TransactionKeuangan.byItemName(
          itemName: itm.itemName,
          listCombobox: _listCombobox,
          posisiCombobox: _posisiCombobox,
        ));
  }

  Future openPage(context, Widget builder) async {
    // wait until animation finished
    await SwipeBackObserver.promise?.future;

    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => builder),
    );
  }

  void _handleCallBack(List<EntryCombobox> lcombo, int index) {
    _listCombobox = lcombo;
    _posisiCombobox = index;
    EntryCombobox entryCombobox = lcombo[index];
    print('Text : ${entryCombobox.text} start: ${entryCombobox.startDate}'
        'end: ${entryCombobox.endDate}');

    this._getDataKeuanganByPeriode(
        entryCombobox.startDate, entryCombobox.endDate);
  }

  Widget _bodyReporting(Size dimention) {
    return Container(
      width: double.infinity,
      child: BodyStatistic(_lItemChart,_funcBtnClick),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    if (_listKeuangan == null) {
      return Scaffold(
        appBar: new AppBar(
          title: new Text('Per Item'),
        ),
        body: LoadingView(),
      );
    } else {
      return ReportSceletonByCategories(
          widget.katkegoridetail.type, 'Laporan per Item',
          listCombobox: _listCombobox,
          posisiCombobox: _posisiCombobox,
          drawer: null,
          callbackChangeComboboxTanggal: _handleCallBack,
          child: _bodyReporting(mediaQueryData.size));
    }
  }
}
