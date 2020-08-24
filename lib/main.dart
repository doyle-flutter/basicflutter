import 'dart:io';
import 'package:basicflutter/providers/LocalNotiProvider.dart';
import 'package:basicflutter/providers/LoginCheckProvider.dart';
import 'package:basicflutter/providers/MultipartImgFilesProvider.dart';
import 'package:basicflutter/providers/MyAppProvider.dart';
import 'package:basicflutter/providers/SQFliteProvider.dart';
import 'package:basicflutter/providers/SQLProvider.dart';
import 'package:basicflutter/providers/SocketProvider.dart';
import 'package:basicflutter/repo/UserLocation.dart';
import 'package:basicflutter/viewModels/LoginCheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  if(Platform.isAndroid) await maybeStartFGS();
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<MyAppProvider>(
              create: (_) => new MyAppProvider(),),
            ChangeNotifierProvider<SQLProvider>(
              create: (_) => new SQLProvider(),),
            ChangeNotifierProvider<SocketProvider>(
              create: (_) => new SocketProvider(),),
            ChangeNotifierProvider<SQFliteProvider>(create: (_)
              => new SQFliteProvider(dbName: "mydb", tableName: "tb", columnTitle: "title", columnDes: "des"),),
            ChangeNotifierProvider<MultipartImgFilesProvider>(
              create: (_) => new MultipartImgFilesProvider(),),
            ChangeNotifierProvider<LoginCheckProvider>(
              create: (_) => new LoginCheckProvider(),),
            Provider<LocalNotiProvider>(create: (_) => new LocalNotiProvider(),)
          ],
          child: MaterialApp(home: LoginCheck())
      )
  );
}

Future<void> maybeStartFGS() async {
  int checkTime = 30;
  if (!(await ForegroundService.foregroundServiceIsStarted())) {
    await ForegroundService.setServiceIntervalSeconds(checkTime);
    ForegroundService.notification
      ..startEditMode()
      ..setTitle("확인 중")
      ..setText("30 초 간격")
      ..finishEditMode();
    // 알림 레벨을 낮추어 기본 진동이 울리지 않도록 설정
    await ForegroundService.notification.setPriority(AndroidNotificationPriority.LOW);
    await ForegroundService.startForegroundService(foregroundServiceFunction);
    await ForegroundService.getWakeLock();
  }
}

Future<void> foregroundServiceFunction() async{
  String latKey = 'lat';
  String lonKey = 'lon';

  SharedPreferences _pref = await SharedPreferences.getInstance();
  String lat = _pref.getString(latKey)??"";
  String lon = _pref.getString(lonKey)??"";

  Map<String, num> userPosition = await UserLocation.getLocation();
  if(lat.isEmpty || lon.isEmpty){
    await _pref.setString(latKey, userPosition['lat'].toString());
    await _pref.setString(lonKey, userPosition['lon'].toString());
    return;
  }
  if(lat.split(".")[1][2] != userPosition['lat'].toString().split(".")[1][2] || lon.split(".")[1][2] != userPosition['lon'].toString().split(".")[1][2]){
    ForegroundService.notification.setText("확인해주세요 :)");
    if (await Vibration.hasVibrator()) Vibration.vibrate(duration: 2000);
    await _pref.setString(latKey, userPosition['lat'].toString());
    await _pref.setString(lonKey, userPosition['lon'].toString());
    return;
  }

  ForegroundService.notification.setText("30 초 간격");
  return;
}
