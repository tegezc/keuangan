import 'package:keuangan/model/keuangan.dart';
import 'package:rxdart/subjects.dart';

class BlocAddKategori{
  final BehaviorSubject<ItemUiAddKategori> _itemUi = BehaviorSubject();
  Stream<ItemUiAddKategori> get uiItemAddKategori => _itemUi.stream;

  void submitKategori(Kategori kategori){

  }

  void stateEdit(){}

  void stateEditSubKategori(){}

  void stateBaruSubKategori(){}

  void stateBaru(){}

  void dispose(){
    _itemUi.close();
  }
}

class ItemUiAddKategori{

}