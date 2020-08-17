import 'package:flutter/material.dart';

class SQfliteModel{
  int id;
  String title;
  String des;
  SQfliteModel({@required this.id, @required this.title, @required this.des});
  factory SQfliteModel.fromJson({Map<String, dynamic> e}) => new SQfliteModel(id: e['id'] as int, title: e['title'] as String, des: e['des'] as String);
}