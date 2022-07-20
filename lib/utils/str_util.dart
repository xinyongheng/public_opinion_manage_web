T checkEmpty<T>(T? data, String hint) {
  if (data == null) throw AssertionError(hint);
  if (data is String && data.isEmpty) throw AssertionError(hint);
  if (data is List && data.isEmpty) throw AssertionError(hint);
  if (data is Map && data.isEmpty) throw AssertionError(hint);
  return data;
}
