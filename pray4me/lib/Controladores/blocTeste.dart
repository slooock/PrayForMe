import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pray4me/Controladores/ControladorUsuario.dart';

class BlocController implements BlocBase {

  BlocController();

//Stream that receives a number and changes the count;
  var _counterController = BehaviorSubject<int>(seedValue: 0);
//output
  Stream<int> get outCounter => _counterController.stream;
//input
  Sink<int> get inCounter => _counterController.sink;

  increment(){
    inCounter.add(_counterController.value+1);
  }

  var _imageController = BehaviorSubject<String>(seedValue: "https://pbs.twimg.com/profile_images/1032242193912582145/umj0Pzx7_400x400.jpg");
  //output
  Stream<String> get outImage => _imageController.stream;
  //input
  Sink<String> get inImage => _imageController.sink;

  changeImage(String image){
    inImage.add(image);
  }

  @override
  void dispose() {
    _counterController.close();
    _imageController.close();
  }


}