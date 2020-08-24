import 'package:basicflutter/providers/SQLProvider.dart';
import 'package:basicflutter/views/LoadingPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SQLPage extends StatelessWidget {
  SQLProvider sqlProvider;
  @override
  Widget build(BuildContext context) {
    sqlProvider = Provider.of<SQLProvider>(context);
    if(sqlProvider == null) return new LoadingPage();
    return Scaffold(
      appBar: AppBar(
        title: Text("SQLPage"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async{
              await this.sqlProvider.createSQL(body: {"title":"NewFlutterSQLTitle","des":"NewFlutterSQLDes"});
              return;
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async{
//              await this.sqlProvider.init();
              return;
            },
          )
        ],
      ),
      body: this.sqlProvider.result == null
        ?  Center(child: CircularProgressIndicator(),)
        :  Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.grey[300],
          child: Card(
            margin: EdgeInsets.all(15.0),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top-kToolbarHeight,
              child: ListView.builder(
                itemCount: this.sqlProvider.result.length,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    onLongPress: () => _sqlEvent(context: context, index: index),
                    leading: Text(sqlProvider.result[index].id.toString()),
                    title: Text(sqlProvider.result[index].title),
                    subtitle: Text(sqlProvider.result[index].des),
                    trailing: Text(sqlProvider.result[index].created.split("T")[0].toString()),
                  );
                },
              ),
            ),
          ),
        ),
    );
  }

  void _sqlEvent({@required BuildContext context, @required int index}) async{
    bool _result = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("선택해주세요"),
          actions: [
            FlatButton(child: Text("수정"),onPressed: () => Navigator.of(context).pop(true),),
            FlatButton(child: Text("삭제"),onPressed: () => Navigator.of(context).pop(false),),
            FlatButton(child: Text("닫기"),onPressed: () => Navigator.of(context).pop(null)),
          ],
        )
    ) ?? null;
    if(_result == null) return;
    if(_result){
      await sqlProvider.updateSQL(index: sqlProvider.result[index].id, body: {"title":"FlutterUpdateTitle", "des":"FlutterUpdateDes"});
      return;
    }
    await sqlProvider.delSQL(index: sqlProvider.result[index].id,body: null);
    return;
  }
}
