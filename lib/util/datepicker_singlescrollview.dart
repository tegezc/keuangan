import 'package:flutter/material.dart';

class CustomeDatePicker extends StatefulWidget {
  final Widget child;
  CustomeDatePicker(this.child);
  @override
  _CustomeDatePickerState createState() => _CustomeDatePickerState();
}

class _CustomeDatePickerState extends State<CustomeDatePicker> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Theme(
        child: widget.child,
        data: ThemeData.light(),
      ),
    );
  }
}
