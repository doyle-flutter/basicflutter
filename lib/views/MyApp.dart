import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:basicflutter/main.dart';
import 'package:basicflutter/providers/LocalNotiProvider.dart';
import 'package:basicflutter/providers/LoginCheckProvider.dart';
import 'package:basicflutter/providers/SocketProvider.dart';
import 'package:basicflutter/repo/ConnectNode.dart';
import 'package:basicflutter/repo/KakaoLogin.dart';
import 'package:basicflutter/repo/LocalNotification.dart';
import 'package:basicflutter/repo/SharedPref.dart';
import 'package:basicflutter/repo/UserLocation.dart';
import 'package:basicflutter/views/CamPage.dart';
import 'package:basicflutter/views/ConnectMultiServer.dart';
import 'package:basicflutter/views/GraphQLPage.dart';
import 'package:basicflutter/views/ImageFilePage.dart';
import 'package:basicflutter/views/SQLPage.dart';
import 'package:basicflutter/views/SQflitePage.dart';
import 'package:basicflutter/views/SocketChatPage.dart';
import 'package:basicflutter/views/StreamingPage.dart';
import 'package:basicflutter/views/VuePage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

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
  bool foregroundCheck = false;

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
        await ConnectNode.fetchPost<bool>(path: '/fcm/token/save', body: {"token":fcmToken});
        return;
      })
      .then((_) async => await UserLocation.getLocation());
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
    UserLocation.permissionCheck(context:context);
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
                            await new KakaoLogin().logout(context: context,at: await SharedPref.getAToken());
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: StreamBuilder(
                  stream: UserLocation.geo.getPositionStream().timeout(Duration(seconds: 4), onTimeout:(EventSink<Position> po) => po.add(new Position(latitude: 0, longitude: 0))),
                  builder: (context, AsyncSnapshot<Position> snap){
                    if(!snap.hasData) return Container(width:100.0,height:100.0,child: CircularProgressIndicator());
                    if(snap.hasError) return Container(child: Text("ERR"),);
                    if(snap.data.latitude == 0 && snap.data.longitude == 0) return Container(
                      height:100.0,
                      alignment: Alignment.centerLeft,
                      child: Text("위치를 불러 올 수 없습니다\n(앱 권한 또는 고객센터를 통해 기종을 확인해주세요)"),
                    );
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100.0,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "내 위치\nlat : ${snap.data.latitude} / long : ${snap.data.longitude}",
                        textAlign: TextAlign.center,
                      )
                    );
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
                child: Text("Image & Video\n(IOS : 기기 테스트)"),
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
                    ) ?? false;
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
                child: Text("Camera View\n(IOS : 기기 테스트)"),
                onPressed: () async => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => new CamPage()
                  )
                ),
              ),
              MaterialButton(
                minWidth: MediaQuery.of(context).size.width*0.5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                color: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
                textColor: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
                child: Text("GraphQL Connect"),
                onPressed: () async => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => new GraphQLPage()
                  )
                ),
              ),
              MaterialButton(
                minWidth: MediaQuery.of(context).size.width*0.5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                color: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
                textColor: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
                child: Text("Audio Streaming"),
                onPressed: () async => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => new StreamingPage()
                  )
                ),
              ),
              MaterialButton(
                minWidth: MediaQuery.of(context).size.width*0.5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                color: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
                textColor: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
                child: Text("WebView : VuePage"),
                onPressed: () async => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => new VuePage()
                  )
                ),
              ),
              MaterialButton(
                minWidth: MediaQuery.of(context).size.width*0.5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                color: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
                textColor: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
                child: Text("MultiServer"),
                onPressed: () async => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => new ConnectMultiServer()
                  )
                ),
              ),
              MaterialButton(
                minWidth: MediaQuery.of(context).size.width*0.5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                color: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
                textColor: Color.fromRGBO(math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), math.Random.secure().nextInt(255), 1.0),
                child: Text("KakaoPay-with DJango & Express.js"),
                onPressed: () async => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(title: Text("카카오페이 직접연결++"),),
                      body: FutureBuilder(
                        future: logic(),
                        builder: (context, snap){
                          if(!snap.hasData) return Text("");
                          return WebView(
                            initialUrl: snap.data,
                            javascriptMode: JavascriptMode.unrestricted,
                            javascriptChannels: {
                              JavascriptChannel(
                                  name: 'jamess',
                                  onMessageReceived: (JavascriptMessage msg){
                                    print(msg.message);
                                    final bool _result = json.decode(msg.message);
                                    if(_result) return Navigator.of(context).pop();
                                  }
                              )
                            },
                          );
                        },
                      ),
                    )
                  )
                ),
              ),

              TextButton(
                child: Text("POP-UP\n-Alert + PageMove"),
                onPressed: () async{
                  bool result = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("POP-UP"),
                      actions: [
                        TextButton(
                          child: Text("닫기"),
                          onPressed: () => Navigator.of(context).pop(false),
                        )
                      ],
                    )
                  ) ?? false;
                  print(result);
                  if(!result) return await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => new Scaffold(
                        appBar: AppBar(title: Text("Hi POP-UP ?!"),),
                      )
                    )
                  );
                },
              )



            ],
          ),
        ),
      ),
      floatingActionButton: Platform.isAndroid
        ? FloatingActionButton(
            child: Icon(this.foregroundCheck ? Icons.play_arrow : Icons.stop),
            onPressed: () async{
              this.foregroundCheck ? await maybeStartFGS() : await ForegroundService.stopForegroundService();
              setState(() {
                this.foregroundCheck = !this.foregroundCheck;
              });
            },
          )
        : null
    );
  }

  Future<String> logic() async{
    final String url = "http://localhost:8000/kakaopay";
    http.Response res = await http.get(url);
    return json.decode(res.body);
  }

}