import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/custom/radio_group.dart';
import 'package:public_opinion_manage_web/data/bean/deal_with_content.dart';
import 'package:public_opinion_manage_web/data/bean/user_bean.dart';

import 'auto_complete_view.dart';

///管理员选择事件 指定处理方式
void showSelectDutyUnitDialog(
  BuildContext context, {
  String? first,
  String? second,
  GestureTapCallback? onTapDuty,
  GestureTapCallback? onTapDealWith,
}) {
  showCenterNoticeDialog(
    context,
    isNeedTitle: true,
    title: '选择处理方式',
    isNeedActions: false,
    contentWidget:
        _loadDialogWidget(context, onTapDuty, onTapDealWith, first, second),
  );
}

Widget _loadDialogWidget(context, GestureTapCallback? onTapDuty,
    GestureTapCallback? onTapDealWith, String? first, String? second) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      _itemWidth(context, first ?? '仅指定单位', onTapDuty),
      const SizedBox(height: 10),
      Container(
        height: 1,
        color: Config.borderColor,
      ),
      const SizedBox(height: 10),
      _itemWidth(context, second ?? '指定单位并处理', onTapDealWith),
    ],
  );
}

Widget _itemWidth(
    BuildContext context, String text, GestureTapCallback? onTap) {
  return InkWell(
    onTap: () {
      Config.finishPage(context);
      onTap?.call();
    },
    child: Text(
      text,
      style: Config.loadDefaultTextStyle(),
    ),
  );
}

typedef DutyUnitChanged<T, M> = void Function(T value, M m);

///管理员添加处理单位
showAddDutyUnitDialog(
    BuildContext context,
    TextEditingController controllerUnit,
    TextEditingController controllerContent,
    TextEditingController feedbackTimeController,
    List<UserData> searchList,
    DealWithContent? bean,
    {DutyUnitChanged<List<String>, DealWithContent?>? onSure}) {
  bool onlyRead = bean?.onlyRead ?? false;
  bool onlyReadForUnit = bean?.onlyReadForUnit ?? false;
  showCenterNoticeDialog(
    context,
    isNeedTitle: true,
    clickDismiss: false,
    barrierDismissible: false,
    title: '添加处理单位以及内容',
    contentWidget: _dutyUnitView(
        controllerUnit,
        controllerContent,
        feedbackTimeController,
        searchList,
        bean?.isMainUnit == true,
        onlyRead,
        onlyReadForUnit),
    onPress: () {
      String unit = controllerUnit.text;
      String content = controllerContent.text;
      String feedbackTime = feedbackTimeController.text;
      if (unit.isEmpty) {
        showNoticeDialog('请输入单位名称');
        return;
      }
      if (content.isEmpty) {
        showNoticeDialog('请输入处理内容');
        return;
      }
      if (feedbackTime.isEmpty) {
        showNoticeDialog('请选择反馈时间');
        return;
      }
      controllerUnit.clear();
      controllerContent.clear();
      feedbackTimeController.clear();
      Navigator.of(context).pop(true);
      onSure?.call([unit, content, feedbackTime], bean);
    },
  );
}

int _selectIndex = 1;

Widget feedbackTimeView(feedbackTimeController, readOnly) {
  return SizedBox(
    width: 624.w,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Text('反馈时间；', style: Config.loadDefaultTextStyle()),
        Expanded(
          child: Config.dateInputView('请设置反馈时间', feedbackTimeController,
              type: DateTimePickerType.date, readOnly: readOnly),
        ),
      ],
    ),
  );
}

Widget _dutyUnitView(
    controllerUnit,
    controllerContent,
    feedbackTimeController,
    List<UserData> searchList,
    bool mainUnit,
    bool onlyRead,
    bool onlyReadForUnit) {
  var borderColor = Config.borderColor;
  _selectIndex = mainUnit ? 0 : 1;
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      //主要负责单位
      //_setMainUnitView(defaultSelectIndex: _selectIndex),
      //反馈时间
      feedbackTimeView(feedbackTimeController, onlyRead),
      SizedBox(height: 20.w),
      //可以输入可以选择的输入框，
      SizedBox(
        width: 624.w,
        child: RawAutocomplete<UserData>(
          textEditingController: controllerUnit,
          displayStringForOption: (option) => option.unit!,
          focusNode: FocusNode(),
          optionsBuilder: (textEditingValue) {
            final v = textEditingValue.text;
            final candidates = searchList;
            return candidates.where((UserData c) => c.unit!.contains(v));
          },
          optionsViewBuilder: (context, onSelected, options) {
            return AutocompleteOptions(
              displayStringForOption: (UserData userData) =>
                  "单位：${userData.unit!}\n名称：${userData.nickname}-${userData.account!}",
              onSelected: onSelected,
              options: options,
              maxOptionsWidth: 500.w,
              maxOptionsHeight: 314.w,
            );
          },
          fieldViewBuilder: (BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted) {
            //_controllerMap['type'] = textEditingController;
            return TextFormField(
              readOnly: onlyRead || onlyReadForUnit,
              controller: textEditingController,
              focusNode: focusNode,
              maxLines: 1,
              minLines: 1,
              scrollPadding: EdgeInsets.zero,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (String value) {
                onFieldSubmitted();
              },
              style: Config.loadDefaultTextStyle(color: Colors.black),
              decoration: decoration(borderColor, "请输入单位名称"),
            );
          },
        ),
      ),
      SizedBox(height: 30.w),
      //可输入内容的文本框
      SizedBox(
        width: 624.w,
        child: _textField(
          controllerContent,
          borderColor,
          readOnly: onlyRead,
          maxLinex: 5,
          minLine: 5,
        ),
      )
    ],
  );
}

TextField _textField(TextEditingController controller, Color borderColor,
    {int? maxLinex = 1, int? minLine = 1, bool readOnly = false}) {
  return TextField(
    readOnly: readOnly,
    controller: controller,
    maxLines: maxLinex,
    minLines: minLine,
    scrollPadding: EdgeInsets.zero,
    // textInputAction: TextInputAction.done,
    style: Config.loadDefaultTextStyle(color: Colors.black),
    decoration: decoration(borderColor, '请输入事件处理内容'),
  );
}

InputDecoration decoration(Color borderColor, String hint) {
  return InputDecoration(
    border: OutlineInputBorder(
      gapPadding: 0,
      borderRadius: BorderRadius.circular(5.sp),
      borderSide: BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      gapPadding: 0,
      borderRadius: BorderRadius.circular(5.sp),
      borderSide: BorderSide(color: borderColor),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 14.w, horizontal: 16.w),
    counterText: '',
    isDense: true,
    hintText: hint,
    hintStyle: Config.loadDefaultTextStyle(color: borderColor),
  );
}
