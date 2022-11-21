import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';

class RadioGroupWidget extends StatefulWidget {
  final List<String> list;
  final int defaultSelectIndex;
  final Axis direction;
  final ValueChanged<int?>? change;
  const RadioGroupWidget({
    Key? key,
    required this.list,
    this.defaultSelectIndex = -1,
    this.direction = Axis.horizontal,
    this.change,
  }) : super(key: key);

  @override
  State<RadioGroupWidget> createState() => RadioGroupWidgetState();
}

class RadioGroupWidgetState extends State<RadioGroupWidget> {
  int _selectValue = -1;
  @override
  void initState() {
    super.initState();
    _selectValue = widget.defaultSelectIndex;
  }

  List<Radio> radios = [];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: widget.direction,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: loadItmes(),
    );
  }

  void updateDefault(int index) {
    setState(() {
      _selectValue = index;
    });
  }

  List<Widget> loadItmes() {
    final items = <Widget>[];
    radios.clear();
    for (int i = 0; i < widget.list.length; i++) {
      final element = widget.list[i];
      Radio radio = Radio<int>(
        activeColor: const Color.fromARGB(255, 29, 153, 93),
        value: i,
        groupValue: _selectValue,
        onChanged: widget.change == null
            ? null
            : (int? value) {
                if (value != _selectValue) {
                  setState(() {
                    _selectValue = value ?? 0;
                  });
                }
                widget.change?.call(value);
              },
      );
      radios.add(radio);
      items.add(Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          radio,
          // SizedBox(width: 5.sp),
          Text(element, style: Config.loadDefaultTextStyle()),
        ],
      ));
      if (i < widget.list.length - 1) {
        items.add(SizedBox(width: 10.sp));
      }
    }
    return items;
  }
}
