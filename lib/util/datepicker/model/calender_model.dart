
import 'enum_calendar.dart';

class CalendarPage {
  int weekday;
  int maxmonth;
  int year;
  int month;
  String strBulan;

  CalendarPage({
    this.weekday,
    this.maxmonth,
    this.year,
    this.month,
    this.strBulan,
  });

  @override
  toString() {
    return '[$weekday,$maxmonth,$year,$month]';
  }
}

class CellCalendar {
  DateTime dateTime;
  String strTanggal;
  CellState state;
  int index;
  bool isHavetodolist;
  bool isCurrentDate;

  CellCalendar({
    this.dateTime,
    this.state,
    this.index,
    this.isHavetodolist,
    this.isCurrentDate,
  });
}
