import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConnectNode{
  static const String END_POINT = "http://192.168.0.2:3000";
  static Future<List> fetchGet({ @required String path, Map<String,String> headers}) async{
    try{
      http.Response _res = await http.get("$END_POINT$path",headers: headers ?? {"type":"json"})
        .timeout(Duration(seconds: 8),onTimeout: () async => new http.Response("[]", 404));
      List _result = json.decode(_res.body);
      return _result;
    }
    catch(e){
      return [];
    }
  }
  static Future<T> fetchGetOthers<T>({ @required String path, Map<String,String> headers}) async{
    try{
      http.Response _res = await http.get("$END_POINT$path",headers: headers ?? {"type":"json"})
          .timeout(Duration(seconds: 8),onTimeout: () async => new http.Response("[]", 404));
      T _result = json.decode(_res.body);
      return _result;
    }
    catch(e){
      return null;
    }
  }
  static Future<T> fetchPost<T>({@required String path, @required Map<String, String> body, Map<String,String> headers}) async{
    http.Response _res = await http.post("$END_POINT$path",headers: headers ?? {"token":"tokenFlutter"},body: body);
    return json.decode(_res.body);
  }
  static Future<T> fetchPostOthers<T>({ @required String path, @required Map<String, String> body, Map<String,String> headers}) async{
    http.Response _res = await http.post("$END_POINT$path",body:body, headers: headers ?? {"type":"json"})
        .timeout(Duration(seconds: 8),onTimeout: () async => new http.Response("[]", 404));
    T _result = json.decode(_res.body);
    return _result;
  }
  static Future<void> fetchMultipart({@required String path, @required File file}) async{
    http.MultipartRequest _request = http.MultipartRequest("POST", Uri.parse("$END_POINT$path"));
    _request.files.add(
      new http.MultipartFile(
        'fimg',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: "flutterImg${DateTime.now().millisecond}.png",
      )
    );
    await _request.send();
    return;
  }
  static Future<void> fetchMultipartArr({@required String path, @required List<File> files}) async{
    http.MultipartRequest _request = http.MultipartRequest("POST", Uri.parse("$END_POINT$path"));
    files.forEach((File file) {
      _request.files.add(
          new http.MultipartFile(
            'fimages',
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: "flutterImg${DateTime.now().millisecond}.png",
          )
      );
    });
    await _request.send();
    return;
  }
}