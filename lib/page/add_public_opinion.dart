import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';

class AddPublicOpinion extends StatefulWidget {
  const AddPublicOpinion({Key? key}) : super(key: key);

  @override
  State<AddPublicOpinion> createState() => _AddPublicOpinionState();
}

class _AddPublicOpinionState extends State<AddPublicOpinion> {
  final _controllerMap = <String, TextEditingController>{};
  @override
  void initState() {
    super.initState();
    _controllerMap['link'] = TextEditingController();
    _controllerMap['title'] = TextEditingController();
    _controllerMap['create_time'] = TextEditingController();
    _controllerMap['find_time'] = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerMap.forEach((_, value) => value.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Config.loadAppbar('舆情录入'),
      body: Wrap(
        direction: Axis.horizontal,
        children: [
          inputGroupView('舆情名称：', '名称', 'title'),
          inputGroupView('舆情链接：', '链接', 'link'),
          inputGroupView('舆情名称：', '名称', 'title'),
        ],
      ),
    );
  }
  
  Widget inputGroupView(title, explain, key, {double? width}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [firstTitle(title), editText(explain, key, width: width)],
    );
  }

  Widget firstTitle(title) => Text(title, style: Config.loadFirstTextStyle());
  Widget editText(explain, key, {double? width}) {
    return Padding(
      padding: EdgeInsets.only(right: 30.sp),
      child: SizedBox(
        width: width ?? 300.sp,
        child: TextField(
          controller: _controllerMap[key],
          maxLength: 100,
          maxLines: 1,
          scrollPadding: EdgeInsets.all(0.sp),
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            // label: const Icon(Icons.people),
            // labelText: '请输入$explain',
            border: const OutlineInputBorder(gapPadding: 0),
            contentPadding: EdgeInsets.all(0.sp),
            // helperText: '手机号',
            hintText: "请输入$explain",
            // errorText: '错误',
          ),
        ),
      ),
    );
  }

  // 舆情基本信息
  // 舆情相关者
  // 舆情处理

}
