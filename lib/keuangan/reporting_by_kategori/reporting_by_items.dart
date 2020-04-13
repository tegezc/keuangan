import 'package:flutter/material.dart';
import 'package:keuangan/database/keuangan/dao_itemname.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/database/keuangan/dao_keuangan.dart';
import 'package:keuangan/keuangan/transaksi/model_keuangan_ui.dart';
import 'package:keuangan/keuangan/reporting_by_kategori/component_reporting.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/datepicker_singlescrollview.dart';
import 'package:keuangan/util/loading_view.dart';
import 'package:keuangan/util/process_string.dart';

class ReportByItems extends StatefulWidget {
  final Kategori katkegoridetail;
  final int ecIndex;
  final List<EntryCombobox> listCombobox;

  ReportByItems(this.katkegoridetail, this.ecIndex,this.listCombobox);

  @override
  _ReportByItemsState createState() =>
      _ReportByItemsState();
}

class _ReportByItemsState extends State<ReportByItems> {
  List<Keuangan> _listKeuangan;
  List<ModelItemKategoriReport> _listEntrySort;

  List<DropdownMenuItem<int>> _dropDownEntry;

  //EntryCombobox _currentEntryCombo;
  List<EntryCombobox> _listCombobox;
  int _currentIndexCombo;

  Map<int, ItemName> _itemNameMap;
  Map<int, Kategori> _kategoriMap;

  ProcessString _processString;
  DateTime _valueTanggalFrom;
  DateTime _valueTanggalTo;

  final int _startDate = 1990;
  final int _endDate = 2050;

  @override
  void initState() {

    _valueTanggalFrom = new DateTime.now();
    _valueTanggalTo = new DateTime.now();
    _processString = new ProcessString();

    _populateKeuangan();

    super.initState();
  }

  _populateKeuangan() {
    _initialCombobox();
    EntryCombobox entryCombobox = _listCombobox[_currentIndexCombo];
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    DaoKategori daoKategori = new DaoKategori();
    DaoItemName daoItemName = new DaoItemName();
    daoKeuangan
        .getKeuanganByPeriode(entryCombobox.startDate, entryCombobox.endDate)
        .then((List<Keuangan> list) {
      _listKeuangan = new List();
      _listKeuangan.addAll(list);

      daoKategori.getAllKategoriMap().then((Map<int, Kategori> kMap) {
        _kategoriMap = new Map();
        _kategoriMap.addAll(kMap);
        daoItemName.getAllItemNameMap().then((Map<int, ItemName> inMap) {
          _itemNameMap = new Map();
          _itemNameMap.addAll(inMap);
          // _hitungTotalPerkategori();
          _filterDetailKategori();
          setState(() {});
        });
      });
    });
  }

  _getDataKeuanganByPeriode(DateTime startDate, DateTime endDate) {
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    daoKeuangan
        .getKeuanganByPeriode(startDate, endDate)
        .then((List<Keuangan> list) {
      _listKeuangan.clear();
      _listKeuangan.addAll(list);
      _filterDetailKategori();
      setState(() {});
    });
  }

  _filterDetailKategori() {
    _hitungTotalSpecifickategori();
  }

  _hitungTotalSpecifickategori() {
    Map<int, List<Keuangan>> mapK = new Map();
    for (int i = 0; i < _listKeuangan.length; i++) {
      Keuangan keuangan = _listKeuangan[i];
      ItemName itemName = _itemNameMap[keuangan.idItemName];
      Kategori kategori = _kategoriMap[itemName.idKategori];
      int idkategori = kategori.id;


      if (idkategori == widget.katkegoridetail.id || kategori.idParent == widget.katkegoridetail.id) {

        if (mapK[itemName.id] == null) {
          List<Keuangan> lk = new List();
          lk.add(keuangan);
          mapK[itemName.id] = lk;
        } else {
          List<Keuangan> lk = mapK[itemName.id];
          lk.add(keuangan);
          mapK[kategori.id] = lk;
        }
      }
    }

    _listEntrySort = new List();
    int total = 0;
    mapK.forEach((key, value) {
      value.forEach((k) {
        total = total + k.jumlah.toInt();
      });
    });

    mapK.forEach((key, value) {
      int jumlahUang = 0;
      value.forEach((k) {
        jumlahUang = jumlahUang + k.jumlah.toInt();
      });

      double percentation = (jumlahUang / total)*100;
      ItemName itemName = _itemNameMap[key];
      Kategori kt = _kategoriMap[key];
      String text = '${itemName.nama} (${percentation.toStringAsFixed(2)} %)';
      var entrySort = new ModelItemKategoriReport(
          values: itemName, color: '#${kt.color}', jumlahUang: jumlahUang, text: text);
      _listEntrySort.add(entrySort);
    });
  }

  _getTotal(List<ModelItemKategoriReport> list) {
    int tmpTotal = 0;
    list.forEach((val) {
      tmpTotal = tmpTotal + val.jumlahUang;
    });
    return tmpTotal;
  }

  _initialCombobox() {
    _listCombobox = new List();
    _listCombobox.addAll(widget.listCombobox);
    _currentIndexCombo = widget.ecIndex;

    _reloadComboBox();
  }

  _reloadComboBox() {
    _dropDownEntry = _getDropDownEntry();
  }

  List<DropdownMenuItem<int>> _getDropDownEntry() {
    List<DropdownMenuItem<int>> items = new List();
    for (int i =0;i < _listCombobox.length;i++) {
      items.add(new DropdownMenuItem(
        value: i,
        child: new Text(_listCombobox[i].text),
      ));
    }
    return items;
  }

  void _changedDropDownEntry(int selectedECombo) {
    EntryCombobox entryCombobox = _listCombobox[selectedECombo];
    if (entryCombobox.startDate == null) {
      _selectDateFrom();
    } else {
      _getDataKeuanganByPeriode(
          entryCombobox.startDate, entryCombobox.endDate);
      setState(() {
        _currentIndexCombo = selectedECombo;
      });
    }
  }

  Widget _widgetComboBoxTanggal(double width) {
    return Container(
      width: width,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: new DropdownButton(
          value: _currentIndexCombo,
          items: _dropDownEntry,
          onChanged: _changedDropDownEntry,
        ),
      ),
    );
  }

  Future _selectDateFrom() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(_startDate),
        lastDate: new DateTime(_endDate),
        builder: (context, child) {
          return CustomeDatePicker(child);
        });
    if (picked != null) {
      _valueTanggalFrom = picked;
      _selectDateTo();
    }
  }

  Future _selectDateTo() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(_startDate),
        lastDate: new DateTime(_endDate),
        builder: (context, child) {
      return CustomeDatePicker(child);
    });
    if (picked != null) {
      _valueTanggalTo = picked;
      String strStartDate =
      _processString.dateToStringDdMmmmYyyy(_valueTanggalFrom);
      String strEndDate =
      _processString.dateToStringDdMmmmYyyy(_valueTanggalTo);
      _listCombobox.insert(
          1,
          EntryCombobox('$strStartDate - $strEndDate', _valueTanggalFrom,
              _valueTanggalTo));
      _getDataKeuanganByPeriode(_valueTanggalFrom, _valueTanggalTo);
      _reloadComboBox();
      setState(() {
        _currentIndexCombo = 1;
      });
    }
  }


  funcBtnClick(Kategori kategori, int ecIndex) {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReportByItems(kategori,_currentIndexCombo,_listCombobox)));
  }
  Widget _bodyReporting(Size dimention) {
    ModelCategoryReport modelCategoryReport = new ModelCategoryReport(
      dimention: dimention,
      itemCategories: _listEntrySort,
      listCombobox: _listCombobox,
      ecindex: _currentIndexCombo,
      total: this._getTotal(_listEntrySort),
      funcBtnClick: funcBtnClick,
    );
    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _widgetComboBoxTanggal(dimention.width),
            BodyStatistic(modelCategoryReport),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    if (_listKeuangan == null) {
      return Scaffold(
        appBar: new AppBar(
          title: new Text('Per Item'),
        ),
        body: LoadingView(),
      );
    } else {
      return Scaffold(
        appBar: new AppBar(
          title: new Text('Per Item'),
        ),
        body: _bodyReporting(mediaQueryData.size),
      );
    }
  }
}
