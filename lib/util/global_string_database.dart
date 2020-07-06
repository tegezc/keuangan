
class TbKategori {
  // id (auto_number), nama, id_parent,type
  final name = 'kategori';
  final fId = 'id';
  final fNama = 'nama';
  final fIdParent = 'id_parent';
  final fType = 'type'; // EnumJenisTransaksi
  final fCatatan = 'catatan';
  final fIsAbadi = 'isabadi';
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
   final fJenisTransaksi = 'jenis_transaksi';// 0 Pengeluaran, 1: Pemasukan
}

class TbItemName{
  //id (auto_number) , nama, id_kategori
   final name = 'item_name';
   final fId = 'id';
   final fNama = 'nama';
   final fIdKategori = 'id_kategori';
   final fDeleted = 'isdeleted'; //1 : sudah di delete, 0 : active

}

class TbSetup{
  //id (auto_number) , nama, id_kategori
  final name = 'setup';
  final fId = 'id';
  final fNama = 'nama';
  final fTglInput = 'tgl_input';
  final fIsSuccess = 'success';

}
