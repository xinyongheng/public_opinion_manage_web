import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/data/bean/update_event_bus.dart';
import 'package:public_opinion_manage_web/data/bean/user_bean.dart';
import 'package:public_opinion_manage_web/service/service.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

import 'auto_complete_view.dart';
import 'dialog.dart';

// typedef ListCallback = void Function(List<String> list, String remark);
void showDutyUnitDialog(context, eventId, List<UserData> list) {
  if (list.isEmpty) {
    showNoticeDialog('请创建其他单位账号');
    return;
  }
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          buttonPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // titlePadding: EdgeInsets.only(top: 37.w, bottom: 17.w),
          content: SizedBox(
              width: 374.w,
              child:
                  DutyUnitWidget(width: 294.w, eventId: eventId, list: list)),
        );
      },
      barrierDismissible: false);
}

class DutyUnitWidget extends StatefulWidget {
  final double width;
  final int eventId;
  final List<UserData> list;
  const DutyUnitWidget({
    Key? key,
    required this.width,
    required this.eventId,
    required this.list,
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
        Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Config.finishPage(context);
                },
                splashRadius: 30.w,
                // iconSize: 25.w,
                // color: Colors.black,
                icon: Icon(
                  Icons.close,
                  color: Colors.blue,
                  size: 30.w,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                "\n指定单位\n",
                style: Config.loadDefaultTextStyle(
                  fonstSize: 22.w,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
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
              return SizedBox(
                child: InkWell(
                  onTap: () {
                    int max = dialoControllergMap.length;
                    dialoControllergMap[max.toString()] =
                        TextEditingController();
                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 30.w),
                    child: Text('添加单位',
                        style: Config.loadDefaultTextStyle(
                          color: Config.fontColorSelect,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                ),
              );
            }
            return Row(
              children: [
                SizedBox(width: 30.w),
                // Expanded(child: createTextField(_loadController(index))),
                Expanded(child: childSelectView(_loadController(index))),
                Opacity(
                  opacity: index != 0 ? 1 : 0,
                  child: IconButton(
                    onPressed: index != 0
                        ? () {
                            _loadController(index).dispose();
                            setState(() {
                              dialoControllergMap.remove(index.toString());
                            });
                          }
                        : null,
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
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: TextField(
              controller: remardController,
              maxLines: 3,
              minLines: 3,
              style: Config.loadDefaultTextStyle(
                fontWeight: FontWeight.w400,
                fonstSize: 19.w,
              ),
              decoration: Config.defaultInputDecoration(hintText: '请输入备注（非必填）'),
            ),
          ),
        ),
        SizedBox(height: 20.w),
        link.isEmpty
            ? Center(
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
                        fonstSize: 18.w, fontWeight: FontWeight.w400),
                    padding: EdgeInsets.all(10.w),
                  ),
                  child: const Text('发送链接'),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child:
                    SelectableText(link, style: Config.loadDefaultTextStyle()),
              ),
        SizedBox(height: 30.w),
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

  String loadUserInfo(UserData userData) {
    return "单位：${userData.unit!}\n名称：${userData.nickname}${userData.nickname}${userData.nickname}${userData.nickname}-${userData.account!}";
  }

  Widget childSelectView(TextEditingController controller,
      [String hintText = '请输入责任单位']) {
    return RawAutocomplete<UserData>(
      displayStringForOption: (option) => option.unit!,
      textEditingController: controller,
      focusNode: FocusNode(),
      optionsViewBuilder: (context, onSelected, options) {
        return AutocompleteOptions(
          displayStringForOption: loadUserInfo,
          onSelected: onSelected,
          options: options,
          maxOptionsWidth: 314.w,
        );
      },
      optionsBuilder: (textEditingValue) {
        final v = textEditingValue.text;
        List<UserData> candidates = widget.list;
        return candidates.where(
            (UserData c) => c.unit!.contains(v) || c.nickname!.contains(v));
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          maxLines: 1,
          minLines: 1,
          focusNode: focusNode,
          scrollPadding: EdgeInsets.zero,
          textInputAction: TextInputAction.next,
          style: Config.loadDefaultTextStyle(
            fontWeight: FontWeight.w400,
            fonstSize: 19.w,
          ),
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              gapPadding: 0,
              borderRadius: BorderRadius.circular(5.sp),
              borderSide: const BorderSide(color: Config.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              gapPadding: 0,
              borderRadius: BorderRadius.circular(5.sp),
              borderSide: const BorderSide(color: Config.borderColor),
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 14.w, horizontal: 16.w),
            counterText: '',
            isDense: true,
            hintText: hintText,
            hintStyle: Config.loadDefaultTextStyle(color: Config.borderColor),
          ),
        );
      },
    );
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
      Config.eventBus.fire(UpdateEventListBean()..needUpdate = true);
      setState(() {
        link = ServiceHttp.parentUrl + data['linkPath'];
      });
    });
  }
}
