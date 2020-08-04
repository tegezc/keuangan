import 'package:flutter/material.dart';
import 'package:keuangan/database/keuangan/dao_itemname.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/database/keuangan/dao_keuangan.dart';
import 'package:keuangan/keuangan/report/reporting_by_kategori/component_reporting.dart';
import 'package:keuangan/keuangan/report/reporting_by_kategori/reporting_by_items.dart';
import 'package:keuangan/keuangan/report/reporting_by_kategori/reporting_by_kategori_detail.dart';
import 'package:keuangan/keuangan/transaksi/keuangan_transaksi.dart';
import 'package:keuangan/keuangan/transaksi/model_keuangan_ui.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/common_ui.dart';
import 'package:keuangan/util/loading_view.dart';

class ReportingByCategories extends StatefulWidget {
  final Widget drawer;
  final EnumJenisTransaksi enumJenisTransaksi;

  ReportingByCategories(this.enumJenisTransaksi, {this.drawer})
      : assert(enumJenisTransaksi != null);

  @override
  _ReportingByCategoriesState createState() => _ReportingByCategoriesState();
}

class _ReportingByCategoriesState extends State<ReportingByCategories> {
  List<Keuangan> _listKeuangan;
  Map<int, ItemName> _itemNameMap;
  Map<int, Kategori> _kategoriMap;
  List<EntryCombobox> _listCombobox;
  int _posisiCombobox;

  List<ItemChartReporting> _lItemChart;
  UtilUiRepByKategori utilUiRepByKategori;
  @override
  void initState() {
    utilUiRepByKategori = new UtilUiRepByKategori();
    _populateKeuangan();
    super.initState();
  }

  _populateKeuangan() {

    _listCombobox = utilUiRepByKategori.initialCombobox();
    _posisiCombobox = 2;

    EntryCombobox entryCombobox = _listCombobox[2];
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    DaoKategori daoKategori = new DaoKategori();
    DaoItemName daoItemName = new DaoItemName();
    daoKeuangan
        .getKeuanganByPeriodeAndJenisTransaksi(widget.enumJenisTransaksi,
            entryCombobox.startDate, entryCombobox.endDate)
        .then((List<Keuangan> list) {
      _listKeuangan = new List();
      _listKeuangan.addAll(list);

      daoKategori.getAllKategoriMap().then((Map<int, Kategori> kMap) {
        _kategoriMap = new Map();
        _kategoriMap.addAll(kMap);
        daoItemName.getAllItemNameMap().then((Map<int, ItemName> inMap) {
          _itemNameMap = new Map();
          _itemNameMap.addAll(inMap);

          _lItemChart = utilUiRepByKategori.ayakBaseonParentKategori(_listKeuangan, _kategoriMap, _itemNameMap);

          setState(() {});
        });
      });
    });
  }

  _getDataKeuanganByPeriode(DateTime startDate, DateTime endDate) {
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    daoKeuangan
        .getKeuanganByPeriodeAndJenisTransaksi(
            widget.enumJenisTransaksi, startDate, endDate)
        .then((List<Keuangan> list) {
      _listKeuangan.clear();
      _listKeuangan.addAll(list);
      _lItemChart = utilUiRepByKategori.ayakBaseonParentKategori(_listKeuangan, _kategoriMap, _itemNameMap);
      setState(() {});
    });
  }

  Future<int> _asyncSimpleDialog(ItemChartReporting itm) async {
    Kategori kategori = itm.kategori;
    return showDialog<int>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text('Pilihan:'),
              children: <Widget>[
                new OutlineButton(
                  onPressed: () {
                    _showBySubKategori(kategori);
                  },
                  child: Text('lap ke sub kategori'),
                ),
                new OutlineButton(
                  onPressed: () {
                    _showByItem(kategori);
                  },
                  child: Text('lap per item'),
                ),
                new OutlineButton(
                  onPressed: () {
                    _showTransaksi(kategori);
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

  _showBySubKategori(Kategori kategori) async {
    Navigator.pop(context);
    await openPage(context,
        ReportingByCategoriesDetail(kategori, _posisiCombobox, _listCombobox));
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

  /// callback saat cell desk report diklik.
  _funcBtnClick(ItemChartReporting itemChartReporting) {
    _asyncSimpleDialog(itemChartReporting);
  }

  /// callback saat select combobox
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
//    ModelCategoryReport modelCategoryReport = new ModelCategoryReport(
//      dimention: dimention,
//      itemCategories: _listEntrySort,
//      total: this._getTotal(_listEntrySort),
//      funcBtnClick: funcBtnClick,
//    );
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
        appBar: AppBar(
          title: Text('Sedang memproses'),
        ),
        body: LoadingView(),
      );
    } else {
      return ReportSceletonByCategories(
        widget.enumJenisTransaksi,
        'Laporan per Kategori',
        drawer: null,
        callbackChangeComboboxTanggal: _handleCallBack,
        child: _bodyReporting(mediaQueryData.size),
      );
    }
  }
}
