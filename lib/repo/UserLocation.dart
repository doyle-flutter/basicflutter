import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class UserLocation{
  bool check;

  static Geolocator geo = new Geolocator();

  static Future getLocation() async {
    if(geo == null) geo = new Geolocator();
    final Position _position = await geo.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final Map<String, num> _result = {'lat':_position.latitude, 'lon':_position.longitude};
    return _result;
  }

  static Future<bool> permissionCheck({@required BuildContext context}) async{
    bool check = false;
    Geolocator geo = UserLocation.geo;
    if(geo == null) geo = new Geolocator();
    GeolocationStatus status = await geo.checkGeolocationPermissionStatus();
    if(status == GeolocationStatus.restricted ||status == GeolocationStatus.granted){
      check = true;
    }
    if(!check){
      await showPermissionCheck(context: context);
      await Permission.locationAlways.request();
      await permissionCheck(context: context);
    }
    return check;
  }

//  static Future<bool> permissionCheck({@required BuildContext context}) async{
//    bool check = false;
//    if(geo == null) geo = new Geolocator();
//    GeolocationStatus status = await geo.checkGeolocationPermissionStatus();
//    if(status == GeolocationStatus.restricted ||status == GeolocationStatus.granted){
//      check = true;
//    }
//    if(!check){
//      await showPermissionCheck(context: context);
//      await Permission.locationAlways.request();
//      await permissionCheck(context: context);
//    }
//    return check;
//  }

  static Future<void> showPermissionCheck({@required BuildContext context}) async{
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("권한 설정 후 이용할 수 있습니다"),
        actions: [
          FlatButton(
            child: Text("설정"),
            onPressed: () async => Navigator.of(context).pop()
          )
        ],
      )
    );
  }
}