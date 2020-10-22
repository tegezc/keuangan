import 'package:keuangan/database/keuangan/dao_keuangan.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:rxdart/subjects.dart';

class BlocExportCsv{
  ItemExportCsv _cacheItemExportCsv;

  final BehaviorSubject<ItemExportCsv> _itemExportcsv = BehaviorSubject();

  BlocExportCsv() ;

  Stream<ItemExportCsv> get itemExportcsvStream => _itemExportcsv.stream;

  void setupFitstime()async{

    DaoKeuangan daoKeuangan = new DaoKeuangan();
    DateTime max = await daoKeuangan.getMaxDate();
    DateTime min = await daoKeuangan.getMinDate();
    _cacheItemExportCsv = new ItemExportCsv(DateTime.now(),DateTime.now(),null);
    _cacheItemExportCsv.startYears = min.year;
    _cacheItemExportCsv.endYears = max.year;
    this._sinkItem(_cacheItemExportCsv);
  }

  void setDate(bool isawal,DateTime dateTime){
    isawal?
        _cacheItemExportCsv.awal = dateTime:
        _cacheItemExportCsv.akhir = dateTime;
    this._sinkItem(_cacheItemExportCsv);
  }

  void _sinkItem(ItemExportCsv itemExportCsv){
    _itemExportcsv.sink.add(itemExportCsv);
  }

  void dispose(){
    _itemExportcsv.close();
  }
}

class ItemExportCsv{
  DateTime awal;
  DateTime akhir;
  EnumJenisTransaksi enumJenisTransaksi;
  int startYears;
  int endYears;

  ItemExportCsv(this.awal,this.akhir,this.enumJenisTransaksi);
}