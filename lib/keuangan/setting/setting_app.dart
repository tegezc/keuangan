import 'dart:convert';

import 'package:keuangan/database/dao_setup.dart';
import 'package:keuangan/database/db_utility.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/model/setup.dart';

class SettingApp {
  DaoSetup _daoSetup;

  final String _tagTex = 'text';
  final String _tagCatatan = 'catatan';
  final String _tagSubkategori = 'subkategori';
  final String _tagWarna = 'warna';
  final String _tagKey = 'key';
  DbUtility _dbUtility;

  DaoKategori _daoKategori;

  SettingApp() {
    _daoSetup = new DaoSetup();
    _daoKategori = new DaoKategori();
    _dbUtility = new DbUtility();
  }

  _testShowData() {
    DaoKategori daoKategori = new DaoKategori();
    daoKategori
        .getAllKategoriTermasukAbadi(EnumJenisTransaksi.pengeluaran)
        .then((value) {
      value.forEach((element) {
        print(element.toString1());
      });
      daoKategori
          .getAllKategoriTermasukAbadi(EnumJenisTransaksi.pemasukan)
          .then((value) {
        value.forEach((element) {
          print(element.toString1());
        });
      });
    });
  }

  Future<bool> prepareFirstTimeInstall() async {
    bool isFirstimeInstall = await this._isFirstTimeInstall();
    if (isFirstimeInstall) {
      bool isinserted = await this._insertInitialKategori();
      if (isinserted) {
        _testShowData();
      }
    }
    return true;
  }

  Future<bool> _isFirstTimeInstall() async {
    Setup setup = await _daoSetup.getSetupByNama('FLAG_FIRSTIME');
    if (setup == null) {
      Setup stp = new Setup(
          'FLAG_FIRSTIME', '', _dbUtility.generateDateToMiliseconds());
      await _daoSetup.saveSetup(stp);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _insertInitialKategori() async {
    String datajson = datajsonkategori;
    Map<String, dynamic> mapKategori = jsonDecode(datajson);

    /// map 0 : pengeluaran, 1: pemasukan, 2: abadi
    Map<String, dynamic> mapPengeluaran = mapKategori['0'];
    Map<String, dynamic> mapPemasukan = mapKategori['1'];
    Map<String, dynamic> mapAbadi = mapKategori['2'];

    List<Kategori> lktg = new List();
    mapPengeluaran.forEach((key, value) {
      String text = value[_tagTex];
      String catatan = value[_tagCatatan];
      String warna = value[_tagWarna];
      int realidParent = value[_tagKey];
      Kategori k = new Kategori.fromUI(
          text, 0, EnumJenisTransaksi.pengeluaran, catatan, warna);
      k.setRealId(realidParent);
      lktg.add(k);
      Map<String, dynamic> msub = value[_tagSubkategori];
      if (msub.isNotEmpty) {
        msub.forEach((kunci, mapchild) {
          String text1 = mapchild[_tagTex];
          String catatan1 = mapchild[_tagCatatan];
          String warna1 = mapchild[_tagWarna];
          int realIdSub = mapchild[_tagKey];
          Kategori k1 = new Kategori.fromUI(text1, realidParent,
              EnumJenisTransaksi.pengeluaran, catatan1, warna1);
          k1.setRealId(realIdSub);
          lktg.add(k1);
        });

      }
    });
    mapPemasukan.forEach((key, value) {
      String text = value[_tagTex];
      String catatan = value[_tagCatatan];
      String warna = value[_tagWarna];
      int realidParent = value[_tagKey];
      Kategori k = new Kategori.fromUI(
          text, 0, EnumJenisTransaksi.pemasukan, catatan, warna);
      k.setRealId(realidParent);
      lktg.add(k);
    });

    Map<String,dynamic> abadiPengeluaran = mapAbadi['0'];
    Map<String,dynamic> abadiPemasukan = mapAbadi['1'];

    String text = abadiPengeluaran[_tagTex];
    String catatan = abadiPengeluaran[_tagCatatan];
    String warna = abadiPengeluaran[_tagWarna];
    int realidParent = abadiPengeluaran[_tagKey];
    Kategori k = new Kategori.fromUI(
        text, 0, EnumJenisTransaksi.pengeluaran, catatan, warna);
    k.setRealId(realidParent);
    k.isAbadi = 1;
    lktg.add(k);

    String text1 = abadiPemasukan[_tagTex];
    String catatan1 = abadiPemasukan[_tagCatatan];
    String warna1 = abadiPemasukan[_tagWarna];
    int realIdSub = abadiPemasukan[_tagKey];
    Kategori k1 = new Kategori.fromUI(text1, 0,
        EnumJenisTransaksi.pemasukan, catatan1, warna1);
    k1.setRealId(realIdSub);
    k1.isAbadi = 1;
    lktg.add(k1);

    for(int i =0;i<lktg.length;i++){
      ResultDb resultDb = await  _daoKategori.saveKategoriInitial(lktg[i]);
      if(resultDb.enumResultDb == EnumResultDb.success){

      }
    }
    return true;
  }
}

final datajsonkategori =
    "{\"0\":{\"1\":{\"text\":\"Pulsa HP\",\"catatan\":\"\",\"warna\":\"623fcd\",\"key\":1597330176064,\"subkategori\":{\"1\":{\"text\":\"Pulsa XL\",\"catatan\":\"\",\"warna\":\"80db3b\",\"key\":1597330176065},\"2\":{\"text\":\"Pulsa Telkomsel\",\"catatan\":\"\",\"warna\":\"ca49da\",\"key\":1597330176066},\"3\":{\"text\":\"Pulsa Indosat\",\"catatan\":\"\",\"warna\":\"64d76e\",\"key\":1597330176067}}},\"2\":{\"text\":\"Tempat Tinggal\",\"catatan\":\"Kategori yang berhubungan dengan keperluan tempat tinggal (kos, rumah, kontrakan)\",\"warna\":\"843498\",\"key\":1597330176068,\"subkategori\":{\"1\":{\"text\":\"Pulsa Listrik\",\"catatan\":\"\",\"warna\":\"d7da44\",\"key\":1597330176069},\"2\":{\"text\":\"Cicilan Rumah\",\"catatan\":\"\",\"warna\":\"3f2b7a\",\"key\":1597330176070},\"3\":{\"text\":\"Kontrakan\",\"catatan\":\"Setiap melakukan pembayaran kontrak rumah, dapat di masukkan kedalam kategori ini.\",\"warna\":\"b2dc8b\",\"key\":1597330176071},\"4\":{\"text\":\"Perabotan\",\"catatan\":\"Seperti: meja, kursi, kran, kabel, kasur,bantal, dll.\",\"warna\":\"623fcd\",\"key\":1597330176072},\"5\":{\"text\":\"Service Rumah\",\"catatan\":\"Setiap melakukan service di setiap bagian rumah.\",\"warna\":\"80db3b\",\"key\":1597330176073},\"6\":{\"text\":\"Tagihan PDAM\",\"catatan\":\"Pembayaran rutin PDAM\",\"warna\":\"d54aa5\",\"key\":1597330176074}}},\"3\":{\"text\":\"Rumah Tangga\",\"catatan\":\"Keperluan rumah tangga seperti diterjen, alat pel, sapu, dll\",\"warna\":\"63dfb4\",\"key\":1597330176075,\"subkategori\":{\"1\":{\"text\":\"Dapur\",\"catatan\":\"Seperti Bumbu masak, sayur, beras, minyak goreng ,dll\",\"warna\":\"d84670\",\"key\":1597330176076},\"2\":{\"text\":\"Iuran\",\"catatan\":\"Seperti iuran sampah, RT\/RW, dll\",\"warna\":\"518a32\",\"key\":1597330176077}}},\"4\":{\"text\":\"Hobi & Hiburan\",\"catatan\":\"Seperti wisata, jalan-jalan, makan di resto, renang dll\",\"warna\":\"9b73de\",\"key\":1597330176078,\"subkategori\":{\"1\":{\"text\":\"Liburan\",\"catatan\":\"Seperti pergi ke tempat wisata\",\"warna\":\"ca49da\",\"key\":1597330176079},\"2\":{\"text\":\"Futsal\",\"catatan\":\"Sepatu futsal, biaya futsal dll\",\"warna\":\"64d76e\",\"key\":1597330176080},\"3\":{\"text\":\"Membaca\",\"catatan\":\"Keperluan yang berhubungan dengan hobi membaca\",\"warna\":\"843498\",\"key\":1597330176081}}},\"5\":{\"text\":\"Sekolah\",\"catatan\":\"Pengeluaran yang berhubungan dengan keperluan sekolah\",\"warna\":\"dd953d\",\"key\":1597330176082,\"subkategori\":{\"1\":{\"text\":\"SPP\",\"catatan\":\"\",\"warna\":\"5e7bca\",\"key\":1597330176083},\"2\":{\"text\":\"Kursus\",\"catatan\":\"Seperti kursus bahasa inggris, kursus matematika, dll\",\"warna\":\"dd5035\",\"key\":1597330176084},\"3\":{\"text\":\"Buku Sekolah\",\"catatan\":\"\",\"warna\":\"88d2d2\",\"key\":1597330176085}}},\"6\":{\"text\":\"Kesehatan\",\"catatan\":\"Segala pengeluaran yang berhubungan dengan kesehatan.\",\"warna\":\"93312d\",\"key\":1597330176086,\"subkategori\":{\"1\":{\"text\":\"BPJS\",\"catatan\":\"\",\"warna\":\"519576\",\"key\":1597330176087}}},\"7\":{\"text\":\"Kecantikan\",\"catatan\":\"Yang berhubungan dengan perawatan kecantikan\",\"warna\":\"7e3666\",\"key\":1597330176088,\"subkategori\":{\"1\":{\"text\":\"Aksesoris\",\"catatan\":\"Seperti kalung, pita dll\",\"warna\":\"d9cda0\",\"key\":1597330176089},\"2\":{\"text\":\"Makeup\",\"catatan\":\"\",\"warna\":\"2f2543\",\"key\":1597330176090}}},\"8\":{\"text\":\"Hadiah\",\"catatan\":\"Seperti  kado, hadiah, dll\",\"warna\":\"dc9f96\",\"key\":1597330176091,\"subkategori\":{}},\"9\":{\"text\":\"Transport\",\"catatan\":\"Berhubungan dengan transportasi\",\"warna\":\"334428\",\"key\":1597330176092,\"subkategori\":{\"1\":{\"text\":\"Motor\",\"catatan\":\"Pengeluaran untuk motor seperti service dll\",\"warna\":\"ce93cb\",\"key\":1597330176093},\"2\":{\"text\":\"Mobil\",\"catatan\":\"Pengeluaran untuk mobil seperti service dll\",\"warna\":\"996030\",\"key\":1597330176094}}},\"10\":{\"text\":\"Makan\",\"catatan\":\"Bagi pekerja biasanya ada pengeluaran makan di luar rumah\",\"warna\":\"92b1d6\",\"key\":1597330176095,\"subkategori\":{\"1\":{\"text\":\"Sarapan\",\"catatan\":\"\",\"warna\":\"522826\",\"key\":1597330176096},\"2\":{\"text\":\"Makan Siang\",\"catatan\":\"\",\"warna\":\"7f7d51\",\"key\":1597330176097},\"3\":{\"text\":\"Makan Malam\",\"catatan\":\"\",\"warna\":\"4f6c82\",\"key\":1597330176098}}},\"11\":{\"text\":\"Utilitas\",\"catatan\":\"Seperti alat potong rumput, palu, dll\",\"warna\":\"d7da44\",\"key\":1597330176099,\"subkategori\":{}},\"12\":{\"text\":\"Pribadi\",\"catatan\":\"Keperluan pribadi\",\"warna\":\"a16772\",\"key\":1597330176100,\"subkategori\":{}}},\"1\":{\"1\":{\"text\":\"Karyawan\",\"catatan\":\"Gaji, Bonus, Tunjangan dll.\",\"warna\":\"d7da44\",\"key\":1597330176101,\"subkategori\":{}},\"2\":{\"text\":\"Bisnis\",\"catatan\":\"Segala pendapatan dari bisnis\",\"warna\":\"3f2b7a\",\"key\":1597330176102,\"subkategori\":{}}},\"2\":{\"0\":{\"text\":\"Lain-Lain\",\"catatan\":\"Pengeluaran yang belum di kategorikan\",\"warna\":\"800000\",\"key\":1597330176103,\"subkategori\":{}},\"1\":{\"text\":\"Lain - Lain\",\"catatan\":\"Pemasukan yang belum di kategorikan\",\"warna\":\"006400\",\"key\":1597330176104,\"subkategori\":{}}}}";

