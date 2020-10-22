import 'package:flutter/material.dart';
import 'package:keuangan/settings/csv/hpexportcsv.dart';
import 'package:keuangan/util/common_ui.dart';

class HpSettings extends StatefulWidget {
  final Widget drawer;

  HpSettings(this.drawer);

  @override
  _HpSettingsState createState() => _HpSettingsState();
}

class _HpSettingsState extends State<HpSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      drawer: widget.drawer,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          _cellSetting('Bacup Google Drive ', '(Off)',
              'Otomatis backup ke account google drive anda.',(){

              }),
          _cellSetting('Backup ke File', '',
              'Backup data ke file, Dimana file ini akan di simpan di penyimpanan lokal di hp anda.',(){}),
          _cellSetting('Restore dari File ', '',
              'Restore data dari file backup di penyimpanan hp anda.',(){}),
          _cellSetting('Export ke CSV ', '', 'Export data transaksi ke csv.',(){
            openPage(
                context,
                HpExportToCsv( ));
          }),
        ],
      ),
    );
  }

  Widget _cellSetting(
      String name, String addname, String desc, Function click) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 0.0, right: 8, left: 8),
      child: RaisedButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(color: Colors.grey)),
        onPressed: () async {
          click();
        },
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 8,
              ),
              RichText(
                text: TextSpan(
                  text: name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                        text: addname,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                  ],
                ),
              ),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future openPage(context, Widget builder) async {
    // wait until animation finished
    await SwipeBackObserver.promise?.future;

    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => builder),
    );
  }
}
