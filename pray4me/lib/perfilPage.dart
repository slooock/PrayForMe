import 'package:flutter/material.dart';
import 'package:pray4me/Controladores/ControladorTelas.dart';
import 'package:pray4me/Controladores/ControladorUsuario.dart';
import 'package:pray4me/Modelo/Usuario.dart';



class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Perfil Page",
          style: TextStyle(
              color: Colors.black
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              SizedBox(
//                width: MediaQuery.of(context).size.width,
//                height: MediaQuery.of(context).size.height/2,
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
                            padding: const EdgeInsets.only(top: 58,left: 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Kayque Avelar",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text("Created for a plave i've necer knownCreated for a plave i've necer knownCreated for a plave i've necer knownCreated for a plave i've necer knownCreated for a plave i've necer knownCreated for a plave i've necer knownCreated for a plave i've necer knownCreated for a plave i've necer knownCreated for a plave i've necer knownCreated for a plave i've necer knownCreated for a plave i've necer knownCreated for a plave i've necer knownCreated for a plave i've necer known",
                                    style: TextStyle(
                                      fontSize: 17
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Text("222",
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
                                        child: Text("321",
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
                          backgroundImage: NetworkImage("https://pbs.twimg.com/profile_images/1032242193912582145/umj0Pzx7_400x400.jpg"),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue
                      ),
                      width: 32.0,
                      height: 32.0,
                      padding: const EdgeInsets.all(4.0), // borde width
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
