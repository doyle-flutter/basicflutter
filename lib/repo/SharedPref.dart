import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  static SharedPreferences sharedPreferences;

  static Future<void> init() async => sharedPreferences = await SharedPreferences.getInstance();

  static const String _A_TOKEN_KEY = "atoken";
  static const String _R_TOKEN_KEY = "rtoken";

  static Future<String> getAToken() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences?.getString(_A_TOKEN_KEY);
  }
  static Future<String> getRToken() async{
    if(sharedPreferences == null) await init();
    return sharedPreferences.getString(_R_TOKEN_KEY);
  }

  static Future<bool> setAToken({@required String aToken}) async{
    if(sharedPreferences == null) await init();
    return await sharedPreferences.setString(_A_TOKEN_KEY, aToken);
  }
  static Future<bool> setRToken({@required String rToken}) async{
    if(sharedPreferences == null) await init();
    return await sharedPreferences.setString(_R_TOKEN_KEY, rToken);
  }
  static Future<bool> deleteToken() async{
    if(sharedPreferences == null) await init();
    return await sharedPreferences.clear();
  }

}