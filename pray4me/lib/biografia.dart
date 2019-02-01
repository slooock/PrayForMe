import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pray4me/Controladores/ControladorTelas.dart';
import 'package:pray4me/Controladores/ControladorUsuario.dart';


class BiografiaPage extends StatefulWidget {
  @override
  _BiografiaPageState createState() => _BiografiaPageState();
}

class _BiografiaPageState extends State<BiografiaPage> {

  var controladorUsuario = ControladorUsuarioSingleton();
  var controladorTela = ControladorTelasSingleton();
  final _textControler = TextEditingController();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text(
                  "Digite uma frase\ninspiradora",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              TextField(
                onChanged: (text){
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                controller: _textControler,
                maxLength: 300,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.blue,
                    disabledColor: Color.fromRGBO(135, 206, 235, 100.0),
                    disabledTextColor: Colors.white,
                    onPressed: _isComposing ? ()async{
                      await controladorUsuario.atualizaNomeBiografia(biografia: _textControler.text);
                      controladorTela.showHomePage(context);
                    } : null,
                    textColor: Colors.white,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    child: Text(
                      "Enviar",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                ),
              ),
            ],
          ),
        )
    );
  }
}
