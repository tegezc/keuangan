class CalenderUtil {
  ///Jika angka tahun itu habis dibagi 400, maka tahun itu sudah pasti tahun kabisat.
  ///Jika angka tahun itu tidak habis dibagi 400 tetapi habis dibagi 100, maka tahun itu sudah pasti bukan merupakan tahun kabisat.
  ///Jika angka tahun itu tidak habis dibagi 400, tidak habis dibagi 100 akan tetapi habis dibagi 4, maka tahun itu merupakan tahun kabisat.
  ///Jika angka tahun tidak habis dibagi 400, tidak habis dibagi 100, dan tidak habis dibagi 4, maka tahun tersebut bukan merupakan tahun kabisat.
  bool isTahunKabisat(int year) {
    if (year % 400 == 0) {
      return true;
    } else if (year % 100 == 0) {
      return false;
    } else if (year % 4 == 0) {
      return true;
    } else {
      return false;
    }
  }

  int jumlahHariPerBulan(int year, int bulan) {
    int bln = bulan - 1;

    List<int> jmlHari = listOfJumlahHariBulan(year);
    return jmlHari[bln];
  }

  List<int> listOfJumlahHariBulan(int year) {
    List<int> jmlHariPerbulan = new List(12);
    jmlHariPerbulan[0] = 31; //Jan
    jmlHariPerbulan[1] = 28; //Feb
    jmlHariPerbulan[2] = 31; //Mar
    jmlHariPerbulan[3] = 30; //Apr
    jmlHariPerbulan[4] = 31; //Mei
    jmlHariPerbulan[5] = 30; //Jun
    jmlHariPerbulan[6] = 31; //Jul
    jmlHariPerbulan[7] = 31; //Agu
    jmlHariPerbulan[8] = 30; //Sept
    jmlHariPerbulan[9] = 31; //Okt
    jmlHariPerbulan[10] = 30; //Nov
    jmlHariPerbulan[11] = 31; //Des

    if (isTahunKabisat(year)) {
      jmlHariPerbulan[1] = 29; //Feb
    }
    return jmlHariPerbulan;
  }
}
