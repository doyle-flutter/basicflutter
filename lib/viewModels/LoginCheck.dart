import 'package:basicflutter/providers/LoginCheckProvider.dart';
import 'package:basicflutter/views/LoadingPage.dart';
import 'package:basicflutter/views/LoginPage.dart';
import 'package:basicflutter/views/MyApp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginCheckProvider _lc = Provider.of<LoginCheckProvider>(context);
    print("_lc.result ${_lc.result}");
    if(_lc.result == null) return new LoadingPage();
    if(_lc.result) return new MyApp();
    return new LoginPage();
  }
}
