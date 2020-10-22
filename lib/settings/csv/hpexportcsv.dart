import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keuangan/settings/csv/blocexportcsv.dart';
import 'package:keuangan/util/common_ui.dart';
import 'package:keuangan/util/datepicker/calender/tgz_datepicker.dart';
import 'package:keuangan/util/loading_view.dart';
import 'package:keuangan/util/process_string.dart';

class HpExportToCsv extends StatefulWidget {
  @override
  _HpExportToCsvState createState() => _HpExportToCsvState();
}

class _HpExportToCsvState extends State<HpExportToCsv> {
  ProcessString _processString = new ProcessString();
  final _styleTextField = TextStyle(fontSize: 15, color: Colors.black);
  final _styleButton = TextStyle(fontSize: 15, fontWeight: FontWeight.normal);
  final _iconFieldSize = 20.0;

  BlocExportCsv _blocExportCsv;
  int _buildCounter = 0;

  @override
  void initState() {
    _blocExportCsv = BlocExportCsv();

    super.initState();
  }

  @override
  void dispose() {
    _blocExportCsv.dispose();
    super.dispose();
  }

  void _clickTgl(int startYears, int endYears, bool isawal) {
    this._selectDate(startYears, endYears, isawal);
  }

  @override
  Widget build(BuildContext context) {
    if (_buildCounter == 0) {
      _blocExportCsv.setupFitstime();
      _buildCounter++;
    }
    return StreamBuilder<ItemExportCsv>(
        stream: _blocExportCsv.itemExportcsvStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return LoadingView();
          } else if (snapshot.hasData) {
            ItemExportCsv item = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: Text('Export csv'),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _widgetTanggal1(item.awal, () {
                      _clickTgl(item.startYears, item.endYears, true);
                    }),
                    _widgetTanggal1(item.akhir, () {
                      _clickTgl(item.startYears, item.endYears, false);
                    }),
                  ],
                ),
              ),
            );
          } else {
            return LoadingView();
          }
        });
  }

  Widget _widgetTanggal1(DateTime dateTime, Function click) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.calendar_today,
          size: _iconFieldSize,
        ),
        Expanded(
          child: FlatButton(
            child: Text(
              _processString.dateToStringDdMmmmYyyy(dateTime),
              style: _styleButton,
            ),
            onPressed: () {
              click();
            },
          ),
        ),
      ],
    );
  }

  Future _selectDate(int startYears, int endYears, bool isawal) async {
    DateTime dt = await openPage(context, TgzDatePicker(startYear:startYears, endYear:endYears));
    if (dt != null) {
      _blocExportCsv.setDate(isawal, dt);
    }
  }

  Future openPage(context, Widget builder) async {
    // wait until animation finished
    await SwipeBackObserver.promise?.future;

    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => builder),
    );
  }
}
