import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pray4me/Controladores/ControladorTelas.dart';
import 'package:pray4me/Controladores/ControladorUsuario.dart';
import 'package:image_cropper/image_cropper.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  var controladorUsuario = ControladorUsuarioSingleton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        title: Text("Editar Perfil",
          style: TextStyle(
              color: Colors.black
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
            iconSize: 30,
            icon: Icon(Icons.close,
              color: Colors.black,
            ),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            color: Colors.blue,
            iconSize: 30,
            onPressed: (){},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20,top:20,right: 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                  controladorUsuario.usuario.senderPhotoUrl,
                ),
                radius: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: RaisedButton(
                    onPressed: (){

                    },
                    child: Text("Alterar foto",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    colorBrightness: Brightness.light,
                  color: Colors.white,
                  highlightColor: Colors.white,
                  splashColor: Colors.white,
                  elevation: 0,
                  highlightElevation: 0,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Nome",
                    style: TextStyle(
                      color: Colors.black38
                    ),
                  ),
                  TextFormField(
                    initialValue: controladorUsuario.usuario.senderName,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text("Biografia",
                      style: TextStyle(
                          color: Colors.black38
                      ),
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.add),
                color: Colors.blue,
                onPressed: (){

                  var controladorTela = ControladorTelasSingleton();
                  controladorTela.showPickImagePage(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Null> _cropImage(File imageFile) async {
  File croppedFile = await ImageCropper.cropImage(
    sourcePath: imageFile.path,
    ratioX: 1.0,
    ratioY: 1.0,
    maxWidth: 512,
    maxHeight: 512,
  );
}