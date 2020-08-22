import 'dart:convert';

import 'package:basicflutter/repo/ConnectNode.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class GraphQLPage extends StatefulWidget {
  @override
  _GraphQLPageState createState() => _GraphQLPageState();
}

class _GraphQLPageState extends State<GraphQLPage> {
  
  List data = [];
  
  @override
  void initState() {
    Future.microtask(() async{
      String query = "{hello(targetId:1){ id title}}";
      http.Response _res = await http.get("http://192.168.0.2:3000/graphqlserver/data?query=$query");
      var _result = json.decode(_res.body);
      print(_result);
      setState(() {
        this.data.add(_result);
      });
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Node.js GraphQL Server"),
        centerTitle: true,
      ),
      body: this.data == null
      ? Center(child: CircularProgressIndicator(),)
      : ListView.builder(
          itemCount: this.data.length,
          itemBuilder: (BuildContext context, int index)
            => Text(this.data[index].toString())
        )
    );
  }
}
