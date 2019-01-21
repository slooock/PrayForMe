import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pray4me/Inicial_login.dart';
import 'package:pray4me/TelaCadastro.dart';

class ControladorTelasSingleton {
  static final ControladorTelasSingleton _controladorTelasSingleton = new ControladorTelasSingleton._internal();

  factory ControladorTelasSingleton() {
    return _controladorTelasSingleton;
  }

  ControladorTelasSingleton._internal();

  void showInicialPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => InicialPage()));
  }

  void showCadastroPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CadastroPage()));
  }

}