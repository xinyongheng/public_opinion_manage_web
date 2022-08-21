import 'package:flutter/material.dart';

typedef CheckBoxChange = Function(bool value, dynamic tag);

class CheckBoxWidget extends StatefulWidget {
  bool value;
  final dynamic boxTag;
  final CheckBoxChange onChanged;
  CheckBoxWidget(
      {Key? key,
      required this.value,
      required this.boxTag,
      required this.onChanged})
      : super(key: key);

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool _value = false;
  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        value: _value,
        onChanged: (change) {
          setState(() {});
          widget.value = _value;
          _value = change ?? false;
          widget.onChanged(_value, widget.boxTag);
        });
  }
}
