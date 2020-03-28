import 'dart:async';

import 'package:keuangan/bloc_main.dart';
import 'package:keuangan/file_non_production/bulk_insert.dart';
import 'package:keuangan/keuangan/reporting_by_kategori/reporting_bykategori.dart';
import 'package:keuangan/main_scaffold.dart';
import 'package:flutter/material.dart';

import 'keuangan/homepage_keuangan.dart';

void main() {
  final blocApp = BlocApp();
  return runApp(MyApp(blocApp));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final BlocApp blocApp;

  MyApp(this.blocApp);

  @override
  Widget build(BuildContext context) {
    return MainProvider(
      blocApp: blocApp,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Opensans',
        ),
        home: MyHomePage(),
        navigatorObservers: <NavigatorObserver>[
          SwipeBackObserver(),
        ],
      ),
    );
  }
}

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class MyHomePage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Kalender Nasional", Icons.rss_feed),
    new DrawerItem("TodoList", Icons.local_pizza),
    new DrawerItem("Keuangan", Icons.info),
  ];

  @override
  State<StatefulWidget> createState() {
    return new MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedDrawerIndex = 0;
  Widget _leadingAppbar;
  List<Widget> _actionButtons;
  bool _isEditModeHomepageTodolist;

  @override
  initState() {
    _actionButtons = new List();
    _isEditModeHomepageTodolist = false;
    _testingonly();

    super.initState();
  }

  _testingonly() {
    //for test only
    Persiapan persiapan = new Persiapan();
    persiapan.deleteAllItemName();
    persiapan.insertItemNameDummy();

    persiapan.deleteAllKategori();
    persiapan.insertKategoriDummy();

    persiapan.deleteAllKeuangan();
    persiapan.bulkinsertKeuangan();
    //end test only
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return HomepageKeuangan();
        break;
      case 1:
        return new ReportByCategories();
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        //selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }


    final p = MainProvider.of(context);

    return StreamBuilder<MainState>(
        stream: p.blocMain.mainState,
        builder: (context, snapshot) {
          var title = widget.drawerItems[_selectedDrawerIndex].title;
          if (snapshot.data != null) {
            if (snapshot.data.isHomePageTodoEdit) {
              title = '${snapshot.data.countItemSelected} item selected';
              _leadingAppbar = FlatButton(
                  onPressed: () {
                    p.changeEditMode(false);
                  },
                  child: Icon(Icons.close));
              _actionButtons.clear();
              _actionButtons.add(IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: snapshot.data.countItemSelected == 0
                      ? null
                      : () {
                          p.afterDelete();
                        }));
            } else {
              _leadingAppbar = null;
              _actionButtons.clear();
              _isEditModeHomepageTodolist = false;
            }
          }

          return WillPopScope(
            onWillPop: () async {
              _leadingAppbar = null;
              setState(() {});
              return true;
            },
            child: new Scaffold(
              appBar: new AppBar(
                // here we display the title corresponding to the fragment
                // you can instead choose to have a static title
                title: new Text(title),
                leading: _leadingAppbar,
                actions: _actionButtons,
              ),
              drawer: new Drawer(
                child: new Column(
                  children: <Widget>[
                    new UserAccountsDrawerHeader(
                        accountName: new Text("John Doe"), accountEmail: null),
                    new Column(children: drawerOptions)
                  ],
                ),
              ),
              body: _getDrawerItemWidget(_selectedDrawerIndex),
              floatingActionButton: _selectedDrawerIndex == 1 &&
                      _isEditModeHomepageTodolist == false
                  ? new FloatingActionButton(
                      onPressed: () {},
                      tooltip: 'add transaction',
                      child: new Icon(Icons.add),
                    )
                  : null,
            ),
          );
        });
  }
}

class SwipeBackObserver extends NavigatorObserver {
  static Completer promise;

  @override
  void didStartUserGesture(Route route, Route previousRoute) {
    // make a new promise
    promise = Completer();
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
    // resolve the promise
    promise.complete();
  }
}
