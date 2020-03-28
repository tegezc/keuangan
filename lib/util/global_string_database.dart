class TbEvent{
  //id (auto_number)	array_tanggal	string_event
   final name = 'event';
   final fId = 'id';
   final fArrayTanggal = 'array_tanggal';
   final fStringEvent = 'string_event';
}

class TbEventBulan{
  //=== table event_bulan
  //id(auto_number) key_event	tanggal
   final name = 'event_bulan';
   final fId = 'id';
   final fKeyEvent = 'key_event';
   final fTanggal = 'tanggal';
}

class TbSpecialDay{
  //=== table specific_day
//id(auto_number)	tanggal	array_tanggal	string_tanggal	status
  final tableSpecialDay = 'special_day';
  final sdId = 'id';
  final sdTanggal = 'tanggal';
  final sdArrayTanggal = 'array_tanggal';
  final sdStringTanggal = 'string_tanggal';
}

class TbTodolist {
  // id(auoto_number), tanggal
  final name = 'todolist';
  final fId = 'id';
  final fTanggal = 'tanggal';
}

class TbTodolistItem {
  // id(auoto_number), id_todolist, text,isChecked (1 = checked)
  final name = 'todolist_item';
  final fId = 'id';
  final fIdTodolist = 'id_todolist';
  final fText = 'text';
  final fIsChecked = 'checked';
  final fNoUrut = 'no_urut';///dimulai dari 0
}

class TbKategori {
  // id (auto_number), nama, id_parent,type
  final name = 'kategori';
  final fId = 'id';
  final fNama = 'nama';
  final fIdParent = 'id_parent';
  final fType = 'type'; // sama dengan type di keuangan
  final fCatatan = 'catatan';
  final fColor = 'color';
}

class TbKeuangan{
  //id (auto number) tanggal, jumlah, catatan,type,
   final name = 'keuangan';
   final fId = 'id';
   final fTgl = 'tanggal';
   final fIdItemName = 'id_itemname';
   final fJumlah = 'jumlah';
   final fCatatan = 'catatan';
}

class TbItemName{
  //id (auto_number) , nama, id_kategori
   final name = 'item_name';
   final fId = 'id';
   final fNama = 'nama';
   final fIdKategori = 'id_kategori';

}

class TbSetup{
  //id (auto_number) , nama, id_kategori
  final name = 'setup';
  final fId = 'id';
  final fNama = 'nama';
  final fTglInput = 'tgl_input';
  final fIsSuccess = 'success';

}
