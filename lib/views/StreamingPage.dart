import 'package:basicflutter/repo/ConnectNode.dart';
import 'package:flutter/material.dart';
import 'package:url_audio_stream/url_audio_stream.dart';

class StreamingPage extends StatefulWidget {
  @override
  _StreamingPageState createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
  @override
  void initState() {
    super.initState();
  }


  bool check = true;


  AudioStream stream = new AudioStream("${ConnectNode.END_POINT}/streamingRouter");
  Future<void> callAudio() async{
    if(check){
      setState(() {
        check = !check;
      });
      await stream.start();
    }
    else{
      setState(() {
        check = !check;
      });
      await stream.stop();
    }
    return;
  }

  @override
  void dispose() {
    stream.stop().then((_) => stream = null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          "Streaming MP3\n- Node.js",
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            fontSize: 24.0
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          this.check
            ? Icons.play_arrow
            : Icons.stop
        ),
        onPressed: callAudio,
      ),
    );
  }
}
