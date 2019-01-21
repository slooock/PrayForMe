import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pray4me/Controladores/ControladorTelas.dart';
import 'package:pray4me/Controladores/ControladorUsuario.dart';

class CadastroPage extends StatefulWidget {
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  bool isLoggedIn = false;
  var controladorUsuario = ControladorUsuarioSingleton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                child: IconButton(
                  onPressed: (){},
                  icon: Icon(MdiIcons.facebookBox,
                  ),
                  iconSize: 40,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  color: Colors.blue,
                ),
              ),
              ButtonTheme(
                child: IconButton(
                  onPressed: (){
                    controladorUsuario.loginGoogle();
                  },
                  icon: Icon(MdiIcons.google,
                  ),
                  iconSize: 40,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  color: Colors.redAccent,
                ),
              ),
              ButtonTheme(
                child: IconButton(
                  onPressed: (){},
                  icon: Icon(MdiIcons.email,
                  ),
                  iconSize: 40,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  color: Colors.amberAccent,
                ),
              )
            ],
          ),
        ],
      )
    );
  }




}
