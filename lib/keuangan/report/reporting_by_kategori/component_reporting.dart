import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

import 'package:keuangan/keuangan/transaksi/model_keuangan_ui.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/colors_utility.dart';
import 'package:keuangan/util/common_ui.dart';
import 'package:keuangan/util/datepicker/calender/calendar_range.dart';
import 'package:keuangan/util/global_data.dart';
import 'package:keuangan/util/process_string.dart';

class ItemChartReporting implements Comparable<ItemChartReporting> {
  double total;
  List<Keuangan> lKeuangan;
  double persen;
  Kategori kategori;
  String text;
  ItemName itemName;
  int id;// for flutter chart

  @override
  String toString() {
    return 'total: $total | lk: ${lKeuangan.length} | pesen: $persen '
        '| kategori: ${kategori.nama} | text: $text | itemname: ${itemName.nama}';
  }

  @override
  int compareTo(ItemChartReporting other) {
    int order = other.total.compareTo(total);
    return order;
  }
}

class UtilUiRepByKategori {
  List<EntryCombobox> initialCombobox() {
    List<EntryCombobox> _listCombobox = new List();
    DateTime today = new DateTime.now();
    int bulanKemarin = today.month > 1 ? today.month - 1 : 12;
    int tahunKemarin = today.month > 1 ? today.year : today.year - 1;

    _listCombobox.add(EntryCombobox('Custom date range', null, null));
    _listCombobox.add(EntryCombobox(
        '${GlobalData.namaBulan[bulanKemarin]}',
        DateTime(tahunKemarin, bulanKemarin, 1),
        DateTime(today.year, today.month, 0)));
    _listCombobox.add(EntryCombobox(
        '${GlobalData.namaBulan[today.month]}',
        DateTime(today.year, today.month, 1),
        DateTime(today.year, today.month + 1, 0)));
    _listCombobox
        .add(EntryCombobox('7 Hari terakhir', _penguranganDate(7), today));
    _listCombobox
        .add(EntryCombobox('30 Hari terakhir', _penguranganDate(30), today));
    _listCombobox
        .add(EntryCombobox('60 Hari terakhir', _penguranganDate(60), today));
    _listCombobox
        .add(EntryCombobox('90 Hari terakhir', _penguranganDate(90), today));
    _listCombobox
        .add(EntryCombobox('6 Bulan terakhir', _penguranganDate(120), today));
    _listCombobox.add(EntryCombobox(
        'Tahun ini', DateTime(today.year, 1, 1), DateTime(today.year, 12, 31)));
    _listCombobox.add(EntryCombobox('Tahun kemarin',
        DateTime(today.year - 1, 1, 1), DateTime(today.year - 1, 12, 31)));
    return _listCombobox;
  }

  _penguranganDate(int jmlHari) {
    DateTime today = new DateTime.now();
    return today.subtract(new Duration(days: jmlHari));
  }

  ItemChartReporting _refactorSetMap(Kategori kategori, ItemName itemName,
      Keuangan keuangan, int key, Map<int, ItemChartReporting> mapK) {
    ItemChartReporting itm;
    if (mapK[key] == null) {
      itm = new ItemChartReporting();
      List<Keuangan> lk = new List();
      lk.add(keuangan);

      itm.total = keuangan.jumlah;
      itm.lKeuangan = lk;

      /// kategori hanya perlu di set sekali
      itm.kategori = kategori;
      itm.itemName = itemName;
    } else {
      itm = mapK[key];
      List<Keuangan> lk = itm.lKeuangan;
      lk.add(keuangan);

      itm.total = itm.total + keuangan.jumlah;
      itm.lKeuangan = lk;
    }
    itm.text = kategori.nama;
    mapK[key] = itm;
    return itm;
  }

  Map<int, ItemChartReporting> _hitungPersentasi(
      Map<int, ItemChartReporting> mapK, total) {
    /// menghitung persen tiap kategori
    Map<int, ItemChartReporting> tmpMap = new Map();
    mapK.forEach((key, itmReport) {
      ItemChartReporting itm = itmReport;
      itm.persen = (itm.total / total) * 100;
      tmpMap[key] = itm;
    });
    return tmpMap;
  }

  List<ItemChartReporting> _convertToListAndSorting(
      Map<int, ItemChartReporting> mapK) {
    /// convert map to list supaya bisa di sorting
    List<ItemChartReporting> litm = new List();
    mapK.forEach((key, itm) {
      litm.add(itm);
    });
    litm.sort();
    return litm;
  }

  /// untuk reporting by Parent Kategori
  List<ItemChartReporting> ayakBaseonParentKategori(List<Keuangan> lKeuangan,
      Map<int, Kategori> mKtg, Map<int, ItemName> mItemName) {
    double totalSeluruhTransaksi = 0;
    Map<int, ItemChartReporting> mapK = new Map();
    for (int i = 0; i < lKeuangan.length; i++) {
      Keuangan keuangan = lKeuangan[i];
      ItemName itemName = mItemName[keuangan.idItemName];
      Kategori kategori = mKtg[itemName.idKategori];

      if (kategori.idParent > 0) {
        kategori = mKtg[kategori.idParent];
      }
      int key = kategori.id;
      ItemChartReporting itm = this._refactorSetMap(kategori, itemName, keuangan, key, mapK);
      itm.id = key;
      mapK[key] = itm;

      /// dapatkan total uang dari seluruh transaksi untuk penghitugnan persen
      totalSeluruhTransaksi = totalSeluruhTransaksi + keuangan.jumlah;
    }

    /// menghitung persen tiap kategori
    mapK = this._hitungPersentasi(mapK, totalSeluruhTransaksi);

    /// convert map to list supaya bisa di sorting
    return this._convertToListAndSorting(mapK);
  }

  /// untuk reporting by Sub Kategori
  List<ItemChartReporting> ayakBaseonsubKategori(List<Keuangan> lKeuangan,
      Map<int, Kategori> mKtg, Map<int, ItemName> mItemName, Kategori ktg) {
    double totalSeluruhTransaksi = 0;
    Map<int, ItemChartReporting> mapK = new Map();
    for (int i = 0; i < lKeuangan.length; i++) {
      Keuangan keuangan = lKeuangan[i];
      ItemName itemName = mItemName[keuangan.idItemName];
      Kategori kategori = mKtg[itemName.idKategori];

      int key;

      /// ini masuk ke subkategori bersangkutan
      if (kategori.idParent == ktg.id) {
        key = kategori.id;
      }

      /// ini masuk ke parent kategori
      else if (kategori.id == ktg.id) {
        key = ktg.id;
      }

      if (key != null) {
        ItemChartReporting itm = this._refactorSetMap(kategori, itemName, keuangan, key, mapK);
        itm.id = key;
        mapK[key] =itm;


        /// dapatkan total uang dari seluruh transaksi untuk penghitugnan persen
        totalSeluruhTransaksi = totalSeluruhTransaksi + keuangan.jumlah;
      }
    }

    /// menghitung persen tiap kategori
    mapK = this._hitungPersentasi(mapK, totalSeluruhTransaksi);

    /// convert map to list supaya bisa di sorting
    return this._convertToListAndSorting(mapK);
  }

  /// untuk reporting by Sub Kategori
  List<ItemChartReporting> ayakBaseonItemName(List<Keuangan> lKeuangan,
      Map<int, Kategori> mKtg, Map<int, ItemName> mItemName, Kategori ktg) {
    double totalSeluruhTransaksi = 0;
    Map<int, ItemChartReporting> mapK = new Map();
    for (int i = 0; i < lKeuangan.length; i++) {
      Keuangan keuangan = lKeuangan[i];
      ItemName itemName = mItemName[keuangan.idItemName];
      Kategori kategori = mKtg[itemName.idKategori];

      int key;

      /// ini masuk ke subkategori bersangkutan
      if (kategori.idParent == ktg.id) {
        key = itemName.id;
      }

      /// ini masuk ke parent kategori
      else if (kategori.id == ktg.id) {
        key = itemName.id;
      }

      if (key != null) {
        ItemChartReporting itm =
            this._refactorSetMap(kategori, itemName, keuangan, key, mapK);
        itm.text = itemName.nama;
        itm.id = key;
        mapK[key] = itm;

        /// dapatkan total uang dari seluruh transaksi untuk penghitugnan persen
        totalSeluruhTransaksi = totalSeluruhTransaksi + keuangan.jumlah;
      }
    }

    /// menghitung persen tiap kategori
    mapK = this._hitungPersentasi(mapK, totalSeluruhTransaksi);

    /// convert map to list supaya bisa di sorting
    return this._convertToListAndSorting(mapK);
  }
}

class DonutPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutPieChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        defaultRenderer: new charts.ArcRendererConfig(arcWidth: 60));
  }
}

//UI Body statistic pada reporting by kategori
class BodyStatistic extends StatefulWidget {
  final List<ItemChartReporting> listItemChart;
  final Function callBackCellClick;

  BodyStatistic(this.listItemChart, this.callBackCellClick);

  @override
  _BodyStatisticState createState() => _BodyStatisticState();
}

class _BodyStatisticState extends State<BodyStatistic> {
  int idKategori;

  Widget _cellReportingItem(ItemChartReporting itm, double width) {
    double widthCell = (width / 100) * itm.persen;
    if (widthCell >= width - 32) {
      ///-32 krn padding 16x2
      widthCell = width - 32;
    }

    final formatCurrency = new NumberFormat("#,##0", "idr");
    final uang = formatCurrency.format(itm.total);
    return Container(
      child: FlatButton(
          onPressed: () {
            widget.callBackCellClick(itm);
          },
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('${itm.text} ( ${itm.persen.toStringAsFixed(2)} %)'),
                  Spacer(),
                  Text('Rp. $uang'),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                height: 30,
                width: width,
                color: Colors.grey,
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 30,
                      width: widthCell,
                      color: HexColor(itm.kategori.color),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  /// Create one series with sample hard coded data.
   List<charts.Series<ItemChartReporting, int>> _createData() {
    return [
      new charts.Series<ItemChartReporting, int>(
        id: 'Sales',
        domainFn: (ItemChartReporting itm, _) => itm.id,
        measureFn: (ItemChartReporting itm, _) => itm.persen,
        colorFn: (ItemChartReporting itm, _) =>
            charts.Color.fromHex(code: '#${itm.kategori.color}'),
        data:  widget.listItemChart,
      )
    ];
  }

  Widget _chartWidget(double height) {
//    widget.listItemChart.forEach((element) {
//      print(element.toString());
//    });
//    var series = [
//      new charts.Series(
//        domainFn: (ItemChartReporting item, _) => item.kategori.nama,
//        measureFn: (ItemChartReporting clickData, _) => clickData.total.toInt(),
//        colorFn: (ItemChartReporting clickData, _) =>
//            charts.Color.fromHex(code: '#${clickData.kategori.color}'),
//        id: 'Clicks',
//        data: widget.listItemChart,
//      ),
//    ];

    List<charts.Series> seriesList = this._createData();
    double proporsionalHeight = height - (height / 4);
    return new Container(
      height: proporsionalHeight,
      child: DonutPieChart(seriesList),
    );
  }

  Widget _cellReporting(Size dimention) {
    List<Widget> listW = new List();
    widget.listItemChart.forEach((itm) {
      listW.add(_cellReportingItem(itm, dimention.width));
      listW.add(new SizedBox(
        height: 20,
      ));
    });
    return Container(
      child: Column(
        children: listW,
      ),
    );
  }

  Widget _formStatistic(Size dimention) {
    return Container(
      child: Column(
        children: <Widget>[
          _chartWidget(dimention.width),
          _cellReporting(dimention),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return _formStatistic(mediaQueryData.size);
  }
}

class ReportSceletonByCategories extends StatefulWidget {
  final Widget drawer;
  final EnumJenisTransaksi enumJenisTransaksi;
  final Widget child;
  final Function callbackChangeComboboxTanggal;
  final String title;
  final List<EntryCombobox> listCombobox;
  final int posisiCombobox;

  ReportSceletonByCategories(this.enumJenisTransaksi, this.title,
      {this.drawer,
      this.child,
      this.callbackChangeComboboxTanggal,
      this.listCombobox,
      this.posisiCombobox})
      : assert(enumJenisTransaksi != null);

  @override
  _ReportSceletonByCategoriesState createState() =>
      _ReportSceletonByCategoriesState();
}

class _ReportSceletonByCategoriesState
    extends State<ReportSceletonByCategories> {
  List<DropdownMenuItem<int>> _dropDownEntry;

  List<EntryCombobox> _listCombobox;

  int _posisiCombobox;
  ProcessString _processString;

  @override
  void initState() {
    _processString = new ProcessString();
    _initialCombobox();
    super.initState();
  }

  _initialCombobox() {
    if (widget.listCombobox == null) {
      UtilUiRepByKategori utilUiRepByKategori = new UtilUiRepByKategori();
      _listCombobox = utilUiRepByKategori.initialCombobox();
      _posisiCombobox = 2;
    } else {
      _listCombobox = widget.listCombobox;
      _posisiCombobox = widget.posisiCombobox;
    }

    _reloadComboBox();
  }

  _reloadComboBox() {
    _dropDownEntry = _getDropDownEntry();
  }

  List<DropdownMenuItem<int>> _getDropDownEntry() {
    List<DropdownMenuItem<int>> items = new List();
    for (int i = 0; i < _listCombobox.length; i++) {
      EntryCombobox eCombo = _listCombobox[i];
      items.add(new DropdownMenuItem(
        value: i,
        child: new Text(eCombo.text),
      ));
    }
    return items;
  }

  void _changedDropDownEntry(int index) async {
    final int _startDate = 1990;
    final int _endDate = 2050;
    EntryCombobox selectedECombo = _listCombobox[index];

    /// user pick custome periode
    if (selectedECombo.startDate == null) {
      TgzDateRangeValue tgzDateRangeValue =
          await openPage(context, TgzRangeDatePicker(_startDate, _endDate));
      if (tgzDateRangeValue != null) {
        if (tgzDateRangeValue.isValid()) {
          String strStartDate = _processString
              .dateToStringDdMmmmYyyy(tgzDateRangeValue.dateStart);
          String strEndDate = _processString
              .dateToStringDdMmmmYyyy(tgzDateRangeValue.dateFinish);
          EntryCombobox ec = EntryCombobox('$strStartDate - $strEndDate',
              tgzDateRangeValue.dateStart, tgzDateRangeValue.dateFinish);
          _listCombobox.insert(1, ec);

          _reloadComboBox();
          setState(() {
            _posisiCombobox = 1;
          });
          widget.callbackChangeComboboxTanggal(_listCombobox, _posisiCombobox);
        }
      }
    }

    /// user pick constant periode (7 hari terakhir, 30 hari terakhir
    else {
      setState(() {
        _posisiCombobox = index;
      });
      widget.callbackChangeComboboxTanggal(_listCombobox, _posisiCombobox);
    }
  }

  Future openPage(context, Widget builder) async {
    // wait until animation finished
    await SwipeBackObserver.promise?.future;

    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => builder),
    );
  }

  Widget _widgetComboBoxTanggal(double width) {
    return Container(
      width: width,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: new DropdownButton(
          value: _posisiCombobox,
          items: _dropDownEntry,
          onChanged: _changedDropDownEntry,
        ),
      ),
    );
  }

  Widget _bodyReporting(Size dimention) {
    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _widgetComboBoxTanggal(dimention.width),
            widget.child,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    return Scaffold(
        drawer: widget.drawer,
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: _bodyReporting(mediaQueryData.size));
  }
}
