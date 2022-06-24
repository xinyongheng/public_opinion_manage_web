import 'package:flutter/material.dart';

class CheckBoxWidget extends StatefulWidget {
  bool value;
  final dynamic boxTag;
  CheckBoxWidget({Key? key, required this.value, required this.boxTag})
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
          setState(() {
            _value = change ?? false;
            widget.value = _value;
          });
        });
  }
}
