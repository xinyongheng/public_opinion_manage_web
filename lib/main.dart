import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
// import 'package:public_opinion_manage_web/custom/histogram.dart';

import 'package:public_opinion_manage_web/utils/info_save.dart';
import 'page/new_login.dart' as newLogin;
import 'package:universal_html/html.dart' show window;

import 'page/widget/load_dispose_event.dart';

void main() {
  String? info;
  if (kIsWeb) {
    var uri = Uri.dataFromString(window.location.href);
    /* print("path=" + uri.path);
    print("pathSegments=${uri.pathSegments}");
    if (uri.pathSegments.isNotEmpty) {
      print("last=${uri.pathSegments.last}");
      for (String element in uri.pathSegments) {
        print(element);
      }
      print("***************");
      print("queryParameters=${uri.queryParameters}");
      潘国珍 25
    } */
    var qp = uri.queryParameters;
    //获取参娄数ID，或你要找的参数
    info = qp['info'];
    print(info);
  }
  // info =
  //     'LZd32Y36MnXQLZ%2BNT78HPOfn9l9GTL6gjMh%2B%2F%2FWzJ%2Bacz6bwi3O%2B2o3Xjg9Y4klfcosB2fmFD0TmrCeqZrW%2BQeZLimeY5ZBucTSn0a%2BgQjJ7w4tN7I86tcLYouMskMgq%2Bqe6WMfhAcREpnu7SjmpyA%3D%3D';
  runApp(MyApp(value: info));
  // SystemUiOverlayStyle systemUiOverlayStyle =
  //     const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  // SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
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
            // Locale('zh', 'CH'),
            // Locale('en', 'US'),
            Locale("zh", "CN"),
            Locale.fromSubtags(
                languageCode: 'zh', scriptCode: 'Hant', countryCode: 'HK'),
            Locale('zh'),
            Locale.fromSubtags(
                languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW'),
            Locale('en')
          ],
          locale: const Locale('zh', 'CH'),
          title: '智慧网信系统',
          builder: EasyLoading.init(builder: (context, child) {
            EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
            EasyLoading.instance.indicatorColor = Colors.blue;
            EasyLoading.instance.backgroundColor = Colors.white;
            EasyLoading.instance.textColor = Colors.black;
            return child!;
          }),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Config.fontColorSelect,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            fontFamily: 'PingFang',
          ),
          home: child,
        );
      },
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      child: //const HistogramWidget()
          !DataUtil.isEmpty(value)
              ? LoadDisposeEventPage(info: value!)
              : const newLogin.LoginPage(),
    );
  }
}

//http://192.168.1.9:8249/
//loadDisposeEvent?info=LZd32Y36MnXQLZ%2BNT78HPOfn9l9GTL6gjMh%2B%2F%2FWzJ%2Bacz6bwi3O%2B2o3Xjg9Y4klfcosB2fmFD0TmrCeqZrW%2BQeZLimeY5ZBucTSn0a%2BgQjJ7w4tN7I86tcLYouMskMgq%2Bqe6WMfhAcREpnu7SjmpyA%3D%3D
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _color = Colors.yellow;
  var _height = 200.0;
  var _width = 200.0;
  var _showFirst = true;
  var _textColor = Colors.red;
  var _textFront = 20.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: Config.loadAppbar(widget.title),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  color: _color,
                  width: _width,
                  height: _height,
                ),
                TextButton(
                  onPressed: () {
                    _color = Colors.red;
                    _height = 400.0;
                    _width = 400.0;
                    setState(() {});
                  },
                  child: const Text('开始动画'),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedCrossFade(
                  duration: const Duration(seconds: 2),
                  firstChild: const FlutterLogo(
                    style: FlutterLogoStyle.horizontal,
                    size: 100,
                  ),
                  secondChild: const FlutterLogo(
                    style: FlutterLogoStyle.stacked,
                    size: 100,
                  ),
                  crossFadeState: _showFirst
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showFirst = !_showFirst;
                    });
                  },
                  child: const Text('开始动画'),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedDefaultTextStyle(
                  style: TextStyle(
                    color: _textColor,
                    fontSize: _textFront,
                    height: 1.2,
                  ),
                  duration: const Duration(seconds: 1),
                  child: const Text('文字演示'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _textColor = Colors.blue;
                      _textFront = 40.0;
                    });
                  },
                  child: const Text('开始动画'),
                ),
              ],
            ),
            SizedBox(
              width: 300.0,
              child: PageView.builder(
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Container(
                    color: _color,
                    alignment: Alignment.center,
                    child: Text('测试数组-$index'),
                  );
                },
                itemCount: 230,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Global {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
}
