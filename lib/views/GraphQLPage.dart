import 'dart:convert';
import 'package:basicflutter/repo/ConnectNode.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
      String query = "{hello(targetId:31){ id title}}";
      http.Response _res = await http.get("${ConnectNode.END_POINT}/graphqlserver/data?query=$query");
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
      body: this.views(data: this.data)
    );
  }

  Widget views({List data}){
    final HttpLink httpLink = HttpLink(uri: '${ConnectNode.END_POINT}/graphqlserver/data',);
    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',);
    final Link link = authLink.concat(httpLink);

    String readRepositories = "query{hello(targetId:31){id title}}";

    if(data == null) return Center(child: CircularProgressIndicator(),);
    return Container(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Text("HTTP(S) : \n${this.data.toString()}")
            )
          ),
          GraphQLProvider(
            client: ValueNotifier(
              GraphQLClient(
                cache: InMemoryCache(),
                link: link,
              ),
            ),
            child: Expanded(
              flex: 1,
              child: Query(
                options: QueryOptions(
                  documentNode: gql(readRepositories),
                  pollInterval: 10,
                ),
                builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
                  if(result.hasException) return Text(result.exception.toString());
                  if(result.loading) return Text('Loading');
                  return Center(child: Text("GraphQL Package : \n${result.data.toString()}"));
                },
              ),
            ),
          ),
        ],
      ),
    );

  }
}
