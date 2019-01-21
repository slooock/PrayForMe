
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pray4me/Modelo/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


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

  Future<Null> loginGoogle()async{
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
    }else{
      usuario.idFirebase = usr.documents[0].data["idFirebase"];
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

        //çogando no firebase
        await FirebaseAuth.instance.signInWithFacebook(accessToken: result.accessToken.token);

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
        }else{
          usuario.idFirebase = usr.documents[0].data["idFirebase"];
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



}