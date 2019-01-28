
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pray4me/Modelo/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_cropper/image_cropper.dart';


class ControladorUsuarioSingleton {
  static final ControladorUsuarioSingleton _controladorUsuarioSingleton = new ControladorUsuarioSingleton._internal();
  Usuario usuario = null;
  final googleSignIn = GoogleSignIn();
  final auth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();

  factory ControladorUsuarioSingleton() {
    return _controladorUsuarioSingleton;
  }

  ControladorUsuarioSingleton._internal();

  Future<Null> autenticarGoogle() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) {
      user = await googleSignIn.signInSilently();
    }
    if (user == null) {
      user = await googleSignIn.signIn();
    }
    if (await auth.currentUser() == null) {
      GoogleSignInAuthentication credentials = await googleSignIn.currentUser
          .authentication;
      await auth.signInWithGoogle(
          idToken: credentials.idToken,
          accessToken: credentials.accessToken
      );
    }
  }

  Future<QuerySnapshot> verificaExistenciaUsuario()async{
    QuerySnapshot usr = await Firestore.instance.collection("usuarios").where("idSistemaLogin", isEqualTo: usuario.idSistemaLogin).getDocuments();

    return usr;
  }

  Future<bool> loginGoogle()async{
    await autenticarGoogle();

    //recolhendo informações do usuario logado
    usuario = new Usuario();
    usuario.senderName = googleSignIn.currentUser.displayName;
    usuario.idSistemaLogin =googleSignIn.currentUser.id;
    usuario.quantAgradecimentos = 0;
    usuario.quantPedidos = 0;
    usuario.senderPhotoUrl = googleSignIn.currentUser.photoUrl;

    //verificando se o usuário ja é cadastrado
    QuerySnapshot usr = await verificaExistenciaUsuario();
    if(usr.documents.length == 0) {
      //se o usuario for novo
      //adidionar usuario no firebase
      DocumentReference doc = await Firestore.instance.collection("usuarios")
          .add({
        "nome": usuario.senderName,
        "idSistemaLogin": usuario.idSistemaLogin,
        "quantAgradecimentos": usuario.quantAgradecimentos,
        "quantPedidos": usuario.quantPedidos,
        "photoUrl": usuario.senderPhotoUrl,
      });
      //atualizando id do usuario adcionado
      await Firestore.instance.collection("usuarios")
          .document(doc.documentID)
          .updateData({"idFirebase": doc.documentID});
      usuario.idFirebase = doc.documentID;
      return true;
    }else{
      usuario.idFirebase = usr.documents[0].data["idFirebase"];
      usuario.quantAgradecimentos = usr.documents[0].data["quantAgradecimentos"];
      usuario.quantPedidos = usr.documents[0].data["quantPedidos"];
      usuario.senderPhotoUrl = usr.documents[0].data["photoUrl"];
      return false;
    }
  }


  //============================================
  //FACEBOOK                                   |
  //============================================
  void sairFacebook(){
    facebookLogin.logOut();
  }

  void loginFacebook()async{

    final result = await facebookLogin.logInWithReadPermissions(['email']);
    final token = result.accessToken.token;
    print(token);
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${token}');

    final profile = json.decode(graphResponse.body);


    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print("FacebookLoginStatus.loggedIn");

        FirebaseAuth.instance.signInWithFacebook(accessToken: result.accessToken.token);

        usuario = new Usuario();
        usuario.senderName = profile['name'];
        usuario.idSistemaLogin = profile["id"];
        usuario.quantAgradecimentos = 0;
        usuario.quantPedidos = 0;
        usuario.senderPhotoUrl = profile['picture']['data']['url'];

        //verificando se o usuário ja é cadastrado
        QuerySnapshot usr = await verificaExistenciaUsuario();
        if(usr.documents.length == 0) {
          //se o usuario for novo
          //adidionar usuario no firebase
          DocumentReference doc = await Firestore.instance.collection("usuarios")
              .add({
            "nome": usuario.senderName,
            "idSistemaLogin": usuario.idSistemaLogin,
            "quantAgradecimentos": usuario.quantAgradecimentos,
            "quantPedidos": usuario.quantPedidos,
            "photoUrl": usuario.senderPhotoUrl,
          });
          //atualizando id do usuario adcionado
          await Firestore.instance.collection("usuarios")
              .document(doc.documentID)
              .updateData({"idFirebase": doc.documentID});
          usuario.idFirebase = doc.documentID;
        }else{
          usuario.idFirebase = usr.documents[0].data["idFirebase"];
          usuario.quantAgradecimentos = usr.documents[0].data["quantAgradecimentos"];
          usuario.quantPedidos = usr.documents[0].data["quantPedidos"];
          usuario.senderPhotoUrl = usr.documents[0].data["photoUrl"];
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("FacebookLoginStatus.cancelledByUser");
        break;
      case FacebookLoginStatus.error:
        print(FacebookLoginStatus.error);
        break;
    }
  }



  //============================================
  //ENVIAR PEDIDO                              |
  //============================================

  void enviaPedido(String pedido)async{

    DocumentReference doc = await Firestore.instance.collection("pedidos").add({
      "text":pedido,
      "senderName": usuario.senderName,
      "senderPhoto": usuario.senderPhotoUrl,
      "idUsrFirebase" : usuario.idFirebase,
    });

    usuario.quantPedidos = usuario.quantPedidos +1;
    await Firestore.instance.collection('usuarios').document(usuario.idFirebase).updateData({"quantPedidos":usuario.quantPedidos});
    await Firestore.instance.collection('pedidos').document(doc.documentID).updateData({"idPedFirebase":doc.documentID});
  }

  //============================================
  //ADICIONA ORADOR                            |
  //============================================
  Future<Null> adicionaOrador(var idPedido)async{
    //adiciona orador no pedido
    await Firestore.instance.collection("pedidos").document(idPedido).collection("pessoasOram").add({"idFirebase":usuario.idFirebase});

    //adiciona no usuario pedidio que esta orando
    await Firestore.instance.collection("usuarios").document(usuario.idFirebase).collection("pedidosOram").add({"idFirebase":idPedido});

  }

  Future<Null> removeOrador(var idPedido)async{
    QuerySnapshot docs = await Firestore.instance.collection("pedidos").document(idPedido).collection("pessoasOram").where("idFirebase",isEqualTo: usuario.idFirebase).getDocuments();

    //remove orador dos pedidos
    for(var doc in docs.documents){
      await Firestore.instance.collection("pedidos").document(idPedido).collection("pessoasOram").document(doc.documentID).delete();
    }

    //remove pedido orado do usuario
    QuerySnapshot pedidos = await Firestore.instance.collection("usuarios").document(usuario.idFirebase).collection("pedidosOram").where("idFirebase",isEqualTo: idPedido).getDocuments();

    for(var ped in pedidos.documents){
      await Firestore.instance.collection("usuarios").document(usuario.idFirebase).collection("pedidosOram").document(ped.documentID).delete();
    }

  }

  Future<bool> verificaExistenciaPedido(String idPedido)async{
    QuerySnapshot pedidos = await Firestore.instance.collection("usuarios").document(usuario.idFirebase).collection("pedidosOram").where("idFirebase",isEqualTo: idPedido).getDocuments();
    if(pedidos.documents.length != 0){
      return true;
    }
    return false;
  }

  Future<Usuario> pesquisaUsuario(String idUsuario)async{

    Usuario usuario = Usuario();
    QuerySnapshot docs = await Firestore.instance.collection("usuarios").where("idFirebase",isEqualTo: idUsuario).getDocuments();
    usuario.idFirebase = docs.documents[0]["idFirebase"];
    usuario.senderPhotoUrl = docs.documents[0]["photoUrl"];
    usuario.senderName = docs.documents[0]["nome"];
    usuario.quantAgradecimentos = docs.documents[0]["quantAgradecimentos"];
    usuario.quantPedidos = docs.documents[0]["quantPedidos"];

    return usuario;
  }

  Future<File> _pickImage(File imageFile) async {
    return imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<File> _cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.blue
    );
    return croppedFile;
  }

  Future<File> selecionaImagem()async{
    File imageFile;
    imageFile = await _pickImage(imageFile);
    if(imageFile != null)
      return imageFile = await _cropImage(imageFile);
    else
      return null;
  }

  Future<Null> atualizaNomeBiografia({String nome, String biografia})async{

    if(nome!=null) {
      print("aaaaaa");
      await Firestore.instance.collection("usuarios").document(
          usuario.idFirebase).updateData({"nome": nome});
      usuario.senderName = nome;
    }

    if(biografia!=null) {
      await Firestore.instance.collection("usuarios").document(
          usuario.idFirebase).updateData({"biografia": biografia});
          usuario.biografia = biografia;
    }
  }
}


