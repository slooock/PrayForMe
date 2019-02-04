import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pray4me/Controladores/ControladorTelas.dart';
import 'package:pray4me/Controladores/ControladorUsuario.dart';
import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pray4me/pedido_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

var _controller = ScrollController();

class _HomePageState extends State<HomePage> {


  final StreamController<Color> _streamController = StreamController<Color>();
  Color _colorController = Colors.black26;

  void changeCor(){

    if(_colorController == Colors.black26){
      _colorController = Colors.blue;
    }else{
      _colorController = Colors.black26;
    }
    _streamController.sink.add(_colorController);
  }

  void setColor(Color color){

    _colorController = color;

    _streamController.sink.add(_colorController);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  var controladorUsuario = ControladorUsuarioSingleton();
  var controladorTela = ControladorTelasSingleton();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            automaticallyImplyLeading: false,
            title: Text('Página inicial',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25
              ),
            ),
            backgroundColor: Colors.white,
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 155,
                  decoration: BoxDecoration(
                      border: BorderDirectional(
                          bottom: BorderSide(
                              color: Colors.black12
                          )
                      )
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 10,left: 20,right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            controladorTela.showPerfilPage(context,controladorUsuario.usuario.idFirebase);
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                controladorUsuario.usuario.senderPhotoUrl
                            ),
                            radius: 30,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(controladorUsuario.usuario.senderName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 20),
                            child:Row(
                              children: <Widget>[
                                StreamBuilder(

                                  stream: Firestore.instance.collection("usuarios").document(controladorUsuario.usuario.idFirebase).snapshots(),
                                  builder: (context,AsyncSnapshot<DocumentSnapshot> snapText){
                                    if(snapText.hasData){
                                      return Text(snapText.data.data["quantPedidos"].toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
//                                color: Colors.grey
                                          )
                                      );
                                    }else{
                                      return Text("?",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
//                                color: Colors.grey
                                          )
                                      );
                                    }
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4,right: 15),
                                  child: Text("Pedidos",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black54
                                      )
                                  ),
                                ),
                                StreamBuilder(
                                    stream: Firestore.instance.collection("usuarios").document(controladorUsuario.usuario.idFirebase).collection("pedidosOram").snapshots(),
                                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                                      if(snapshot.hasData){
                                        return Text(snapshot.data.documents.length.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            )
                                        );
                                      }else {
                                        return Container();
                                      }
                                    }
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Text("Orações",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black54
                                      )
                                  ),
                                )
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                        onPressed: (){
                          controladorTela.showPerfilPage(context,controladorUsuario.usuario.idFirebase);
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.account_circle,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text("Perfil",
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: (){
                          controladorTela.showPerfilPage(context,controladorUsuario.usuario.idFirebase);
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.home,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text("Home",
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.arrow_back,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text("Sair",
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async{
              controladorTela.showPedidoPage(context);

            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder(
                    stream: Firestore.instance.collection("pedidos").snapshots(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        default:
                          return ListView.builder(
                            controller: _controller,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              List r = snapshot.data.documents.reversed.toList();
                              return CardBloc(r[index].data);
                            },
                          );
                      }
                    }
                ),
              ),
            ],
          )
      ),
    );
  }

  Future<bool> _requestPop(){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
//            title: Text("Deseja sair?"),
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))
          ),
            content: Text("Deseja sair?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Sim"),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
    return Future.value(false);

  }
}


class CardBloc extends StatefulWidget {
  final Map<String, dynamic> data;
  CardBloc(this.data);
  @override
  _CardBlocState createState() => _CardBlocState(data);
}

class _CardBlocState extends State<CardBloc> {

  final Map<String, dynamic> data;
  _CardBlocState(this.data);

  final StreamController<Color> _streamController = StreamController<Color>();
  Color _colorController = Colors.black26;

  var _controladorTela = ControladorTelasSingleton();

  void changeCor(){

    if(_colorController == Colors.black26){
      _colorController = Colors.blue;
    }else{
      _colorController = Colors.black26;
    }
    _streamController.sink.add(_colorController);
  }

  void setColor(Color color){

    _colorController = color;

    _streamController.sink.add(_colorController);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  var controladorUsuario = ControladorUsuarioSingleton();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20,top: 10),
            child: Column(
              children: <Widget>[
                StreamBuilder(
                  stream: Firestore.instance.collection("usuarios").document(controladorUsuario.usuario.idFirebase).collection("pedidosOram").snapshots(),
                  builder: (context,snap){
                    switch (snap.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: Container(),
                        );
                      default:
                        List list = snap.data.documents.toList();
                        for(var item in list){
                          if(item['idFirebase']==data['idPedFirebase']){
                            setColor(Colors.blue);
                          }
                        }
                        return Container();
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      child: StreamBuilder(
                        stream: Firestore.instance.collection("usuarios").document(data['idUsrFirebase']).snapshots(),
                        builder: (context,snaps){
                          switch (snaps.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return Center(
                                child: Container(),
                              );
                            default:
                              return  CircleAvatar(
                                backgroundImage: NetworkImage(snaps.data.data["photoUrl"]),
                                radius: 30,
                              );
                          }
                        },
                      ),
                      onTap: (){
                        _controladorTela.showPerfilPage(context,data["idUsrFirebase"].toString());
                      },
                    ),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: StreamBuilder(
                                    stream: Firestore.instance.collection("usuarios").document(data['idUsrFirebase']).snapshots(),
                                    builder: (context,snaps){

                                      if(snaps.hasData) return  Text(
                                        snaps.data.data["nome"],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                      );
                                      else
                                        return Container();
                                    },
                                  ),
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0,top: 10,right: 10),
                              child: Text(
                                data["text"],
                                style: TextStyle(
                                    fontSize: 17
                                ),
                              ),
                            ),
                          ],
                        )
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    StreamBuilder(
                        stream: _streamController.stream,
                        initialData: Colors.black26,
                        builder: (context,snapshot){
                          return IconButton(
                            icon: Icon(FontAwesomeIcons.prayingHands),
                            splashColor: Colors.transparent,
                            color: snapshot.data,
                            iconSize: 15,
                            onPressed: (){
                              if(snapshot.data == Colors.black26){
                                controladorUsuario.adicionaOrador(data['idPedFirebase']);
                              }else{
                                controladorUsuario.removeOrador(data["idPedFirebase"]);
                              }
                              changeCor();
                            },
                          );
                        }
                    ),
                    StreamBuilder(
                      stream: Firestore.instance.collection("pedidos").document(data["idPedFirebase"]).collection("pessoasOram").snapshots(),
                      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                        if(snapshot.hasData){
                          return Container(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("${snapshot.data.documents.length} orando",
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 17
                              ),
                            ),
                          );
                        }else{
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
          )
        ],
      ),
      onTap: (){
        _controladorTela.showOrandoPage(context, data["idPedFirebase"]);
      },
    );
  }

}


