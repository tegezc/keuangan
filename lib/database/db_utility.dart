class DbUtility{

}

class ResultDb{
  EnumResultDb enumResultDb;
  int value;
  ResultDb(this.value);
}

enum EnumResultDb{
  success,
  failed,
  duplicate,
}
