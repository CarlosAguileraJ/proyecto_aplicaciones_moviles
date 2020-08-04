import 'package:flutter/material.dart';

class ajustes extends StatefulWidget {
  @override
  _ajustesState createState() => _ajustesState();
}

class _ajustesState extends State<ajustes> {
  String _group1SelectedValue;

  @override
  void initState() {
    _group1SelectedValue = "";// agregar aqui variable donde se almacenara idioma

    super.initState();
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
                Text("\n "),
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
                    "Otro",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                  leading: Radio(
                      value: "Otro",
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
                    label: Text("Guardar"),
                    onPressed: (){},
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
