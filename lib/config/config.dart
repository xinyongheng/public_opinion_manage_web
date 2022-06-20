import 'package:date_time_picker/date_time_picker.dart';
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

  static TextStyle loadDefaultTextStyle(
      {Color color = Colors.black, double? fonstSize}) {
    return TextStyle(
      color: color,
      fontSize: fonstSize ?? 15.sp,
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

  static TextStyle loadFirstTextStyle({Color? backgroundColor}) {
    return TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.bold,
      backgroundColor: backgroundColor,
    );
  }

  static ButtonStyle loadPerformButtonStyle() {
    return TextButton.styleFrom(
      primary: Colors.white,
      backgroundColor: Colors.blue,
      padding: EdgeInsets.only(
        left: 60.sp,
        top: 15.sp,
        right: 60.sp,
        bottom: 15.sp,
      ),
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

  static Widget dateInputView(explain, controller, {DateTimePickerType? type}) {
    return DateTimePicker(
      controller: controller,
      type: type ?? DateTimePickerType.dateTime,
      dateMask: type == DateTimePickerType.dateTime
          ? 'yyyy-MM-dd HH:mm'
          : 'yyyy-MM-dd',
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      textInputAction: TextInputAction.next,
      style: Config.loadDefaultTextStyle(color: Colors.black),
      decoration: InputDecoration(
        // label: const Icon(Icons.people),
        // labelText: '请输入$explain',
        border: const OutlineInputBorder(gapPadding: 0),
        contentPadding: EdgeInsets.only(
          left: 5.sp,
          right: 20.sp,
        ),
        // helperText: '手机号',
        hintText: "请输入$explain",
        hintStyle: Config.loadDefaultTextStyle(color: Colors.grey),
        // errorText: '错误',
      ),
    );
  }

  static TextField textInputView(explain, controller) {
    return TextField(
      controller: controller,
      maxLength: 100,
      maxLines: 1,
      scrollPadding: EdgeInsets.all(0.sp),
      textInputAction: TextInputAction.next,
      style: Config.loadDefaultTextStyle(color: Colors.black),
      decoration: InputDecoration(
        // label: const Icon(Icons.people),
        // labelText: '请输入$explain',
        border: const OutlineInputBorder(gapPadding: 0),
        contentPadding: EdgeInsets.only(
          left: 5.sp,
          right: 20.sp,
        ),
        // helperText: '手机号',
        hintText: "请输入$explain",
        hintStyle: Config.loadDefaultTextStyle(color: Colors.grey),
        // errorText: '错误',
      ),
    );
  }
}
