
class CalendarController {
  final int startYear;
  final int endYear;
  CalendarController(this.startYear,this.endYear);

  int get countItems{
    int count = endYear-startYear+1;
    return count*12;
  }

  //convert tahun bulan menjadi index di pageview
  int tahunFromDate(int year, int bulan) {
    return (year -startYear)*12 + bulan;
  }

  //dari index di convert ke tahun dan bulan
  DateTime dateFromIndex(int index) {
    int tahun = (index ~/ 12)+startYear;
    int bulan = (index % 12)+1;
    DateTime dateTime = new DateTime(tahun, bulan, 1);
    return dateTime;
  }



}