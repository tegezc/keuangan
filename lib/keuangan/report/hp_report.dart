import 'package:flutter/material.dart';
import 'package:keuangan/util/colors_utility.dart';

class HpReport extends StatefulWidget {
  final Widget drawer;
  HpReport({this.drawer});
  @override
  _HpReportState createState() => _HpReportState();
}

class _HpReportState extends State<HpReport> {
  Map<EnumItemLaporan, HpUiItemLaporan> _mReport;

  @override
  void initState() {
    _setupItemUi();
    super.initState();
  }

  _setupItemUi() {
    _mReport = new Map();
    // ============ pemasukan =================== //
    _mReport[EnumItemLaporan.pmByCategory] = new HpUiItemLaporan(
        'Laporan Per Kateogri',
        'Laporan Pemasukan yang di kelompokkan berdasarkan kategori.',
        EnumJenisLaporan.pemasukan,
        EnumItemLaporan.pmByCategory,
        null);
    _mReport[EnumItemLaporan.pmByMonth] = new HpUiItemLaporan(
        'Laporan Per Bulan',
        'Laporan Pemasukan per bulan pada tahun tertentu.',
        EnumJenisLaporan.pemasukan,
        EnumItemLaporan.pmByMonth,
        null);
    _mReport[EnumItemLaporan.pmByYear] = new HpUiItemLaporan(
        'Laporan Per Tahun',
        'Laporan Pemasukan per tahun.',
        EnumJenisLaporan.pemasukan,
        EnumItemLaporan.pmByYear,
        null);

    // ============ pengeluaran =================== //
    _mReport[EnumItemLaporan.pgByCategory] = new HpUiItemLaporan(
        'Laporan Per Kateogri',
        'Laporan Pengeluaran yang di kelompokkan berdasarkan kategori.',
        EnumJenisLaporan.pengeluaran,
        EnumItemLaporan.pgByCategory,
        null);
    _mReport[EnumItemLaporan.pgByMonthly] = new HpUiItemLaporan(
        'Laporan Per Bulan',
        'Laporan Pengeluaran tiap bulan.',
        EnumJenisLaporan.pengeluaran,
        EnumItemLaporan.pgByMonthly,
        null);
    _mReport[EnumItemLaporan.pgByYearly] = new HpUiItemLaporan(
        'Laporan Per Tahun',
        'Laporan Pengeluaran per tahun.',
        EnumJenisLaporan.pengeluaran,
        EnumItemLaporan.pgByYearly,
        null);

    // ============ pengeluaran =================== //
    _mReport[EnumItemLaporan.cfMonthly] = new HpUiItemLaporan(
        'Cash Flow Bulanan',
        'Membandingkan pemasukan dan pengeluaran tiap bulan.',
        EnumJenisLaporan.flowcash,
        EnumItemLaporan.cfMonthly,
        null);
    _mReport[EnumItemLaporan.cfYearly] = new HpUiItemLaporan(
        'Cash Flow Tahunan',
        'Membandingkan pemasukan dan pengeluaran per tahun.',
        EnumJenisLaporan.flowcash,
        EnumItemLaporan.cfYearly,
        null);
  }

  Widget _cellReport(HpUiItemLaporan hpUiItemLaporan) {
    Color color = Colors.black54;
    if (hpUiItemLaporan.enumJenisLaporan == EnumJenisLaporan.pengeluaran) {
      color = HexColor('#A80900');
    } else if (hpUiItemLaporan.enumJenisLaporan == EnumJenisLaporan.pemasukan) {
      color = Colors.green;
    }
    return Padding(
      padding: const EdgeInsets.only(top:8.0,bottom: 0.0,right: 8,left: 8),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(color: color)
        ),
        onPressed: (){},
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 8,),
              Text(
                hpUiItemLaporan.nama,
                style: TextStyle(
                  fontSize: 16,fontWeight: FontWeight.bold
                ),
              ),
              Text(
                hpUiItemLaporan.desc,
                style: TextStyle(fontSize: 11,),
              ),
              SizedBox(height: 5,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contentPengeluaran() {
    return Container(
      child: Column(
        children: <Widget>[
          _cellReport(_mReport[EnumItemLaporan.pgByCategory]),
          _cellReport(_mReport[EnumItemLaporan.pgByMonthly]),
          _cellReport(_mReport[EnumItemLaporan.pgByYearly]),
        ],
      ),
    );
  }

  Widget _contentPemasukan() {
    return Container(
      child: Column(
        children: <Widget>[
          _cellReport(_mReport[EnumItemLaporan.pmByCategory]),
          _cellReport(_mReport[EnumItemLaporan.pmByMonth]),
          _cellReport(_mReport[EnumItemLaporan.pmByYear]),
        ],
      ),
    );
  }

  Widget _contentCashFlow() {
    return Container(
      child: Column(
        children: <Widget>[
          _cellReport(_mReport[EnumItemLaporan.cfMonthly]),
          _cellReport(_mReport[EnumItemLaporan.cfYearly]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: widget.drawer,
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text('Pengeluaran'),
                ),
                Tab(
                  child: Text('Pemasukan'),
                ),
                Tab(
                  child: Text('Cash Flow'),
                ),
              ],
            ),
            title: Text('Laporan'),
          ),
          body: TabBarView(
            children: [
              _contentPengeluaran(),
              _contentPemasukan(),
              _contentCashFlow(),
            ],
          ),
        ),
      );
  }
}

enum EnumJenisLaporan { pengeluaran, pemasukan, flowcash }

enum EnumItemLaporan {
  pmByCategory,
  pmByMonth,
  pmByYear,
  cfMonthly,
  cfYearly,
  pgByCategory,
  pgByMonthly,
  pgByYearly
}

class HpUiItemLaporan {
  String nama;
  String desc;
  EnumJenisLaporan enumJenisLaporan;
  EnumItemLaporan enumItemLaporan;
  Widget widgetLaporan;

  HpUiItemLaporan(this.nama, this.desc, this.enumJenisLaporan,
      this.enumItemLaporan, this.widgetLaporan);
}