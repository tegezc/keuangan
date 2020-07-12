import 'dart:collection';

import 'package:keuangan/database/keuangan/dao_keuangan.dart';
import 'package:keuangan/keuangan/report/hp_report.dart';
import 'package:keuangan/keuangan/report/report_batang/batang/bloc_report_batang.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/global_data.dart';
import 'package:rxdart/subjects.dart';

class BlocCfReportBatang {
  final BehaviorSubject<ReportBatangCashFlowUi> _uiReportBatang =
      BehaviorSubject();

  Stream<ReportBatangCashFlowUi> get uiReportBatang => _uiReportBatang.stream;

  prosesCfByMonth(int year){
    this._prosesperBulan(year);
  }

  prosesCfByYears() {
    this._prosesperTahun();
  }

  void _sinkUIKategori(ReportBatangCashFlowUi reportBatangUi) {
    this._uiReportBatang.sink.add(reportBatangUi);
  }

  void _prosesperBulan(int year) async {
    EnumItemLaporan enumItemLaporan = EnumItemLaporan.cfMonthly;
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    DateTime startDate = DateTime(year, 1, 1);
    DateTime endDate = DateTime(year, 12, 31);

    List<Keuangan> lkPemasukan =
        await daoKeuangan.getKeuanganByPeriodeAndJenisTransaksi(
            EnumJenisTransaksi.pemasukan, startDate, endDate);
    List<ReportBatangItem> lBatangItemPemasukan =
        this._extractToMonthlyReport(lkPemasukan, enumItemLaporan);

    List<Keuangan> lkPengeluaran =
        await daoKeuangan.getKeuanganByPeriodeAndJenisTransaksi(
            EnumJenisTransaksi.pengeluaran, startDate, endDate);
    List<ReportBatangItem> lBatangItemPengeluaran =
        this._extractToMonthlyReport(lkPemasukan, enumItemLaporan);
    ReportBatangCashFlowUi reportBatangCashFlowUi = new ReportBatangCashFlowUi(
        lBatangItemPemasukan,
        lBatangItemPengeluaran,
        lkPemasukan,
        lkPengeluaran,
        enumItemLaporan);

    this._sinkUIKategori(reportBatangCashFlowUi);
  }

  void _prosesperTahun () async{
    EnumItemLaporan enumItemLaporan = EnumItemLaporan.cfYearly;
    DaoKeuangan daoKeuangan = new DaoKeuangan();

    List<Keuangan> lkPemasukan =
        await daoKeuangan.getKeuanganByJenisTransaksi(EnumJenisTransaksi.pemasukan,);
    List<ReportBatangItem> lBatangItemPemasukan =
    this._extractToYearlyReport(lkPemasukan, enumItemLaporan);

    List<Keuangan> lkPengeluaran =
        await daoKeuangan.getKeuanganByJenisTransaksi(EnumJenisTransaksi.pengeluaran);
    List<ReportBatangItem> lBatangItemPengeluaran =
    this._extractToYearlyReport(lkPemasukan, enumItemLaporan);

    ReportBatangCashFlowUi reportBatangCashFlowUi = new ReportBatangCashFlowUi(
        lBatangItemPemasukan,
        lBatangItemPengeluaran,
        lkPemasukan,
        lkPengeluaran,
        enumItemLaporan);

    this._sinkUIKategori(reportBatangCashFlowUi);
  }

  List<ReportBatangItem> _extractToMonthlyReport(
      List<Keuangan> lk, EnumItemLaporan enumItemLaporan) {
    // Map<int, double> tmpMk = new Map();
    SplayTreeMap<int, double> tmpMk = SplayTreeMap<int, double>();

    /// di simpan di tmpmap<int,double> krn untuk akurasi, untuk menhandle suatu
    /// saat jikamenggunakan mata uang selain rupoiah, dimana angka dibelakang
    /// koma sangat penting
    lk.forEach((keuangan) {
      DateTime dt = keuangan.tanggal;
      if (tmpMk[dt.month] == null) {
        tmpMk[dt.month] = keuangan.jumlah;
      } else {
        tmpMk[dt.month] = tmpMk[dt.month] + keuangan.jumlah;
      }
    });

    List<ReportBatangItem> listBatangItem = new List();
    tmpMk.forEach((key, value) {
      ReportBatangItem reportBatangItem =
          new ReportBatangItem(GlobalData.namaBulanPendek[key], value.toInt());
      listBatangItem.add(reportBatangItem);
    });

    return listBatangItem;
  }

  List<ReportBatangItem> _extractToYearlyReport(
      List<Keuangan> lk, EnumItemLaporan enumItemLaporan) {
    SplayTreeMap<int, double> tmpMk = SplayTreeMap<int, double>();

    /// di simpan di tmpmap<int,double> krn untuk akurasi, untuk menhandle suatu
    /// saat jikamenggunakan mata uang selain rupoiah, dimana angka dibelakang
    /// koma sangat penting
    lk.forEach((keuangan) {
      DateTime dt = keuangan.tanggal;
      if (tmpMk[dt.year] == null) {
        tmpMk[dt.year] = keuangan.jumlah;
      } else {
        tmpMk[dt.year] = tmpMk[dt.year] + keuangan.jumlah;
      }
    });

    List<ReportBatangItem> listBatangItem = new List();
    tmpMk.forEach((key, value) {
      ReportBatangItem reportBatangItem =
          new ReportBatangItem('$key', value.toInt());
      listBatangItem.add(reportBatangItem);
    });

    return listBatangItem;
  }

  void dispose() {
    _uiReportBatang.close();
  }
}

class ReportBatangCashFlowUi {
  List<ReportBatangItem> listPemasukan;
  List<ReportBatangItem> listPengeluaran;
  List<Keuangan> listKeuanganPemasukan;
  List<Keuangan> listKeuanganPengeluaran;
  EnumItemLaporan enumItemLaporan;

  ReportBatangCashFlowUi(
      this.listPemasukan,
      this.listPengeluaran,
      this.listKeuanganPemasukan,
      this.listKeuanganPengeluaran,
      this.enumItemLaporan);
}
