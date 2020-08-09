class DbUtility {
  int generateId() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  int generateDateToMiliseconds() {
    return DateTime.now().millisecondsSinceEpoch;
  }



}

class ResultDb {
  EnumResultDb enumResultDb;
  int value;

  ResultDb(this.value);
}

enum EnumResultDb {
  success,
  failed,
  duplicate,
}
