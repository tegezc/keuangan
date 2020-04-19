import 'package:flutter/material.dart';
import 'package:keuangan/database/keuangan/dao_itemname.dart';
import 'package:keuangan/keuangan/entry_item/dialog_calculator.dart';
import 'package:keuangan/keuangan/entry_item/entry_keuangan_bloc.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/datepicker_singlescrollview.dart';
import 'package:keuangan/util/loading_view.dart';
import 'package:keuangan/util/process_string.dart';

class KeuanganItemView extends StatefulWidget {
  final DateTime dateTime;
  final bool isEditMode;
  final Keuangan keuangan;

  KeuanganItemView(
      {this.dateTime, @required this.isEditMode, @required this.keuangan});

  @override
  _KeuanganItemViewState createState() => _KeuanganItemViewState();
}

class _KeuanganItemViewState extends State<KeuanganItemView>
    with WidgetsBindingObserver {
  static final _jenisTransaksi = ['Pengeluaran', 'Pemasukan'];

  EdgeInsets _insetsMedia;

  FocusNode _focusNodeTextItem = new FocusNode();
  FocusNode _focusNodeCatatan = new FocusNode();

  ScrollController _controllerAutoComplete;
  TextEditingController _controllerTextItem;
  TextEditingController _txtNoteController;

  //creating Key for red panel
  GlobalKey _keyTextItem = GlobalKey();
  final _decoration = InputDecoration(
    // border: OutlineInputBorder(),
    hintText: 'Nama Item',
  );

  final _decorationNote = InputDecoration(
    // border: OutlineInputBorder(),
    hintText: 'Catatan',
  );

  final _styleTextField = TextStyle(fontSize: 15, color: Colors.black);
  final _styleButton = TextStyle(fontSize: 15, fontWeight: FontWeight.normal);
  final _iconFieldSize = 20.0;

  BlocEntryKeuangan _blocEntryKeuangan;
  RenderBox _cacheRenderBox;
  String _cacheTextItemName = '';
  EnumEntryKeuangan _cacheStateEntry;

  @override
  initState() {
    _blocEntryKeuangan = BlocEntryKeuangan();
    WidgetsBinding.instance.addObserver(this);
    _txtNoteController = TextEditingController();

    _controllerAutoComplete = ScrollController();
    _controllerTextItem = TextEditingController()
      ..addListener(_editingListener);
    if (widget.isEditMode) {
      int idItemname = widget.keuangan.idItemName;
      DaoItemName daoItemName = new DaoItemName();
      daoItemName.getItemNameById(idItemname).then((item) {
        if (item != null) {
          _txtNoteController.text = widget.keuangan.catatan;
          _controllerTextItem.text = item.nama;
          _blocEntryKeuangan.firstTimeLoadData(
              widget.isEditMode, widget.keuangan);
        }
      });
    } else {
      _blocEntryKeuangan.firstTimeLoadData(widget.isEditMode, widget.keuangan);
    }

    super.initState();
  }

  @override
  dispose() {
    _focusNodeTextItem.dispose();
    _focusNodeCatatan.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (_insetsMedia.bottom > 0 &&
        (_cacheStateEntry == EnumEntryKeuangan.dragAutoComplete ||
            _cacheStateEntry == EnumEntryKeuangan.typeItem)) {
      _dismissAutoComplete();
    }
  }

  _editingListener() {
    String text = _controllerTextItem.text;
    if (text != _cacheTextItemName) {
      _cacheTextItemName = text;

      StateTypingItem stateTypingItem = new StateTypingItem(text);
      _blocEntryKeuangan.sinkState(stateTypingItem);
    }
  }

  _afterLayout() {
    if (_cacheRenderBox == null && _keyTextItem.currentContext != null) {
      _cacheRenderBox = _keyTextItem.currentContext.findRenderObject();
    }
  }

  _dismissAutoComplete() {
    StateDismissAutoComplete stateDismissAutoComplete =
        new StateDismissAutoComplete();
    _blocEntryKeuangan.sinkState(stateDismissAutoComplete);
  }

  _autoCompleteClick(ItemName itemName) {
    _controllerTextItem.text = itemName.nama;
    StateClickAutoComplte stateClickAutoComplte =
        new StateClickAutoComplte(itemName);
    _blocEntryKeuangan.sinkState(stateClickAutoComplte);
  }

  //edited
  _simpanKeuangan(BuildContext context, bool isSavenLagi) async {
    if (isSavenLagi) {
      StateSimpanLagi stateSimpanLagi = new StateSimpanLagi(
          _controllerTextItem.text, _txtNoteController.text);
      _blocEntryKeuangan.sinkState(stateSimpanLagi);
    } else {
      EnumFinalResult enumFinalResult = await _blocEntryKeuangan.simpan1(
          _controllerTextItem.text, _txtNoteController.text);
      Navigator.pop(context, enumFinalResult);
    }
  }

  PropertyAutoComplete _setupAutoComplete(Size sizeWidget, double insetsBottom,
      EnumEntryKeuangan stateEntry, Map<int, ItemName> lItemName) {
    double paddingKananAutoComplete = 55.0;
    double paddingKiriAutoComplete = 15.0;

    PropertyAutoComplete p;
    if (stateEntry == EnumEntryKeuangan.typeItem && lItemName.isNotEmpty) {
      p = this._setupLayoutAutoCompleteB4Drag1(sizeWidget, insetsBottom,
          paddingKananAutoComplete, paddingKiriAutoComplete);
    }

    if (stateEntry == EnumEntryKeuangan.dragAutoComplete) {
      p = this._setupLayoutAutoCompleteAfterDrag1(
          sizeWidget,
          _insetsMedia.bottom,
          paddingKananAutoComplete,
          paddingKiriAutoComplete);
    }

    return p;
  }

  PropertyAutoComplete _setupLayoutAutoCompleteB4Drag1(
      Size sizeWidget, double insetsBottom, double pKanan, double pKiri) {
    if (_cacheRenderBox == null) {
      return null;
    }
    //final RenderBox renderBoxRed = _keyTextItem.currentContext.findRenderObject();
    Size _sizeTextFieldItem = _cacheRenderBox.size;
    Offset _positionTextfieldItem = _cacheRenderBox.localToGlobal(Offset.zero);

    double heightAPpBar = 76.0; // reference from internet app bar android
    double topWidget =
        (_positionTextfieldItem.dy - heightAPpBar) + _sizeTextFieldItem.height;

    Offset _positionAutoComplete = Offset(pKanan, topWidget);

    /*
    *  76 tinggi appBar Android ref dari internet
    * */
    double heightContainer =
        sizeWidget.height - (insetsBottom + topWidget + heightAPpBar + 5);

    //padding kanan , kiri 10
    Size _sizeAutoComplete =
        Size(sizeWidget.width - (pKanan + pKiri), heightContainer);

    return new PropertyAutoComplete(
      sizeTextFieldItem: _sizeTextFieldItem,
      positionTextfieldItem: _positionTextfieldItem,
      sizeAutoComplete: _sizeAutoComplete,
      positionAutoComplete: _positionAutoComplete,
      isDrag: false,
    );
  }

  PropertyAutoComplete _setupLayoutAutoCompleteAfterDrag1(
      Size sizeWidget, double insetsBottom, double pKanan, double pKiri) {
    if (_cacheRenderBox == null) {
      return null;
    }

    //final RenderBox renderBoxRed =_keyTextItem.currentContext.findRenderObject();
    Size _sizeTextFieldItem = _cacheRenderBox.size;
    Offset _positionTextfieldItem = _cacheRenderBox.localToGlobal(Offset.zero);

    Offset _positionAutoComplete = Offset(pKanan, 10.0);

    /*
    * 76 tinggi appBar Android ref dari internet,
    * 10 nilai padding
    * */
    double heightContainer = sizeWidget.height - (insetsBottom + 76 + 10);

    //padding kanan, kiri 10
    Size _sizeAutoComplete =
        Size(sizeWidget.width - (pKanan + pKiri), heightContainer);

    return new PropertyAutoComplete(
      sizeTextFieldItem: _sizeTextFieldItem,
      positionTextfieldItem: _positionTextfieldItem,
      sizeAutoComplete: _sizeAutoComplete,
      positionAutoComplete: _positionAutoComplete,
      isDrag: true,
    );
  }

  _dragAutoComplete() {
    StateDragAutoComplete stateDragAutoComplete = new StateDragAutoComplete();
    _blocEntryKeuangan.sinkState(stateDragAutoComplete);
  }

  Future _selectDate() async {
    int _startDate = widget.dateTime.year - 5;
    int _endDate = widget.dateTime.year + 5;
    if (widget.isEditMode) {
      _startDate = widget.keuangan.tanggal.year - 5;
      _endDate = widget.keuangan.tanggal.year + 5;
    } else {
      _startDate = widget.dateTime.year - 5;
      _endDate = widget.dateTime.year + 5;
    }

    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(_startDate),
        lastDate: new DateTime(_endDate),
        builder: (context, child) {
          return CustomeDatePicker(child);
        });
    if (picked != null) {
      StatePickDate statePickDate = new StatePickDate(picked);
      _blocEntryKeuangan.sinkState(statePickDate);
    }
  }

  Future<Kategori> _asyncSimpleDialog1(
      BuildContext context, Map<int, Kategori> lKategori) async {
    List<Widget> listWidget = new List();
    if (lKategori.isNotEmpty) {
      lKategori.forEach((k, v) {
        listWidget.add(OutlineButton(
          onPressed: () {
            Navigator.pop(context, v);
          },
          child: Text(v.nama),
        ));
      });
    }
    listWidget.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: new RaisedButton(
          color: Colors.blueAccent,
          child: new Text("Add Category"),
          onPressed: () {
            Navigator.pop(context, null);
          },
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(15.0))),
    ));

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Kategori '),
            children: listWidget,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _afterLayout());
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size _sizeWidget = mediaQueryData.size;
    _insetsMedia = MediaQuery.of(context).viewInsets;
    return StreamBuilder<EntryKeuangan>(
        stream: _blocEntryKeuangan.entryKeuanganStream,
        builder: (context, snapshot) {
          if (snapshot == null) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('tunggu sebentar...'),
                ),
                body: LoadingView());
          } else if (snapshot.data == null) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('tunggu sebentar...'),
                ),
                body: LoadingView());
          } else {
            /// set state to [_cacheStateEntry]
            _cacheStateEntry = snapshot.data.stateEntryKeuangan;

            ///menunggu proses save ke database selesai. menanggulangi user klik UI saat proses save
            if (snapshot.data.stateEntryKeuangan ==
                EnumEntryKeuangan.simpandanlagi) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text('tunggu sebentar...'),
                  ),
                  body: LoadingView());
            }

            if (snapshot.data.stateEntryKeuangan ==
                EnumEntryKeuangan.finishLagi) {
              _controllerTextItem.text = snapshot.data.itemName.nama;
              _txtNoteController.text = snapshot.data.keuangan.catatan;
            }

            ///setup auto complete
            PropertyAutoComplete p;

            //auto complete akan muncul jika user mengetikkan minimal 2 hurug
            if (_controllerTextItem.text.length > 1) {
              p = this._setupAutoComplete(_sizeWidget, _insetsMedia.bottom,
                  snapshot.data.stateEntryKeuangan, snapshot.data.mapItemName);
            }

            ///end setup auto complete
            return Scaffold(
              appBar: AppBar(
                title: dropdownWidget1(snapshot.data.jenisKeuangan),
              ),
              body: Stack(children: <Widget>[
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          _widgetAmount1(snapshot.data.keuangan.jumlah.toInt()),
                          Container(
                            color: Colors.grey[200],
                            width: double.infinity,
                            height: 5.0,
                          ),
                          _widgetTextItem(),
                          _widgetKategori1(snapshot.data.itemName.kategori,
                              snapshot.data.mapKategori),
                          _widgetCatatan1(),
                          Container(
                            color: Colors.grey[200],
                            width: double.infinity,
                            height: 10.0,
                          ),
                          _widgetTanggal1(snapshot.data.keuangan.tanggal),
                          new Container(
                            height: 70,
                            width: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Transform(
                  transform: Matrix4.translationValues(
                      0, _sizeWidget.height - (127 + _insetsMedia.bottom), 0),
                  child: widget.isEditMode
                      ? _widgetButtonUpdate(_sizeWidget.width)
                      : _widgetButtonSave(_sizeWidget.width),
                ),
                p != null
                    ? _widgetPadPositionAutoComplete1(p, _sizeWidget)
                    : new Container(),
                p != null
                    ? _widgetPositionAutoComplete1(snapshot.data.mapItemName, p)
                    : new Container(),
              ]),
            );
          }
        });
  }

  Widget dropdownWidget1(EnumJenisTransaksi stateJenisKeuangan) {
    return DropdownButton<int>(
      //map each value from the lIst to our dropdownMenuItem widget
      items: [
        DropdownMenuItem(
          value: EnumJenisTransaksi.pengeluaran.index,
          child: Text(_jenisTransaksi[0]),
        ),
        DropdownMenuItem(
          value: EnumJenisTransaksi.pemasukan.index,
          child: Text(_jenisTransaksi[1]),
        ),
      ],
      onChanged: (v) {
        if (v != null) {
          StateJenisKeuangan entryState =
              StateJenisKeuangan(EnumJenisTransaksi.values[v]);
          _blocEntryKeuangan.sinkState(entryState);
        }
      },
      //this wont make dropdown expanded and fill the horizontal space
      isExpanded: false,
      //make default value of dropdown the first value of our list
      value: stateJenisKeuangan.index,
    );
  }

  callBackFinalResult(int value) {
    StateAmount entryState = new StateAmount(value);
    _blocEntryKeuangan.sinkState(entryState);
  }

  void _showOverlay(BuildContext context) {
    Navigator.of(context)
        .push(CalculatorDialog(callBackLastResult: callBackFinalResult));
  }

  Widget _widgetAmount1(int amount) {
    return FlatButton(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AutoFontSize(
                text: '$amount',
              ),
            ],
          ),
        ],
      ),
      onPressed: () {
        _showOverlay(context);
      },
    );
  }

  Widget _widgetTextItem() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.account_balance_wallet,
          size: _iconFieldSize,
          color: Colors.grey,
        ),
        SizedBox(
          width: 15,
        ),
        Flexible(
          child: TextField(
            key: _keyTextItem,
            controller: _controllerTextItem,
            decoration: _decoration,
            style: _styleTextField,
            focusNode: _focusNodeTextItem,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _widgetKategori1(Kategori kategori, Map<int, Kategori> lKategori) {
    String text = kategori == null ? '' : kategori.nama;
    return Row(
      children: <Widget>[
        Icon(
          Icons.category,
          size: _iconFieldSize,
          color: Colors.grey,
        ),
        Expanded(
          child: FlatButton(
            child: Row(
              // mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  text,
                  style: _styleButton,
                ),
                Spacer(),
                Icon(
                  Icons.arrow_drop_down,
                  size: 25,
                ),
              ],
            ),
            onPressed: () async {
              await _asyncSimpleDialog1(context, lKategori).then((value) {
                if (value != null) {
                  if (value == null) {
                    //TODO: add category
                  } else {
                    var entryState = StateCategori(value);
                    _blocEntryKeuangan.sinkState(entryState);
                  }
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _widgetCatatan1() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.note,
          size: _iconFieldSize,
          color: Colors.grey,
        ),
        SizedBox(
          width: 15,
        ),
        Flexible(
          child: TextField(
            controller: _txtNoteController,
            focusNode: _focusNodeCatatan,
            decoration: _decorationNote,
            style: _styleTextField,
            maxLines: null,
          ),
        ),
      ],
    );
  }

  Widget _widgetTanggal1(DateTime dateTime) {
    ProcessString _processString = new ProcessString();
    return Row(
      children: <Widget>[
        Icon(
          Icons.calendar_today,
          size: _iconFieldSize,
          color: Colors.grey,
        ),
        Expanded(
          child: FlatButton(
            child: Text(
              _processString.dateToStringDdMmmmYyyy(dateTime),
              style: _styleButton,
            ),
            onPressed: () {
              _selectDate();
            },
          ),
        ),
      ],
    );
  }

  Widget _widgetButtonSave(double width) {
    return Container(
      width: double.infinity,
      height: 50,
      child: Row(
        children: <Widget>[
          Container(
            width: width / 2,
            child: new RaisedButton(
              padding: const EdgeInsets.all(8.0),
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: () {
                _simpanKeuangan(context, true);
              },
              child: new Text("Simpan dan lagi"),
            ),
          ),
          Container(
            width: width / 2,
            child: new RaisedButton(
              padding: const EdgeInsets.all(8.0),
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: () {
                _simpanKeuangan(context, false);
              },
              child: new Text("Simpan"),
            ),
          )
        ],
      ),
    );
  }

  Widget _widgetButtonUpdate(double width) {
    return Container(
      width: double.infinity,
      height: 50,
      child: Center(
        child: new RaisedButton(
          padding: const EdgeInsets.all(8.0),
          textColor: Colors.white,
          color: Colors.blue,
          onPressed: () {},
          child: new Text("Update"),
        ),
      ),
    );
  }

  Widget _widgetPadPositionAutoComplete1(
      PropertyAutoComplete p, Size sizeWidget) {
    return new Positioned(
        top: p.positionAutoComplete.dy,
        left: 0,
        child: GestureDetector(
          onTap: () {
            _dismissAutoComplete();
          },
          child: new Container(
            width: sizeWidget.width,
            height: p.sizeAutoComplete.height,
            color: Colors.transparent,
          ),
        ));
  }

  Widget _widgetPositionAutoComplete1(
      Map<int, ItemName> lItemName, PropertyAutoComplete p) {
    List<Widget> listW = new List();
    if (lItemName != null) {
      lItemName.forEach((k, v) {
        listW.add(Row(
          children: <Widget>[
            Expanded(
              child: FlatButton(
                onPressed: () {
                  _autoCompleteClick(v);
                },
                child: Text(v.nama),
              ),
            ),
          ],
        ));
      });
    }
    return new Positioned(
        top: p.positionAutoComplete.dy,
        left: p.positionAutoComplete.dx,
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            _dragAutoComplete();
          },
          child: new Container(
            width: p.sizeAutoComplete.width,
            height: p.sizeAutoComplete.height,
            color: Colors.white,
            child: new SingleChildScrollView(
                controller: _controllerAutoComplete,
                child: new ConstrainedBox(
                  constraints: new BoxConstraints(),
                  child: new Column(children: listW),
                )),
          ),
        ));
  }
}

class AutoFontSize extends StatelessWidget {
  final String text;

  AutoFontSize({this.text});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return LayoutBuilder(builder: (context, size) {
      final style = TextStyle(fontWeight: FontWeight.bold);
      double fontSize =
          calculateAutoscaleFontSize(text, style, mediaQuery.size);
      Widget autoSizeWidget = Container(
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize),
        ),
      );

      return autoSizeWidget;
    });
  }

  double calculateAutoscaleFontSize(
      String text, TextStyle style, Size sizeMedia) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    double hitungan = sizeMedia.width - (140 + 32 + 30);
    var currentFontSize = 20.0;

    for (var i = currentFontSize; i < 40; i++) {
      // limit max iterations to 60
      final nextFontSize = currentFontSize + 1;
      final nextTextStyle = style.copyWith(fontSize: nextFontSize);
      textPainter.text = TextSpan(text: text, style: nextTextStyle);
      textPainter.layout();
      if (textPainter.width >= hitungan) {
        break;
      } else {
        currentFontSize = nextFontSize;
        // continue iteration
      }
    }

    return currentFontSize;
  }
}

class PropertyAutoComplete {
  Size sizeTextFieldItem;
  Offset positionTextfieldItem;

  Size sizeAutoComplete;
  Offset positionAutoComplete;

  bool isDrag;

  PropertyAutoComplete({
    this.sizeTextFieldItem,
    this.positionTextfieldItem,
    this.sizeAutoComplete,
    this.positionAutoComplete,
    this.isDrag,
  });
}
