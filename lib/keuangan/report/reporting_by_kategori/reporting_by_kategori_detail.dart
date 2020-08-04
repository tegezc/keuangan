import 'package:flutter/material.dart';
import 'package:keuangan/database/keuangan/dao_itemname.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/database/keuangan/dao_keuangan.dart';
import 'package:keuangan/keuangan/report/reporting_by_kategori/component_reporting.dart';
import 'package:keuangan/keuangan/report/reporting_by_kategori/reporting_by_items.dart';
import 'package:keuangan/keuangan/transaksi/keuangan_transaksi.dart';
import 'package:keuangan/keuangan/transaksi/model_keuangan_ui.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/common_ui.dart';
import 'package:keuangan/util/loading_view.dart';

class ReportingByCategoriesDetail extends StatefulWidget {
  final Kategori katkegoridetail;
  final int posisiCombobox;
  final List<EntryCombobox> listCombobox;

  ReportingByCategoriesDetail(
      this.katkegoridetail, this.posisiCombobox, this.listCombobox);

  @override
  _ReportingByCategoriesDetailState createState() =>
      _ReportingByCategoriesDetailState();
}

class _ReportingByCategoriesDetailState
    extends State<ReportingByCategoriesDetail> {
  List<Keuangan> _listKeuangan;
  List<ItemChartReporting> _lItemChart;

  List<EntryCombobox> _listCombobox;

  int _posisiCombobox;

  Map<int, ItemName> _itemNameMap;
  Map<int, Kategori> _kategoriMap;
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
          _lItemChart = utilUiRepByKategori.ayakBaseonsubKategori(_listKeuangan, _kategoriMap, _itemNameMap, widget.katkegoridetail);
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
      _lItemChart = utilUiRepByKategori.ayakBaseonsubKategori(_listKeuangan, _kategoriMap, _itemNameMap, widget.katkegoridetail);
      setState(() {});
    });
  }

  Future<int> _asyncSimpleDialog(ItemChartReporting itm) async {
    return showDialog<int>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text('Pilihan:'),
              children: <Widget>[
                new OutlineButton(
                  onPressed: () {
                    _showByItem(itm.kategori);
                  },
                  child: Text('lap per item'),
                ),
                new OutlineButton(
                  onPressed: () {
                    _showTransaksi(itm.kategori);
                  },
                  child: Text('tampilkan transaksi'),
                ),
                new OutlineButton(
                  onPressed: _cancelDialog,
                  child: Text('Cancel'),
                ),
              ],
            ));
  }

  _showByItem(Kategori kategori) async {
    Navigator.pop(context);
    await openPage(
        context, ReportingByItems(kategori, _posisiCombobox, _listCombobox));
  }

  _showTransaksi(Kategori kategori) async {
    Navigator.pop(context);
    await openPage(
        context,
        TransactionKeuangan.byKategori(
          kategori: kategori,
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

  _cancelDialog() {
    Navigator.pop(context);
  }

  _funcBtnClick(ItemChartReporting itemChartReporting) async {
    await _asyncSimpleDialog(itemChartReporting);
  }

  Widget _bodyReporting(Size dimention) {
    return Container(
      width: double.infinity,
      child: BodyStatistic(_lItemChart, _funcBtnClick),
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

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    if (_listKeuangan == null) {
      return Scaffold(
        appBar: new AppBar(
          title: new Text('Sub Kategori'),
        ),
        body: LoadingView(),
      );
    } else {
      return ReportSceletonByCategories(
        widget.katkegoridetail.type,
        'Laporan per Subkategori',
        listCombobox: _listCombobox,
        posisiCombobox: _posisiCombobox,
        drawer: null,
        child: _bodyReporting(mediaQueryData.size),
        callbackChangeComboboxTanggal: _handleCallBack,
      );
    }
  }
}
