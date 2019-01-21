import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pray4me/Controladores/ControladorTelas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class InicialPage extends StatefulWidget {
  _InicialPageState createState() => _InicialPageState();
}

class _InicialPageState extends State<InicialPage> {
  var _controladorPag = ControladorTelasSingleton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Veja o que está \nacontecendo no mundo\nneste momento",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 45,
                      child: RaisedButton(
                        child: Text(
                          "Comece já",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                        elevation: 0,
                        highlightElevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        onPressed: () {
                            _controladorPag.showCadastroPage(context);
                        },
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Text(
                      "Já tem uma conta? ",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    InkWell(
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.blue
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

