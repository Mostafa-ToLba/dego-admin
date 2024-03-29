
/*
class CacheHelper{
  static SharedPreferences? sharedPreferences ;

  static Future init() async{
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static dynamic getData(String  key)  {
    print('KEY :: $key');
    init();
    return  sharedPreferences?.get(key);
  }

  static Future<bool?> saveData(
    { 
      required String key,
      dynamic value
      }
      ) async {
    init();
    print('SAVED');
    if(value is String) return await sharedPreferences?.setString(key, value);
    if(value is int) return await sharedPreferences?.setInt(key, value);
    if(value is bool) return await sharedPreferences?.setBool(key, value);
    return await sharedPreferences?.setDouble(key, value);


  }

  static dynamic removeData(
      String token
      ){
    return sharedPreferences?.clear();
  }
}
class CacheErrorException implements Exception{}

class LocalDataSourceProvider {
  final SharedPreferences sharedPreferences;
  //final String key = 'TRIVIA_CACHE_DATA';
  LocalDataSourceProvider({required this.sharedPreferences});
  Future<void> cacheLocalDataSource(String key, Object objectModel) async {
    await sharedPreferences.setString(
      key,
      json.encode(objectModel),
    );
  }

  Future<Object> getLocalDataSource(String key) {
    final result = sharedPreferences.getString(key);
    if (result != null) {
      return Future.value(result);
    } else {
      throw CacheErrorException();
    }
  }
}

 */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Keys {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
}


class PrefKeys {
  static const String TOKEN = 'token';
  static const String REFRESH_TOKEN = 'refresh_token';
  static const String ONBOARDING = "on_boarding";
  static const String isDeviceTokenAdded = "isDeviceTokenAdded" ;
  static const String educationLevel = "educationLevel" ;
}

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putBoolean({
    required String key,
    required bool value,
  }) async {
    return await sharedPreferences.setBool(key, value);
  }

  static Future<bool> SaveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is bool) return await sharedPreferences.setBool(key, value);
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);

    return await sharedPreferences.setDouble(key, value);
  }

  static saveUserData({
    required dynamic value,
  }) async {
    String encodedMap = json.encode(value);
    await sharedPreferences.setString('kcashedUserData', encodedMap);
  }


  static dynamic getData({
    required String key,
  }) {
    return sharedPreferences.get(key);
  }

  static Future<bool> removeData({
    required String key,
  }) async {
    return await sharedPreferences.remove(key);
  }

  static Future<bool> clearAll() async {
    return await sharedPreferences.clear();
  }

}