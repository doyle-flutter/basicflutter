import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebV extends StatefulWidget {
  @override
  _WebVState createState() => _WebVState();
}

class _WebVState extends State<WebV> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        initialUrl: "http://192.168.0.2:3000/",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
