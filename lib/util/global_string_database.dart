class TbKategori {
  // id (auto_number), nama, id_parent,type
  final realId = 'real_id';
  final name = 'kategori';
  final fId = 'id';
  final fNama = 'nama';
  final fIdParent = 'id_parent';
  final fType = 'type'; // EnumJenisTransaksi
  final fCatatan = 'catatan';
  final fIsAbadi = 'isabadi';
  final fColor = 'color';
  final fLastupdate = 'lastupdate';
}

class TbKeuangan {
  //id (auto number) tanggal, jumlah, catatan,type,
  final realId = 'real_id';
  final name = 'keuangan';
  final fId = 'id';
  final fTgl = 'tanggal';
  final fIdItemName = 'id_itemname';
  final fJumlah = 'jumlah';
  final fCatatan = 'catatan';
  final fLastUpdate = 'last_update';
  final fJenisTransaksi = 'jenis_transaksi'; // 0 Pengeluaran, 1: Pemasukan
}

class TbItemName {
  //id (auto_number) , nama, id_kategori
  final realId = 'real_id';
  final name = 'item_name';
  final fId = 'id';
  final fNama = 'nama';
  final fIdKategori = 'id_kategori';
  final fDeleted = 'isdeleted'; //1 : sudah di delete, 0 : active
  final fLastupdate = 'lastupdate';
}

class TbSetup {
  //id (auto_number) , nama, id_kategori
  final name = 'setup';
  final fId = 'id';
  final fNama = 'nama';
  final fValue = 'value';
  final fTglInput = 'tgl_input';
}
