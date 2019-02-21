import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pray4me/Controladores/ControladorTelas.dart';
import 'package:pray4me/Controladores/ControladorUsuario.dart';
import 'package:pray4me/Modelo/Usuario.dart';
import 'package:pray4me/home_page.dart';

class CadastroPage extends StatefulWidget {
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  bool isLoggedIn = false;
  var controladorUsuario = ControladorUsuarioSingleton();
  var controladorTela = ControladorTelasSingleton();
  bool _controladorIconeFace = false;
  bool _controladorIconeGoogle = false;

  @override
  void initState() {
    super.initState();
    _controladorIconeFace = false;
    _controladorIconeGoogle = false;

    controladorUsuario.usuario = new Usuario();

    controladorUsuario.usuario.idFirebase = "idFirebase";
    controladorUsuario.usuario.quantPedidos = 0;
    controladorUsuario.usuario.senderPhotoUrl = "photoUrl";
    controladorUsuario.usuario.senderName = "Nome Usuario";
    controladorUsuario.usuario.biografia = "Frase inspiradora";
    controladorUsuario.usuario.quantAgradecimentos = 0;
    controladorUsuario.usuario.idSistemaLogin = "idSistemaLogin";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('#PrayForMe',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: 20
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              color: Colors.blue,
              icon: Icon(
                Icons.arrow_back_ios,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonTheme(
                  child: _controladorIconeFace == false? IconButton(
                    onPressed: ()async{

                      setState(() {
                        if(_controladorIconeFace)
                          _controladorIconeFace = false;
                        else
                          _controladorIconeFace = true;
                      });

                      if(await controladorUsuario.loginFacebook()){
                        controladorTela.showBiografiaPage(context);
                      }else{
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
                          ModalRoute.withName("/"),
                        );
                      }
                    },
                    icon: Icon(MdiIcons.facebookBox,
                    ),
                    iconSize: 40,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    color: Colors.blue,
                  ): CircularProgressIndicator(),
                ),
                ButtonTheme(
                  child: _controladorIconeGoogle == false? IconButton(
                    onPressed: ()async{

                      setState(() {
                        if(_controladorIconeGoogle)
                          _controladorIconeGoogle = false;
                        else
                          _controladorIconeGoogle = true;
                      });

                      if(await controladorUsuario.loginGoogle()){
                        controladorTela.showBiografiaPage(context);
                      }else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
                          ModalRoute.withName("/"),
                        );
//                       controladorTela.showHomePage(context);
                      }
                    },
                    icon: Icon(MdiIcons.google,
                    ),
                    iconSize: 40,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    color: Colors.redAccent,
                  ): CircularProgressIndicator(
                    value: null,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
//                ButtonTheme(
//                  child: IconButton(
//                    onPressed: (){
//                      Navigator.pushAndRemoveUntil(
//                        context,
//                        MaterialPageRoute(builder: (BuildContext context) => HomePage()),
//                        ModalRoute.withName("/"),
//                      );
//                    },
//                    icon: Icon(MdiIcons.email,
//                    ),
//                    iconSize: 40,
//                    highlightColor: Colors.transparent,
//                    splashColor: Colors.transparent,
//                    color: Colors.amberAccent,
//                  ),
//                ),
              ],
            ),
          ],
        )
    );
  }




}
