import 'package:keuangan/util/global_data.dart';

class ProcessString {
/*
* ex: 2019-03
* */
  String dateToStringYyyyMm(DateTime dt) {
    String strMonth = dt.month > 9 ? '${dt.month}' : '0${dt.month}';
    return '${dt.year}-$strMonth';
  }

  /*
  * ex: 21-03-2019
  * */
  String dateToStringDdMmYyyy(DateTime dateTime) {
    String tanggal =
        '${dateTime.day < 10 ? '0' : ''}${dateTime.day}-${dateTime.month < 10 ? '0' : ''}${dateTime.month}-${dateTime.year}';
    return tanggal;
  }

  /*
  * ex: 23 Maret 2019
  * */
  String dateToStringDdMmmmYyyy(DateTime dateTime) {
    String tanggal =
        '${dateTime.day < 10 ? '0' : ''}${dateTime.day} ${GlobalData.namaBulan[dateTime.month]} ${dateTime.year}';
    return tanggal;
  }

  /*
  * ex: 23 Maret 2019
  * */
  String dateToStringMmmmYyyy(DateTime dateTime) {
    String tanggal =
        '${GlobalData.namaBulan[dateTime.month]} ${dateTime.year}';
    return tanggal;
  }

  /*
  * ex: 2019-03-14
  * */
  String dateFormatForDB(DateTime dateTime) {
    String tanggal =
        '${dateTime.year}-${dateTime.month < 10 ? '0' : ''}${dateTime.month}-${dateTime.day < 10 ? '0' : ''}${dateTime.day}';
    return tanggal;
  }

  /*
  * ex:  2019-04
  * */
  String dateToStringMmyyyy(DateTime dateTime) {
    String tanggal =
        '${dateTime.year}-${dateTime.month < 10 ? '0' : ''}${dateTime.month}';
    return tanggal;
  }


  DateTime dateFromDbToDateTime(String tanggal) {
    var tmp = tanggal.split('-');
    if (tmp.length == 3) {
      try {
        int year = int.parse(tmp[0]);
        int month = int.parse(tmp[1]);
        int day = int.parse(tmp[2]);

        return DateTime(year, month, day);
      } catch (e) {
        //jika format salah, maka di set sekarang. ini dilakukan jika format salah
        // tidak menyebabkan aplikasi force close, namun mengakibatkan anomali data

        return DateTime.now();
      }
    } else {
      //jika format salah, maka di set sekarang. ini dilakukan jika format salah
      // tidak menyebabkan aplikasi force close, namun mengakibatkan anomali data

      return DateTime.now();
    }
  }

//  String removeEnter(String text){
//   String tmpText='';
//    if (text.length == 1) {
//      tmpText = '';
//    } else {
//      for(int i = 0;i<text.length;i++){
//        if(text.codeUnitAt(i)!=10){
//          tmpText = tmpText+text[i];
//        }
//      }
//    }
//  }
}
