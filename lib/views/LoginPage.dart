import 'package:basicflutter/models/KakaoLoginModel.dart';
import 'package:basicflutter/providers/LoginCheckProvider.dart';
import 'package:basicflutter/repo/KakaoLogin.dart';
import 'package:basicflutter/repo/SharedPref.dart';
import 'package:basicflutter/views/MyApp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginCheckProvider _lc = Provider.of<LoginCheckProvider>(context);
    return Scaffold(
      body: Container(
        child: Container(
          child: Center(
            child: RaisedButton(
              child: Text("카카오톡 로그인"),
              onPressed: () async{
               print("Login1");
               Map<String, dynamic> result = await KakaoLogin()?.login(context: context);
               print("Login2");
               if(result == null) return showDialog(
                 context: context,
                 builder: (context) => AlertDialog(
                   title: Text("로그인 실패"),
                 )
               );
               KakaoLoginModel _kakaoLoginModel = KakaoLoginModel.fromMap(userInfo: result);
               bool _aTokenCheck = await SharedPref.setAToken(aToken: _kakaoLoginModel.aToken);
               bool _rTokenCheck = await SharedPref.setRToken(rToken: _kakaoLoginModel.rToken);
               if(!_aTokenCheck || !_rTokenCheck) return;
               await _lc.check();
               return;
              },
            ),
          ),
        ),
      ),
    );
  }
}
