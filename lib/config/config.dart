import 'package:date_time_picker/date_time_picker.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:public_opinion_manage_web/main.dart';
import 'package:public_opinion_manage_web/page/new_login.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';
import 'package:url_launcher/url_launcher.dart';

class Config {
  static final appBarTitleSize = 30.w;
  static final firstSize = 26.w;
  static final secondSize = 21.w;
  static final defaultSize = 19.w;
  static const fontColorSelect = Color(0xFF3E7BFA);
  static const Color borderColor = Color.fromRGBO(0, 0, 0, 0.15);
  static const mediaTypeArr = [
    '抖音',
    '微博',
    '微信',
    '快手',
    '小红书',
    '百度贴吧',
    '今日头条',
    '西瓜视频'
  ];
  // static const fontColorDefault = Color(0xFF333333);
  static TextStyle loadAppBarTextStyle() {
    return TextStyle(
      color: Colors.white,
      fontSize: appBarTitleSize,
      // height: 1.2,
    );
  }

  static final EventBus eventBus = EventBus();

  static TextStyle loadDefaultTextStyle(
      {Color? color,
      double? fonstSize,
      FontWeight? fontWeight,
      String? fontFamily}) {
    return TextStyle(
      color: color,
      fontSize: fonstSize ?? defaultSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      // height: 1.2,
      // textBaseline: TextBaseline.alphabetic,
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
      // height: 1.1,
    );
  }

  static ButtonStyle loadPerformButtonStyle() {
    return TextButton.styleFrom(
      foregroundColor: Colors.white,
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

  static finishPage(BuildContext context, {bool refresh = false}) {
    Navigator.of(context).pop(refresh);
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

  static defaultInputDecoration({String hintText = '请输入', Widget? suffixIcon}) {
    return InputDecoration(
      border: OutlineInputBorder(
        gapPadding: 0,
        borderRadius: BorderRadius.circular(5.sp),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        gapPadding: 0,
        borderRadius: BorderRadius.circular(5.w),
        borderSide: const BorderSide(color: borderColor),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 14.w, horizontal: 16.w),
      counterText: '',
      isDense: true,
      hintText: hintText,
      suffixIcon: null != suffixIcon
          ? Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: suffixIcon,
            )
          : null,
      suffixIconConstraints: BoxConstraints.expand(width: 29.w, height: 19.w),
      hintStyle: Config.loadDefaultTextStyle(color: borderColor),
    );
  }

  static Widget dateInputView(explain, controller,
      {DateTimePickerType? type,
      DateTime? initialDate,
      Widget? suffixIcon,
      bool readOnly = false}) {
    return DateTimePicker(
      controller: controller,
      readOnly: readOnly,
      type: type ?? DateTimePickerType.dateTime,
      dateMask: type == DateTimePickerType.dateTime
          ? 'yyyy-MM-dd HH:mm'
          : 'yyyy-MM-dd',
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: initialDate,
      textInputAction: TextInputAction.next,
      style: Config.loadDefaultTextStyle(color: Colors.black),
      decoration:
          defaultInputDecoration(hintText: explain, suffixIcon: suffixIcon),
    );
  }

  static TextField textInputView(explain, controller,
      {int? maxLength = 100,
      bool obscureText = false,
      String? counterText,
      int? maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      scrollPadding: EdgeInsets.zero,
      textInputAction: TextInputAction.next,
      style: Config.loadDefaultTextStyle(color: Colors.black),
      obscureText: obscureText,
      decoration: InputDecoration(
        counterText: counterText,
        // label: const Icon(Icons.people),
        // labelText: '请输入$explain',
        border: const OutlineInputBorder(gapPadding: 0),
        contentPadding: EdgeInsets.only(
          left: 5.w,
          right: 20.w,
          top: 22.w,
          bottom: 22.w,
        ),
        // isCollapsed: true,
        isDense: true,
        // helperText: '手机号',
        hintText: "请输入$explain",
        hintStyle: Config.loadDefaultTextStyle(color: Colors.grey),
        // errorText: '错误',
      ),
    );
  }

  static void launch(String urlPath) async {
    final Uri _uri = Uri.parse(urlPath);
    if (!await launchUrl(_uri)) {
      throw 'Could not launch $_uri';
    }
  }

  static Widget pageScaffold(
      {String? title,
      required Widget body,
      ScrollController? scrollController}) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/bg.png"), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //修改颜色
          ),
          title: Text(title ?? '',
              style: Config.loadDefaultTextStyle(
                color: Colors.black,
                fonstSize: Config.appBarTitleSize,
              )),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 30.w),
            child: Container(
              width: 1630.w,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13.w),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: body,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
