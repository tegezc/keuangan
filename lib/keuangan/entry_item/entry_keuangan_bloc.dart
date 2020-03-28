import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:keuangan/database/keuangan/dao_itemname.dart';
import 'package:keuangan/database/keuangan/dao_keuangan.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:rxdart/subjects.dart';

class BlocEntryKeuangan {
  EntryKeuangan _cacheEntry;
  Map<int, ItemName> _cacheMapItemName;

  final BehaviorSubject<EntryKeuangan> _entryKeuangan = BehaviorSubject();
  final BehaviorSubject<StateEntryKeuangan> _stateEntryKeuangan =
      BehaviorSubject();

  BlocEntryKeuangan() {
    _cacheEntry = new EntryKeuangan(
      keuangan: new Keuangan.fromUI(DateTime.now(), 0, 0, ''),
      mapKategori: Map(),
      mapItemName: Map(),
      jenisKeuangan: EnumJenisTransaksi.pengeluaran,
      itemName: new ItemName('', 0),
      stateEntryKeuangan: null,
      finalResult: EnumFinalResult.inprogres,
    );

    _cacheMapItemName = new Map();
    _stateEntryKeuangan.listen((entryState) {
      _cacheEntry.stateEntryKeuangan = entryState.stateEntry;
      switch (entryState.stateEntry) {
        case EnumEntryKeuangan.jenisKeuangan:
          {
            StateJenisKeuangan v = entryState;
            _cacheEntry.jenisKeuangan = v.jenisKeuangan;
          }
          break;
        case EnumEntryKeuangan.pickDate:
          {
            StatePickDate statePickDate = entryState;
            _cacheEntry.keuangan.setTanggal(statePickDate.dateTime);
          }
          break;
        case EnumEntryKeuangan.pickCategory:
          {
            StateCategori stateCategori = entryState;
            _cacheEntry.itemName.setKategori(stateCategori.kategori);
          }
          break;
        case EnumEntryKeuangan.typeItem:
          {
            StateTypingItem stateTypingItem = entryState;
            String text = stateTypingItem.text;
            _cacheEntry.mapItemName =
                this._filterForAutoComplete(text, _cacheMapItemName);
          }
          break;
        case EnumEntryKeuangan.amount:
          {
            StateAmount v = entryState;
            _cacheEntry.keuangan.setJumlah(v.amount.toDouble());
          }
          break;
        case EnumEntryKeuangan.dragAutoComplete:
          break;
        case EnumEntryKeuangan.dismissAutoComplete:
          break;

        case EnumEntryKeuangan.clickAutoComplete:
          {
            StateClickAutoComplte stateClickAutoComplte = entryState;
            ItemName itemName = stateClickAutoComplte.itemName;
            DaoKategori daoKategori = new DaoKategori();
            daoKategori
                .getKategoriById(itemName.idKategori)
                .then((Kategori ktgori) {
              if (ktgori != null) {
                _cacheEntry.itemName.setKategori(ktgori);
              }
            });
          }
          break;
        case EnumEntryKeuangan.simpandanlagi:
          {
            StateSimpanLagi stateSimpanLagi = entryState;
            _cacheEntry.itemName.setNama(stateSimpanLagi.textItemName);
            _cacheEntry.keuangan.setCatatan(stateSimpanLagi.textCatatan);
            this._simpanLagi(_cacheEntry);
          }
          break;
        case EnumEntryKeuangan.finishLagi:
          {
            this._reset();
          }
          break;
      }

      this._sinkEntryKeuangan(_cacheEntry);
    });
  }

  Stream<EntryKeuangan> get entryKeuanganStream => _entryKeuangan.stream;

  void sinkState(StateEntryKeuangan state) {
    _stateEntryKeuangan.sink.add(state);
  }

  void _sinkEntryKeuangan(EntryKeuangan entryKeuangan) {
    _entryKeuangan.sink.add(entryKeuangan);
  }

  void _simpanLagi(EntryKeuangan entryKeuangan) {
    DaoItemName daoItemName = new DaoItemName();
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    String strItemName = entryKeuangan.itemName.nama;

    daoItemName
        .getItemNameByNamaNIdKategori(
            strItemName, entryKeuangan.itemName.idKategori)
        .then((ItemName iName) {
      if (iName != null) {
        entryKeuangan.keuangan.setIdItemName(iName.id);
        daoKeuangan.saveKeuangan(entryKeuangan.keuangan).then((value) {
          StateFinishLagi stateFinishLagi = StateFinishLagi();
          this.sinkState(stateFinishLagi);
        });
      } else {
        ItemName itemName = entryKeuangan.itemName;
        daoItemName.saveItemName(itemName).then((v) {
          if (v>0) {
            entryKeuangan.keuangan.setIdItemName(v);
            daoKeuangan.saveKeuangan(entryKeuangan.keuangan).then((value) {
              StateFinishLagi stateFinishLagi = StateFinishLagi();
              this.sinkState(stateFinishLagi);
            });
          }
        });
      }
    });
  }

  Future<EnumFinalResult> simpan1(String nama,String catatan) async{
    _cacheEntry.itemName.setNama(nama);
    _cacheEntry.keuangan.setCatatan(catatan);

    EntryKeuangan entryKeuangan = _cacheEntry;

    DaoItemName daoItemName = new DaoItemName();
    DaoKeuangan daoKeuangan = new DaoKeuangan();
    String strItemName = entryKeuangan.itemName.nama;
    EnumFinalResult enumFinalResult ;

    ItemName itemName = await daoItemName.getItemNameByNamaNIdKategori(strItemName, entryKeuangan.itemName.idKategori);
    if(itemName !=null){
      entryKeuangan.keuangan.setIdItemName(itemName.id);
      int resDb = await daoKeuangan.saveKeuangan(entryKeuangan.keuangan);

      if(resDb>0){
        enumFinalResult = EnumFinalResult.success;
      }else{
        enumFinalResult = EnumFinalResult.failed;
      }
    }else{
      ItemName itemName =
      new ItemName(strItemName, entryKeuangan.itemName.idKategori);
      int resDb = await daoItemName.saveItemName(itemName);

      if(resDb>0){
        entryKeuangan.keuangan.setIdItemName(resDb);
        int resK = await daoKeuangan.saveKeuangan(entryKeuangan.keuangan);
        if(resK > 0){
          enumFinalResult = EnumFinalResult.success;
        }else{
          enumFinalResult = EnumFinalResult.failed;
        }
      }else{
        enumFinalResult = EnumFinalResult.failed;
      }

    }

    return enumFinalResult;
  }

  void _reset() {
    _cacheEntry.jenisKeuangan = EnumJenisTransaksi.pengeluaran;
    _cacheEntry.itemName = null;
    _cacheEntry.keuangan = null;
  }

  Map<int, ItemName> _filterForAutoComplete(
      String text, Map<int, ItemName> lItemName) {
    String textLowerCase = text.toLowerCase();
    Map<int, ItemName> mitn = new Map();

    lItemName.forEach((k, v) {
      String namaLowerCase = v.nama.toLowerCase();
      if (namaLowerCase.contains(textLowerCase)) {
        mitn[k] = v;
      }
    });
    return mitn;
  }

  Map<int, Kategori> _lkategoriToMap(List<Kategori> lk) {
    Map<int, Kategori> mk = new Map();
    lk.forEach((k) {
      mk[k.id] = k;
    });
    return mk;
  }

  Map<int, ItemName> _lItmNameToMap(List<ItemName> lin) {
    Map<int, ItemName> mi = new Map();
    lin.forEach((itn) {
      mi[itn.id] = itn;
    });
    return mi;
  }

  void firstTimeLoadData(bool isEditMode, Keuangan kngan) {
    if (_cacheEntry.mapKategori.isEmpty) {
      DaoKategori daoKategori = new DaoKategori();
      DaoItemName daoItemName = new DaoItemName();
      daoKategori.getAllKategori().then((kategories) {
        if (kategories != null) {
          _cacheEntry.mapKategori = _lkategoriToMap(kategories);
          _cacheEntry.itemName.setKategori(kategories[0]);
        }

        daoItemName.getAllItemName().then((itemNames) {
          if (itemNames != null) {
            _cacheMapItemName = this._lItmNameToMap(itemNames);
          }

          if (isEditMode && kngan != null) {
            _cacheEntry.keuangan = kngan;
            _cacheEntry.itemName = _cacheMapItemName[kngan.idItemName];
            _cacheEntry.itemName.setKategori(
                _cacheEntry.mapKategori[_cacheEntry.itemName.idKategori]);
          }
          this._sinkEntryKeuangan(_cacheEntry);
        });
      });
    }
  }

  void dispose() {
    _entryKeuangan.close();
    _stateEntryKeuangan.close();
  }
}

class EntryKeuangan {
  Map<int, Kategori> mapKategori;
  Map<int, ItemName> mapItemName;
  EnumJenisTransaksi jenisKeuangan;
  ItemName itemName;
  Keuangan keuangan;

  EnumEntryKeuangan stateEntryKeuangan;
  EnumFinalResult finalResult;

  EntryKeuangan({
    @required this.mapKategori,
    @required this.mapItemName,
    @required this.jenisKeuangan,
    @required this.itemName,
    @required this.keuangan,
    @required this.stateEntryKeuangan,
    @required this.finalResult,
  });
}



class StateEntryKeuangan {
  EnumEntryKeuangan stateEntry;

  StateEntryKeuangan(this.stateEntry);
}

class StateJenisKeuangan extends StateEntryKeuangan {
  EnumJenisTransaksi jenisKeuangan;

  StateJenisKeuangan(this.jenisKeuangan)
      : super(EnumEntryKeuangan.jenisKeuangan);
}

class StateAmount extends StateEntryKeuangan {
  int amount;

  StateAmount(this.amount) : super(EnumEntryKeuangan.amount);
}

class StateCategori extends StateEntryKeuangan {
  Kategori kategori;

  StateCategori(this.kategori) : super(EnumEntryKeuangan.pickCategory);
}

class StatePickDate extends StateEntryKeuangan {
  DateTime dateTime;

  StatePickDate(this.dateTime) : super(EnumEntryKeuangan.pickDate);
}

class StateTypingItem extends StateEntryKeuangan {
  String text;

  StateTypingItem(this.text) : super(EnumEntryKeuangan.typeItem);
}

class StateDragAutoComplete extends StateEntryKeuangan {
  StateDragAutoComplete() : super(EnumEntryKeuangan.dragAutoComplete);
}

class StateDismissAutoComplete extends StateEntryKeuangan {
  StateDismissAutoComplete() : super(EnumEntryKeuangan.dismissAutoComplete);
}

class StateClickAutoComplte extends StateEntryKeuangan {
  ItemName itemName;

  StateClickAutoComplte(this.itemName)
      : super(EnumEntryKeuangan.clickAutoComplete);
}

class StateSimpanLagi extends StateEntryKeuangan {
  String textItemName;
  String textCatatan;

  StateSimpanLagi(this.textItemName, this.textCatatan)
      : super(EnumEntryKeuangan.simpandanlagi);
}

class StateFinishLagi extends StateEntryKeuangan {
  StateFinishLagi() : super(EnumEntryKeuangan.finishLagi);
}
