import 'package:flutter/material.dart';
import 'package:keuangan/util/datepicker/calenderutil/calender_util.dart';
import 'package:keuangan/util/datepicker/calenderutil/setting_text_color.dart';
import 'package:keuangan/util/datepicker/model/calender_model.dart';
import 'package:keuangan/util/datepicker/model/enum_calendar.dart';
import 'package:keuangan/util/global_data.dart';

class CalendarView extends StatefulWidget {
  final DateTime date;
  final double width;
  final Function calbackCellClick;

  CalendarView({
    this.date,
    this.width,
    this.calbackCellClick,
  });

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final namaHari = GlobalData.nhari;

  _handleCellPress(DateTime dateTime, BuildContext context) async {
    print('cell di click');
    widget.calbackCellClick(dateTime);
  }

  _buildCalendarView(double widhtCell) {
    List<Widget> lOffRow = new List<Widget>();
    //Setup isi Calendar
    CalenderUtil calenderUtil = new CalenderUtil();
    DateTime dateTime = this.widget.date;
    int weekday = dateTime.weekday;
    int year = dateTime.year;
    int bulan = dateTime.month;
    int maxbulan = calenderUtil.jumlahHariPerBulan(year, bulan);
    String strBln = '$year-$bulan';

    CalendarPage calendarPage = new CalendarPage(
        strBulan: strBln,
        maxmonth: maxbulan,
        month: bulan,
        weekday: weekday,
        year: year);
    List<List<CellCalendar>> loCell = this.arrayTanggal(
      //   calendarPage.prevmax,
        calendarPage.weekday,
        calendarPage.maxmonth,
        calendarPage.year,
        calendarPage.month);

    for (int i = 0; i < loCell.length; i++) {
      List<Widget> lWidget = new List();

      for (int k = 0; k < loCell[i].length; k++) {
        CellCalendar cc = loCell[i][k];
        Widget cellWidget = _cellCalender(widhtCell,cc);

        lWidget.add(cellWidget);
      }

      Widget rowWidget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: lWidget);
      lOffRow.add(rowWidget);
    }

    return lOffRow;
  }

  Widget _cellCalender(double widthCell,CellCalendar cc){
    Color fontColor;
    if (cc.state == CellState.jumat) {
      fontColor = SettingTextColor.colorFontJumat;
    } else if (cc.state == CellState.normal) {
      fontColor = SettingTextColor.colorFontHariNormal;
    } else if (cc.state == CellState.libur) {
      fontColor = SettingTextColor.colorFontLibur;
    }
    return  Container(
      decoration: cc.isCurrentDate
          ? BoxDecoration(
          border: Border.all(
              color: SettingTextColor.colorKotakCurrentDate, width: 2))
          : null,
      width: widthCell,
      height: 40,
      child: cc.state != CellState.out
          ? FlatButton(
        padding: const EdgeInsets.all(0),
        child: new Text(
          '${cc.dateTime.day}',
          maxLines: 1,
          textAlign: TextAlign.center,
          style: new TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
            color: fontColor,
          ),
        ),
        onPressed: () {
          _handleCellPress(cc.dateTime, context);
        },
      )
          : new Container(
        height: 40,
      ),
    );
  }

  CellState stateActiveDay(
      int year, int mont, int day) {
    CellState state = CellState.normal;
    DateTime dt = new DateTime(year, mont, day);

    if (dt.weekday == 7) {
      state = CellState.libur;
    } else if (dt.weekday == 5) {
      state = CellState.jumat;
    }


    return state;
  }

  List<List<CellCalendar>> arrayTanggal(
      int weekday,
      int maxDay,
      int year,
      int month) {
    List<List<CellCalendar>> listOd2D = new List();
    List<CellCalendar> l1d = new List();
    int tmpIndex = 0;

    var namaBulan = GlobalData.namaBulan;

    for (int i = 0; i < weekday; i++) {
      CellCalendar cellC = new CellCalendar();
      cellC.state = CellState.out;
      cellC.isCurrentDate = false;
      l1d.add(cellC);
      tmpIndex++;
    }
    // }

    //loop 2 initialitation cell => active calendar
    DateTime currentDate = new DateTime.now();
    for (int i = 1; i <= maxDay; i++) {
      CellCalendar cellC = new CellCalendar();
      cellC.isCurrentDate = false;
      DateTime dt = new DateTime(year, month, i);
      if (year == currentDate.year &&
          month == currentDate.month &&
          i == currentDate.day) {
        cellC.isCurrentDate = true;
      }
      cellC.dateTime = dt;
      cellC.strTanggal = '$i - ${namaBulan[month]} - $year';
      cellC.state = stateActiveDay(year, month, i);
      cellC.index = tmpIndex;
      cellC.isHavetodolist = false;
      l1d.add(cellC);
      tmpIndex++;
    }

    //end loop2

    //loop 3 => grey akhir
    int tmpLoop3;
    if (weekday == 7) {
      tmpLoop3 = ((42 - maxDay) - (weekday - 1)) + 7;
    } else {
      tmpLoop3 = (42 - maxDay) - (weekday - 1);
    }

    for (int i = 1; i <= tmpLoop3; i++) {
      CellCalendar cellC = new CellCalendar();
      cellC.state = CellState.out;
      cellC.isCurrentDate = false;
      l1d.add(cellC);
      tmpIndex++;
    }

    listOd2D = [
      [l1d[0], l1d[1], l1d[2], l1d[3], l1d[4], l1d[5], l1d[6]],
      [l1d[7], l1d[8], l1d[9], l1d[10], l1d[11], l1d[12], l1d[13]],
      [l1d[14], l1d[15], l1d[16], l1d[17], l1d[18], l1d[19], l1d[20]],
      [l1d[21], l1d[22], l1d[23], l1d[24], l1d[25], l1d[26], l1d[27]],
      [l1d[28], l1d[29], l1d[30], l1d[31], l1d[32], l1d[33], l1d[34]],
      [l1d[35], l1d[36], l1d[37], l1d[38], l1d[39], l1d[40], l1d[41]],
    ];
    return listOd2D;
  }

  @override
  Widget build(BuildContext context) {
    double cellDimen = (widget.width - 20) / 7;
    return Padding(
      padding: const EdgeInsets.only(top: 5,right: 5,left: 5),
      child: Container(
        decoration:  BoxDecoration(
          border: Border.all(
              width: 0.5,
              color: SettingTextColor.calClrBorderCalendar,
              style: BorderStyle.solid),
        ),
        child: Column(
          children: _buildCalendarView(cellDimen),
        ),
      ),
    );
  }
}

class CellTitleView extends StatelessWidget {
  final String name;
  final double widthCell;

  CellTitleView({
    this.widthCell,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      height: 30,
      width: widthCell,
      child: new Text(
        name,
        textAlign: TextAlign.center,
        style: SettingTextColor.calStNmHr,
      ),
    );
  }
}
