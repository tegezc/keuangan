import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keuangan/util/datepicker/calenderutil/setting_text_color.dart';
import 'package:keuangan/util/global_data.dart';
import 'calendar_controller.dart';
import 'calendar_view.dart';

class TgzRangeDatePicker extends StatefulWidget {
  final int startYear;
  final int endYear;

  TgzRangeDatePicker(
    this.startYear,
    this.endYear, {
    Key key,
  }) : super(key: key);

  @override
  TgzRangeDatePickerState createState() => TgzRangeDatePickerState();
}

class TgzRangeDatePickerState extends State<TgzRangeDatePicker> {
  CalendarController _calendarController;
  ScrollController _controller;

  final _namaBulan = GlobalData.namaBulan;

  int _indexNow;

  /// 300 berasal dari
  /// 20 : padding atas
  /// 40 tinggi header bulan tahun (september 2020)
  /// 40 x 6 : 40 tinggi cell, dan 6 jumlah baris

  double _itemExtends = 286.0;

  DateTime _tmpMulaiDate;
  DateTime _tmpSampaiDate;

  @override
  void initState() {
    _calendarController =
        new CalendarController(widget.startYear, widget.endYear);
    DateTime dt = new DateTime.now();
    _indexNow = _calendarController.tahunFromDate(dt.year, dt.month) - 1;

    _controller =
        ScrollController(initialScrollOffset: _itemExtends * _indexNow);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void handleCallbackCellCllick(DateTime dt) {
    if (_tmpMulaiDate == null) {
      _tmpMulaiDate = dt;
    } else if (_tmpMulaiDate.isAfter(dt)) {
      _tmpMulaiDate = dt;
    }
    if (_tmpMulaiDate.isBefore(dt)) {
      _tmpSampaiDate = dt;
      TgzDateRangeValue tgzDateRangeValue = new TgzDateRangeValue(_tmpMulaiDate,_tmpSampaiDate);
      Navigator.pop(context, tgzDateRangeValue);
    } else {
      setState(() {});
    }
  }

  String getTextDate(DateTime dateTime) {
    return '${dateTime.day} - ${_namaBulan[dateTime.month]} ${dateTime.year}';
  }

  Widget _infoRangeTanggal(double width) {
    return Container(
      color: Colors.white,
      height: 70.0,
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text('Mulai Tanggal'),
                    SizedBox(
                      height: 12.0,
                    ),
                    _tmpMulaiDate == null
                        ? Text(
                            'Pilih Tanggal',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          )
                        : Text(
                            '${getTextDate(_tmpMulaiDate)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ],
                )),
            Center(
              child: Container(
                width: 30,
                height: 1,
                color: Colors.black,
              ),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text('Sampai Tanggal'),
                    SizedBox(
                      height: 12.0,
                    ),
                    _tmpSampaiDate == null
                        ? Text(
                            'Pilih Tanggal',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          )
                        : Text(
                            '${getTextDate(_tmpSampaiDate)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _headerKalendar(DateTime dt) {
    String title = '${_namaBulan[dt.month]} ${dt.year}';

    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 40,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 8),
        child: Text(
          title,
          style: SettingTextColor.calStTitleNmBulan,
        ),
      ),
    );
  }

  Widget _buildTitle(double widthCell) {
    List<Widget> lw = new List<Widget>();

    for (int i = 0; i < 7; i++) {
      lw.add(CellTitleView(
        name: GlobalData.nhari[i],
        widthCell: widthCell,
      ));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 5, right: 5, left: 8),
      child: Container(
        child: Row(
          children: lw,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    double cellDimen = (mediaQueryData.size.width - 20) / 7;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: SettingTextColor.colorHeaderApp,
          title: Text('Pilih Tanggal'),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.transparent,
          child: Column(
            children: <Widget>[
              _infoRangeTanggal(mediaQueryData.size.width),
              _buildTitle(cellDimen),
              Container(
                height: mediaQueryData.size.height - 235,
                child: ListView.builder(
                  itemCount: _calendarController.countItems,
                  controller: _controller,
                  itemExtent: _itemExtends,
                  itemBuilder: (BuildContext context, int index) {
                    DateTime dt = _calendarController.dateFromIndex(index);
                    return Container(
                      child: Column(
                        children: <Widget>[
                          _headerKalendar(dt),
                          CalendarView(
                            date: dt,
                            width: mediaQueryData.size.width,
                            calbackCellClick: handleCallbackCellCllick,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

class TgzDateRangeValue {
  DateTime dateStart;
  DateTime dateFinish;

  TgzDateRangeValue(this.dateStart,this.dateFinish);
  bool isValid(){
    if(dateStart != null && dateFinish != null){
      return true;
    }
    return false;
  }
}
