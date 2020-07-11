import 'package:keuangan/database/keuangan/dao_keuangan.dart';
import 'package:keuangan/keuangan/report/hp_report.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/global_data.dart';
import 'package:rxdart/subjects.dart';

class BlocReportBatang {
  final BehaviorSubject<ReportBatangUi> _uiReportBatang = BehaviorSubject();

  Stream<ReportBatangUi> get uiReportBatang => _uiReportBatang.stream;

  prosesPemasukanByMonth(int year) {
    this._prosesperBulan(year,EnumJenisTransaksi.pemasukan,EnumItemLaporan.pmByMonth);
  }

  prosesPemasukanByYears() {
    this._prosesperTahun(EnumJenisTransaksi.pemasukan,EnumItemLaporan.pmByYear);
  }

  prosesPengeluaranByMonth(int year) {
    this._prosesperBulan(year,EnumJenisTransaksi.pengeluaran,EnumItemLaporan.pgByMonthly);
  }

  prosesPengeluaranByYears() {
    this._prosesperTahun(EnumJenisTransaksi.pengeluaran,EnumItemLaporan.pgByYearly);
  }


  void _sinkUIKategori(ReportBatangUi reportBatangUi) {
    this._uiReportBatang.sink.add(reportBatangUi);
  }

  void _prosesperBulan(int year,EnumJenisTransaksi enumJenisTransaksi,EnumItemLaporan enumItemLaporan){
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    DateTime startDate = DateTime(year, 1, 1);
    DateTime endDate = DateTime(year, 12, 31);
    daoKeuangan
        .getKeuanganByPeriodeAndJenisTransaksi(
        enumJenisTransaksi, startDate, endDate)
        .then((listKeuangan) {
      ReportBatangUi reportBatangUi = this._extractToMonthlyReport(listKeuangan,enumItemLaporan);
      this._sinkUIKategori(reportBatangUi);
    });
  }

  void _prosesperTahun(EnumJenisTransaksi enumJenisTransaksi,EnumItemLaporan enumItemLaporan){
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    daoKeuangan.getKeuanganByJenisTransaksi(enumJenisTransaksi).then((listKeuangan) {
      ReportBatangUi reportBatangUi = this._extractToYearlyReport(listKeuangan,enumItemLaporan);
      this._sinkUIKategori(reportBatangUi);
    });
  }


  ReportBatangUi _extractToMonthlyReport(List<Keuangan> lk,EnumItemLaporan enumItemLaporan) {
    Map<int, double> tmpMk = new Map();

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

    ReportBatangUi reportBatangUi = new ReportBatangUi();
    reportBatangUi.enumItemLaporan = enumItemLaporan;
    reportBatangUi.listKeuangan = lk;
    reportBatangUi.listBatangItem = listBatangItem;
    return reportBatangUi;
  }

  ReportBatangUi _extractToYearlyReport(List<Keuangan> lk,EnumItemLaporan enumItemLaporan) {
    Map<int, double> tmpMk = new Map();

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

    ReportBatangUi reportBatangUi = new ReportBatangUi();
    reportBatangUi.enumItemLaporan = enumItemLaporan;
    reportBatangUi.listKeuangan = lk;
    reportBatangUi.listBatangItem = listBatangItem;
    return reportBatangUi;
  }
}

class ReportBatangUi {
  List<Keuangan> listKeuangan;
  List<ReportBatangItem> listBatangItem;
  EnumItemLaporan enumItemLaporan;
}

class ReportBatangItem {
  String xvalue;
  int yvalue;

  ReportBatangItem(this.xvalue, this.yvalue);
}
