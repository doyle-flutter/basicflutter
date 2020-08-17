import 'package:basicflutter/providers/LocalNotiProvider.dart';
import 'package:basicflutter/providers/LoginCheckProvider.dart';
import 'package:basicflutter/providers/SocketProvider.dart';
import 'package:basicflutter/repo/ConnectNode.dart';
import 'package:basicflutter/repo/KakaoLogin.dart';
import 'package:basicflutter/repo/LocalNotification.dart';
import 'package:basicflutter/repo/SharedPref.dart';
import 'package:basicflutter/views/ImageFilePage.dart';
import 'package:basicflutter/views/SQLPage.dart';
import 'package:basicflutter/views/SQflitePage.dart';
import 'package:basicflutter/views/SocketChatPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  LocalNotification _localNotification;

  SocketProvider _socket;
  LoginCheckProvider _lc;
  FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {
    Future.microtask(() async{
      _firebaseMessaging = FirebaseMessaging();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('on message $message');
        },
        onResume: (Map<String, dynamic> message) async {
          print('on resume $message');
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('on launch $message');
        },
      );
      return _firebaseMessaging;
    }).then((_) async{
      String token = await _.getToken();
      bool result = await ConnectNode.fetchPost<bool>(path: '/fcm/token/save', body: {"token":token});
      return;
    });
    super.initState();
  }

// IOS
  @override
  Widget build(BuildContext context) {
//    if(_localNotification == null) _localNotification = Provider.of<LocalNotiProvider>(context).localNotification..showNoti();
    if(_localNotification == null) _localNotification = Provider.of<LocalNotiProvider>(context).localNotification;
    // SocketPage가 아닌 다른 뷰에서 활용한 내용(임시) : And/IOS 테스크까지는 동작하지만 완전 종료(백그라운드)에서는 동작하지 않습니
    if(_socket == null) _socket = Provider.of<SocketProvider>(context)
      ..socket.on('chatsYou', (data) {
        Future.microtask(() async => await _localNotification.showNoti(des: data['des']));
        return;
      });
    if(_lc == null) _lc = Provider.of<LoginCheckProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("with Node.js"),
        backgroundColor: Colors.grey,
        actions: [
          IconButton(
            icon: Icon(Icons.check_box),
            onPressed: () async{
              await showModalBottomSheet(
                context: context,
                builder: (context) => BottomSheet(
                  onClosing: () => false,
                  builder: (context) => Container(
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("카카오 로그인 회원"),
                        RaisedButton(
                          child: Text("로그아웃"),
                          onPressed: () async{
                            Map<String, dynamic> result = await new KakaoLogin().logout(context: context,at: await SharedPref.getAToken());
                            await _lc.reset();
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                )
              );
            },
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width*0.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              color: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
              textColor: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
              child: Text("SQL Page"),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => new SQLPage())
              ),
            ),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width*0.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              color: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
              textColor: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
              child: Text("LocalDB : SQflite Page"),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => new SQflitePage()
                )
              ),
            ),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width*0.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              color: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
              textColor: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
              child: Text("SocketChat Page"),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => new SocketChatPage()
                )
              ),
            ),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width*0.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              color: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
              textColor: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
              child: Text("Image File Page\n(IOS : 기기 테스트)"),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => new ImageFilePage()
                )
              ),
            ),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width*0.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              color: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
              textColor: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
              child: Text("Push MSG(FCM) And -> IOS"),
              onPressed: () async => await ConnectNode.fetchPost(path: '/fcm/send', body: {'title': "Hi !", 'body':'IOS !'}),
            ),
          ],
        ),
      ),
    );
  }
}