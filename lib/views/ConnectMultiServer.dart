import 'package:basicflutter/providers/SocketProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectMultiServer extends StatefulWidget {
  @override
  _ConnectMultiServerState createState() => _ConnectMultiServerState();
}

class _ConnectMultiServerState extends State<ConnectMultiServer> {
  String txt;
  SocketProvider socket;

  @override
  void didChangeDependencies() {
    if(socket == null){
      socket = Provider.of<SocketProvider>(context);
      socket.socket.on('hiflask', (data){
        if(!mounted) return;
        setState(() {
          this.txt = data.toString();
        });
        Future.delayed(Duration(seconds: 5), () async{
          setState(() {
            this.txt = '초기화(5초)';
          });
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Node.js <-Socket-> Flask"),
      ),
      body: socket == null ? _load() : _contentsWidget(context),
    );
  }

  Widget _contentsWidget(BuildContext context) => SingleChildScrollView(
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Text("Flutter\nNode.js & Flask", style: _title(),),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            padding: EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5.0)
            ),
            child: Text(this.txt ?? 'await...', style: _dataSt()),
          )
        ],
      ),
    ),
  );

  Widget _load() => Center(child: CircularProgressIndicator(),);

  TextStyle _title() => TextStyle(
    color: Colors.black,
    fontSize: 28.0,
    fontWeight: FontWeight.bold
  );

  TextStyle _dataTitle() => TextStyle(
    color: Colors.black,
    fontSize: 22.0,
    fontWeight: FontWeight.bold
  );

  TextStyle _dataSt() => TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold
  );
}
