import 'package:keuangan/database/keuangan/dao_itemname.dart';
import 'package:keuangan/database/keuangan/dao_keuangan.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/colors_utility.dart';

class Persiapan {
  static final int tahunMulai = 1965;
  static final int tahunAkhir = 2050;


  insertKategoriDummy() {
    var colors = ColorManagement.colors;
    DaoKategori daoKategori = DaoKategori();
    Kategori kOtherPemasukan = new Kategori('Other', 0,EnumJenisTransaksi.pemasukan,'mencoba catatan',colors[0]);
    kOtherPemasukan.isAbadi = 1;
    Kategori kOtherPengeluaran = new Kategori('Other', 0,EnumJenisTransaksi.pengeluaran,'mencoba catatan',colors[0]);
    kOtherPengeluaran.isAbadi = 1;
    daoKategori.saveKategori(kOtherPemasukan);
    daoKategori.saveKategori(kOtherPengeluaran);
    daoKategori.saveKategori(new Kategori('Donation', 0,EnumJenisTransaksi.pengeluaran,'',colors[1]));
    daoKategori.saveKategori(new Kategori('Gaji', 0,EnumJenisTransaksi.pemasukan,'',colors[2]));
    daoKategori.saveKategori(new Kategori('k14cccccccc', 0,EnumJenisTransaksi.pengeluaran,'',colors[3]));
    daoKategori.saveKategori(new Kategori('Google Play', 0,EnumJenisTransaksi.pemasukan,'',colors[4]));
    daoKategori.saveKategori(new Kategori('Gift', 0,EnumJenisTransaksi.pengeluaran,'',colors[5]));
    daoKategori.saveKategori(new Kategori('k10dddddddd', 0,EnumJenisTransaksi.pengeluaran,'',colors[6]));

    daoKategori.saveKategori(new Kategori('k11dddddddd', 3,EnumJenisTransaksi.pengeluaran,'',colors[0]));
    daoKategori.saveKategori(new Kategori('k12ddddddddd', 3,EnumJenisTransaksi.pengeluaran,'',colors[1]));

    daoKategori.saveKategori(new Kategori('Entertainment', 5,EnumJenisTransaksi.pengeluaran,'',colors[0]));
    daoKategori.saveKategori(new Kategori('Food', 5,EnumJenisTransaksi.pengeluaran,'',colors[1]));
    daoKategori.saveKategori(new Kategori('k6pajanng', 5,EnumJenisTransaksi.pemasukan,'',colors[2]));
    daoKategori.saveKategori(new Kategori('k7aaaaaaaaa', 3,EnumJenisTransaksi.pemasukan,'',colors[3]));
    daoKategori.saveKategori(new Kategori('k8aaaaaaa', 3,EnumJenisTransaksi.pemasukan,'',colors[4]));
    daoKategori.saveKategori(new Kategori('k9sssssss', 3,EnumJenisTransaksi.pengeluaran,'',colors[5]));

    daoKategori.saveKategori(new Kategori('Insurance',5,EnumJenisTransaksi.pengeluaran,'',colors[0]));

    daoKategori.saveKategori(new Kategori('k16ttttttt', 7,EnumJenisTransaksi.pengeluaran,'',colors[0]));

  }

  deleteAllKategori() {
    DaoKategori daoKategori = new DaoKategori();
    daoKategori.deleteAllKategori();
  }

  insertItemNameDummy(){
    DaoItemName daoItemName = new DaoItemName();
    daoItemName.saveItemName(new ItemName('Makan', 1,0));
    daoItemName.saveItemName(new ItemName('pulsa', 1,0));
    daoItemName.saveItemName(new ItemName('Internet Telkomsel', 2,0));
    daoItemName.saveItemName(new ItemName('Internet XL', 2,0));
    daoItemName.saveItemName(new ItemName('Shop', 3,0));
    daoItemName.saveItemName(new ItemName('Transport Operasional', 3,0));
    daoItemName.saveItemName(new ItemName('Kosan', 5,0));
    daoItemName.saveItemName(new ItemName('Jajan', 5,0));
    daoItemName.saveItemName(new ItemName('Kalender', 6,0));
    daoItemName.saveItemName(new ItemName('Freelance', 4,0));
//    daoItemName.saveItemName(new ItemName('Keperluan bulanan', 3));
//    daoItemName.saveItemName(new ItemName('keperluan Motor', 3));
//    daoItemName.saveItemName(new ItemName('Mobil', 4));
//    daoItemName.saveItemName(new ItemName('Anak Sekolah', 4));
//    daoItemName.saveItemName(new ItemName('Belanja Harian', 4));
//    daoItemName.saveItemName(new ItemName('Ngirim Orang Tua', 4));
//    daoItemName.saveItemName(new ItemName('Makan malam', 6));
//    daoItemName.saveItemName(new ItemName('Makan Siang', 6));
//    daoItemName.saveItemName(new ItemName('Makan Pagi', 6));
//    daoItemName.saveItemName(new ItemName('Makan Kantor', 6));
//    daoItemName.saveItemName(new ItemName('Salon', 5));
//    daoItemName.saveItemName(new ItemName('Bekam', 5));
//    daoItemName.saveItemName(new ItemName('Transport Jakarta', 5));
  }

  deleteAllItemName(){
    DaoItemName daoItemName = new DaoItemName();
    daoItemName.deleteAllItemName();
  }

  bulkinsertall(){
    bulkinsertKeuangan(2013);
    bulkinsertKeuangan(2014);
    bulkinsertKeuangan(2015);
    bulkinsertKeuangan(2016);
    bulkinsertKeuanganVersi2BiarBeda(2017);
    bulkinsertKeuangan(2018);
    bulkinsertKeuangan(2019);
    bulkinsertKeuangan(2020);

  }

  bulkinsertKeuangan(int year){
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    /// JANUARI
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-11', 1, 50000, 'ct',DateTime(2019,8,1).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-22', 2, 50000, 'ct',DateTime(2019,8,2).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-23', 3, 13700, 'ct',DateTime(2019,8,3).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-14', 4, 1700000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-15', 5, 532000, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-26', 6, 32000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-17', 6, 10000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-8', 6, 5000, 'ct',DateTime(2019,8,8).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-7', 4, 500, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-25', 5, 1000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-5', 6, 23000, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-4', 3, 200000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-28', 9,1200000 , 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));

    /// FEBRUARI
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-11', 1, 25000, 'ct',DateTime(2019,8,1).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-22', 2, 20000, 'ct',DateTime(2019,8,2).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-23', 3, 13700, 'ct',DateTime(2019,8,3).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-14', 4, 1700000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-15', 5, 532000, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-26', 6, 32000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-17', 6, 10000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-8', 6, 5000, 'ct',DateTime(2019,8,8).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-7', 4, 500, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-25', 5, 1000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-5', 6, 23000, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-4', 3, 200000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-28', 10,1000000 , 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));

    /// maret
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-11', 1, 50000, 'ct',DateTime(2019,8,1).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-22', 2, 50000, 'ct',DateTime(2019,8,2).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-23', 3, 13000, 'ct',DateTime(2019,8,3).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-14', 4, 1700000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-15', 5, 532000, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-26', 6, 32000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-17', 6, 10000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-8', 6, 5000, 'ct',DateTime(2019,8,8).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-7', 4, 5000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-25', 5, 91000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-5', 6, 23000, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-4', 9, 200000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-28', 10,900000 , 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));

    /// APRIL
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-11', 1, 50000, 'ct',DateTime(2019,8,1).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-22', 2, 50000, 'ct',DateTime(2019,8,2).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-23', 3, 13700, 'ct',DateTime(2019,8,3).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-14', 4, 1700000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-15', 5, 53000, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-26', 6, 32000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-17', 6, 10000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-8', 6, 5000, 'ct',DateTime(2019,8,8).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-7', 4, 500, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-25', 5, 1000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-5', 6, 23000, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-4', 3, 200000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-28', 10,1000000 , 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));

    /// mei
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-11', 1, 50000, 'ct',DateTime(2019,8,1).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-22', 2, 50000, 'ct',DateTime(2019,8,2).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-23', 3, 13700, 'ct',DateTime(2019,8,3).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-14', 4, 1700000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-15', 5, 532000, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-26', 6, 32000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-17', 6, 10000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-8', 6, 5000, 'ct',DateTime(2019,8,8).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-7', 4, 500, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-25', 5, 1000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-5', 6, 23000, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-4', 3, 200000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-28', 9,1200000 , 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));

    /// JUNI
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-11', 1, 50000, 'ct',DateTime(2019,8,1).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-22', 2, 50000, 'ct',DateTime(2019,8,2).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-23', 3, 13700, 'ct',DateTime(2019,8,3).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-14', 4, 1700000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-15', 5, 532000, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-26', 6, 32000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-17', 6, 10000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-8', 6, 55000, 'ct',DateTime(2019,8,8).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-7', 4, 7500, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-25', 5, 1000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-5', 6, 23000, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-4', 3, 200000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-28', 10,2000000 , 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    if(year != 2020) {
      /// JULI
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-07-11', 1, 10000, 'ct',
          DateTime(2019, 8, 1).millisecondsSinceEpoch, 1));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-07-22', 2, 40000, 'ct',
          DateTime(2019, 8, 2).millisecondsSinceEpoch, 1));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-07-23', 3, 13700, 'ct',
          DateTime(2019, 8, 3).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-07-14', 4, 1700000, 'ct',
          DateTime(2019, 8, 4).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-07-15', 5, 532000, 'ct',
          DateTime(2019, 8, 5).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-07-26', 6, 32000, 'ct',
          DateTime(2019, 8, 6).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-07-17', 6, 10000, 'ct',
          DateTime(2019, 8, 7).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-07-8', 6, 5000, 'ct',
          DateTime(2019, 8, 8).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-07-7', 4, 2500, 'ct',
          DateTime(2019, 8, 7).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-07-25', 5, 13000, 'ct',
          DateTime(2019, 8, 6).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-07-5', 6, 23000, 'ct',
          DateTime(2019, 8, 5).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-07-4', 3, 200000, 'ct',
          DateTime(2019, 8, 4).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-07-28', 9, 1500000, 'ct',
          DateTime(2019, 8, 4).millisecondsSinceEpoch, 0));

      /// AGUSTUS
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-08-11', 1, 55000, 'ct',
          DateTime(2019, 8, 1).millisecondsSinceEpoch, 1));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-08-22', 2, 55000, 'ct',
          DateTime(2019, 8, 2).millisecondsSinceEpoch, 1));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-08-23', 3, 13000, 'ct',
          DateTime(2019, 8, 3).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-08-14', 4, 1700000, 'ct',
          DateTime(2019, 8, 4).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-08-15', 5, 532000, 'ct',
          DateTime(2019, 8, 5).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-08-26', 6, 32000, 'ct',
          DateTime(2019, 8, 6).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-08-17', 6, 10000, 'ct',
          DateTime(2019, 8, 7).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-08-8', 6, 5000, 'ct',
          DateTime(2019, 8, 8).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-08-7', 4, 55500, 'ct',
          DateTime(2019, 8, 7).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-08-25', 5, 111000, 'ct',
          DateTime(2019, 8, 6).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-08-5', 6, 23000, 'ct',
          DateTime(2019, 8, 5).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-08-4', 3, 200000, 'ct',
          DateTime(2019, 8, 4).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-08-28', 10, 12000000, 'ct',
          DateTime(2019, 8, 4).millisecondsSinceEpoch, 0));

      /// SEPT
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-09-11', 1, 50000, 'ct',
          DateTime(2019, 8, 1).millisecondsSinceEpoch, 1));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-09-22', 2, 50000, 'ct',
          DateTime(2019, 8, 2).millisecondsSinceEpoch, 1));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-09-23', 3, 13700, 'ct',
          DateTime(2019, 8, 3).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-09-14', 4, 1700000, 'ct',
          DateTime(2019, 8, 4).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-09-15', 5, 532000, 'ct',
          DateTime(2019, 8, 5).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-09-26', 6, 32000, 'ct',
          DateTime(2019, 8, 6).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-09-17', 6, 10000, 'ct',
          DateTime(2019, 8, 7).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-09-8', 6, 5000, 'ct',
          DateTime(2019, 8, 8).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-09-7', 4, 500, 'ct',
          DateTime(2019, 8, 7).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-09-25', 5, 1000, 'ct',
          DateTime(2019, 8, 6).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-09-5', 6, 23000, 'ct',
          DateTime(2019, 8, 5).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-09-4', 3, 200000, 'ct',
          DateTime(2019, 8, 4).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-09-28', 10, 13000000, 'ct',
          DateTime(2019, 8, 4).millisecondsSinceEpoch, 0));

      /// OKT
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-10-11', 1, 50000, 'ct',
          DateTime(2019, 8, 1).millisecondsSinceEpoch, 1));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-10-22', 2, 50000, 'ct',
          DateTime(2019, 8, 2).millisecondsSinceEpoch, 1));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-10-23', 3, 13700, 'ct',
          DateTime(2019, 8, 3).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-10-14', 4, 1700000, 'ct',
          DateTime(2019, 8, 4).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-10-15', 5, 532000, 'ct',
          DateTime(2019, 8, 5).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-10-26', 6, 32000, 'ct',
          DateTime(2019, 8, 6).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-10-17', 6, 160000, 'ct',
          DateTime(2019, 8, 7).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-10-8', 6, 5000, 'ct',
          DateTime(2019, 8, 8).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-10-7', 4, 50000, 'ct',
          DateTime(2019, 8, 7).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-10-25', 5, 001000, 'ct',
          DateTime(2019, 8, 6).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-10-5', 6, 23000, 'ct',
          DateTime(2019, 8, 5).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-10-4', 3, 200000, 'ct',
          DateTime(2019, 8, 4).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-10-28', 9, 12000000, 'ct',
          DateTime(2019, 8, 4).millisecondsSinceEpoch, 0));

      /// NOV
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-11-11', 1, 550000, 'ct',
          DateTime(2019, 8, 1).millisecondsSinceEpoch, 1));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-11-22', 2, 550000, 'ct',
          DateTime(2019, 8, 2).millisecondsSinceEpoch, 1));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-11-23', 3, 130000, 'ct',
          DateTime(2019, 8, 3).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-11-14', 4, 1700000, 'ct',
          DateTime(2019, 8, 4).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-11-15', 5, 532000, 'ct',
          DateTime(2019, 8, 5).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-11-26', 6, 32000, 'ct',
          DateTime(2019, 8, 6).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-11-17', 6, 10000, 'ct',
          DateTime(2019, 8, 7).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-11-8', 6, 5000, 'ct',
          DateTime(2019, 8, 8).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-11-7', 4, 500, 'ct',
          DateTime(2019, 8, 7).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-11-25', 5, 1000, 'ct',
          DateTime(2019, 8, 6).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-11-5', 6, 23000, 'ct',
          DateTime(2019, 8, 5).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-11-4', 3, 200000, 'ct',
          DateTime(2019, 8, 4).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-11-28', 10, 13000000, 'ct',
          DateTime(2019, 8, 4).millisecondsSinceEpoch, 0));

      /// DES
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-12-11', 1, 50000, 'ct',
          DateTime(2019, 8, 1).millisecondsSinceEpoch, 1));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-12-22', 2, 50000, 'ct',
          DateTime(2019, 8, 2).millisecondsSinceEpoch, 1));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-12-23', 3, 13700, 'ct',
          DateTime(2019, 8, 3).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-12-14', 4, 1700000, 'ct',
          DateTime(2019, 8, 4).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-12-15', 5, 532000, 'ct',
          DateTime(2019, 8, 5).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-12-26', 6, 32000, 'ct',
          DateTime(2019, 8, 6).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-12-17', 6, 10000, 'ct',
          DateTime(2019, 8, 7).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-12-8', 6, 5000, 'ct',
          DateTime(2019, 8, 8).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-12-7', 4, 55000, 'ct',
          DateTime(2019, 8, 7).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-12-25', 5, 190000, 'ct',
          DateTime(2019, 8, 6).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-12-5', 6, 23000, 'ct',
          DateTime(2019, 8, 5).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-12-4', 3, 200000, 'ct',
          DateTime(2019, 8, 4).millisecondsSinceEpoch, 0));
      daoKeuangan.saveKeuangan(new Keuangan.fromDB(
          '$year-12-28', 9, 13000000, 'ct',
          DateTime(2019, 8, 4).millisecondsSinceEpoch, 0));
    }
  }

  bulkinsertKeuanganVersi2BiarBeda(int year){
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    /// JANUARI
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-11', 1, 500, 'ct',DateTime(2019,8,1).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-22', 2, 500, 'ct',DateTime(2019,8,2).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-23', 3, 100, 'ct',DateTime(2019,8,3).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-14', 4, 100, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-15', 5, 500, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-26', 6, 300, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-17', 6, 1000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-8', 6, 500, 'ct',DateTime(2019,8,8).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-7', 4, 500, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-25', 5, 100, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-5', 6, 200, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-4', 3, 200, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-01-28', 9,12000 , 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));

    /// FEBRUARI
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-11', 1, 250, 'ct',DateTime(2019,8,1).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-22', 2, 200, 'ct',DateTime(2019,8,2).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-23', 3, 1370, 'ct',DateTime(2019,8,3).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-14', 4, 17000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-15', 5, 5300, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-26', 6, 3200, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-17', 6, 1000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-8', 6, 500, 'ct',DateTime(2019,8,8).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-7', 4, 500, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-25', 5, 1000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-5', 6, 2300, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-4', 3, 2000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-02-28', 10,10000 , 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));

    /// maret
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-11', 1, 500, 'ct',DateTime(2019,8,1).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-22', 2, 500, 'ct',DateTime(2019,8,2).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-23', 3, 13000, 'ct',DateTime(2019,8,3).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-14', 4, 1000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-15', 5, 5320, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-26', 6, 3200, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-17', 6, 1000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-8', 6, 500, 'ct',DateTime(2019,8,8).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-7', 4, 500, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-25', 5, 900, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-5', 6, 2300, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-4', 9, 20000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-03-28', 10,90000 , 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));

    /// APRIL
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-11', 1, 5000, 'ct',DateTime(2019,8,1).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-22', 2, 5000, 'ct',DateTime(2019,8,2).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-23', 3, 1370, 'ct',DateTime(2019,8,3).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-14', 4, 10000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-15', 5, 5300, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-26', 6, 3000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-17', 6, 1000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-8', 6, 500, 'ct',DateTime(2019,8,8).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-7', 4, 500, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-25', 5, 100, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-5', 6, 2300, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-4', 3, 20000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-04-28', 10,100000 , 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));

    /// mei
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-11', 1, 5000, 'ct',DateTime(2019,8,1).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-22', 2, 5000, 'ct',DateTime(2019,8,2).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-23', 3, 1300, 'ct',DateTime(2019,8,3).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-14', 4, 1000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-15', 5, 5300, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-26', 6, 3200, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-17', 6, 100, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-8', 6, 5000, 'ct',DateTime(2019,8,8).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-7', 4, 500, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-25', 5, 1000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-5', 6, 2000, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-4', 3, 2000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-05-28', 9,12000 , 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));

    /// JUNI
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-11', 1, 5000, 'ct',DateTime(2019,8,1).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-22', 2, 5000, 'ct',DateTime(2019,8,2).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-23', 3, 1300, 'ct',DateTime(2019,8,3).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-14', 4, 10000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-15', 5, 5300, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-26', 6, 3200, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-17', 6, 1000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-8', 6, 5500, 'ct',DateTime(2019,8,8).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-7', 4, 750, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-25', 5, 1000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-5', 6, 2300, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-4', 3, 20000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-06-28', 10,20000 , 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));

    /// JULI
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-07-11', 1, 1000, 'ct',DateTime(2019,8,1).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-07-22', 2, 4000, 'ct',DateTime(2019,8,2).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-07-23', 3, 1000, 'ct',DateTime(2019,8,3).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-07-14', 4, 17000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-07-15', 5, 532000, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-07-26', 6, 32000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-07-17', 6, 1000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-07-8', 6, 500, 'ct',DateTime(2019,8,8).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-07-7', 4, 2500, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-07-25', 5, 13000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-07-5', 6, 2300, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-07-4', 3, 2000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-07-28', 9,15000 , 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));

    /// AGUSTUS
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-08-11', 1, 5000, 'ct',DateTime(2019,8,1).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-08-22', 2, 5000, 'ct',DateTime(2019,8,2).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-08-23', 3, 1300, 'ct',DateTime(2019,8,3).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-08-14', 4, 10000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-08-15', 5, 532000, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-08-26', 6, 32000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-08-17', 6, 10000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-08-8', 6, 5000, 'ct',DateTime(2019,8,8).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-08-7', 4, 5500, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-08-25', 5, 1000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-08-5', 6, 2300, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-08-4', 3, 20000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-08-28', 10,100000 , 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));

    /// SEPT
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-09-11', 1, 5000, 'ct',DateTime(2019,8,1).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-09-22', 2, 5000, 'ct',DateTime(2019,8,2).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-09-23', 3, 1300, 'ct',DateTime(2019,8,3).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-09-14', 4, 10000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-09-15', 5, 5000, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-09-26', 6, 3000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-09-17', 6, 1000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-09-8', 6, 5000, 'ct',DateTime(2019,8,8).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-09-7', 4, 500, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-09-25', 5, 1000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-09-5', 6, 200, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-09-4', 3, 20000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-09-28', 10,100000 , 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));

    /// OKT
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-10-11', 1, 5000, 'ct',DateTime(2019,8,1).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-10-22', 2, 5000, 'ct',DateTime(2019,8,2).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-10-23', 3, 1300, 'ct',DateTime(2019,8,3).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-10-14', 4, 10000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-10-15', 5, 5000, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-10-26', 6, 32000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-10-17', 6, 16000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-10-8', 6, 5000, 'ct',DateTime(2019,8,8).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-10-7', 4, 5000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-10-25', 5, 1000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-10-5', 6, 2300, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-10-4', 3, 20000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-10-28', 9,100000 , 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));

    /// NOV
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-11-11', 1, 5000, 'ct',DateTime(2019,8,1).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-11-22', 2, 5000, 'ct',DateTime(2019,8,2).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-11-23', 3, 10000, 'ct',DateTime(2019,8,3).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-11-14', 4, 10000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-11-15', 5, 5000, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-11-26', 6, 32000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-11-17', 6, 1000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-11-8', 6, 5000, 'ct',DateTime(2019,8,8).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-11-7', 4, 500, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-11-25', 5, 1000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-11-5', 6, 2300, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-11-4', 3, 20000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-11-28', 10,100000 , 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));

    /// DES
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-12-11', 1, 5000, 'ct',DateTime(2019,8,1).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-12-22', 2, 5000, 'ct',DateTime(2019,8,2).millisecondsSinceEpoch,1));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-12-23', 3, 1300, 'ct',DateTime(2019,8,3).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-12-14', 4, 10000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-12-15', 5, 5300, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-12-26', 6, 3000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-12-17', 6, 1000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-12-8', 6, 5000, 'ct',DateTime(2019,8,8).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-12-7', 4, 5000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-12-25', 5, 1000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-12-5', 6, 2300, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-12-4', 3, 20000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('$year-12-28', 9,1300000 , 'ct',DateTime(2019,8,4).millisecondsSinceEpoch,0));

  }

  deleteAllKeuangan(){
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    daoKeuangan.deleteAllKeuangan();
  }
}
