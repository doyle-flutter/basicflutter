import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';

class DartStock extends StatefulWidget {
  @override
  _DartStockState createState() => _DartStockState();
}

class _DartStockState extends State<DartStock> {
  List _dartData;
  int _pageIndex = 1;
  @override
  void initState() {
    Future.microtask(() async{
      _dartData = await _connect(index: _pageIndex.toString());
      setState(() {});
      return;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("상장기업 공시(${DateTime.now().year} 최근 3개월)"),),
      body: SafeArea(
        child: _dartData == null
          ? Center(child: Text("load..."),)
          : ListView.builder(
            itemCount: _dartData.length+1,
            itemBuilder: (BuildContext context, int index){
              if(index == _dartData.length) return Container(
                child: Center(
                  child: TextButton(
                    child: Text("More"),
                    onPressed: () async{
                      _pageIndex++;
                     _dartData += await _connect(index: _pageIndex.toString());
                     setState(() {});
                     return;
                    },
                  )
                ),
              );
              return ListTile(
                title: Text(_dartData[index]['corp_name'].toString()),
                subtitle: Text(_dartData[index]['report_nm']),
                onTap: () => Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Scaffold(
                      appBar: AppBar(title: Text(_dartData[index]['corp_name'].toString()),),
                      body: SafeArea(
                        child: WebView(
                          initialUrl: "https://m.dart.fss.or.kr/html_mdart/MD1007.html?rcpNo=${_dartData[index]['rcept_no'].toString()}",
                          javascriptMode: JavascriptMode.unrestricted,
                        ),
                      ),
                    )
                  )
                ),
              );
            }
          ),
      )
    );
  }

  Future<List> _connect({@required String index}) async{
    const String _url = "https://opendart.fss.or.kr/api/list.json";
    const String _apiKey = "";
    final _dateTime = DateTime.now();
    final String _endPoint = "$_url?crtfc_key=$_apiKey&bgn_de=${_dateTime.year.toString()+ (( _dateTime.month.toString().length < 2) ? '0${_dateTime.month.toString()}': _dateTime.month.toString()) +'01'}&page_no=$index&page_count=100";
    final http.Response _res = await http.get(_endPoint);
    final Map<String, dynamic> _result = json.decode(_res.body);
    return _result['list'];
  }
}
