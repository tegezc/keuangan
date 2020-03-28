import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  new Center(
        child: new CircularProgressIndicator(),
      );
  }
}
