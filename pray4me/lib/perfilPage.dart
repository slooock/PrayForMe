import 'package:flutter/material.dart';
import 'package:pray4me/Controladores/ControladorTelas.dart';
import 'package:pray4me/Controladores/ControladorUsuario.dart';
import 'package:pray4me/Modelo/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PerfilPage extends StatefulWidget {
  Usuario usuario;
  PerfilPage(this.usuario);
  @override
  _PerfilPageState createState() => _PerfilPageState(usuario);
}

class _PerfilPageState extends State<PerfilPage> {
  Usuario usuario;
  _PerfilPageState(this.usuario);
  bool _controllerPerfil = true;


  @override
  void initState() {
    _controllerPerfil = true;
    super.initState();
  }

  @override
  void dispose() {
    _controllerPerfil = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controllerPerfil = true;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: (){
                Navigator.pop(context);
              }
          ),
          title: Text("Perfil",
            style: TextStyle(
                color: Colors.black
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: StreamBuilder(
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
                      if(_controllerPerfil){
                        _controllerPerfil = false;
                        return Column(
                          children: <Widget>[
                            CardPerfil(usuario),
                            CardPedido(r[index].data,usuario)
                          ],
                        );
                      }
                      return CardPedido(r[index].data,usuario);
                    },
                  );
              }
            }

        )
    );
  }
}



class CardPerfil extends StatefulWidget {
  Usuario usuario;
  CardPerfil(this.usuario);

  @override
  _CardPerfilState createState() => _CardPerfilState(usuario);
}

class _CardPerfilState extends State<CardPerfil> {

  Usuario usuario;
  var controladorTela = ControladorTelasSingleton();
  var controladorUsuario = ControladorUsuarioSingleton();
  _CardPerfilState(this.usuario);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              SizedBox(
                child: Container(
                  color: Colors.red,
                ),
              ),
              Positioned(
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height/4.6,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage("https://pbs.twimg.com/profile_banners/146214409/1460576856/600x200")
                              )
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10,left: 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    FutureBuilder(
                                        future: controladorUsuario.verificaPerfilVisitado(usuario.idFirebase),
                                        builder: (context,snapshot){
                                          if(snapshot.hasData) {
                                            if (snapshot.data)
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: OutlineButton(
                                                    child: new Text(
                                                      "Editar perfil",
                                                      style: TextStyle(),
                                                    ),
                                                    onPressed: () {
                                                      controladorTela
                                                          .showEditPage(
                                                          context);
                                                    },
                                                    borderSide: BorderSide(
                                                        color: Colors.black38
                                                    ),
                                                    shape: new RoundedRectangleBorder(
                                                        borderRadius: new BorderRadius
                                                            .circular(30.0))
                                                ),
                                              );
                                            else
                                              return Container(
                                                padding: EdgeInsets.only(
                                                    top: 45),
                                              );
                                          }else{
                                            return Container();
                                          }
                                        }
                                    ),
                                  ],
                                ),
                                Text( usuario.idFirebase == controladorUsuario.usuario.idFirebase ? controladorUsuario.usuario.senderName :
                                  usuario.senderName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text( usuario.idFirebase == controladorUsuario.usuario.idFirebase ? controladorUsuario.usuario.biografia :
                                    usuario.biografia,
                                    style: TextStyle(
                                        fontSize: 17
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Text(usuario.quantPedidos.toString(),
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text("Pedidos",
                                          style: TextStyle(
                                              fontSize: 17
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: Text(usuario.quantAgradecimentos.toString(),
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text("Orações",
                                          style: TextStyle(
                                              fontSize: 17
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider()
                  ],
                ),
              ),

              Positioned(
                  left: 20.0,
                  top: 100.0,
                  width: 100.0,
                  height: 100.0,
                  child: Container(
                      child: new CircleAvatar(
                          backgroundImage: NetworkImage(usuario.senderPhotoUrl),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue
                      ),
                      width: 32.0,
                      height: 32.0,
                      padding: const EdgeInsets.all(5.0), // borde width
                      decoration: new BoxDecoration(
                        color: const Color(0xFFFFFFFF), // border color
                        shape: BoxShape.circle,
                      )
                  )
              ),
            ],
          ),
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
  var controladorTela = ControladorTelasSingleton();

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
                  Text(data["text"]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          controladorTela.showOrandoPage(context, data["idPedFirebase"]);
                        },
                        child: StreamBuilder(
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
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
