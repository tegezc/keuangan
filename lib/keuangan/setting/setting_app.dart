import 'dart:convert';

import 'package:keuangan/database/dao_setup.dart';
import 'package:keuangan/database/db_utility.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/model/setup.dart';
import 'package:keuangan/util/colors_utility.dart';

class SettingApp {
  DaoSetup _daoSetup;
  final _colorsmain = ColorManagement.colors;
  final _colorsSub = ColorManagement.colors;
  final String _tagTex = 'text';
  final String _tagCatatan = 'catatan';
  final String _tagSubkategori = 'subkategori';
  DbUtility _dbUtility;

  DaoKategori _daoKategori;
  int _selisih;
  int _realId;

  SettingApp() {
    _realId = DateTime.now().millisecondsSinceEpoch;
    _selisih = 60000; // agar selisih waktu realid menjadi 1 menit
    _daoSetup = new DaoSetup();
    _daoKategori = new DaoKategori();
    _dbUtility = new DbUtility();
  }

  Future<bool> prepareFirstTimeInstall() async {
    bool isFirstimeInstall = await this._isFirstTimeInstall();
    if (isFirstimeInstall) {
      await this._insertInitialKategori();
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

  String _getMainColor(int idx) {
    if (idx < _colorsmain.length) {
      return _colorsmain[idx];
    } else {
      int m = idx % _colorsmain.length;
      return _colorsmain[m];
    }
  }

  String _getSubColor(int idx) {
    if (idx < _colorsSub.length) {
      return _colorsSub[idx];
    } else {
      int m = idx % _colorsSub.length;
      return _colorsSub[m];
    }
  }

  Future<bool> _insertSatuanKategori(EnumJenisTransaksi enumJenisTransaksi,
      Map<String, dynamic> map, int idx, int rid, int idparent) async {
    String text = map[_tagTex];
    String catatan = map[_tagCatatan];

    String color;
    if (idparent == 0) {
      color = this._getMainColor(idx);
    } else {
      color = this._getSubColor(idx);
    }
    Kategori k = new Kategori(
        rid, text, idparent, enumJenisTransaksi, catatan, color);
    await _daoKategori.saveKategori(k);
    return true;
  }

  Future<bool> _insertKategori(
      EnumJenisTransaksi enumJenisTransaksi, Map<String, dynamic> map) async {
    int idx1 = 0;
    map.forEach((key, value) async {
      _realId = _realId + _selisih;
      await this
          ._insertSatuanKategori(enumJenisTransaksi, value, idx1, _realId, 0);

      Map<String, dynamic> mapSubKategori = value[_tagSubkategori];
      int idx2 = 0;
      int realidsub = _realId;
      mapSubKategori.forEach((key, value) async {
        realidsub = realidsub + _selisih;
        await this._insertSatuanKategori(
            enumJenisTransaksi, value, idx2, realidsub, _realId);
        idx2++;
      });
      _realId = realidsub + _selisih;
      idx1++;
    });
    return true;
  }

  Future<bool> _insertInitialKategori() async {
    String datajson = datajsonkategori;
    Map<String, dynamic> mapKategori = jsonDecode(datajson);

    /// map 0 : pengeluaran, 1: pemasukan, 2: abadi
    Map<String, dynamic> mapPengeluaran = mapKategori['0'];
    Map<String, dynamic> mapPemasukan = mapKategori['1'];
    Map<String, dynamic> mapAbadi = mapKategori['2'];

    /// insert kategori pengeluaran
    await this._insertKategori(EnumJenisTransaksi.pengeluaran, mapPengeluaran);

    /// insert kategori pemasukan
    await this._insertKategori(EnumJenisTransaksi.pemasukan, mapPemasukan);

    print('mapabadi: ${mapKategori['1'].toString()}');
    /// map kategori abadi
    Map<String, dynamic> mPengeluaranAbadi = mapAbadi['0'];
    Map<String, dynamic> mPemasukanAbadi = mapAbadi['1'];

    /// insert kategori abadi pengeluaran
    String text = mPengeluaranAbadi[_tagTex];
    String catatan = mPengeluaranAbadi[_tagCatatan];
    _realId = _realId + _selisih;
    Kategori k = new Kategori(
        _realId, text, 0, EnumJenisTransaksi.pengeluaran, catatan, 'ff0000');
    k.isAbadi = 1;
    await _daoKategori.saveKategori(k);

    /// insert kategori abadi pemasukan
    text = mPemasukanAbadi[_tagTex];
    catatan = mPemasukanAbadi[_tagCatatan];
    _realId = _realId + _selisih;
    Kategori k1 = new Kategori(
        _realId, text, 0, EnumJenisTransaksi.pemasukan, catatan, '008000');
    k1.isAbadi = 1;
    await _daoKategori.saveKategori(k1);
    return true;
  }
}

class TextKategori {
  String textKtg;
  String catatan;
  List<TextKategori> lAnak;

  TextKategori(this.textKtg, this.catatan);
}

final datajsonkategori ="{\"0\":{\"1\":{\"text\":\"Pulsa HP\",\"catatan\":\"\",\"subkategori\":{\"1\":{\"text\":\"Pulsa XL\",\"catatan\":\"\"},\"2\":{\"text\":\"Pulsa Telkomsel\",\"catatan\":\"\"},\"3\":{\"text\":\"Pulsa Indosat\",\"catatan\":\"\"}}},\"2\":{\"text\":\"Tempat Tinggal\",\"catatan\":\"Kategori yang berhubungan dengan keperluan tempat tinggal (kos, rumah, kontrakan)\",\"subkategori\":{\"1\":{\"text\":\"Pulsa Listrik\",\"catatan\":\"\"},\"2\":{\"text\":\"Cicilan Rumah\",\"catatan\":\"\"},\"3\":{\"text\":\"Kontrakan\",\"catatan\":\"Setiap melakukan pembayaran kontrak rumah, dapat di masukkan kedalam kategori ini.\"},\"4\":{\"text\":\"Perabotan\",\"catatan\":\"Seperti: meja, kursi, kran, kabel, kasur,bantal, dll.\"},\"5\":{\"text\":\"Service Rumah\",\"catatan\":\"Setiap melakukan service di setiap bagian rumah.\"},\"6\":{\"text\":\"Tagihan PDAM\",\"catatan\":\"Pembayaran rutin PDAM\"}}},\"3\":{\"text\":\"Rumah Tangga\",\"catatan\":\"Keperluan rumah tangga seperti diterjen, alat pel, sapu, dll\",\"subkategori\":{\"1\":{\"text\":\"Dapur\",\"catatan\":\"Seperti Bumbu masak, sayur, beras, minyak goreng ,dll\"},\"2\":{\"text\":\"Iuran\",\"catatan\":\"Seperti iuran sampah, RT\/RW, dll\"}}},\"4\":{\"text\":\"Hobi & Hiburan\",\"catatan\":\"Seperti wisata, jalan-jalan, makan di resto, renang dll\",\"subkategori\":{\"1\":{\"text\":\"Liburan\",\"catatan\":\"Seperti pergi ke tempat wisata\"},\"2\":{\"text\":\"Futsal\",\"catatan\":\"Sepatu futsal, biaya futsal dll\"},\"3\":{\"text\":\"Membaca\",\"catatan\":\"Keperluan yang berhubungan dengan hobi membaca\"}}},\"5\":{\"text\":\"Sekolah\",\"catatan\":\"Pengeluaran yang berhubungan dengan keperluan sekolah\",\"subkategori\":{\"1\":{\"text\":\"SPP\",\"catatan\":\"\"},\"2\":{\"text\":\"Kursus\",\"catatan\":\"Seperti kursus bahasa inggris, kursus matematika, dll\"},\"3\":{\"text\":\"Buku Sekolah\",\"catatan\":\"\"}}},\"6\":{\"text\":\"Kesehatan\",\"catatan\":\"Segala pengeluaran yang berhubungan dengan kesehatan.\",\"subkategori\":{\"1\":{\"text\":\"BPJS\",\"catatan\":\"\"}}},\"7\":{\"text\":\"Kecantikan\",\"catatan\":\"Yang berhubungan dengan perawatan kecantikan\",\"subkategori\":{\"1\":{\"text\":\"Aksesoris\",\"catatan\":\"Seperti kalung, pita dll\"},\"2\":{\"text\":\"Makeup\",\"catatan\":\"\"}}},\"8\":{\"text\":\"Hadiah\",\"catatan\":\"Seperti  kado, hadiah, dll\",\"subkategori\":{}},\"9\":{\"text\":\"Transport\",\"catatan\":\"Berhubungan dengan transportasi\",\"subkategori\":{\"1\":{\"text\":\"Motor\",\"catatan\":\"Pengeluaran untuk motor seperti service dll\"},\"2\":{\"text\":\"Mobil\",\"catatan\":\"Pengeluaran untuk mobil seperti service dll\"}}},\"10\":{\"text\":\"Makan\",\"catatan\":\"Bagi pekerja biasanya ada pengeluaran makan di luar rumah\",\"subkategori\":{\"1\":{\"text\":\"Sarapan\",\"catatan\":\"\"},\"2\":{\"text\":\"Makan Siang\",\"catatan\":\"\"},\"3\":{\"text\":\"Makan Malam\",\"catatan\":\"\"}}},\"11\":{\"text\":\"Utilitas\",\"catatan\":\"Seperti alat potong rumput, palu, dll\",\"subkategori\":{}},\"12\":{\"text\":\"Pribadi\",\"catatan\":\"Keperluan pribadi\",\"subkategori\":{}}},\"1\":{\"1\":{\"text\":\"Karyawan\",\"catatan\":\"Gaji, Bonus, Tunjangan dll.\",\"subkategori\":{}},\"2\":{\"text\":\"Bisnis\",\"catatan\":\"Segala pendapatan dari bisnis\",\"subkategori\":{}}},\"2\":{\"0\":{\"text\":\"Lain-Lain\",\"catatan\":\"Pengeluaran yang belum di kategorikan\",\"subkategori\":{}},\"1\":{\"text\":\"Lain - Lain\",\"catatan\":\"Pemasukan yang belum di kategorikan\",\"subkategori\":{}}}}";
