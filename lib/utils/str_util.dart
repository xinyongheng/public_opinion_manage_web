T checkEmpty<T>(T? data, String hint) {
  if (data == null) throw AssertionError(hint);
  if (data is String && data.isEmpty) throw AssertionError(hint);
  if (data is List && data.isEmpty) throw AssertionError(hint);
  if (data is Map && data.isEmpty) throw AssertionError(hint);
  return data;
}

String formatNum(double num, int fractionDigits) {
  if ((num.toString().length - num.toString().lastIndexOf(".") - 1) <
      fractionDigits) {
    //小数点后有几位小数
    return num.toStringAsFixed(fractionDigits)
        .substring(0, num.toString().lastIndexOf(".") + fractionDigits + 1)
        .toString();
  } else {
    return num.toString()
        .substring(0, num.toString().lastIndexOf(".") + fractionDigits + 1)
        .toString();
  }
}
