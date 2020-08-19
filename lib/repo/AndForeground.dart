import 'dart:io';
import 'package:basicflutter/repo/UserLocation.dart';
import 'package:flutter/material.dart';
import 'package:foreground_service/foreground_service.dart';

class AndForeground{
  static Future<bool> backStart() async{
    if(Platform.isAndroid){
      if (!(await ForegroundService.foregroundServiceIsStarted())) {
        // 30초마다 위치 포그라운드로 확인
        await ForegroundService.setServiceIntervalSeconds(30);
        await ForegroundService.notification.startEditMode();

        await ForegroundService.notification
            .setTitle("Example Title: ${DateTime.now()}");
        await ForegroundService.notification
            .setText("Example Text: ${DateTime.now()}");

        await ForegroundService.notification.finishEditMode();

        await ForegroundService.startForegroundService(await UserLocation.getLocation());
        await ForegroundService.getWakeLock();
      }

      ///this exists solely in the main app/isolate,
      ///so needs to be redone after every app kill+relaunch
      await ForegroundService.setupIsolateCommunication((data) {
        debugPrint("main received: $data");
      });
    }
    return false;
  }
}