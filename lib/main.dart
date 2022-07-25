import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/page/login.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:public_opinion_manage_web/utils/info_save.dart';

import 'page/load_dispose_event.dart';

void main() {
  String? info;
  if (kIsWeb) {
    var uri = Uri.dataFromString(window.location.href);
    // print("path=" + uri.path);
    // print(uri.pathSegments);
    if (uri.pathSegments.isNotEmpty &&
        uri.pathSegments.last == 'loadDisposeEvent') {
      var qp = uri.queryParameters;
      //获取参娄数ID，或你要找的参数
      info = qp['info'];
      // print(info);
    }
  }
  runApp(MyApp(value: info));
}

class MyApp extends StatelessWidget {
  final String? value;
  const MyApp({Key? key, this.value}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: Global.navigatorKey,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: const [
            Locale('zh', 'CH'),
            Locale('en', 'US'),
          ],
          locale: const Locale('zh', 'CH'),
          title: '舆情台账',
          builder: EasyLoading.init(builder: (context, child) {
            EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
            EasyLoading.instance.indicatorColor = Colors.blue;
            EasyLoading.instance.backgroundColor = Colors.white;
            EasyLoading.instance.textColor = Colors.black;
            return child!;
          }),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: child,
        );
      },
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      child: !DataUtil.isEmpty(value)
          ? LoadDisposeEventPage(info: value!)
          : const LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: Config.loadAppbar(widget.title),
      body: LoginPage(),
    );
  }
}

class Global {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
}
