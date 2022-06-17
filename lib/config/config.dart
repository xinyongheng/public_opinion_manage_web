import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Config {
  static TextStyle loadAppBarTextStyle() {
    return TextStyle(
      color: Colors.white,
      fontSize: 25.sp,
    );
  }

  static TextStyle loadDefaultTextStyle({Color color = Colors.black}) {
    return TextStyle(
      color: color,
      fontSize: 15.sp,
    );
  }

  static AppBar loadAppbar(String title) {
    return AppBar(
      title: Text(
        title,
        style: loadAppBarTextStyle(),
      ),
      centerTitle: true,
    );
  }

  static TextStyle loadFirstTextStyle() {
    return TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.bold,
      backgroundColor: Colors.yellow,
    );
  }

  static startPage(context, page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  static toast(String data) {
    Fluttertoast.showToast(
        msg: data,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 15.sp);
  }
}
