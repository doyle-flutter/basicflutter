import 'package:basicflutter/repo/SharedPref.dart';
import 'package:flutter/material.dart';

class LoginCheckProvider with ChangeNotifier{
  bool result;

  LoginCheckProvider(){
    Future.microtask(() async => await check());
  }

  Future<void> check() async{
    try{
      String _value = await SharedPref?.getAToken() ?? null;
      if(_value == null){
        this.result = false;
      }
      else{
        this.result = true;
      }
    }
    catch(e){
      this.result = false;
    }
    notifyListeners();
    return;
  }

  Future<void> reset() async{
    await SharedPref.deleteToken();
    //await check();
    this.result = false;
    notifyListeners();
    return;
  }
}