import 'dart:math';

import 'package:keuangan/database/db_utility.dart';
import 'package:keuangan/database/keuangan/dao_itemname.dart';
import 'package:keuangan/database/keuangan/dao_keuangan.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/datepicker/calenderutil/calender_util.dart';

class GenerateDymmyDataTest {
  CalenderUtil _calenderUtil = new CalenderUtil();
  Random _random = new Random();
  DaoItemName daoItemName = new DaoItemName();
  DaoKeuangan daoKeuangan = new DaoKeuangan();
  DaoKategori daoKategori = new DaoKategori();

  Future<bool> generateKeuangan() async {
    await daoKeuangan.deleteAllKeuangan();
    await daoItemName.deleteAllItemName();

    bool insertedPengeluaran = await this._insertItemCepatPengeluaran();
    bool insertedPemasukan = await this._insertItemCepatPemasukan();
    if (insertedPengeluaran && insertedPemasukan) {
      UiItemNamesLazy uiItemNamesLazy = await daoItemName.getAllItemNameVisibleLazy();

      List<ItemName> litmPengeluaran = uiItemNamesLazy.listPengeluaran;
      List<ItemName> litmPemasukan = uiItemNamesLazy.listPemasukan;

      print('jmlitempengeluaran: ${litmPengeluaran.length}');
      print('jmlitempemasukan: ${litmPemasukan.length}');

      List<Keuangan> lk = await daoKeuangan.get5LastKeuanganLazy();

      /// jika data keuangan masih kosong makap input data dummy
      if (lk.isEmpty) {
        await this._generatePerYear(2015, litmPengeluaran, litmPemasukan);
        await this._generatePerYear(2016, litmPengeluaran, litmPemasukan);
        await this._generatePerYear(2017, litmPengeluaran, litmPemasukan);
        await this._generatePerYear(2018, litmPengeluaran, litmPemasukan);
        await this._generatePerYear(2019, litmPengeluaran, litmPemasukan);
        await this._generatePerYear(2020, litmPengeluaran, litmPemasukan);
        return true;
      }
      return false;
    }

    return false;
  }

  Future<bool> _generatePerYear(int year, List<ItemName> litmPengeluaran,
      List<ItemName> litmPemasukan) async {
    for (int i = 1; i <= 12; i++) {
      await this._generatePerMonth(year, i, litmPengeluaran, litmPemasukan);
    }
    return true;
  }

  Future<bool> _generatePerMonth(int year, int month,
      List<ItemName> litmPengeluaran, List<ItemName> litmPemasukan) async {
    int maxHari = _calenderUtil.jumlahHariPerBulan(year, month);


    for (int i = 1; i <= maxHari; i++) {
      int jmlTrx = this.next(2, 5);
      DateTime dt = new DateTime(year, month, i, 1);
      int realId = dt.millisecondsSinceEpoch;
      for (int j = 0; j < jmlTrx; j++) {
        int idxitemname = this.next(0, litmPengeluaran.length - 1);
        ItemName itm = litmPengeluaran[idxitemname];

        int jml = this.next(10000, 50000);
        int m = jml % 1000;
        jml = jml - m;

        realId = realId + 60000;
        Keuangan k =
            new Keuangan.fromUI(dt, itm.realId, jml.toDouble(), 'catatan');
        k.setRealId(realId);
        await daoKeuangan.saveKeuanganForTesting(k);
      }
    }

    int jmlTrx = this.next(1, 2);
    int min;
    int max;
    if(jmlTrx==2){
      min = 5000000;
      max = 8000000;
    }else{
      min = 10000000;
      max = 15000000;
    }
    DateTime dt = new DateTime(year, month, 2, 12);
    int realId = dt.millisecondsSinceEpoch;
    for (int j = 0; j < jmlTrx; j++) {
      int idxitemname = this.next(0, litmPemasukan.length - 1);
      ItemName itm = litmPemasukan[idxitemname];

      int jml = this.next(min, max);
      int m = jml % 1000000;
      jml = jml - m;
      realId = realId + 60000;
      Keuangan k =
          new Keuangan.fromUI(dt, itm.realId, jml.toDouble(), 'catatan');
      k.setRealId(realId);
      await daoKeuangan.saveKeuanganForTesting(k);
    }

    return true;
  }

  Future<bool> _insertItemCepatPengeluaran() async {
    List<Kategori> lk = await daoKategori
        .getAllKategoriTermasukAbadi(EnumJenisTransaksi.pengeluaran);
    int realId = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < lk.length; i++) {
      realId = realId + 60000;
      ItemName itemName = new ItemName.fromUI( 'Itempg$i', lk[i].realId, 0);
      itemName.setKategori(lk[i]);
      itemName.setRealId(realId);
      await daoItemName.saveItemNameForMassInsert(itemName);
    }
    return true;
  }

  Future<bool> _insertItemCepatPemasukan() async {
    List<Kategori> lk = await daoKategori
        .getAllKategoriTermasukAbadi(EnumJenisTransaksi.pemasukan);
    int realId = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < lk.length; i++) {
      realId = realId + 60000;

      ItemName itemName = new ItemName.fromUI('Itemp$i', lk[i].realId, 0);
      itemName.setKategori(lk[i]);
      itemName.setRealId(realId);

      ResultDb resultDb = await daoItemName.saveItemNameForMassInsert(itemName);
      if(resultDb.enumResultDb == EnumResultDb.success){}

    }
    return true;
  }

  int next(int min, int max) => min + _random.nextInt(max - min);
}
