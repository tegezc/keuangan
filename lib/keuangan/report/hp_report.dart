import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:keuangan/keuangan/report/report_batang/batang/report_batang.dart';
import 'package:keuangan/keuangan/report/report_batang/cashflow/report_batang_fill.dart';
import 'package:keuangan/keuangan/report/reporting_by_kategori/reporting_bykategori.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/util/adsmob.dart';
import 'package:keuangan/util/colors_utility.dart';
import 'package:keuangan/util/common_ui.dart';

class HpReport extends StatefulWidget {
  final Widget drawer;

  HpReport({this.drawer});

  @override
  _HpReportState createState() => _HpReportState();
}

class _HpReportState extends State<HpReport> {
  Map<EnumItemLaporan, HpUiItemLaporan> _mReport;

  BannerAd _bannerAd;

  @override
  void initState() {
    _loadBannerAd();
    _setupItemUi();
    super.initState();
  }

  @override
  void dispose() {
    _disposeBanner();
    super.dispose();
  }

  void _loadBannerAd() {
    if (_bannerAd == null) {
      _bannerAd = BannerAd(
        adUnitId: AdManager.bannerAdUnitId(EnumBannerId.hpLaporan),
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

  void _disposeBanner() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  _setupItemUi() {
    _mReport = new Map();
    // ============ pemasukan =================== //
    _mReport[EnumItemLaporan.pmByCategory] = new HpUiItemLaporan(
        'Laporan Per Kateogri',
        'Laporan Pemasukan yang di kelompokkan berdasarkan kategori.',
        EnumJenisLaporan.pemasukan,
        EnumItemLaporan.pmByCategory,
        new ReportByCategories(EnumJenisTransaksi.pemasukan));
    _mReport[EnumItemLaporan.pmByMonth] = new HpUiItemLaporan(
        'Laporan Per Bulan',
        'Laporan Pemasukan per bulan pada tahun tertentu.',
        EnumJenisLaporan.pemasukan,
        EnumItemLaporan.pmByMonth,
        ReportBatang(EnumItemLaporan.pmByMonth));
    _mReport[EnumItemLaporan.pmByYear] = new HpUiItemLaporan(
        'Laporan Per Tahun',
        'Laporan Pemasukan yang ditampilkan per tahun.',
        EnumJenisLaporan.pemasukan,
        EnumItemLaporan.pmByYear,
        ReportBatang(EnumItemLaporan.pmByYear));

    // ============ pengeluaran =================== //
    _mReport[EnumItemLaporan.pgByCategory] = new HpUiItemLaporan(
        'Laporan Per Kateogri',
        'Laporan Pengeluaran yang di kelompokkan berdasarkan kategori.',
        EnumJenisLaporan.pengeluaran,
        EnumItemLaporan.pgByCategory,
        new ReportByCategories(EnumJenisTransaksi.pengeluaran));
    _mReport[EnumItemLaporan.pgByMonthly] = new HpUiItemLaporan(
        'Laporan Per Bulan',
        'Laporan Pengeluaran tiap bulan.',
        EnumJenisLaporan.pengeluaran,
        EnumItemLaporan.pgByMonthly,
        ReportBatang(EnumItemLaporan.pgByMonthly));
    _mReport[EnumItemLaporan.pgByYearly] = new HpUiItemLaporan(
        'Laporan Per Tahun',
        'Laporan Pengeluaran per tahun.',
        EnumJenisLaporan.pengeluaran,
        EnumItemLaporan.pgByYearly,
        ReportBatang(EnumItemLaporan.pgByYearly));

    // ============ pengeluaran =================== //
    _mReport[EnumItemLaporan.cfMonthly] = new HpUiItemLaporan(
        'Cash Flow Bulanan',
        'Membandingkan pemasukan dan pengeluaran tiap bulan.',
        EnumJenisLaporan.flowcash,
        EnumItemLaporan.cfMonthly,
        CfReportBatang(EnumItemLaporan.cfMonthly));
    _mReport[EnumItemLaporan.cfYearly] = new HpUiItemLaporan(
        'Cash Flow Tahunan',
        'Membandingkan pemasukan dan pengeluaran per tahun.',
        EnumJenisLaporan.flowcash,
        EnumItemLaporan.cfYearly,
        CfReportBatang(EnumItemLaporan.cfYearly));
  }

  Widget _cellReport(HpUiItemLaporan hpUiItemLaporan) {
    Color color = Colors.black54;
    if (hpUiItemLaporan.enumJenisLaporan == EnumJenisLaporan.pengeluaran) {
      color = HexColor('#A80900');
    } else if (hpUiItemLaporan.enumJenisLaporan == EnumJenisLaporan.pemasukan) {
      color = Colors.green;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 0.0, right: 8, left: 8),
      child: RaisedButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(color: color)),
        onPressed: () async {
          await openPage(context, hpUiItemLaporan.widgetLaporan);
        },
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 8,
              ),
              Text(
                hpUiItemLaporan.nama,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                hpUiItemLaporan.desc,
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
              SizedBox(
                height: 5,
              ),
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

  Future openPage(context, Widget builder) async {
    // wait until animation finished
    await SwipeBackObserver.promise?.future;

    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => builder),
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
