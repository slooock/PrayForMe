import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pray4me/Controladores/ControladorTelas.dart';
import 'package:pray4me/Controladores/ControladorUsuario.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pray4me/Controladores/blocGlobal.dart';
import 'package:pray4me/Controladores/blocTeste.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  AppState state;
  File imageFile;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }
  var controladorUsuario = ControladorUsuarioSingleton();
  final _textNameControler = TextEditingController();
  final _textBioController = TextEditingController();


  @override
  void dispose() {
    super.dispose();
    _textNameControler.dispose();
    _textBioController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final BlocController bloc = BlocProvider.of<BlocController>(context);
    bloc.changeImage(controladorUsuario.usuario.senderPhotoUrl);
    _textNameControler.text = controladorUsuario.usuario.senderName;
    _textBioController.text = controladorUsuario.usuario.biografia;

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
            onPressed: ()async{
              await controladorUsuario.atualizaNomeBiografia(nome:_textNameControler.text,biografia: _textBioController.text);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20,top:20,right: 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              StreamBuilder(
                stream: bloc.outImage,
                builder: (context, snap){
                  if(snap.hasData) return CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(snap.data),
                  );
                  else
                    return Container();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: RaisedButton(
                    onPressed: ()async{

                      imageFile = await controladorUsuario.selecionaImagem();

                      if(imageFile == null) return;

                      FirebaseStorage.instance.ref().
                      child(controladorUsuario.usuario.idFirebase).delete();

                      StorageUploadTask task = FirebaseStorage.instance.ref().
                        child(controladorUsuario.usuario.idFirebase).putFile(imageFile);
                      String downloadUrl;

                      await task.onComplete.then((s) async {
                        downloadUrl = await s.ref.getDownloadURL();
                      });
                      Firestore.instance.collection("usuarios").
                        document(controladorUsuario.usuario.idFirebase).updateData({"photoUrl":downloadUrl});

                      bloc.changeImage(downloadUrl);
                      controladorUsuario.usuario.senderPhotoUrl = downloadUrl;
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
                    controller: _textNameControler,
//                  initialValue: controladorUsuario.usuario.senderName,

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
                    controller: _textBioController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<Null> _pickImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      toolbarTitle: 'Cropper',
      toolbarColor: Colors.blue

    );
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }
}

enum AppState {
  free,
  picked,
  cropped,
}

