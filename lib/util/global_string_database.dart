
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
   final fLastUpdate = 'last_update';
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
