import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keuangan/keuangan/report/hp_report.dart';
import 'package:keuangan/keuangan/report/report_batang/batang/bloc_report_batang.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:keuangan/util/loading_view.dart';

class ReportBatang extends StatefulWidget {
  final EnumItemLaporan enumItemLaporan;

  ReportBatang(this.enumItemLaporan);

  @override
  _ReportBatangState createState() => _ReportBatangState();
}

class _ReportBatangState extends State<ReportBatang> {
  BlocReportBatang _blocReportBatang;
  String _titleAppBar;
  String _colorCharts;

  bool _isComboboxYearShowing;

  @override
  void initState() {
    _blocReportBatang = new BlocReportBatang();
    _setupInitial();
    super.initState();
  }

  @override
  void dispose() {
    _blocReportBatang.dispose();
    super.dispose();
  }

  _setupInitial() {
    int year = DateTime.now().year;
    if (widget.enumItemLaporan == EnumItemLaporan.pmByMonth) {
      _isComboboxYearShowing = true;
      _colorCharts = '#78AB46';
      _titleAppBar = 'Laporan Pemasukan Bulanan';
      _blocReportBatang.prosesPemasukanByMonth(year);
    } else if (widget.enumItemLaporan == EnumItemLaporan.pmByYear) {
      _isComboboxYearShowing = false;
      _colorCharts = '#78AB46';
      _titleAppBar = 'Laporan Pemasukan Tahunan';
      _blocReportBatang.prosesPemasukanByYears();
    } else if (widget.enumItemLaporan == EnumItemLaporan.pgByMonthly) {
      _isComboboxYearShowing = true;
      _colorCharts = '#FF3333';
      _titleAppBar = 'Laporan Pengeluaran Bulanan';
      _blocReportBatang.prosesPengeluaranByMonth(year);
    } else if (widget.enumItemLaporan == EnumItemLaporan.pgByYearly) {
      _isComboboxYearShowing = false;
      _colorCharts = '#FF3333';
      _titleAppBar = 'Laporan Pengeluaran Tahunan';
      _blocReportBatang.prosesPengeluaranByYears();
    }
  }

  List<charts.Series<ReportBatangItem, String>> _dataForCharts(
      List<ReportBatangItem> listData) {
    return [
      new charts.Series<ReportBatangItem, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.Color.fromHex(code: _colorCharts),
        domainFn: (ReportBatangItem sales, _) => sales.xvalue,
        measureFn: (ReportBatangItem sales, _) => sales.yvalue,
        data: listData,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ReportBatangUi>(
        stream: _blocReportBatang.uiReportBatang,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                    title: Text(
                  'tunggu sebentar...',
                )),
                body: LoadingView());
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  _titleAppBar,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              body: Container(
                  width: double.infinity,
                  child: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      SizedBox(height: 5,),
                      _isComboboxYearShowing
                          ? RaisedButton(
                              onPressed: () {
                                _showDialogJumpDateEksByMain(snapshot.data.tahun,context);
                              },
                              child: Row(
                                children: <Widget>[
                                  SizedBox(width: 8,),
                                  Text('${snapshot.data.tahun}'),
                                  SizedBox(width: 15,),
                                  Icon(Icons.keyboard_arrow_down),
                                ],
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 0.0),
                        child: Container(
                            width: double.infinity,
                            height: 400,
                            child: ChartBatangSimple(
                                _dataForCharts(snapshot.data.listBatangItem))),
                      ),
//                      Container(
//                        height: 300,
//                        color: Colors.green,
//                        child: Text('Ora po po'),
//                      ),
                    ],
                  ))),
            );
          }
        });
  }

  _showDialogJumpDateEksByMain(int initYear,BuildContext context) {
    int tahunTmp = initYear;

    final FixedExtentScrollController scrollControllerTahun =
        FixedExtentScrollController(initialItem: initYear);

    showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => SimpleDialog(
              title: Text('Pilih Tahun'),
              children: <Widget>[
                Container(
                  child: Container(
                    height: 100,
                    width: 100,
                    child: CupertinoPicker.builder(
                      scrollController: scrollControllerTahun,
                      itemExtent: 45,
                      childCount: 2099,
                      backgroundColor: CupertinoColors.systemBackground
                          .resolveFrom(context),
                      onSelectedItemChanged: (int index) {
                        tahunTmp = index;
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                            child: Padding(
                          padding:
                              const EdgeInsets.only(bottom: 7.0, top: 7.0),
                          child: Text(
                            '$index',
                          ),
                        ));
                      },
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new OutlineButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new OutlineButton(
                        onPressed: () {
                          _pickYear(tahunTmp);
                          Navigator.pop(context);
                        },
                        child: Text('Ok'),
                      ),
                    ),
                  ],
                ),
              ],
            ));
  }

  _pickYear(int year) {
    if (widget.enumItemLaporan == EnumItemLaporan.pmByMonth) {
      _blocReportBatang.prosesPemasukanByMonth(year);
    }  else if (widget.enumItemLaporan == EnumItemLaporan.pgByMonthly) {
      _blocReportBatang.prosesPengeluaranByMonth(year);
    }
  }
}

class ChartBatangSimple extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  ChartBatangSimple(this.seriesList, {this.animate});

//  /// Creates a [BarChart] with sample data and no transition.
//  factory ChartBatangSimple.withSampleData() {
//    return new ChartBatangSimple(
//      _createSampleData(),
//      // Disable animations for image tests.
//      animate: false,
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
        minimumPaddingBetweenLabelsPx: 0,
        labelStyle: new charts.TextStyleSpec(fontSize: 9),
      )),
    );
  }
}
