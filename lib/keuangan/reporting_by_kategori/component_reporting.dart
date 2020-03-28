import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:keuangan/keuangan/model_keuangan_ui.dart';
import 'package:keuangan/util/colors_utility.dart';
import 'package:keuangan/util/global_data.dart';


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
}

class ModelItemKategoriReport implements Comparable<ModelItemKategoriReport> {
  dynamic values;
  String text;
  int jumlahUang;
  String color;//

  ModelItemKategoriReport({
      this.values,this.text,this.jumlahUang, this.color});

  @override
  int compareTo(ModelItemKategoriReport other) {
    int order = jumlahUang.compareTo(other.jumlahUang);
    return order;
  }
}


class ModelCategoryReport{
  Function funcBtnClick;
  int ecindex;
  int total;
  Size dimention;
  List<ModelItemKategoriReport> itemCategories;
  List<EntryCombobox> listCombobox;

  ModelCategoryReport({this.dimention, this.itemCategories,this.listCombobox, this.total, this.ecindex,
      this.funcBtnClick});


}
//}

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
  final ModelCategoryReport modelCategoryReport;

  BodyStatistic(this.modelCategoryReport);

  @override
  _BodyStatisticState createState() => _BodyStatisticState();
}

class _BodyStatisticState extends State<BodyStatistic> {
  int idKategori;

  Widget _cellReportingItem(ModelCategoryReport modelCategoryReport, ModelItemKategoriReport itemKategoriReport) {
    double percentation = (itemKategoriReport.jumlahUang / modelCategoryReport.total) * 100;
    double widthCell = (modelCategoryReport.dimention.width / 100) * percentation;
    if (widthCell >= modelCategoryReport.dimention.width-32) {
      //-32 krn padding 16x2
      widthCell = modelCategoryReport.dimention.width - 32;
    }

    final formatCurrency = new NumberFormat("#,##0", "idr");
    final uang = formatCurrency.format(itemKategoriReport.jumlahUang);
    return Container(
      child: FlatButton(
          onPressed: () {
            widget.modelCategoryReport.funcBtnClick(itemKategoriReport);
          },
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                      '${itemKategoriReport.text}'),
                  Spacer(),
                  Text('Rp. $uang'),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                height: 30,
               width: this.widget.modelCategoryReport.dimention.width,
                color: Colors.grey,
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 30,
                      width: widthCell,
                      color: HexColor(itemKategoriReport.color),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _chartWidget(double height) {
    var series = [
      new charts.Series(
        domainFn: (ModelItemKategoriReport item, _) => item.text,
        measureFn: (ModelItemKategoriReport clickData, _) => clickData.jumlahUang,
        colorFn: (ModelItemKategoriReport clickData, _) => charts.Color.fromHex(code:clickData.color),
        id: 'Clicks',
        data: widget.modelCategoryReport.itemCategories,
      ),
    ];
    double proporsionalHeight = height - (height / 3);
    return new Container(
      height: proporsionalHeight,
      child: DonutPieChart(series),
    );
  }

  Widget _cellReporting(Size dimention) {
    List<Widget> listW = new List();
    widget.modelCategoryReport.itemCategories.forEach((es) {

      listW.add(_cellReportingItem(
          widget.modelCategoryReport, es));
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
