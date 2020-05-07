import 'package:flutter/material.dart';
import 'package:keuangan/model/enum_keuangan.dart';

class CalculatorDialog extends ModalRoute<void> {
  Function callBackLastResult;

  CalculatorDialog({this.callBackLastResult});

  @override
  Duration get transitionDuration => Duration(milliseconds: 220);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _gestureDetector(Widget child, BuildContext context) {
    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        Navigator.pop(context);
      },
      child: child,
    );
  }

  finalResultFunc(int value) {
    callBackLastResult(value);
  }

  Widget _buildOverlayContent(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size sizeWidget = mediaQueryData.size;
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _gestureDetector(
              new Container(
                color: Colors.transparent,
                height: 80,
              ),
              context),
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _gestureDetector(
                      Container(
                        width: 40,
                        // height: 40,
                        color: Colors.transparent,
                      ),
                      context),
                  Container(
                    width: sizeWidget.width - 60,
                    color: Colors.transparent,
                    child: CalculatorView(
                      widthWidget: sizeWidget.width - 60,
                      functionResult: finalResultFunc,
                    ),
                  ),
                  _gestureDetector(
                      new Container(
                        color: Colors.transparent,
                        width: 20,
                      ),
                      context),
                ],
              ),
            ),
          ),
//          Expanded(
//            child: Container(
//              color: Colors.yellow,
//            ),
//          ),
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

class CalculatorView extends StatefulWidget {
  //double dimension;
  final double widthWidget;
  final Function functionResult;

  CalculatorView({this.widthWidget, this.functionResult});

  @override
  _CalculatorViewState createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  static final initialText = '0';
  static final heighCell = 50.0;
  int finalResult = 0;
  final TextStyle textStyleKet = TextStyle(
      fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.normal);

  final TextStyle textStyleCell = TextStyle(
      fontSize: 20, color: Colors.grey[700], fontWeight: FontWeight.normal);
  final TextStyle textStyleAmount =
  TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold);

  GlobalKey _keyButtonSave = GlobalKey();

  //calculator logic
  String isiText = initialText;
  double num1;
  double num2;
  Operator operator = Operator.kosong;

  @override
  initState() {
    //isiText = initialText;
    super.initState();
  }

  _setTextDisplay(double value) {
    String s = '$value';
    List<String> d = s.split('.');
    if (d.length == 2) {
      if (d[1].startsWith('0')) {
        isiText = d[0];
      } else {
        isiText = value.toStringAsFixed(1);
      }
    } else {
      isiText = '$value';
    }
  }

  _log(String ket) {
//    print('=========== $ket ==================');
//    print('Operator: $operator');
//    print('Num1 : $num1');
//    print('Num2 : $num2');
  }

  _clickNumber(int value) {
    _log('Sebelum click Number');
    if (operator == Operator.kosong) {
      if (isiText == initialText || isiText.length == 0) {
        num1 = value.toDouble();
      } else {
        String sn = isiText + '$value';
        num1 = double.parse(sn);
      }
      _setTextDisplay(num1);
    } else {
      if (num2 == null) {
        num2 = value.toDouble();
      } else {
        String sn = isiText + '$value';
        num2 = double.parse(sn);
      }
      _setTextDisplay(num2);
    }
    _log('Setelah Number');
    setState(() {});
  }

  _clickOperator(Operator op) {
    _log('Sebelum click operator');
    if (num1 != null && num2 != null) {
      _clickSamaDengan();
    }
    //else if(num1 > 0){
    operator = op;
    // }
    _log('Setelah click operator');
  }

  _clickDelete() {
    String txt = isiText;
    if(txt.length == 1){
      isiText = '0';
    }else{
      isiText = txt.substring(0,txt.length-1);
    }

    if(num2 != null){
      num2 =  double.parse(isiText);
    }else{
      num1 = double.parse(isiText);
      operator = Operator.kosong;
    }
    setState(() {

    });
  }

  _clickClear() {
    num1 = null;
    num2 = null;
    operator = Operator.kosong;
    _setTextDisplay(0.0);
    setState(() {

    });
  }

  double _logicOperation(double n1,double n2,Operator op){
    var value = num1;
    LogicCalculator logicCalculator = new LogicCalculator();
    switch (op) {
      case Operator.addition:
        value = logicCalculator.addition(num1, num2);
        break;
      case Operator.subtraction:
        value = logicCalculator.subtraction(num1, num2);
        break;
      case Operator.multiplication:
        value = logicCalculator.multiplication(num1, num2);
        break;
      case Operator.division:
        value = logicCalculator.division(num1, num2);
        break;
      case Operator.kosong:
        break;
    }
    return value;
  }
  _clickSamaDengan() {
    _log('Sebelum Sama Dengan');
    if (num1 > 0 && num2 > 0) {
      num1 = this._logicOperation(num1, num2, operator);
      num2 = null;
      operator = Operator.kosong;
      _log('Setelah Sama Dengan');
      _setTextDisplay(num1);
      setState(() {});
    }
  }

  //_clickTitik() {}

  Widget _widgetText() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Text(
                'JUMLAH TRANSAKSI',
                maxLines: 1,
                style: textStyleKet,
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Text(
                isiText,
                maxLines: 1,
                style: textStyleAmount,
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cellClear() {
    return Expanded(
      flex: 1,
      child: Container(
        height: heighCell,
        color: Colors.white,
        child: FlatButton(
          onPressed: () {
            _clickClear();
          },
          child: Text(
            'C',
            style: textStyleCell,
          ),
        ),
      ),
    );
  }

  Widget _cellDelee() {
    return Expanded(
      flex: 2,
      child: Container(
        color: Colors.white,
        height: heighCell,
        child: FlatButton(
          onPressed: () {
            _clickDelete();
          },
          child: Text(
            'Del',
            style: textStyleCell,
          ),
        ),
      ),
    );
  }

  Widget _cellChar(String char) {
    return Flexible(
      flex: 1,
      child: Container(
        color: Colors.white,
        height: heighCell,
        child: FlatButton(
          onPressed: () {
            if (char == '=') {
              _clickSamaDengan();
            }
          },
          child: Text(
            char,
            style: textStyleCell,
          ),
        ),
      ),
    );
  }

  Widget _cellNoll() {
    return Expanded(
      flex: 2,
      child: Container(
        color: Colors.white,
        height: heighCell,
        child: FlatButton(
          onPressed: () {
            _clickNumber(0);
          },
          child: Text(
            '0',
            style: textStyleCell,
          ),
        ),
      ),
    );
  }

  Widget _cellNumber(int value) {
    return Expanded(
      flex: 1,
      child: Container(
        color: Colors.white,
        height: heighCell,
        child: FlatButton(
          onPressed: () {
            _clickNumber(value);
          },
          child: Text(
            '$value',
            style: textStyleCell,
          ),
        ),
      ),
    );
  }

  Widget _cellOperator(Operator op) {
    String value;
    switch (op) {
      case Operator.addition:
        value = '+';
        break;
      case Operator.subtraction:
        value = '-';
        break;
      case Operator.multiplication:
        value = '\u00D7';
        break;
      case Operator.division:
        value = '\u00F7';
        break;
      case Operator.kosong:
        break;
    }
    return Flexible(
      flex: 1,
      child: Container(
        color: Colors.grey[200],
        height: heighCell,
        child: FlatButton(
          onPressed: () {
            _clickOperator(op);
          },
          child: Text(
            value,
            style: textStyleCell,
          ),
        ),
      ),
    );
  }

  Widget _rowTop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _cellClear(),
        _cellDelee(),
      ],
    );
  }

  Widget _rowCalc1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _cellNumber(7),
        _cellNumber(8),
        _cellNumber(9),
        _cellOperator(Operator.division),
      ],
    );
  }

  Widget _rowCalc2() {
    return Row(
      children: <Widget>[
        _cellNumber(4),
        _cellNumber(5),
        _cellNumber(6),
        _cellOperator(Operator.multiplication),
      ],
    );
  }

  Widget _rowCalc3() {
    return Row(
      children: <Widget>[
        _cellNumber(1),
        _cellNumber(2),
        _cellNumber(3),
        _cellOperator(Operator.subtraction),
      ],
    );
  }

  Widget _rowCalc4() {
    return Row(
      children: <Widget>[
        _cellNoll(),
        _cellChar('='),
        _cellOperator(Operator.addition),
      ],
    );
  }

  _exseButtonSave() {
//    var val = 0.0;
//    if(num2 != null && operator != Operator.kosong){
//      val = this._logicOperation(num1, num2, operator);
//    }else{
//      val = num1;
//    }
    widget.functionResult(int.parse(isiText));
  }

  Widget _widgetButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ),
        Expanded(
          child: RaisedButton(
            key: _keyButtonSave,
            onPressed: () {
              _exseButtonSave();
              Navigator.pop(context);
            },
            child: Text('Done'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (TapUpDetails details){

        RenderBox getBox = context.findRenderObject();
        var local = getBox.localToGlobal(details.globalPosition);

        final RenderBox renderBoxRed =
        _keyButtonSave.currentContext.findRenderObject();

        Offset positionTextfieldItem = renderBoxRed.localToGlobal(Offset.zero);

        if(local.dy> positionTextfieldItem.dy){
          Navigator.pop(context);
        }
      },
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          _widgetText(),
          SizedBox(
            width: widget.widthWidget,
            height: 2,
            child: Container(),
          ),
          _rowTop(),
          _rowCalc1(),
          _rowCalc2(),
          _rowCalc3(),
          _rowCalc4(),
          _widgetButton(context),
          Flexible(
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}

class LogicCalculator {
  double addition(double num1, double num2) {
    return num1 + num2;
  }

  double subtraction(double num1, double num2) {
    return num1 - num2;
  }

  double multiplication(double num1, double num2) {
    return num1 * num2;
  }

  double division(double num1, double num2) {
    return num1 / num2;
  }
}


