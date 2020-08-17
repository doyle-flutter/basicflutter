import 'package:flutter/material.dart';

class SQLReadModel{
  int id;
  String title;
  String des;
  String created;

  SQLReadModel({@required this.id, @required this.title, @required this.des, @required this.created});

  factory SQLReadModel.fromJson({@required dynamic e})
    => new SQLReadModel(id: e['id'], title: e['title'], des: e['des'], created: e['created']);
}