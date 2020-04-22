enum StateAddCategory { editSubkategori, baru,edit, baruSubkategori }
enum EnumStatePopulateKategori {
  firsttime,
  savesuccess,
  editsuccess,
}

enum StateTransaksi {
  byDefault,
  byKategori,
  byItemName,
}

enum Operator {
  addition,
  subtraction,
  multiplication,
  division,
  kosong,
}

enum EnumStatePopulateItemName {
  firsttime,
  savesuccess,
  editsuccess,
  deleteSuccess,
}

enum StateItemNameEntry { edit, baru }

enum EnumEntryKeuangan {
  jenisKeuangan,
  typeItem,
  pickCategory,
  pickDate,
  dragAutoComplete,
  amount,
  dismissAutoComplete,
  clickAutoComplete,
  simpandanlagi,
  finishLagi,
}

enum EnumFinalResult{
  success,
  failed,
  inprogres,
}

enum EnumJenisTransaksi{
  pengeluaran,
  pemasukan
}