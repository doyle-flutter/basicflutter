import 'package:basicflutter/providers/SQFliteProvider.dart';
import 'package:basicflutter/views/LoadingPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SQflitePage extends StatelessWidget {
  SQFliteProvider _sqFliteProvider;
  @override
  Widget build(BuildContext context) {
    _sqFliteProvider = Provider.of<SQFliteProvider>(context);
    if(_sqFliteProvider == null) return new LoadingPage();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async => await _sqFliteProvider.createData(cTitle: "FlutterSQFlite",cDes: "FlutterSQFliteDES"),
          )
        ],
      ),
      body: _sqFliteProvider.result == null
        ? Center(child: Text("NULL !"),)
        : ListView.builder(
          itemCount: _sqFliteProvider.result?.length,
          itemBuilder: (BuildContext context, int index)
            => ListTile(
              onTap: () async{
                bool _check = await showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => CupertinoActionSheet(
                    title: Text("Do ?"),
                    message: Text("SQFLite"),
                    actions: [
                      CupertinoActionSheetAction(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text("수정")
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text("삭제")
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () => Navigator.of(context).pop(null),
                      child: Text("닫기")
                    ),
                  )
                ) ?? null;
                if(_check == null) return;
                if(_check) return await _sqFliteProvider?.delData(id: _sqFliteProvider?.result[index]?.id);
                return await _sqFliteProvider?.updateData(
                  id: _sqFliteProvider?.result[index]?.id,
                  cTitle: "FlutterUpdateSQFLite${_sqFliteProvider?.result[index]?.id}",
                  cDes: "FlutterUpdateSQFLiteDes${_sqFliteProvider?.result[index]?.id}"
                );
              },
              leading: Text(_sqFliteProvider?.result[index]?.id?.toString() ?? "...await"),
              title: Text(_sqFliteProvider?.result[index]?.title ?? "...await"),
              subtitle: Text(_sqFliteProvider?.result[index]?.des ?? "...await"),
            )
        )
    );
  }
}
