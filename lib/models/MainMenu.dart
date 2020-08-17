import 'package:flutter/material.dart';

class MainMenu{
  String menu;
  void Function(BuildContext context) func;
  MainMenu({@required this.menu, @required this.func})
    :  assert(menu != null), assert(func != null);

  factory MainMenu.fromJson({@required Map<String, dynamic> e})
    => new MainMenu(menu: e['menu'].toString(), func: e['func']);
}