import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:public_opinion_manage_web/main.dart';
import 'package:public_opinion_manage_web/page/login.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

class Config {
  static final appBarTitleSize = 50.sp;
  static final firstSize = 40.sp;
  static final secondSize = 35.sp;
  static final defaultSize = 30.sp;

  static TextStyle loadAppBarTextStyle() {
    return TextStyle(
      color: Colors.white,
      fontSize: appBarTitleSize,
    );
  }

  static TextStyle loadDefaultTextStyle({Color? color, double? fonstSize}) {
    return TextStyle(
      color: color,
      fontSize: fonstSize ?? defaultSize,
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
      fontSize: firstSize,
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

  static startPage(BuildContext context, page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  static startPageAndFinishOther(context, page) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (content) => page));
  }

  static finishPage(BuildContext context) {
    Navigator.of(context).pop();
  }

  static startLoginPage() {
    Global.navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) => const LoginPage(
              comeFrom: UserUtil.reLogin,
            )));
    // Global.navigatorKey.currentState!.pushAndRemoveUntil(
    //     MaterialPageRoute(
    //       builder: (context) => const LoginPage(
    //         comeFrom: UserUtil.reLogin,
    //       ),
    //     ),
    //     (route) => false);
  }

  static toast(String data) {
    Fluttertoast.showToast(
        msg: data,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: firstSize);
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
          top: 5.sp,
          bottom: 5.sp,
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
