import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';

class PressPage extends StatelessWidget {
  final String pressType;
  const PressPage({Key? key, required this.pressType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pressType, style: Config.loadDefaultTextStyle()),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 1515.w,
            maxWidth: 1515.w,
            minHeight: 925.w,
          ),
          child: Text('data'),
        ),
      ),
    );
  }
}

Widget parentContainer(Widget child, {double? height}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(13.w),
    ),
    width: 1515.w,
    height: height,
    child: child,
  );
}

class PressHeadWidget extends StatefulWidget {
  const PressHeadWidget({Key? key}) : super(key: key);

  @override
  State<PressHeadWidget> createState() => _PressHeadWidgetState();
}

class _PressHeadWidgetState extends State<PressHeadWidget> {
  final map = <String, TextEditingController>{};
  late TapGestureRecognizer _tapGestureRecognizer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()..onTap = _resetSelect;
  }

  @override
  Widget build(BuildContext context) {
    return parentContainer(
      Padding(
        padding:
            EdgeInsets.only(left: 38.w, top: 32.w, right: 38.w, bottom: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '舆情筛选',
              style: Config.loadDefaultTextStyle(
                fonstSize: 27.w,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
            SizedBox(height: 26.w),
            SizedBox(height: 21.w),
          ],
        ),
      ),
      height: 925.w,
    );
  }

  Row firstRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        searchItem('description', '事件描述：'),
        SizedBox(width: 44.w),
        searchItem('type', '事件类型：'),
        SizedBox(width: 44.w),
        searchItem('mediaType', '媒体类型：'),
      ],
    );
  }

  Row secondRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        searchItem('publishTime', '发布时间：'),
        SizedBox(width: 44.w),
        searchItem('feedbackTime', '反馈时间：'),
        SizedBox(width: 83.w),
        searchItem('findTime', '发现时间：'),
        SizedBox(width: 33.w),
        sureButton(),
        SizedBox(width: 10.w),
        resetButton(),
      ],
    );
  }

  TextButton sureButton() {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        textStyle: Config.loadDefaultTextStyle(fontWeight: FontWeight.w400),
        minimumSize: const Size(1, 1),
        padding: EdgeInsets.zero,
        fixedSize: Size(89.w, 43.w),
        primary: Colors.white,
        backgroundColor: Config.fontColorSelect,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.w),
        ),
      ),
      child: const Text('确定'),
    );
  }

  TextButton resetButton() {
    return TextButton(
      onPressed: () {
        _resetFilter();
      },
      style: TextButton.styleFrom(
        textStyle: Config.loadDefaultTextStyle(fontWeight: FontWeight.w400),
        minimumSize: const Size(1, 1),
        padding: EdgeInsets.zero,
        fixedSize: Size(89.w, 43.w),
        primary: Config.fontColorSelect,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Color(0xFFD9D9D9),
          ),
          borderRadius: BorderRadius.circular(5.w),
        ),
      ),
      child: const Text('确定'),
    );
  }

  void _resetFilter() {
    map.forEach((key, value) {
      value.text = '';
    });
  }

  Widget searchItem(String key, String explain) {
    final bool dateTag = explain.endsWith('时间');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          explain,
          style: Config.loadDefaultTextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.black.withOpacity(0.85),
          ),
        ),
        SizedBox(
          width: 213.w,
          child: TextField(
            controller: loadController(key),
            decoration: Config.defaultInputDecoration(
                hintText: dateTag ? '年/月/日' : '请输入',
                suffixIcon:
                    dateTag ? Image.asset('images/icon_date.png)') : null),
          ),
        ),
      ],
    );
  }

  TextEditingController loadController(String key) {
    if (!map.containsKey(key)) {
      map[key] = TextEditingController();
    }
    return map[key]!;
  }

  @override
  void dispose() {
    super.dispose();
    map.forEach((key, value) {
      value.dispose();
    });
  }

  Widget selectView(int size) {
    return Padding(
      padding: EdgeInsets.only(left: 43.w, top: 43.w, bottom: 27.w),
      child: Container(
        width: 1429.w,
        height: 53.w,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: const Color(0xFFBAE7FF),
          border: Border.all(color: const Color(0xFFBAE7FF), width: 1.33.w),
          borderRadius: BorderRadius.circular(5.33.w),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 33.w),
            Icon(Icons.info, size: 19.w, color: Config.fontColorSelect),
            SizedBox(width: 11.w),
            Text("$size项"),
            Text.rich(TextSpan(
                text: '已选择',
                style: Config.loadDefaultTextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.65),
                ),
                children: [
                  TextSpan(
                      text: "$size ",
                      style: Config.loadDefaultTextStyle(
                        color: Config.fontColorSelect,
                        fontWeight: FontWeight.w400,
                      )),
                  const TextSpan(text: "项"),
                  TextSpan(
                      text: "空",
                      style: Config.loadDefaultTextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.transparent)),
                  TextSpan(
                      text: "清空",
                      style: Config.loadDefaultTextStyle(
                        color: Config.fontColorSelect,
                        fontWeight: FontWeight.w400,
                      ),
                      recognizer: _tapGestureRecognizer),
                ]))
          ],
        ),
      ),
    );
  }

  ///清空选择的事件
  void _resetSelect() {}
}
