import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:keuangan/database/dao_setup.dart';
import 'package:keuangan/database/keuangan/dao_kategori.dart';
import 'package:keuangan/file_non_production/bulk_insert.dart';
import 'package:keuangan/keuangan/itemname/homepage_itemname.dart';
import 'package:keuangan/keuangan/kategori/homepage_kategori.dart';
import 'package:keuangan/keuangan/report/hp_report.dart';
import 'package:keuangan/keuangan/startup/startupapp.dart';
import 'package:keuangan/keuangan/transaksi/keuangan_transaksi.dart';
import 'package:flutter/material.dart';
import 'package:keuangan/model/enum_keuangan.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/util/adsmob.dart';
import 'package:keuangan/util/common_ui.dart';
import 'package:keuangan/util/sceleten_firstime.dart';
import 'package:keuangan/util/style.dart';

import 'keuangan/homepage_keuangan.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Management',
//      theme: ThemeData(
//       // primarySwatch: Colors.blue,
//       // brightness: Brightness.light,
//        primaryColor: Colors.white,
//        accentColor: Colors.cyan[600],
//        fontFamily: 'Opensans',
//        textTheme: TextTheme(),
//      ),
      theme: AppTheme.lightTheme,
//      darkTheme: AppTheme.lightTheme,
      home: MyHomePage(),
      navigatorObservers: <NavigatorObserver>[
        SwipeBackObserver(),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedDrawerIndex = 5;
  final _textStyleNormal = new TextStyle(fontSize: 16, color: Colors.black);
  final _textStyleSelected = new TextStyle(fontSize: 16, color: Colors.blue);
  final _textStyleNormalKecil = new TextStyle(fontSize: 14, color: Colors.black);
  final _textStyleSelectedKecil = new TextStyle(fontSize: 14, color: Colors.blue);
  @override
  initState() {
   // _setupFirstimeForTEST();
    _setupFirstime();
    _initAdMob();
    super.initState();
  }

  Future<void> _initAdMob() {
    // TODO: Initialize AdMob SDK
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  _setupFirstimeForTEST() async {
    DaoKategori daoKategori = new DaoKategori();
    DaoSetup daoSetup = new DaoSetup();
    daoSetup.deleteAllSetup().then((value) {
      daoKategori.deleteAllKategori().then((value) {
        SettingApp settingApp = new SettingApp();
        settingApp.prepareFirstTimeInstall().then((value) {
          this._testOnly();
        });
      });
    });
  }

  _setupFirstime() async {
    SettingApp settingApp = new SettingApp();
    settingApp.prepareFirstTimeInstall().then((value) {
      setState(() {
        _selectedDrawerIndex = 0;
      });
    });
  }
  _testOnly() async {
    GenerateDymmyDataTest generateDymmyDataTest = new GenerateDymmyDataTest();
    generateDymmyDataTest.generateKeuangan().then((value) {
      setState(() {
        _selectedDrawerIndex = 0;
      });
    });
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        {
          // return CobaFB();
          return HomepageKeuangan(drawer: _createDrawer(pos));
        }
        break;
      case 1:
        {
          return new TransactionKeuangan.byDefault(drawer: _createDrawer(pos));
        }
        break;
      case 2:
        {
          //      return new ReportByCategories(drawer: _createDrawer(pos));
          return HpReport(drawer: _createDrawer(pos));
        }
        break;
      case 3:
        {
          return new HomePageKategori(drawer: _createDrawer(pos));
        }
        break;
      case 4:
        {
          return new HomePageItemName(drawer: _createDrawer(pos));
        }
        break;
      case 5:
        {
          return new FirtimeSceleton();
        }
        break;
      case 6:
        {
          return new HomePageItemName(drawer: _createDrawer(pos));
        }
        break;
      case 7:
        {
          return new HomePageItemName(drawer: _createDrawer(pos));
        }
        break;
      default:
        return new Text("Error");
        break;
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  List<Widget> _createDrawerItem(int pos) {
   
    List<Widget> drawerOptions = [];
    drawerOptions.add(new SizedBox(
      height: 8.0,
    ));
    drawerOptions.add(new ListTile(
      leading: new Icon(Icons.monetization_on,
          color: _selectedDrawerIndex == 0 ? Colors.blue : Colors.black),
      title: new Text("Home",
          style:
              _selectedDrawerIndex == 0 ? _textStyleSelected : _textStyleNormal),
      onTap: () => _onSelectItem(0),
    ));
    drawerOptions.add(new ListTile(
      leading: new Icon(Icons.swap_horizontal_circle,
          color: _selectedDrawerIndex == 1 ? Colors.blue : Colors.black),
      title: new Text("Transaksi",
          style:
              _selectedDrawerIndex == 1 ? _textStyleSelected : _textStyleNormal),
      onTap: () => _onSelectItem(1),
    ));
    drawerOptions.add(new ListTile(
      leading: new Icon(Icons.pie_chart,
          color: _selectedDrawerIndex == 2 ? Colors.blue : Colors.black),
      title: new Text("Laporan",
          style:
              _selectedDrawerIndex == 2 ? _textStyleSelected : _textStyleNormal),
      onTap: () => _onSelectItem(2),
    ));
    drawerOptions.add(new Divider());
    drawerOptions.add(new ListTile(
      leading: new Icon(
        Icons.playlist_add_check,
        color: _selectedDrawerIndex == 3 ? Colors.blue : Colors.black,
      ),
      title: new Text("Kategori",
          style:
              _selectedDrawerIndex == 3 ? _textStyleSelectedKecil : _textStyleNormalKecil),
      //selected: i == _selectedDrawerIndex,
      onTap: () => _onSelectItem(3),
    ));

    drawerOptions.add(new ListTile(
      leading: new Icon(
        Icons.fast_forward,
        color: _selectedDrawerIndex == 4 ? Colors.blue : Colors.black,
      ),
      title: new Text("Item Cepat",
          style:
              _selectedDrawerIndex == 4 ? _textStyleSelectedKecil : _textStyleNormalKecil),
      onTap: () => _onSelectItem(4),
    ));

    drawerOptions.add(new Divider());
    drawerOptions.add(new ListTile(
      leading: new Icon(
        Icons.settings_applications,
        color: _selectedDrawerIndex == 6 ? Colors.blue : Colors.black,
      ),
      title: new Text("Setting",
          style:
          _selectedDrawerIndex == 6 ? _textStyleSelectedKecil : _textStyleNormalKecil),
      onTap: () => _onSelectItem(6),
    ));

    drawerOptions.add(new ListTile(
      leading: new Icon(
        Icons.info,
        color: _selectedDrawerIndex == 7 ? Colors.blue : Colors.black,
      ),
      title: new Text("About",
          style:
          _selectedDrawerIndex == 7 ? _textStyleSelectedKecil : _textStyleNormalKecil),
      onTap: () => _onSelectItem(7),
    ));

    drawerOptions.add(new Divider());

    return drawerOptions;
  }

  Widget _createDrawer(int pos) {
    return new Drawer(
      child: new Column(
        children: <Widget>[
          _createHeader(),
          new Column(children: _createDrawerItem(pos))
        ],
      ),
    );
  }

  Widget _createHeader() {
    return Container(
        color: Colors.white,
        height: 100,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0, left: 10.0),
          child: Text("Keuangan",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => true);
      },
      child: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
