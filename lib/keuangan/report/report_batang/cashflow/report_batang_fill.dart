import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:keuangan/keuangan/report/hp_report.dart';
import 'package:keuangan/keuangan/report/report_batang/batang/bloc_report_batang.dart';
import 'package:keuangan/keuangan/report/report_batang/cashflow/bloc_cfbatang.dart';
import 'package:keuangan/util/loading_view.dart';

class CfReportBatang extends StatefulWidget {
  final EnumItemLaporan enumItemLaporan;

  CfReportBatang(this.enumItemLaporan);

  @override
  _CfReportBatangState createState() => _CfReportBatangState();
}

class _CfReportBatangState extends State<CfReportBatang> {
  BlocCfReportBatang _blocCfReportBatang;
  String _titleAppBar;
  bool _isComboboxYearShowing;

  @override
  void initState() {
    _blocCfReportBatang = new BlocCfReportBatang();
    this._setupInit();
    super.initState();
  }

  void _setupInit() {
    if (widget.enumItemLaporan == EnumItemLaporan.cfMonthly) {
      _isComboboxYearShowing = true;
      _titleAppBar = 'Laporan Cash Flow Bulanan';
      int year = DateTime.now().year;
      _blocCfReportBatang.prosesCfByMonth(year);
    } else if (widget.enumItemLaporan == EnumItemLaporan.cfYearly) {
      _isComboboxYearShowing = false;
      _titleAppBar = 'Laporan Cash Flow Tahunan';
      _blocCfReportBatang.prosesCfByYears();
    }
  }

  @override
  void dispose() {
    _blocCfReportBatang.dispose();
    super.dispose();
  }

  // Create series list with multiple series
  List<charts.Series<ReportBatangItem, String>> _createData(
      List<ReportBatangItem> lbatangPemasukan,
      List<ReportBatangItem> lbatangPengeluaran) {
    return [
      // Blue bars with a lighter center color.
      new charts.Series<ReportBatangItem, String>(
        id: 'Desktop',
        domainFn: (ReportBatangItem sales, _) => sales.xvalue,
        measureFn: (ReportBatangItem sales, _) => sales.yvalue,
        data: lbatangPemasukan,
        colorFn: (_, __) => charts.Color.fromHex(code: '#78AB46'),
        fillColorFn: (_, __) => charts.Color.fromHex(code: '#78AB46'),
      ),
      // Solid red bars. Fill color will default to the series color if no
      // fillColorFn is configured.
      new charts.Series<ReportBatangItem, String>(
        id: 'Tablet',
        measureFn: (ReportBatangItem sales, _) => sales.yvalue,
        data: lbatangPengeluaran,
        colorFn: (_, __) => charts.Color.fromHex(code: '#FF3333'),
        domainFn: (ReportBatangItem sales, _) => sales.xvalue,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ReportBatangCashFlowUi>(
        stream: _blocCfReportBatang.uiReportBatang,
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
                          _showDialogJumpDateEksByMain(snapshot.data.year,context);
                        },
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 8,),
                            Text('${snapshot.data.year}'),
                            SizedBox(width: 15,),
                            Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 0),
                        child: Container(
                            width: double.infinity,
                            height: 400,
                            child: StackedFillColorBarChart(_createData(
                                snapshot.data.listPemasukan,
                                snapshot.data.listPengeluaran))),
                      ),
//                  Container(
//                    height: 300,
//                    color: Colors.green,
//                    child: Text('Ora po po'),
//                  ),
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
    _blocCfReportBatang.prosesCfByMonth(year);
  }
}

/// Example of a stacked bar chart with three series, each rendered with
/// different fill colors.
class StackedFillColorBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  StackedFillColorBarChart(this.seriesList, {this.animate});
//
//  factory StackedFillColorBarChart.withSampleData() {
//    return new StackedFillColorBarChart(
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
      // Configure a stroke width to enable borders on the bars.
      defaultRenderer: new charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.stacked, strokeWidthPx: 2.0),

      /// mengcostume text di axist horizontal dan vertical kunjungi stackoverflow
      /// https://stackoverflow.com/questions/54437448/charts-flutter-labels-text-on-x-axis-overlapping-each-other
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
              minimumPaddingBetweenLabelsPx: 0,
              labelStyle: new charts.TextStyleSpec(fontSize: 9))),
    );
  }
}