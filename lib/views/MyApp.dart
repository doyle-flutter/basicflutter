import 'package:basicflutter/providers/LocalNotiProvider.dart';
import 'package:basicflutter/providers/LoginCheckProvider.dart';
import 'package:basicflutter/providers/SocketProvider.dart';
import 'package:basicflutter/repo/ConnectNode.dart';
import 'package:basicflutter/repo/KakaoLogin.dart';
import 'package:basicflutter/repo/LocalNotification.dart';
import 'package:basicflutter/repo/SharedPref.dart';
import 'package:basicflutter/repo/UserLocation.dart';
import 'package:basicflutter/views/CamPage.dart';
import 'package:basicflutter/views/ImageFilePage.dart';
import 'package:basicflutter/views/SQLPage.dart';
import 'package:basicflutter/views/SQflitePage.dart';
import 'package:basicflutter/views/SocketChatPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
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
  String fcmToken = "";

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    Future.microtask(() async{
      _firebaseMessaging = FirebaseMessaging();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async => print('on message $message'),
        onResume: (Map<String, dynamic> message) async => print('on resume $message'),
        onLaunch: (Map<String, dynamic> message) async => print('on launch $message'),
      );
      return _firebaseMessaging;
    })
      .then((_) async{
        fcmToken = await _.getToken();
        bool result = await ConnectNode.fetchPost<bool>(path: '/fcm/token/save', body: {"token":fcmToken});
        return;
      })
      .then((_) async{
        Map<String, num> _location = await UserLocation.getLocation(context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_localNotification == null) _localNotification = Provider.of<LocalNotiProvider>(context).localNotification..showNoti();
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
        centerTitle: true,
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
            Container(
              margin: EdgeInsets.all(10.0),
              child: StreamBuilder(
                stream: UserLocation.geo.getPositionStream(),
                builder: (context, AsyncSnapshot<Position> snap){
                  if(!snap.hasData) return Container(width:100.0, height:100.0, child: CircularProgressIndicator());
                  return Text("lat : ${snap.data.latitude} / long : ${snap.data.longitude}");
                },
              ),
            ),
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
              child: Text("Push MSG Send"),
              onPressed: () async{
                bool _check;
                if(fcmToken.isEmpty){
                  _check = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("토큰을 읽어볼 수 없습니다, 재부팅 또는 불러오기 버튼을 이용해주세요"),
                        actions: [
                          FlatButton(
                            child: Text("다시 불러오기"),
                            onPressed: ()async{
                              this.fcmToken = await _firebaseMessaging.getToken();
                              Navigator.of(context).pop(true);
                            },
                          )
                        ],
                      )
                  )??false;
                  if(!_check) return;
                }
                await ConnectNode.fetchPost(path: '/fcm/send', body: {'title': "Hi !", 'body':'IOS !', 'token':fcmToken});
              },
            ),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width*0.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              color: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
              textColor: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
              child: Text("Camera View"),
              onPressed: () async => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => new CamPage()
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}