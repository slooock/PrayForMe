import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pray4me/Controladores/blocGlobal.dart';
import 'package:pray4me/Controladores/blocTeste.dart';
import 'package:pray4me/Inicial_login.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:pray4me/orandoPage.dart';
import 'package:pray4me/biografia.dart';
import 'package:pray4me/perfilPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<BlocController>(
      bloc: BlocController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pray for me',
        color: Colors.white,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: InicialPage(),
      ),
    );
  }
}
