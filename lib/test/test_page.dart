import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/circle_point.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Config.loadAppbar('测试'),
      body: Center(
        child: Transform.scale(
          scale: 1.5,
          child: Container(
            // color: Colors.yellow,
            width: 300.w,
            height: 300.w,
            child: CirclePointRenderWidget(
              Colors.blue.withOpacity(0.1),
              _value,
              Colors.blue,
              150.w,
              tag: 'lalal',
              onChanged: (value) {
                toast(value.toString());
                setState(() {
                  _value = !_value;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
