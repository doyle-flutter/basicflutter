import 'package:flutter/material.dart';

class KakaoLoginModel{
  String aToken;
  String rToken;

  KakaoLoginModel({@required this.aToken, @required this.rToken});

  factory KakaoLoginModel.fromMap({Map<String,dynamic> userInfo})
    => new KakaoLoginModel(aToken: userInfo['at'] as String, rToken: userInfo['rt'] as String);
}