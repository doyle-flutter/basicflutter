import 'package:flutter/material.dart';
import 'dart:io';

class MultipartImgFilesProvider with ChangeNotifier{
  List<File> _files = [];
  List<File> get filesList => _files;
  void addFiles(File addFile){
    _files.add(addFile);
    notifyListeners();
    return;
  }

  void removeFile({File targetFile}){
    int index = _files.indexOf(targetFile);
    if(index < 0) return;
    _files.removeAt(index);
    notifyListeners();
    return;
  }

}