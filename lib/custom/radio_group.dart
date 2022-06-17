import 'package:flutter/material.dart';
import 'package:public_opinion_manage_web/config/config.dart';

typedef OnChangeListener = void Function(int groupValue);

class RadioGroup extends StatefulWidget {
  final Axis direction;
  final TextStyle? style;
  final List<String> list;
  int groupValue = 0;
  OnChangeListener changeListener;

  RadioGroup({
    Key? key,
    required this.list,
    this.style,
    this.direction = Axis.horizontal,
    required this.changeListener,
  }) : super(key: key);

  String loadSelect() {
    return list[groupValue];
  }

  @override
  State<RadioGroup> createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  @override
  Widget build(BuildContext context) {
    return widget.direction == Axis.horizontal ? row() : column();
  }

  Widget row() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: radioList(),
    );
  }

  Widget column() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: radioList(),
    );
  }

  void onChange(int? v) {
    print("啦啦啦1： $v");
    setState(() {
      widget.groupValue = v ?? 0;
    });
    widget.changeListener(v ?? 0);
    print("啦啦啦2： ${widget.groupValue}");
  }

  List<Widget> radioList() {
    final views = <Widget>[];
    for (int index = 0; index < widget.list.length; index++) {
      String element = widget.list[index];
      final item = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio(
            value: index,
            groupValue: widget.groupValue,
            onChanged: onChange,
          ),
          Text(element, style: widget.style ?? Config.loadDefaultTextStyle())
        ],
      );
      views.add(item);
    }
    return views;
  }
}
