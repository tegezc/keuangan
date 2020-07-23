import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

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

class CommonUi {
  Future openPage(context, Widget builder) async {
    // wait until animation finished
    await SwipeBackObserver.promise?.future;

    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => builder),
    );
  }

//  void showToastBottom(String msg) {
//    Fluttertoast.showToast(
//        msg: msg,
//        toastLength: Toast.LENGTH_SHORT,
//        gravity: ToastGravity.BOTTOM,
//        timeInSecForIosWeb: 1,
//        backgroundColor: Colors.red,
//        textColor: Colors.white,
//        fontSize: 16.0);
//  }
}

class CustomToastForMe extends StatefulWidget {
  final Widget child;

  CustomToastForMe({this.child});

  @override
  _CustomToastForMeState createState() => _CustomToastForMeState();
}

class _CustomToastForMeState extends State<CustomToastForMe> {
  @override
  Widget build(BuildContext context) {
    return StyledToast(
        locale: const Locale('id', 'ID'),

        ///You have to set this parameters to your locale
//        textStyle: TextStyle(fontSize: 16.0, color: Colors.white,fontWeight: FontWeight.bold),
//        backgroundColor: Color(0x99000000),
 //       backgroundColor: Colors.cyan,
        borderRadius: BorderRadius.circular(5.0),
        textPadding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
        toastAnimation: StyledToastAnimation.size,
        reverseAnimation: StyledToastAnimation.size,
        startOffset: Offset(0.0, -1.0),
        reverseEndOffset: Offset(0.0, -1.0),
//        duration: Duration(seconds: 1),
//        animDuration: Duration(seconds: 1),
        alignment: Alignment.center,
        toastPositions: StyledToastPosition.center,
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.fastOutSlowIn,
        dismissOtherOnShow: true,
        movingOnWindowChange: true,
        child: widget.child);
  }
}
