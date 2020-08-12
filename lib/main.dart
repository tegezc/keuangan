import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:keuangan/file_non_production/bulk_insert.dart';
import 'package:keuangan/keuangan/itemname/homepage_itemname.dart';
import 'package:keuangan/keuangan/kategori/homepage_kategori.dart';
import 'package:keuangan/keuangan/report/hp_report.dart';
import 'package:keuangan/keuangan/setting/setting_app.dart';
import 'package:keuangan/keuangan/transaksi/keuangan_transaksi.dart';
import 'package:flutter/material.dart';
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

  @override
  initState() {
    //_testingonly();
    _setupFirstime();
    _initAdMob();
    super.initState();
  }

  Future<void> _initAdMob() {
    // TODO: Initialize AdMob SDK
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  _setupFirstime() async {
    SettingApp settingApp = new SettingApp();
    settingApp.prepareFirstTimeInstall().then((value) {
      bool isTestOn = false;
      if(isTestOn){
        /// for testing only
        _testOnly();
      }else{
        setState(() {
          _selectedDrawerIndex = 0;
        });
      }
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
    final textStyleNormal = new TextStyle(fontSize: 16, color: Colors.black);
    final textStyleSelected = new TextStyle(fontSize: 16, color: Colors.blue);
    List<Widget> drawerOptions = [];
    drawerOptions.add(new SizedBox(
      height: 8.0,
    ));
    drawerOptions.add(new ListTile(
      leading: new Icon(Icons.monetization_on,
          color: _selectedDrawerIndex == 0 ? Colors.blue : Colors.black),
      title: new Text("Home",
          style:
              _selectedDrawerIndex == 0 ? textStyleSelected : textStyleNormal),
      onTap: () => _onSelectItem(0),
    ));
    drawerOptions.add(new ListTile(
      leading: new Icon(Icons.swap_horizontal_circle,
          color: _selectedDrawerIndex == 1 ? Colors.blue : Colors.black),
      title: new Text("Transaksi",
          style:
              _selectedDrawerIndex == 1 ? textStyleSelected : textStyleNormal),
      onTap: () => _onSelectItem(1),
    ));
    drawerOptions.add(new ListTile(
      leading: new Icon(Icons.pie_chart,
          color: _selectedDrawerIndex == 2 ? Colors.blue : Colors.black),
      title: new Text("Laporan",
          style:
              _selectedDrawerIndex == 2 ? textStyleSelected : textStyleNormal),
      onTap: () => _onSelectItem(2),
    ));
    drawerOptions.add(new ListTile(
      leading: new Icon(
        Icons.playlist_add_check,
        color: _selectedDrawerIndex == 3 ? Colors.blue : Colors.black,
      ),
      title: new Text("Manage Kategori",
          style:
              _selectedDrawerIndex == 3 ? textStyleSelected : textStyleNormal),
      //selected: i == _selectedDrawerIndex,
      onTap: () => _onSelectItem(3),
    ));

    drawerOptions.add(new ListTile(
      leading: new Icon(
        Icons.fast_forward,
        color: _selectedDrawerIndex == 4 ? Colors.blue : Colors.black,
      ),
      title: new Text("Manage Item Cepat",
          style:
              _selectedDrawerIndex == 4 ? textStyleSelected : textStyleNormal),
      onTap: () => _onSelectItem(4),
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
