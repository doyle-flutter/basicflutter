import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VuePage extends StatefulWidget {
  @override
  _VuePageState createState() => _VuePageState();
}

class _VuePageState extends State<VuePage> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebVue Page"),
      ),
      body: WebView(
        initialUrl: "http://127.0.0.1:3000/vues",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController)
          => setState((){_controller = webViewController;}),
        gestureNavigationEnabled: true,
        javascriptChannels: {
          JavascriptChannel(
            name: "james",
            onMessageReceived: (JavascriptMessage msg){
              print("msg.message : ${msg.message}");
            }
          )
        },
      ),
      floatingActionButton: _controller == null
        ? null
        : StreamBuilder(
            stream: Stream.fromFuture(Future(() async{
              bool re = await _controller.canGoBack();
              setState(() {});
              return re;
            })),
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<bool> snap){
              if(!snap.hasData) return Container();
              if(!snap.data) return Container();
              return FloatingActionButton(
                child: Icon(Icons.backspace),
                onPressed: () async => await _controller.goBack(),
              );
            },
          )
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.backspace),
//        onPressed: () async{
//          if(await _controller.canGoBack()){
//            await _controller.goBack();
//          }
//          return;
//        },
//      ),
    );
  }
}
