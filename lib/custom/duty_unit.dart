import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/service/service.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

import 'dialog.dart';

// typedef ListCallback = void Function(List<String> list, String remark);
void showDutyUnitDialog(context, eventId) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "指定单位",
              style: Config.loadDefaultTextStyle(
                fonstSize: 19.w,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          titlePadding: EdgeInsets.only(top: 37.w, bottom: 17.w),
          content: SizedBox(
              width: 374.w,
              child: DutyUnitWidget(width: 294.w, eventId: eventId)),
        );
      });
}

class DutyUnitWidget extends StatefulWidget {
  final double width;
  final int eventId;
  const DutyUnitWidget({
    Key? key,
    required this.width,
    required this.eventId,
  }) : super(key: key);

  @override
  State<DutyUnitWidget> createState() => _DutyUnitWidgetState();
}

class _DutyUnitWidgetState extends State<DutyUnitWidget> {
  final dialoControllergMap = <String, TextEditingController>{};
  final TextEditingController remardController = TextEditingController();
  String link = '';
  @override
  void initState() {
    _loadController(0);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    dialoControllergMap.forEach((key, value) => value.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              height: 20.w,
              thickness: 20.w,
              color: Colors.transparent,
            );
          },
          itemBuilder: (context, index) {
            if (index == dialoControllergMap.length) {
              return InkWell(
                onTap: () {
                  int max = dialoControllergMap.length;
                  dialoControllergMap[max.toString()] = TextEditingController();
                  setState(() {});
                },
                child: Text('添加',
                    style: Config.loadDefaultTextStyle(
                      color: Config.fontColorSelect,
                      fontWeight: FontWeight.w400,
                    )),
              );
            }
            return Row(
              children: [
                SizedBox(
                  width: widget.width,
                  child: createTextField(_loadController(index)),
                ),
                Visibility(
                  visible: index != 0,
                  child: IconButton(
                    onPressed: () {
                      _loadController(index).dispose();
                      setState(() {
                        dialoControllergMap.remove(index.toString());
                      });
                    },
                    icon: Icon(
                      Icons.close,
                      size: 30.w,
                    ),
                  ),
                ),
              ],
            );
          },
          itemCount: dialoControllergMap.length + 1,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        ),
        SizedBox(height: 20.w),
        SizedBox(
          width: widget.width + 100.w,
          child: TextField(
            controller: remardController,
            maxLines: 5,
            minLines: 5,
            style: Config.loadDefaultTextStyle(
              fontWeight: FontWeight.w400,
              fonstSize: 19.w,
            ),
            decoration: Config.defaultInputDecoration(hintText: '请输入备注（非必填）'),
          ),
        ),
        SizedBox(height: 20.w),
        Center(
          child: TextButton(
            onPressed: link.isEmpty
                ? () {
                    makeLink();
                  }
                : null,
            style: TextButton.styleFrom(
              enableFeedback: true,
              primary: Colors.white,
              backgroundColor: Config.fontColorSelect,
              textStyle: Config.loadDefaultTextStyle(
                  fonstSize: 19.w, fontWeight: FontWeight.w400),
              padding: EdgeInsets.all(8.w),
            ),
            child: const Text('发送链接'),
          ),
        )
      ],
    );
  }

  TextField createTextField(controller) {
    return TextField(
      controller: controller,
      style: Config.loadDefaultTextStyle(
        fontWeight: FontWeight.w400,
        fonstSize: 19.w,
      ),
      decoration: Config.defaultInputDecoration(hintText: '请输入责任单位'),
    );
  }

  TextEditingController _loadController(int index) {
    String key = index.toString();
    if (!dialoControllergMap.containsKey(key)) {
      dialoControllergMap[key] = TextEditingController();
    }
    return dialoControllergMap[key]!;
  }

  List<String> _checkUnit() {
    List<String> list = [];
    dialoControllergMap.forEach((key, controller) {
      final text = controller.value.text;
      if (text.isEmpty) {
        throw AssertionError("请补充第$key个责任单位信息");
      }
      list.add(text);
    });
    return list;
  }

  void makeLink() {
    try {
      List<String> list = _checkUnit();
      askInternetDutyUnit(list, remardController.text);
    } catch (err) {
      toast((err as AssertionError).message.toString());
    }
  }

  void askInternetDutyUnit(List list, String remark) async {
    String api = "/assignedDutyUnit";
    final map = <String, dynamic>{};
    map["userId"] = await UserUtil.getUserId();
    map["eventId"] = widget.eventId;
    map["dutyUnitList"] = list;
    if (remark.isNotEmpty) {
      map["manageRemark"] = remark;
    }
    ServiceHttp().post(api, data: map, success: (data) {
      // setState(() {
      //   link = data['linkPath'];
      // });
    });
  }
}
