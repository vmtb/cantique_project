import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> savePreference(String key, String value) async{
  final prefs = await SharedPreferences.getInstance();
  return prefs.setString(key, value);
}

Future<String?> getPreference(String key) async{
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

