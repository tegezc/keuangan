import 'dart:async';

import 'package:rxdart/subjects.dart';

class BlocMain {
  MainState _oMainState;

  BlocMain(){
    this._oMainState = new MainState();
    this._oMainState.isHomePageTodoEdit = false;
    this._mainState.sink.add(this._oMainState);
  }

  final BehaviorSubject<MainState> _mainState = BehaviorSubject<MainState>();

  Stream<MainState> get mainState => _mainState.stream;

  void sinkMainStateHomePageTodo(bool val){
    _oMainState.isHomePageTodoEdit = val;
    _mainState.sink.add(_oMainState);
  }

  void sinkMainStateWithSelectedItem(int selectedItem){
    _oMainState.countItemSelected = selectedItem;
    _oMainState.isHomePageTodoEdit = true;
    _mainState.sink.add(_oMainState);
  }

  void dispose() {
    _mainState.close();
  }
}

class BlocApp{
  BlocMain blocMain;

  BlocApp(){
    blocMain = BlocMain();

  }


  void changeEditMode(bool val){
    blocMain.sinkMainStateHomePageTodo(val);

  }

  void afterDelete(){
    blocMain.sinkMainStateHomePageTodo(false);

  }
}

class MainState {
  bool isHomePageTodoEdit;
  int countItemSelected;

  MainState(){
    isHomePageTodoEdit = false;
    countItemSelected = 0;
  }

}