import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
// import 'package:public_opinion_manage_web/page/widget/info_public_opinion.dart';

///创建报刊
class CreatePressType extends StatefulWidget {
  const CreatePressType({Key? key}) : super(key: key);

  @override
  State<CreatePressType> createState() => _CreatePressTypeState();
}

class _CreatePressTypeState extends State<CreatePressType> {
  final _mapController = <String, TextEditingController>{};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Config.loadAppbar('创建报刊'),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searchView(),
            // Expanded(child: ListInfoWidget()),
          ],
        ),
      ),
    );
  }

  // public opinion search
  Column searchView() {
    final arr = ['事件名称', '舆情类别', '舆情报刊类型', '发布时间', '发现时间', '反馈时间'];
    final views = <Widget>[];
    for (String element in arr) {
      views.add(searchItemView(element));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        loadFirstTitle('舆情搜索:'),
        Padding(
          padding: EdgeInsets.only(
              left: Config.defaultSize, top: Config.defaultSize),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 30.sp,
                  children: views,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 30.sp),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.only(
                        left: 30.sp, right: 30.sp, top: 10.sp, bottom: 10.sp),
                    textStyle: Config.loadDefaultTextStyle(),
                  ),
                  child: const Text('筛选'),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  // first title
  Widget loadFirstTitle(data) => Text(data, style: Config.loadFirstTextStyle());
  // secodn title
  Widget loadSecondTitle(data) =>
      Text(data, style: Config.loadDefaultTextStyle());
  Widget searchItemView(data) {
    if (!_mapController.containsKey(data)) {
      _mapController[data] = TextEditingController();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        loadSecondTitle(data),
        Padding(
          padding: EdgeInsets.only(right: 30.sp),
          child: SizedBox(
            width: 200.sp,
            height: 80.sp,
            child: Padding(
              padding: EdgeInsets.only(top: 20.sp, left: 20.sp),
              child: data.contains('时间')
                  ? Config.dateInputView(data, _mapController[data],
                      type: DateTimePickerType.date)
                  : Config.textInputView(data, _mapController[data]),
            ),
          ),
        ),
      ],
    );
  }
}
