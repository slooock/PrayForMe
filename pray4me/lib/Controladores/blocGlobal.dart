import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class BlocGlobal implements BlocBase{

  var _imageController = BehaviorSubject<String>(seedValue: "https://pbs.twimg.com/profile_images/1032242193912582145/umj0Pzx7_400x400.jpg");

  Stream<String> get outImageController => _imageController.stream;
  Sink<String> get inImageController => _imageController.sink;

  void changeImage(){
    inImageController.add("https://pbs.twimg.com/profile_images/1077732422152802304/3uwC_0iB_400x400.jpg");
  }

  @override
  void dispose() {

  }
}