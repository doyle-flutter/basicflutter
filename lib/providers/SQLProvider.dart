import 'package:basicflutter/models/SQLReadModel.dart';
import 'package:basicflutter/repo/ConnectNode.dart';
import 'package:flutter/material.dart';

class SQLProvider with ChangeNotifier{
  List<SQLReadModel> result;

  Future<void> init() async{
    List _result = await ConnectNode.fetchGet(path: "/sqls");
    this.result = _result.map((e) => SQLReadModel.fromJson(e: e)).toList();
    notifyListeners();
    return;
  }
  SQLProvider(){
    Future.microtask(() async => await init());
  }

  Future<void> updateSQL({@required int index, @required Map<String, String> body}) async{
    await ConnectNode.fetchPost<bool>(path: '/sqls/update/$index', body: body);
    await init();
    return;
  }

  Future<void> delSQL({@required int index, @required Map<String, String> body}) async{
    await ConnectNode.fetchPost<bool>(path: '/sqls/delete/$index', body: body);
    await init();
    return;
  }

  Future<void> createSQL({@required Map<String, String> body}) async{
    await ConnectNode.fetchPost<List>(path: '/sqls/create/data', body: body);
    await init();
    return;
  }


}