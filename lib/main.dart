import 'package:basicflutter/providers/LocalNotiProvider.dart';
import 'package:basicflutter/providers/LoginCheckProvider.dart';
import 'package:basicflutter/providers/MultipartImgFilesProvider.dart';
import 'package:basicflutter/providers/MyAppProvider.dart';
import 'package:basicflutter/providers/SQFliteProvider.dart';
import 'package:basicflutter/providers/SQLProvider.dart';
import 'package:basicflutter/providers/SocketProvider.dart';
import 'package:basicflutter/viewModels/LoginCheck.dart';
import 'package:basicflutter/views/WebViewTe.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider<MyAppProvider>(create: (_) => new MyAppProvider(),),
          ChangeNotifierProvider<SQLProvider>(create: (_) => new SQLProvider(),),
          ChangeNotifierProvider<SocketProvider>(create: (_) => new SocketProvider(),),
          ChangeNotifierProvider<SQFliteProvider>(create: (_) => new SQFliteProvider(dbName: "mydb", tableName: "tb", columnTitle: "title", columnDes: "des"),),
          ChangeNotifierProvider<MultipartImgFilesProvider>(create: (_) => new MultipartImgFilesProvider(),),
          ChangeNotifierProvider<LoginCheckProvider>(create: (_) => new LoginCheckProvider(),),
          Provider<LocalNotiProvider>(create: (_) => new LocalNotiProvider(),)
        ],
        child: MaterialApp(home:LoginCheck())
    )
);
