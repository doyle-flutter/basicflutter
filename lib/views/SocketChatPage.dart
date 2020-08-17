import 'package:basicflutter/providers/LocalNotiProvider.dart';
import 'package:basicflutter/providers/SocketProvider.dart';
import 'package:basicflutter/repo/LocalNotification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SocketChatPage extends StatefulWidget {
  @override
  _SocketChatPageState createState() => _SocketChatPageState();
}

class _SocketChatPageState extends State<SocketChatPage> {
  SocketProvider _socket;
  LocalNotification _localNotification;
  TextEditingController _chatTxtCt = new TextEditingController(text: "");
  ScrollController _scrollController = new ScrollController();

  List _msgTxt = [];

  @override
  void initState() {
    if(!mounted) return;
    super.initState();
  }

  @override
  void dispose() {
    _chatTxtCt?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(_localNotification == null) _localNotification = Provider.of<LocalNotiProvider>(context).localNotification;
    // SockeProvider를 다른 뷰에서 사용하여 현재 화면이 아닐 겅우 알림을 받을 수 있습니다
    // 단 LocalNotification은 앱이 활성화 상태에서만 동작하므로 종료시에도 작업하기 위해서는 FCM 사용
    if(_socket == null) _socket = Provider.of<SocketProvider>(context)
      ..socket.on('chatsYou', (data) {
        if(!mounted) return;
        setState(() {
          _msgTxt.insert(0, data);
        });
// 역순으로 사용하면 스크롤을 제어하지 않아도 됩니다 :)
//        if(_scrollController.hasClients && _scrollController.position.maxScrollExtent > 0){
//          _scrollController.animateTo(_scrollController.position.maxScrollExtent+kToolbarHeight, duration: Duration(milliseconds: 500), curve: Curves.linear);
//        }
        Future.microtask(() async => await _localNotification.showNoti(des: data['des']));
        return;
      });
    return Scaffold(
      appBar: AppBar(
        title: Text("Node.js Socket.io Chat"),
        centerTitle: true,
        backgroundColor: Colors.yellow[800],
      ),
      body: SingleChildScrollView(
         physics: BouncingScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height-kToolbarHeight-MediaQuery.of(context).padding.top,
          child: Stack(
            children: [
              Container(
                child: _msgTxt.isEmpty
                  ? Container()
                  : ListView.builder(
                      reverse: true,
                      itemCount: _msgTxt.length,
                      controller: _scrollController,
                      padding: EdgeInsets.only(bottom: 50.0),
                      itemBuilder: (BuildContext context, int index)
                        => Container(
                          padding: EdgeInsets.all(20.0),
                          alignment: _msgTxt[index]['title'] == "FlutterTitle" ? Alignment.centerLeft : Alignment.centerRight,
                          child: Text(_msgTxt[index]['des'].toString()),
                        )
                    ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 50,
                child: Container(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 7,
                        child: Container(
                          child: TextField(
                            controller: _chatTxtCt,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
                            ),
                          )
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          height: double.infinity,
                          child: MaterialButton(
                            child: Text("Send"),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0),side: BorderSide(color: Colors.black)),
                            color: Colors.yellow[800],
                            textColor: Colors.white,
                            onPressed: _sendMsg,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // controller를 인자로 받아서 처리하는 등으로 분리할 수 있습니다
  void _sendMsg() async => Future(() async {
    if(_chatTxtCt.text.isNotEmpty || _chatTxtCt.text != ""){
      _socket.socket.emit('chats', {'title':'FlutterTitle', 'des':_chatTxtCt.text});
      return true;
    }
    return false;
  })
   .then((bool check) async{
     if(check){
       setState(() {
         _msgTxt.insert(0, {'title':'FlutterTitle', 'des':_chatTxtCt.text});
       });
     }
     return check;
    })
      .then((bool check){
// 역순으로 사용하면 스크롤을 제어하지 않아도 됩니다 :)
//        if(check && _scrollController.hasClients && _scrollController.position.maxScrollExtent > 0){
//          _scrollController.animateTo(_scrollController.position.maxScrollExtent+kToolbarHeight, duration: Duration(milliseconds: 500), curve: Curves.linear);
//        }
        _chatTxtCt.text = "";
        return;
      });
}
