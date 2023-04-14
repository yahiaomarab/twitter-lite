import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{
  static late SharedPreferences prefs;


  static  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    return prefs.getBool(key) ?? defaultValue;
  }

  static Future<void> setBool(String key, bool value) async {
    await prefs.setBool(key, value);
  }

  static Future<int> getInt(String key, {int defaultValue = 0}) async {
    return prefs.getInt(key) ?? defaultValue;
  }

  static Future<void> setInt(String key, int value) async {
    await prefs.setInt(key, value);
  }

  static Future<double> getDouble(String key, {double defaultValue = 0.0}) async {
    return prefs.getDouble(key) ?? defaultValue;
  }

  static Future<void> setDouble(String key, double value) async {
    await prefs.setDouble(key, value);
  }

  static  Future<String> getString(String key, {String defaultValue = ""}) async {
    return prefs.getString(key) ?? defaultValue;
  }

  static Future<void> setString(String key, String value) async {
    await prefs.setString(key, value);
  }

  static Future<List<String>> getStringList(String key,
      {List<String> defaultValue = const []}) async {
    return prefs.getStringList(key) ?? defaultValue;
  }

  Future<void> setStringList(String key, List<String> value) async {
    await prefs.setStringList(key, value);
  }

  static  Future<void> remove(String key) async {
    await prefs.remove(key);
  }

  Future<void> clear() async {
    await prefs.clear();
  }
}