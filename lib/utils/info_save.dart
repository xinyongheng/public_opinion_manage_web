import 'package:shared_preferences/shared_preferences.dart';

class DataUtil {
  static isEmpty(Object? data) {
    if (null == data) return true;
    switch (data.runtimeType) {
      case String:
        return (data as String).isEmpty;
      case List:
        return (data as List).isEmpty;
      case Map:
        return (data as Map).isEmpty;
      default:
        return false;
    }
  }
}

class InfoSaveUtil {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<bool> save(String key, dynamic content) async {
    if (content is String) {
      return await (await _prefs).setString(key, content);
    }
    if (content is int) {
      return await (await _prefs).setInt(key, content);
    }
    if (content is bool) {
      return await (await _prefs).setBool(key, content);
    }
    if (content is double) {
      return await (await _prefs).setDouble(key, content);
    }
    if (content is List<String>) {
      return await (await _prefs).setStringList(key, content);
    }
    return Future<bool>.value(false);
  }

  static Future<String?> getString(String key) async {
    return (await _prefs).getString(key);
  }

  static Future<int?> getInt(String key) async {
    return (await _prefs).getInt(key);
  }

  static Future<double?> getDouble(String key) async {
    return (await _prefs).getDouble(key);
  }

  static Future<bool> clear() async {
    return await (await _prefs).clear();
  }
}
