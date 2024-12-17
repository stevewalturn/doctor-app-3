import 'dart:convert';
import 'package:stacked/stacked.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService implements InitializableDependency {
  late SharedPreferences _prefs;

  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  Future<void> setJson(String key, Map<String, dynamic> value) async {
    await _prefs.setString(key, json.encode(value));
  }

  Future<Map<String, dynamic>?> getJson(String key) async {
    final data = _prefs.getString(key);
    if (data != null) {
      return json.decode(data) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
}
