import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pray4me/Inicial_login.dart';
import 'package:pray4me/Modelo/Usuario.dart';
import 'package:pray4me/biografia.dart';
import 'package:pray4me/TelaCadastro.dart';
import 'package:pray4me/home_page.dart';
import 'package:pray4me/pedido_page.dart';
import 'package:pray4me/pickImage.dart';
import 'package:pray4me/profile_page.dart';
import 'package:pray4me/EditPage.dart';
import 'package:pray4me/Controladores/ControladorUsuario.dart';

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

  void showHomePage(BuildContext context){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  void showProfilePage(BuildContext context,String idUsuario)async{

    var controladorUsuario = ControladorUsuarioSingleton();

    Usuario usuario = await controladorUsuario.pesquisaUsuario(idUsuario);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfilePage(usuario)));
  }

  void showPedidoPage(BuildContext context){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PedidoPage()));
  }

  void showEditPage(BuildContext context){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditPage()));
  }

  void showPickImagePage(BuildContext context){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PickImagePage()));
  }

  void showBiografiaPage(BuildContext context){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BiografiaPage()));
  }

}