import 'package:flutter/material.dart';

class EventScrollView extends StatelessWidget {
  final int scrollDir;

  EventScrollView({
    this.scrollDir,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
//      height: 700.0,
      color: Colors.red,
      child: ListView(
        scrollDirection: scrollDir==1?Axis.horizontal:Axis.vertical,
        children: <Widget>[
          new Icon(Icons.print),
          new Icon(Icons.print),
          new Icon(Icons.print),
          new Icon(Icons.print),
          new Icon(Icons.print),
          new Icon(Icons.print),
          new Icon(Icons.print),
          new Icon(Icons.print),
          new Icon(Icons.print),
          new Icon(Icons.print),
          new Icon(Icons.print),
          new Icon(Icons.print),
          new Icon(Icons.print),
          new Icon(Icons.print),
          new Icon(Icons.print),
          new Icon(Icons.print),
          new Icon(Icons.print),
          new Icon(Icons.print),
          new Icon(Icons.print),
        ],
      ),
    );
  }
}
