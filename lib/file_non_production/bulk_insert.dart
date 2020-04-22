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

    daoKategori.saveKategori(new Kategori('k11dddddddd', 1,EnumJenisTransaksi.pengeluaran,'',colors[0]));
    daoKategori.saveKategori(new Kategori('k12ddddddddd', 1,EnumJenisTransaksi.pengeluaran,'',colors[1]));

    daoKategori.saveKategori(new Kategori('Entertainment', 2,EnumJenisTransaksi.pengeluaran,'',colors[0]));
    daoKategori.saveKategori(new Kategori('Food', 2,EnumJenisTransaksi.pengeluaran,'',colors[1]));
    daoKategori.saveKategori(new Kategori('k6pajanng', 2,EnumJenisTransaksi.pemasukan,'',colors[2]));
    daoKategori.saveKategori(new Kategori('k7aaaaaaaaa', 2,EnumJenisTransaksi.pemasukan,'',colors[3]));
    daoKategori.saveKategori(new Kategori('k8aaaaaaa', 2,EnumJenisTransaksi.pemasukan,'',colors[4]));
    daoKategori.saveKategori(new Kategori('k9sssssss', 2,EnumJenisTransaksi.pengeluaran,'',colors[5]));

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

  bulkinsertKeuangan(){
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-08-1', 1, 50000, 'ct',DateTime(2019,8,1).millisecondsSinceEpoch));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-08-2', 2, 50000, 'ct',DateTime(2019,8,2).millisecondsSinceEpoch));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-08-3', 3, 13700, 'ct',DateTime(2019,8,3).millisecondsSinceEpoch));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-08-4', 4, 1700000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-08-5', 5, 532000, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-08-6', 6, 32000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-08-7', 7, 10000, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-08-8', 8, 5000, 'ct',DateTime(2019,8,8).millisecondsSinceEpoch));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-08-7', 4, 500, 'ct',DateTime(2019,8,7).millisecondsSinceEpoch));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-08-6', 5, 1000, 'ct',DateTime(2019,8,6).millisecondsSinceEpoch));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-08-5', 6, 23000, 'ct',DateTime(2019,8,5).millisecondsSinceEpoch));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-08-4', 9, 200000, 'ct',DateTime(2019,8,4).millisecondsSinceEpoch));
    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-08-4', 10,1200000 , 'ct',DateTime(2019,8,4).millisecondsSinceEpoch));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-04-28', 1, 5, '', 1));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-04-29', 10, 5, '', 1));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-04-29', 11, 5, '', 0));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-04-29', 12, 5, '', 1));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-04-30', 13, 5, '', 0));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-04-30', 14, 5, '', 1));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-04-30', 1, 5, '', 0));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-04-30', 2, 5, '', 1));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-04-01', 3, 5, '', 0));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-04-01', 4, 5, '', 1));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-04-01', 5, 5, '', 1));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-02-02', 14, 50000, '', 1));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-02-03', 16, 50000, '', 0));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-02-03', 16, 50000, '', 0));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-02-04', 16, 50000, '', 1));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-02-04', 16, 50000, '', 0));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-02-04', 8, 50000, '', 0));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-02-05', 9, 50000, '', 1));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-02-06', 2, 50000, '', 0));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-04-02', 2, 50001, '', 1));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-04-03', 4, 50002, '', 0));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-04-03', 14, 50003, '', 0));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-04-04', 14, 50004, '', 1));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-04-04', 14, 50005, '', 0));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-04-04', 14, 50006, '', 0));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-04-05', 14, 50007, '', 1));
//    daoKeuangan.saveKeuangan(new Keuangan.fromDB('2019-04-06', 14, 50008, '', 0));
  }

  deleteAllKeuangan(){
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    daoKeuangan.deleteAllKeuangan();
  }
}
