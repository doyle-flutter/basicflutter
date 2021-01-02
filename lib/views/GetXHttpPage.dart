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

class GetXHttp extends GetX.GetxController{
  final GetX.RxList<dynamic> data = [].obs;
  final String _url = "https://raw.githubusercontent.com/doyle-flutter/basicflutter/master/lib/testJson.json";

  Future<void> connectServer() async{
    final http.Response _res = await http.get(this._url);
    final List _result = json.decode(_res.body);
    // ignore: unnecessary_statements
    this.data +_result;
    return;
  }

}