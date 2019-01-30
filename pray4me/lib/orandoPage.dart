import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pray4me/Controladores/ControladorTelas.dart';
import 'package:pray4me/Controladores/ControladorUsuario.dart';

class OrandoPage extends StatefulWidget {
  String idPedido;
  OrandoPage(this.idPedido);
  @override
  _OrandoPageState createState() => _OrandoPageState(idPedido);
}

class _OrandoPageState extends State<OrandoPage> {

  ControladorTelasSingleton controladorTelas = ControladorTelasSingleton();
  String idPedido;
  _OrandoPageState(this.idPedido);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: false,
          title: Text("Orando",
            style: TextStyle(
                color: Colors.black,
                fontSize: 25
            ),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: (){
                Navigator.pop(context);
              }
          )
      ),
      body:Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
                stream: Firestore.instance.collection("pedidos").document(idPedido).collection("pessoasOram").snapshots(),
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
                          return GestureDetector(
                            child: CardPessoa(r[index].data),
                            onTap: (){
                              controladorTelas.showPerfilPage(context, r[index].data["idFirebase"]);
                            },
                          );
                        },
                      );
                  }
                }
            ),
          )
        ],
      ),
    );
  }
}

class CardPessoa extends StatefulWidget {
  final Map<String, dynamic> data;
  CardPessoa(this.data);
  @override
  _CardPessoaState createState() => _CardPessoaState(data);
}

class _CardPessoaState extends State<CardPessoa> {

  final Map<String, dynamic> data;
  _CardPessoaState(this.data);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10,top: 10,right: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                stream: Firestore.instance.collection("usuarios").document(data["idFirebase"]).snapshots(),
                builder: (context,snapshot){
                  if(snapshot.hasData) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data["photoUrl"]),
                      radius: 30,
                    );
                  }else{
                    return Container();
                  }
                },
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        StreamBuilder(
                          stream: Firestore.instance.collection("usuarios").document(data["idFirebase"]).snapshots(),
                          builder: (context,snapshot){
                            if(snapshot.hasData) {
                              return Text(snapshot.data["nome"],
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              );
                            }else{
                              return Container();
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: StreamBuilder(
                            stream: Firestore.instance.collection("usuarios").document(data["idFirebase"]).snapshots(),
                            builder: (context,snapshot){
                              if(snapshot.hasData) {
                                return Text(snapshot.data["biografia"],
                                  style: TextStyle(
                                      fontSize: 17
                                  ),
                                );
                              }else{
                                return Container();
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
        Divider(
          color: Colors.black38,
        )
      ],
    );
  }
}
