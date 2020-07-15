enum StateAddCategory { editSubkategori, baru,edit, baruSubkategori }

enum Operator {
  addition,
  subtraction,
  multiplication,
  division,
  kosong,
}

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

enum EnumStateFromBloc{
  progress,
  finish,
  error
}

enum EnumPopupAction{
  simpan,
  update
}