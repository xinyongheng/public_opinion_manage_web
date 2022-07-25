import 'package:flutter/material.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/service/service.dart';

class MyTestPage extends StatefulWidget {
  const MyTestPage({Key? key}) : super(key: key);

  @override
  State<MyTestPage> createState() => _MyTestPageState();
}

class _MyTestPageState extends State<MyTestPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextButton(
            onPressed: () => click(),
            child: Text(
              '测试',
              style: Config.loadDefaultTextStyle(),
            )));
  }

  click() {
    ServiceHttp().post(
      '/statisticsEvent',
      data: {'startDate': '2022-07-01', 'endDate': '2022-07-22'},
      success: (data) {
        data['rows'].forEach((e) {
          print(e['utime']);
        });
      },
    );
  }
}
