import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keuangan/model/enum_keuangan.dart';

class CalculatorDialog extends ModalRoute<void> {
  Function callBackLastResult;
  double amount;

  CalculatorDialog({this.callBackLastResult, this.amount});

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
                    child: CalculatorView(
                      widthWidget: sizeWidget.width - 60,
                      functionResult: finalResultFunc,
                      amount: amount,
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
  final double amount;

  CalculatorView({this.widthWidget, this.functionResult, this.amount});

  @override
  _CalculatorViewState createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  static final _heighCell = 50.0;
  final TextStyle _textStyleKet = TextStyle(
      fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.normal);

  final TextStyle _textStyleCell =
      TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold);
  final TextStyle _textStyleBtn =
      TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold);
  final TextStyle _textStyleAmount =
      TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold);

  final Color _colorNonNumber = Colors.grey[100];
  final Color _colorNumber = Colors.white;
  final Color _colorButton = Colors.cyan[600];

  GlobalKey _keyButtonSave = GlobalKey();

  //calculator logic
  IsiTextAmount _isiText;

  double _num1;
  double _num2;
  Operator _operator = Operator.kosong;
  bool _isFirstimeClickNumber;

  @override
  initState() {
    _isiText = IsiTextAmount();
    _isFirstimeClickNumber = true;
    _isiText.setRealValue(widget.amount);
    super.initState();
  }

  _setTextDisplay(double value) {
    _isiText.setRealValue(value);
//    String s = '$value';
//    List<String> d = s.split('.');
//    if (d.length == 2) {
//      if (d[1].startsWith('0')) {
//        _isiText = d[0];
//      } else {
//        _isiText = value.toStringAsFixed(1);
//      }
//    } else {
//      _isiText = '$value';
//    }
  }

  _log(String ket) {
//    print('=========== $ket ==================');
//    print('Operator: $operator');
//    print('Num1 : $num1');
//    print('Num2 : $num2');
  }

  _clickNumber(int value) {
    if (_operator == Operator.kosong) {
      if (_isiText.realValue == 0 || _isFirstimeClickNumber) {
        _num1 = value.toDouble();
        _isFirstimeClickNumber = false;
      } else {
        String tmp = _isiText.realValue.toInt().toString();
        String sn = tmp + '$value';
        _num1 = double.parse(sn);
      }
      _setTextDisplay(_num1);
    } else {
      if (_num2 == null) {
        _num2 = value.toDouble();
      } else {
        String tmp = _isiText.realValue.toInt().toString();
        String sn = tmp + '$value';
        _num2 = double.parse(sn);
      }
      _setTextDisplay(_num2);
    }
    _log('Setelah Number');
    setState(() {});
  }

  _clickOperator(Operator op) {
    _log('Sebelum click operator');
    if (_num1 != null && _num2 != null) {
      _clickSamaDengan();
    }

    if (_isFirstimeClickNumber) {
      _isFirstimeClickNumber = false;
      _num1 = _isiText.realValue;
    }
    //else if(num1 > 0){
    _operator = op;
    // }
    _log('Setelah click operator');
  }

  _clickDelete() {
    String txt = _isiText.realValue.toInt().toString();
    if (txt.length == 1) {
      _isiText.setRealValue(0);
    } else {
      String tmp = txt.substring(0, txt.length - 1);
      _isiText.setRealValue(double.parse(tmp));
    }

    if (_num2 != null) {
      _num2 = _isiText.realValue;
    } else {
      _num1 = _isiText.realValue;
      _operator = Operator.kosong;
    }
    setState(() {});
  }

  _clickClear() {
    _num1 = null;
    _num2 = null;
    _operator = Operator.kosong;
    _setTextDisplay(0.0);
    setState(() {});
  }

  double _logicOperation(double n1, double n2, Operator op) {
    var value = _num1;
    LogicCalculator logicCalculator = new LogicCalculator();
    switch (op) {
      case Operator.addition:
        value = logicCalculator.addition(_num1, _num2);
        break;
      case Operator.subtraction:
        value = logicCalculator.subtraction(_num1, _num2);
        break;
      case Operator.multiplication:
        value = logicCalculator.multiplication(_num1, _num2);
        break;
      case Operator.division:
        value = logicCalculator.division(_num1, _num2);
        break;
      case Operator.kosong:
        break;
    }
    return value;
  }

  _clickSamaDengan() {
    _log('Sebelum Sama Dengan');
    if (_num1 > 0 && _num2 > 0) {
      _num1 = this._logicOperation(_num1, _num2, _operator);
      _num2 = null;
      _operator = Operator.kosong;
      _log('Setelah Sama Dengan');
      _setTextDisplay(_num1);
      setState(() {});
    }
  }

  //_clickTitik() {}

  Widget _widgetText() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Text(
                  'JUMLAH TRANSAKSI',
                  maxLines: 1,
                  style: _textStyleKet,
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Text(
                _isiText.formatedCurrency,
                maxLines: 1,
                style: _textStyleAmount,
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

  Widget _btnCacel() {
    return Expanded(
      flex: 1,
      child: Container(
        height: _heighCell,
        color: _colorButton,
        child: OutlineButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: _textStyleBtn,
          ),
        ),
      ),
    );
  }

  Widget _btnDone() {
    return Expanded(
      key: _keyButtonSave,
      flex: 1,
      child: Container(
        height: _heighCell,
        color: _colorButton,
        child: OutlineButton(
          onPressed: () {
            _exseButtonSave();
            Navigator.pop(context);
          },
          child: Text(
            'Done',
            style: _textStyleBtn,
          ),
        ),
      ),
    );
  }

  Widget _cellClear() {
    return Expanded(
      flex: 1,
      child: Container(
        height: _heighCell,
        color: _colorNonNumber,
        child: OutlineButton(
          onPressed: () {
            _clickClear();
          },
          child: Text(
            'C',
            style: _textStyleCell,
          ),
        ),
      ),
    );
  }

  Widget _cellDelee() {
    return Expanded(
      flex: 2,
      child: Container(
        color: _colorNonNumber,
        height: _heighCell,
        child: OutlineButton(
          onPressed: () {
            _clickDelete();
          },
          child: Text(
            'Del',
            style: _textStyleCell,
          ),
        ),
      ),
    );
  }

  Widget _cellChar(String char) {
    return Flexible(
      flex: 1,
      child: Container(
        color: _colorNonNumber,
        height: _heighCell,
        child: OutlineButton(
          onPressed: () {
            if (char == '=') {
              _clickSamaDengan();
            }
          },
          child: Text(
            char,
            style: _textStyleCell,
          ),
        ),
      ),
    );
  }

  Widget _cellNoll() {
    return Expanded(
      flex: 2,
      child: Container(
        color: _colorNumber,
        height: _heighCell,
        child: OutlineButton(
          onPressed: () {
            _clickNumber(0);
          },
          child: Text(
            '0',
            style: _textStyleCell,
          ),
        ),
      ),
    );
  }

  Widget _cellNumber(int value) {
    return Expanded(
      flex: 1,
      child: Container(
        color: _colorNumber,
        height: _heighCell,
        child: OutlineButton(
          onPressed: () {
            _clickNumber(value);
          },
          child: Text(
            '$value',
            style: _textStyleCell,
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
        color: _colorNonNumber,
        height: _heighCell,
        child: OutlineButton(
          onPressed: () {
            _clickOperator(op);
          },
          child: Text(
            value,
            style: _textStyleCell,
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

  Widget _rowCalc5() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _btnCacel(),
        _btnDone(),
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
    widget.functionResult(_isiText.realValue.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        RenderBox getBox = context.findRenderObject();
        var local = getBox.localToGlobal(details.globalPosition);

        final RenderBox renderBoxRed =
            _keyButtonSave.currentContext.findRenderObject();

        Offset positionTextfieldItem = renderBoxRed.localToGlobal(Offset.zero);

        if (local.dy > positionTextfieldItem.dy) {
          Navigator.pop(context);
        }
      },
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                _widgetText(),
                Container(
                  color: Colors.grey,
                  height: 1,
                  width: widget.widthWidget,
                ),
                _rowTop(),
                _rowCalc1(),
                _rowCalc2(),
                _rowCalc3(),
                _rowCalc4(),
                _rowCalc5(),
                // _widgetButton(context),
              ],
            ),
          ),
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

class IsiTextAmount {
  double _realValue;
  String _formatedCurrency;

  double get realValue => this._realValue;

  String get formatedCurrency => this._formatedCurrency;

  void setRealValue(double amount) {
    this._realValue = amount;

    final formatCurrency = new NumberFormat("#,##0", "idr");
    int tmpValue = amount.toInt();

    this._formatedCurrency = formatCurrency.format(tmpValue);

    print('realvalue2: $_realValue || Currency: $_formatedCurrency');
  }
}
