import 'dart:io';
import 'package:basicflutter/providers/MultipartImgFilesProvider.dart';
import 'package:basicflutter/repo/ConnectNode.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ImageFilePage extends StatelessWidget {

  MultipartImgFilesProvider _filesProvider;

  @override
  Widget build(BuildContext context) {
    _filesProvider = Provider.of<MultipartImgFilesProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width/2.0,
              child: RaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.camera),
                    Text("촬영 이미지 전송"),
                  ],
                ),
                color: Colors.white,
                onPressed: () async{
                  PickedFile f = await ImagePicker().getImage(source: ImageSource.camera);
                  if(f == null) return;
                  await ConnectNode.fetchMultipart(path: '/fpage/send/img', file: File(f.path));
                  return;
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.camera),
                            Text("촬영's"),
                          ],
                        ),
                        color: Colors.white,
                        onPressed: () async{
                          PickedFile f = await ImagePicker().getImage(source: ImageSource.camera);
                          if(f == null) return;
                          this._filesProvider.addFiles(File(f.path));
                          return;
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.file_upload),
                        onPressed: () async{
                          if(_filesProvider.filesList == null) return;
                          return await ConnectNode.fetchMultipartArr(path: '/fpage/send/images', files: _filesProvider.filesList);
                        },
                      )
                    ],
                  ),
                  _filesProvider.filesList.isEmpty
                    ? Container(
                        height: 100.0,
                        alignment: Alignment.center,
                        child: Text("촬영해주세요"),
                      )
                    : Container(
                        height: 100.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _filesProvider.filesList.length,
                          itemBuilder:(BuildContext context, int index)
                            => Container(
                              width: 100.0,
                              height: 100.0,
                              margin: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(_filesProvider.filesList[index]),
                                      fit: BoxFit.cover
                                  )
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(18.0)
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.delete),
                                        color: Colors.white,
                                        iconSize: 18.0,
                                        onPressed: (){
                                          _filesProvider.removeFile(targetFile:_filesProvider.filesList[index]);
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                        ),
                      ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.red)),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.50,
                        padding: EdgeInsets.only(top: 20.0),
                        child: RaisedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.camera),
                              Text("비디오선택"),
                            ],
                          ),
                          color: Colors.white,
                          onPressed: () async{
                            PickedFile f = await ImagePicker().getVideo(source: ImageSource.gallery);
                            if(f == null) return;
                            File upf = File(f.path);
                            return await ConnectNode.fetchMultipartFv(path: '/fpage/videos', file: upf);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
