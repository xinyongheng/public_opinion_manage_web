import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///自带删除键的ClearTextField
typedef void ITextFieldCallBack(String content);

enum ITextInputType {
  text,
  multiline,
  number,
  phone,
  datetime,
  emailAddress,
  url,
  password
}

class ClearTextField extends StatefulWidget {
  final ITextInputType keyboardType;
  final int maxLines;
  final int maxLength;
  final String labelText;
  final String hintText;
  final TextStyle hintStyle;
  final Icon deleteIcon;
  final InputBorder inputBorder;
  final Widget prefixIcon;
  final TextStyle textStyle;
  final ITextFieldCallBack fieldCallBack;
  final FormFieldValidator<String> validator;

  ClearTextField({
    Key? key,
    ITextInputType keyboardType: ITextInputType.text,
    this.maxLines = 1,
    required this.maxLength,
    required this.labelText,
    required this.hintText,
    required this.hintStyle,
    required this.deleteIcon,
    required this.inputBorder,
    required this.textStyle,
    required this.prefixIcon,
    required this.fieldCallBack,
    required this.validator,
  })  : assert(maxLines == null || maxLines > 0),
        assert(maxLength == null || maxLength > 0),
        keyboardType = maxLines == 1 ? keyboardType : ITextInputType.multiline,
        super(key: key);

  @override
  _ClearTextFieldState createState() {
    return _ClearTextFieldState();
  }
}

class _ClearTextFieldState extends State<ClearTextField> {
  String _inputText = "";
  bool _hasDeleteIcon = false;
  bool _hasFocus = false;
  bool _isNumber = false;
  bool _isPassword = false;

  ///输入类型
  TextInputType? _getTextInputType() {
    switch (widget.keyboardType) {
      case ITextInputType.text:
        return TextInputType.text;
      case ITextInputType.multiline:
        return TextInputType.multiline;
      case ITextInputType.number:
        _isNumber = true;
        return TextInputType.number;
      case ITextInputType.phone:
        _isNumber = true;
        return TextInputType.phone;
      case ITextInputType.datetime:
        return TextInputType.datetime;
      case ITextInputType.emailAddress:
        return TextInputType.emailAddress;
      case ITextInputType.url:
        return TextInputType.url;
      case ITextInputType.password:
        _isPassword = true;
        return TextInputType.text;
      default:
        return null;
    }
  }

  ///输入框焦点控制
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_focusNodeListener);
  }

  Future<Null> _focusNodeListener() async {
    if (_focusNode.hasFocus) {
      setState(() {
        _hasFocus = true;
      });
    } else {
      setState(() {
        _hasFocus = false;
      });
    }
  }

  ///输入范围
  List<TextInputFormatter>? _getTextInputFormatter() {
    return _isNumber
        ? <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ]
        : null;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = new TextEditingController.fromValue(
        TextEditingValue(
            text: _inputText,
            selection: TextSelection.fromPosition(TextPosition(
                affinity: TextAffinity.downstream,
                offset: _inputText.length))));
    TextField textField = TextField(
      focusNode: _focusNode,
      controller: _controller,
      decoration: InputDecoration(
        hintStyle: widget.hintStyle,
        counterStyle: TextStyle(color: Colors.white),
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: widget.inputBorder != null
            ? widget.inputBorder
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.green),
              ),
        fillColor: Colors.transparent,
        filled: true,
        prefixIcon: widget.prefixIcon,
        suffixIcon: _hasDeleteIcon && _hasFocus
            ? new Container(
                width: 20.0,
                height: 20.0,
                child: new IconButton(
                  alignment: Alignment.center,
                  padding: new EdgeInsets.all(0.0),
                  iconSize: 18.0,
                  icon: widget.deleteIcon != null
                      ? widget.deleteIcon
                      : Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      _inputText = "";
                      _hasDeleteIcon = _inputText.isNotEmpty;
                      widget.fieldCallBack(_inputText);
                    });
                  },
                ),
              )
            : new Text(""),
      ),
      onChanged: (str) {
        setState(() {
          _inputText = str;
          _hasDeleteIcon = _inputText.isNotEmpty;
          widget.fieldCallBack(_inputText);
        });
      },
      onSubmitted: (str) {
        widget.fieldCallBack(_inputText);
        setState(() {
          _hasFocus = false;
        });
      },
      keyboardType: _getTextInputType(),
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      style: widget.textStyle,
      obscureText: _isPassword,
      inputFormatters: _getTextInputFormatter(),
    );
    return textField;
  }
}
