import 'package:basicflutter/models/SQfliteModel.dart';
import 'package:basicflutter/repo/LocalSqflite.dart';
import 'package:flutter/material.dart';

class SQFliteProvider with ChangeNotifier{
  LocalSqflite _sqflite;

  List<SQfliteModel> _result;
  List<SQfliteModel> get result => _result;
  set result(newData) => throw "ERR !";

  SQFliteProvider({@required String dbName, @required String tableName, @required String columnTitle, @required String columnDes}){
    _sqflite = new LocalSqflite(dbName: dbName, tableName: tableName, columnTitle: columnTitle, columnDes: columnDes);
  }

  Future<void> dataGet() async{
    List<Map<String, dynamic>> _data = await _sqflite?.dbDataGet() ?? null;
    _result = _data?.map((Map<String, dynamic> e) => SQfliteModel.fromJson(e: e))?.toList() ?? null;
    notifyListeners();
    return;
  }

  Future<void> createData({@required String cTitle, @required String cDes}) async{
    await _sqflite?.createTransitionData(cTitle: cTitle, cDes: cDes);
    await this.dataGet();
    return;
  }

  Future<void> updateData({@required int id, @required String cTitle, @required String cDes}) async{
    await _sqflite?.updateData(id: id,cTitle: cTitle, cDes: cDes);
    await this.dataGet();
    return;
  }

  Future<void> delData({@required int id}) async{
    await _sqflite?.delData(id: id);
    await this.dataGet();
    return;
  }

}