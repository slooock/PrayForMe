import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pray4me/Controladores/ControladorTelas.dart';
import 'package:pray4me/Controladores/ControladorUsuario.dart';


class PedidoPage extends StatefulWidget {
  PedidoPage();

  @override
  _PedidoPageState createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {

  var controladorUsuario = ControladorUsuarioSingleton();
  var controladorTela = ControladorTelasSingleton();

  dynamic contextPage;
  bool _isComposing = false;

  FormPedido(contextPage) {
    this.contextPage = contextPage;
  }

  final _textControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 30.0),
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.close),
                      iconSize: 35.0,
                      onPressed: () {
                        _requestPop(context, _textControler);
                      },
                      color: Colors.blue,
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 15.0),
                      child: RaisedButton(
                        color: Colors.blue,
                        disabledColor: Color.fromRGBO(135, 206, 235, 100.0),
                        disabledTextColor: Colors.white,
                        onPressed: _isComposing
                            ? () async{
                          await controladorUsuario.enviaPedido(_textControler.text);
                          Navigator.pop(context);
                        }
                            : null,
                        textColor: Colors.white,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: Text(
                          "Enviar",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                      ),
                    )
                  ],
                )),
            Container(
//                decoration: BoxDecoration(color: Colors.blue),
                margin: EdgeInsets.only(bottom: 10.0),
                height: MediaQuery.of(context).size.height / (2.3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            controladorUsuario.usuario.senderPhotoUrl
                        ),
                        maxRadius: 25.0,
                      ),
                    ),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.only(right: 10.0),
                          child: TextField(
                            style:
                            TextStyle(color: Colors.black, fontSize: 20.0),
                            onChanged: (text) {
                              setState(() {
                                _isComposing = text.length > 0;
                              });
                            },
                            controller: _textControler,
                            maxLines: null,
                            decoration: InputDecoration(
                                hintText: 'Faça um pedido',
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none)),
                          )),
                    )
                  ],
                ))
          ],
        ));
  }
}

Future<bool> _requestPop(context, dynamic msg) {
  if (msg.text.length != 0) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Descartar pedido?."),
            actions: <Widget>[
              FlatButton(
                child: Text("CANCELAR"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("SIM"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
    //    return Future.value(false);
  } else {
    Navigator.pop(context, true);
//    return Future.value(true);
  }
}
