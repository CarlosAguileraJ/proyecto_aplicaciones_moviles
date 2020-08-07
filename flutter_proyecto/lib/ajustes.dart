import 'package:flutter/material.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ajustes extends StatefulWidget {
  @override
  _ajustesState createState() => _ajustesState();
}

class _ajustesState extends State<ajustes> {
  String _group1SelectedValue;
  int idioma;

  @override
  void initState() {
    _group1SelectedValue = "";// agregar aqui variable donde se almacenara idioma
    _guardaridioma();

    super.initState();
  }



  _guardaridioma() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() { idioma
       = (prefs.getInt('idioma') ?? 0) + 1;
      prefs.setInt('idioma', idioma);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selección del idioma"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Center(
                    child: RichText(
                        text: TextSpan(
                            text: "\nIdioma selecionado ",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal),
                            children: <TextSpan>[
                      TextSpan(
                          text: '$_group1SelectedValue ',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal)),
                    ])),
                ),
                
                Divider(color: Colors.teal,),

                ListTile(
                  title: Text("Español",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70)),
                  leading: Radio(
                      value: "Español",
                      groupValue: _group1SelectedValue,
                      onChanged: _group1Changes),
                ),
                ListTile(
                  title: Text(
                    "Inglés",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.white70),
                  ),
                  leading: Radio(
                      value: "Inglés",
                      groupValue: _group1SelectedValue,
                      onChanged: _group1Changes),
                ),
                ListTile(
                  title: Text(
                    "Italiano",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                  leading: Radio(
                      value: "Italiano",
                      groupValue: _group1SelectedValue,
                      onChanged: _group1Changes),
                ),
                Text("\n \n"),

                Center(
                  child: OutlineButton.icon(
                    icon: Icon(
                      Icons.save,
                      size: 25.0,
                      color: Colors.teal,
                    ),
                    label: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Guardar", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                    ),
                    onPressed: (){
                      if(_group1SelectedValue == "Español"){
                        idioma = 1;
                      }
                      if(_group1SelectedValue == "Inglés" ){
                        idioma = 2;
                      }
                      if(_group1SelectedValue == "Italiano" ){
                        idioma = 3;
                      }
                      _guardaridioma;


                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            // Recupera el texto que el usuario ha digitado utilizando nuestro
                            // TextEditingController
                            content: Text("Preferencia de idioma guardada" + "\nIdioma guardado: $_group1SelectedValue",
                              style: TextStyle(fontSize: 20),
                            ),
                            contentTextStyle: TextStyle(color: Colors.teal),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],

      ),

    );
  }

  void _group1Changes(String value) {
    setState(() {
      _group1SelectedValue = value;
    });
  }
}
