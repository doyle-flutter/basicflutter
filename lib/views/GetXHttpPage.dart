import 'package:flutter/material.dart';
import 'package:get/get.dart' as GetX;
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetXHttpPage extends StatelessWidget {

  final GetXHttp _getXController = GetX.Get.put(new GetXHttp());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetX.Obx(() => Text(_getXController.data.toString())),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.record_voice_over_rounded),
        onPressed: () async => await _getXController.connectServer(),
      ),
    );
  }
}

// Use http Package
class GetXHttp extends GetX.GetxController{
  final GetX.RxList<dynamic> data = [].obs;
  final String _url = "https://raw.githubusercontent.com/doyle-flutter/basicflutter/master/lib/testJson.json";

  Future<void> connectServer() async{
    if(data.length < 1 ){
      final http.Response _res = await http.get(this._url);
      final List _result = json.decode(_res.body);
      // ignore: unnecessary_statements
      this.data +_result;
    }
    else{
      this.data.clear();
    }
    return;
  }

}

class GetXHttpPage2 extends StatelessWidget {

  final GetXHttp2 _getXController2 = GetX.Get.put(new GetXHttp2());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetX.Obx(() => Text(_getXController2.data.toString())),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.record_voice_over_rounded),
        onPressed: () async => await _getXController2.connectServer(),
      ),
    );
  }
}

// Built-in
class GetXHttp2 extends GetX.GetConnect{
  final GetX.RxList<dynamic> data = [].obs;
  final String _url = "https://raw.githubusercontent.com/doyle-flutter/basicflutter/master/lib/testJson.json";

  Future<void> connectServer() async{
    if(data.length < 1 ){
      GetX.Response<String> _res = await get(_url);
      final List _result = json.decode(_res.body);
      // ignore: unnecessary_statements
      this.data +_result;
    }
    else{
      this.data.clear();
    }
    return;
  }

}