import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pray4me/Controladores/ControladorTelas.dart';
import 'package:pray4me/Controladores/ControladorUsuario.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  var _controller = ScrollController();

  var controladorUsuario = ControladorUsuarioSingleton();
  var controladorTela = ControladorTelasSingleton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Perfil",
          style: TextStyle(
            fontSize: 25,
            color: Colors.black
          ),
        ),
        elevation: 1,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(controladorUsuario.usuario.senderPhotoUrl),
                  radius: 50,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(controladorUsuario.usuario.quantPedidos.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.0),
                                    child: Text("Pedidos",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey
                                        )
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(controladorUsuario.usuario.quantAgradecimentos.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22
                                      )
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(top: 4.0),
                                      child: Text("Agradecimentos",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey
                                          )
                                      )
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text("3123",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      )
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(top: 4.0),
                                      child:
                                      Text("Oradas",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey

                                          )
                                      )
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: OutlineButton(
                            color: Colors.white,
                            onPressed: ()async{},
                            child: Text("Editar perfil"),
//                            highlightColor: Colors.lightBlue,
//                            disabledBorderColor: Colors.lightBlue,
                            splashColor: Colors.lightBlue,

                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 20.0,bottom: 20.0),
                  decoration: BoxDecoration(
                      border: BorderDirectional(
                          bottom: BorderSide(
                              color: Colors.black12
                          )
                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(controladorUsuario.usuario.senderName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text("Created for a place i've never known"),
                    ],
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: StreamBuilder(
              stream: Firestore.instance.collection("pedidos").where("idUsrFirebase",isEqualTo: controladorUsuario.usuario.idFirebase).snapshots(),
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
                          return CardPedido(r[index].data);
                        },
                      );
                  }
                }

            )
          )
        ],
      ),
    );
  }
}


class CardPedido extends StatefulWidget {

  final Map<String, dynamic> data;
  CardPedido(this.data);

  @override
  _CardPedidoState createState() => _CardPedidoState(this.data);
}

class _CardPedidoState extends State<CardPedido> {

  final Map<String, dynamic> data;
  _CardPedidoState(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
      decoration: BoxDecoration(
          border: BorderDirectional(
              bottom: BorderSide(
                  color: Colors.black12
              )
          )
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(
              data["senderPhoto"]
            ),
            maxRadius: 30,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(data["senderName"],
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Text(data["text"])
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
