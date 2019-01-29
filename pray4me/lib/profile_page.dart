import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pray4me/Controladores/ControladorTelas.dart';
import 'package:pray4me/Controladores/ControladorUsuario.dart';
import 'package:pray4me/Controladores/blocTeste.dart';
import 'package:pray4me/Modelo/Usuario.dart';

class ProfilePage extends StatefulWidget {
  Usuario usuario;
  ProfilePage(this.usuario);

  @override
  _ProfilePageState createState() => _ProfilePageState(usuario);
}

class _ProfilePageState extends State<ProfilePage> {

  Usuario usuario;
  _ProfilePageState(this.usuario);

  var controladorUsuario = ControladorUsuarioSingleton();
  var controladorTela = ControladorTelasSingleton();

  @override
  Widget build(BuildContext context) {
    final BlocController bloc = BlocProvider.of<BlocController>(context);

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
                FutureBuilder<Usuario>(
                    future: controladorUsuario.pesquisaUsuario(usuario.idFirebase),
                    builder: (context,snap){
                      if(snap.connectionState == ConnectionState.done){
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(snap.data.senderPhotoUrl),
                        );
                      }else{
                        return CircularProgressIndicator();
                      }
                    }
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
                                  Text(usuario.quantPedidos.toString(),
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
                                  Text(usuario.quantAgradecimentos.toString(),
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
                          height: 30,
                          width: double.infinity,
                          child: OutlineButton(
                            onPressed: (){
                              controladorTela.showEditPage(context);
                            },
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
                      FutureBuilder<Usuario>(
                          future: controladorUsuario.pesquisaUsuario(usuario.idFirebase),
                          builder: (context,snap){
                            if(snap.connectionState == ConnectionState.done){
                              return Text(
                                  snap.data.senderName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              );
                            }else{
                              return Container();
                            }
                          }
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: FutureBuilder<Usuario>(
                            future: controladorUsuario.pesquisaUsuario(usuario.idFirebase),
                            builder: (context,snap){
                              if(snap.connectionState == ConnectionState.done){
                                return Text(snap.data.biografia);
                              }else{
                                return Container();
                              }
                            }
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Expanded(
              child: StreamBuilder(
                  stream: Firestore.instance.collection("pedidos").where("idUsrFirebase",isEqualTo: usuario.idFirebase).snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            List r = snapshot.data.documents.reversed.toList();
                            return CardPedido(r[index].data,usuario);
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

  Usuario usuario;
  final Map<String, dynamic> data;
  CardPedido(this.data,this.usuario);

  @override
  _CardPedidoState createState() => _CardPedidoState(this.data,usuario);
}

class _CardPedidoState extends State<CardPedido> {

  Usuario usuario;
  final Map<String, dynamic> data;
  _CardPedidoState(this.data,this.usuario);

  var controladorUsuario = ControladorUsuarioSingleton();

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
          FutureBuilder<Usuario>(
              future: controladorUsuario.pesquisaUsuario(usuario.idFirebase),
              builder: (context,snap){
                if(snap.connectionState == ConnectionState.done){
                  return CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(snap.data.senderPhotoUrl),
                  );
                }else{
                  return CircularProgressIndicator();
                }
              }
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
                    child:FutureBuilder<Usuario>(
                        future: controladorUsuario.pesquisaUsuario(usuario.idFirebase),
                        builder: (context,snap){
                          if(snap.connectionState == ConnectionState.done){
                            return Text(
                              snap.data.senderName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            );
                          }else{
                            return Container();
                          }
                        }
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
