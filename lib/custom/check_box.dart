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
  // bool _value = false;
  @override
  void initState() {
    super.initState();
    // _value = widget.value;
    // print("initState：widget.value=${widget.value}, _value=${_value}");
  }

  @override
  Widget build(BuildContext context) {
    // print("_CheckBoxWidgetState：widget.value=${widget.value}, _value=${true}");
    return Checkbox(
        value: widget.value,
        onChanged: (change) {
          setState(() {});
          widget.value = change ?? false;
          //_value = change ?? false;
          widget.onChanged(widget.value, widget.boxTag);
        });
  }
}
