import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pray4me/Controladores/ControladorTelas.dart';
import 'package:pray4me/Controladores/ControladorUsuario.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

var _controller = ScrollController();

class _HomePageState extends State<HomePage> {

  var controladorUsuario = ControladorUsuarioSingleton();
  var controladorTela = ControladorTelasSingleton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          controladorTela.showProfilePage(context);
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
                              Text(controladorUsuario.usuario.quantPedidos.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
//                                color: Colors.grey
                                  )
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
                              Text(controladorUsuario.usuario.quantAgradecimentos.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  )
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Text("Agradecimentos",
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
                height: MediaQuery.of(context).size.height/3.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      onPressed: (){
                        controladorTela.showProfilePage(context);
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.account_circle),
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
                      onPressed: (){},
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.chrome_reader_mode),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text("Pedidos",
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FlatButton(
                      onPressed: (){},
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.people),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text("Agradecimentos",
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
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
                            return CardHomePage(r[index].data);
                          },
                        );
                    }
                  }
                  ),
            )
          ],
        ));
  }


}


class CardHomePage extends StatefulWidget {
  final Map<String, dynamic> data;
  CardHomePage(this.data);
  _CardHomePageState createState() => _CardHomePageState(data);
}

class _CardHomePageState extends State<CardHomePage> {

  final Map<String, dynamic> data;
  _CardHomePageState(this.data);

  Color _collorButton = Colors.grey;


  var controladorUsuario = ControladorUsuarioSingleton();
  var controladorTela = ControladorTelasSingleton();

  int _counter = 0;
  StreamController<Color> _streamController = StreamController<Color>();


  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Color cor = Colors.black26;
  void _increment(){

    if(cor == Colors.black26){
      cor = Colors.blue;
    }else{
      cor = Colors.black26;
    }
    _streamController.sink.add(cor);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: EdgeInsets.only(top: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(

                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  // 'https://pbs.twimg.com/profile_images/1032242193912582145/umj0Pzx7_400x400.jpg'),
                                    data["senderPhoto"]
                                ),
                                maxRadius: 30.0,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      data["senderName"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: Text(data["text"],
                                        style: TextStyle(
                                            fontSize: 17.0
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
                Container(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        child: IconButton(
                          icon: Icon(FontAwesomeIcons.bowlingBall,
                            color: _collorButton,
                            size: 20,
                          ),
                          onPressed: ()async{
                            setState(() {
                              if(_collorButton == Colors.grey){
                                _collorButton = Colors.blue;
                              }else{
                                _collorButton = Colors.grey;
                              }
                            });
                            if(_collorButton == Colors.grey){
                              await controladorUsuario.removeOrador(data['idPedFirebase']);
                            }else{
                              await controladorUsuario.adicionaOrador(data['idPedFirebase']);
                            }
                          },
                          splashColor: Colors.transparent,
                        ),
                      ),
                      StreamBuilder<Color>(
                        stream: _streamController.stream,
                        builder: (context,snapshot){
                          return IconButton(
                            icon: Icon(
                              Icons.add,
                              color: snapshot.data,
                            ),
                            onPressed: (){
                              _increment();
                            },
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            )
        )
    );
  }
}

