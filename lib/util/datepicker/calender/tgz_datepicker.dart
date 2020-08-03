import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keuangan/util/datepicker/calenderutil/setting_text_color.dart';
import 'package:keuangan/util/global_data.dart';
import 'calendar_controller.dart';
import 'calendar_view.dart';

class TgzDatePicker extends StatefulWidget {
  final int startYear;
  final int endYear;

  TgzDatePicker(
      this.startYear,
      this.endYear, {
        Key key,
      }) : super(key: key);

  @override
  TgzDatePickerState createState() => TgzDatePickerState();
}

class TgzDatePickerState extends State<TgzDatePicker> {
  CalendarController _calendarController;
  ScrollController _controller;

  final _namaBulan = GlobalData.namaBulan;

  int _indexNow;

  /// 300 berasal dari
  /// 20 : padding atas
  /// 40 tinggi header bulan tahun (september 2020)
  /// 40 x 6 : 40 tinggi cell, dan 6 jumlah baris

  double _itemExtends = 286.0;
  @override
  void initState() {
    _calendarController =
    new CalendarController(widget.startYear, widget.endYear);
    DateTime dt = new DateTime.now();
    _indexNow = _calendarController.tahunFromDate(dt.year, dt.month) - 1;
    print('index: $_indexNow');
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
      Navigator.pop(context, dt);

  }

  String getTextDate(DateTime dateTime) {
    return '${dateTime.day} - ${_namaBulan[dateTime.month]} ${dateTime.year}';
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
              _buildTitle(cellDimen),
              Container(
                height: mediaQueryData.size.height - 150,
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