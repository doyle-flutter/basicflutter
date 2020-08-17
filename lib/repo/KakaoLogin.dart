import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

abstract class LoginLogic{
  String authKey;
  String connectHost;
  Future login(){}
  Future logout(){}
}

class KakaoLogin implements LoginLogic{
  @override
  String authKey = "453a071e0479512fb9e3722b3e5c7d0a";

  @override
  String connectHost ="https://kauth.kakao.com";

  String redirect = "http://192.168.0.2:3000/auth";
  String loginOutRedirect = "http://192.168.0.2:3000/auth/logout";

  String connectUrl() => "${this.connectHost}/oauth/authorize?client_id=${this.authKey}&redirect_uri=${this.redirect}&response_type=code";
  String connectLogoutUrl({@required String at}) => "${this.connectHost}/oauth/logout?client_id=${this.authKey}&logout_redirect_uri=${this.loginOutRedirect}&state=$at";

  @override
  Future<Map<String, dynamic>> login({@required BuildContext context}) async{
    final String url = this.connectUrl();
    final Completer<WebViewController> _c = Completer<WebViewController>();
    print(url);
    var _result;
    try{
       _result = await Navigator.of(context).push(
          MaterialPageRoute(
//        builder: (context) => WebviewScaffold(
//          url: url,
//          withJavascript: true,
//          javascriptChannels: Set.of([
//              JavascriptChannel(
//                name: 'james',
//                onMessageReceived: (JavascriptMessage msg) async => Navigator.of(context).pop(msg?.message ?? null)
//              ),
//          ]),
//          appBar: AppBar(
//            backgroundColor: Colors.white,
//            elevation: 0,
//          ),
//        )
              builder: (context) => Scaffold(
                body: Builder(
                  builder: (context) => WebView(
                    initialUrl: url,
                    onWebViewCreated: (WebViewController webc){
                      _c.complete(webc);
                    },
                    onPageStarted: (String url) {
                      print('Page started loading: $url');
                    },
                    onPageFinished: (String url) {
                      print('Page finished loading: $url');
                    },
                    javascriptMode: JavascriptMode.unrestricted,
                    javascriptChannels: <JavascriptChannel>[
                      JavascriptChannel(
                          name: 'james',
                          onMessageReceived: (JavascriptMessage msg) async => Navigator.of(context).pop(msg.message)
                      ),
                    ].toSet(),
                  ),
                ),
              )
          )
      );
    }
    catch(e){
      _result = null;
    }
    if(_result == null) return null;
    Map<String, dynamic> _re = json.decode(_result);
    return _re;
  }
  
  @override
  Future logout({@required BuildContext context, @required String at}) async{
    String url = connectLogoutUrl(at: at);
    final Completer<WebViewController> _c = Completer<WebViewController>();

    String _result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Builder(
              builder: (context) => WebView(
                initialUrl: url,
                gestureNavigationEnabled: true,
                onWebViewCreated: (WebViewController webc){
                  _c.complete(webc);
                },
                onPageStarted: (String url) {
                  print('Page started loading: $url');
                },
                onPageFinished: (String url) {
                  print('Page finished loading: $url');
                },
                javascriptMode: JavascriptMode.unrestricted,
                javascriptChannels: <JavascriptChannel>[
                  JavascriptChannel(
                      name: 'james',
                      onMessageReceived: (JavascriptMessage msg) async => Navigator.of(context).pop(msg?.message ?? null)
                  ),
                ].toSet(),
              ),
            ),
          )
        )
    );
    print("rESULT : ${_result}");
    if(_result == null) return null;
    Map<String, dynamic> _re = json.decode(_result);
    return _re;
  }

}