import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; //libreria para realizar conversion de JSON
import 'Modelos/pelicula_modelos.dart'; // importamos file
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart'; //paquete modificar formato de fecha
import 'detalles.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

const baseUrl = "https://api.themoviedb.org/3/movie/"; //constante peliculas now playing
const baseImagenUrl = "https://image.tmdb.org/t/p/"; //url base  para accder a imagenes
const apiKey = "5053a39cc3fbd46cff101eeca1bdf2f3";

String idioma="es";
int _totalItems=0;
int _pageNumber =1;
int _pageNumberup = 1;
int _totalItemsup=0;
int _pageNumbertop =1;
int _totalItemstop=0;
int t;




void main() => runApp(
    MaterialApp(
  debugShowCheckedModeBanner: false, //ocultar barra modo debug
  title: "PELICULAS",
  theme: ThemeData.dark(), // asignamos tema dark
  home: MyPeliculasApp(storage: CounterStorage()),
));

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }


  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<String> readCounter() async {
    try {
      final file = await _localFile;

      // Leer archivo
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // Si encuentras un error, regresamos 0
      return "es";
    }
  }

  Future<File> writeCounter(String idioma) async {
    final file = await _localFile;

    // Escribir archivo
    return file.writeAsString('$idioma');
  }
}


class MyPeliculasApp extends StatefulWidget {
  final CounterStorage storage;


  MyPeliculasApp({Key key, @required this.storage}) : super(key: key);

  @override
  _MyPeliculasApp createState() =>
      new _MyPeliculasApp(); //crear instancia del objeto
}

//objeto tipo estado
class _MyPeliculasApp extends State<MyPeliculasApp> {

  Pelicula nowPlayingMovies; //creamos variable
  Pelicula upcomingMovies;
  Pelicula popularMovies;
  Pelicula topRateMovies;

  // variables para almacenar cambios de paginas de json
  int heroTag = 0;

  @override
  void initState() {
    super.initState();

    widget.storage.readCounter().then((String value) {
      setState(() {
        idioma = value;
        _fetchNowPlayingMovies();
        _fetchUpcomingMovies();
        _fetchPopularMovies();
        _fetchTopRateMovies();

      }
      );
    }

    );



  }

  Future<File> _incrementCounter() {
    setState(() {
      idioma=idioma;
    });

    // Escribe las variables como texto en el archivo
    return widget.storage.writeCounter(idioma);
  }
  void alerta (BuildContext context){
    showDialog<void>(
      context: context,
      builder: (BuildContext){
        return AlertDialog(
          title: Text("Aviso"),
          content: Text("El idioma selecionado se ha guardado y cambiara la próxima vez que inicie la aplicación"),
          backgroundColor: Colors.black.withOpacity(0.7),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        ) ;
      }
    );
  }


  //crear funbcion retornar peliculas

  void _fetchNowPlayingMovies(  ) async {
    var response =
    await http.get("${baseUrl}now_playing?api_key=$apiKey&language=$idioma"); //almacenar resultado de http variable
    var decodeJson = jsonDecode(response.body); //ejecutar json
    //actualizar informacion
    setState(() {
      nowPlayingMovies = Pelicula.fromJson(
          decodeJson); //llamamos metodo json para decodificacion
    });
    //metodo de tipo asyncrono
  }

  void _fetchUpcomingMovies(  ) async {
    var response =
    await http.get("${baseUrl}upcoming?api_key=$apiKey&language=$idioma&page=$_pageNumberup"); //almacenar resultado de http variable
    var decodeJson = jsonDecode(response.body); //ejecutar json
    //actualizar informacion
    upcomingMovies == null ? upcomingMovies = Pelicula.fromJson(decodeJson) : upcomingMovies.results.addAll(Pelicula.fromJson(decodeJson).results); //llamamos metodo json para decodificacion
    //actualizar informacion
    setState(() {
      _totalItemsup = upcomingMovies.results.length;
    });
  }

  void _fetchPopularMovies(   ) async {
    var response =
    await http.get("${baseUrl}popular?api_key=$apiKey&language=$idioma&page=$_pageNumber"); //almacenar resultado de http variable
    var decodeJson = jsonDecode(response.body); //ejecutar json
    popularMovies == null ? popularMovies = Pelicula.fromJson(decodeJson) : popularMovies.results.addAll(Pelicula.fromJson(decodeJson).results); //llamamos metodo json para decodificacion
    //actualizar informacion
    setState(() {
      _totalItems = popularMovies.results.length;
    });
  }

  void _fetchTopRateMovies(  ) async {
    var response =
    await http.get("${baseUrl}top_rated?api_key=$apiKey&language=$idioma&page=$_pageNumbertop"); //almacenar resultado de http variable
    var decodeJson = jsonDecode(response.body); //ejecutar json
    topRateMovies == null ? topRateMovies = Pelicula.fromJson(decodeJson) : topRateMovies.results.addAll(Pelicula.fromJson(decodeJson).results); //llamamos metodo json para decodificacion
    //actualizar informacion
    setState(() {
      _totalItemstop = topRateMovies.results.length;
    });
  }



  //widget para construir carousel
  Widget _buildCarouselSlider() => CarouselSlider(
    items: nowPlayingMovies == null
        ? <Widget>[
      Center(
        child: CircularProgressIndicator(),
      )
    ]
        : nowPlayingMovies.results
        .map((movieItem) => _buildMovieItem(
        movieItem)) //obtenemos las imagenes de poster de la api concatenando link api key y imagen mediante mapeo
        .toList(), //almacenar en variable resultado
    autoPlay: true, //activamos autoplay
    height: 240.0, // asignamos altura poster altura
    viewportFraction: 0.5, // distancia
  );
  //obtenemos imagen accediendo a la ruta

  //cambio de pantallas
  Widget _buildMovieItem(Results movieItem) {
    heroTag += 1;
    movieItem.heroTag = heroTag;
    return Material(
      elevation: 15.0,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => MovieDetail(pelicula: movieItem,)
          )
          );
        }, //****************pantalla detalle
        child: Hero(//animacion hero
          tag: heroTag,
          child: Image.network(
            "${baseImagenUrl}w342${movieItem.posterPath}",
            fit: BoxFit.cover,
          ),
        ),
      ), //efect//animacion de transicion de pantallaso de tap
    );
  }


  // detalles de la pelicula en contenedor
  Widget _buildMoviesListItem(Results movieItem) => Material(
    child: Container(
      width: 125.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(6.0),
              child: _buildMovieItem(
                  movieItem)), // funcion para el tap de cada pelicula
          Padding(
            padding: EdgeInsets.only(left: 6.0, top: 2.0),
            child: Text(
              movieItem.title,
              style: TextStyle(fontSize: 8.0),
              overflow: TextOverflow.ellipsis,
            ), //funcionlidad adaptar texto
          ),
          Padding(
            padding: EdgeInsets.only(left: 6.0, top: 2.0),
            child: Text(
              DateFormat("yyyy").format(DateTime.parse(movieItem.releaseDate)),// aplicamos el formato a la fecha
              semanticsLabel: movieItem.releaseDate,
              style: TextStyle(fontSize: 8.0),
            ),
          ) //contenedor de imagen con imagen y texto
        ],
      ),
    ),
  );

  // se contruyye widget para listas de peliculas
  Widget _buildMoviesListViewpop(Pelicula pelicula, String movieListTittle) =>
      Container(
        height: 258.0,//altura contenedor
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),// color del contenedor
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 7.0, bottom: 7.0),
              child: Text(
                movieListTittle,
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400]),
              ),
            ),
            Flexible(
              //widget flexible para poder hacer scroll infinito
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _totalItems ,
                itemBuilder: (BuildContext context, int index){
                  if (index >= pelicula.results.length -1){
                    _pageNumber ++;
                    _fetchPopularMovies();
                  }
                  return Padding(
                    padding: EdgeInsets.only(left: 6.0, right: 2.0),
                    child: _buildMoviesListItem(pelicula.results[index]),//elementos desplegados
                  );
                },
              ),
            ),
          ],
        ),
      );

  // se contruyye widget para listas de peliculas
  Widget _buildMoviesListViewup(Pelicula pelicula, String movieListTittle) =>
      Container(
        height: 258.0,//altura contenedor
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),// color del contenedor
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 7.0, bottom: 7.0),
              child: Text(
                movieListTittle,
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400]),
              ),
            ),
            Flexible(
              //widget flexible para poder hacer scroll infinito
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _totalItemsup ,
                itemBuilder: (BuildContext context, int index){
                  if (index >= pelicula.results.length -1){
                    _pageNumberup ++;
                    _fetchUpcomingMovies();
                  }
                  return Padding(
                    padding: EdgeInsets.only(left: 6.0, right: 2.0),
                    child: _buildMoviesListItem(pelicula.results[index]),//elementos desplegados
                  );
                },
              ),
            ),
          ],
        ),
      );

  Widget _buildMoviesListViewtop(Pelicula pelicula, String movieListTittle) =>
      Container(
        height: 258.0,//altura contenedor
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),// color del contenedor
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 7.0, bottom: 7.0),
              child: Text(
                movieListTittle,
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400]),
              ),
            ),
            Flexible(
              //widget flexible para poder hacer scroll infinito
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _totalItemstop ,
                itemBuilder: (BuildContext context, int index){
                  if (index >= pelicula.results.length -1){
                    _pageNumbertop ++;
                    _fetchTopRateMovies();
                  }
                  return Padding(
                    padding: EdgeInsets.only(left: 6.0, right: 2.0),
                    child: _buildMoviesListItem(pelicula.results[index]),//elementos desplegados
                  );
                },
              ),
            ),
          ],
        ),
      );



  //contruir arbol widget
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      //appbar
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Inicio",
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true, //centramos el titulo

        actions: <Widget>[
          //ingresar serie de widgets
          IconButton(
            icon: Icon(Icons.language), //icono de busqueda
            color: Colors.white70,
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => SimpleDialog(
                  title: Text('Seleccione un idioma',textAlign: TextAlign.center), backgroundColor: Colors.teal.withOpacity(0.4),
                  children: <Widget>[
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.language),
                      title: Text('Español'),
                      onTap: (){
                        idioma="es";
                        _incrementCounter();
                        alerta(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.language),
                      title: Text('Inglés'),

                      onTap: (){
                        idioma="en";
                        _incrementCounter();
                        alerta(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.language),
                      title: Text('Italiano'),

                      onTap: (){
                        idioma="it";
                        _incrementCounter();
                        alerta(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.language),
                      title: Text('Japones'),

                      onTap: (){
                        idioma="ja";
                        _incrementCounter();
                        alerta(context);
                      },
                    ),

                    ListTile(
                      leading: Icon(Icons.language),
                      title: Text('Ruso'),

                      onTap: (){
                        idioma="ru";
                        _incrementCounter();
                        alerta(context);

                      },
                    ),


                    RaisedButton(

                      child:
                      Text("Regresar",),

                      onPressed: () => Navigator.pop(context, "Ok"),
                      color: Colors.teal.withOpacity(0.7),
                    ),

                  ],

                ),
              );
            },
          )

        ],

      ),

      //widget con scroll
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext contex, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Center(
                //centrar widgwt
                child: Padding(
                  padding:
                  const EdgeInsets.only(bottom: 8.0), //insertar relleno
                  child: Text("ACTUALES",
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              expandedHeight: 290.0,
              floating: false,
              //pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    Container(
                      child: Image.network(
                        "${baseImagenUrl}w500/m0ObOaJBerZ3Unc74l471ar8Iiy.jpg", //imagen de fondo 7WsyChQLEftFiDOVTGkv3hFpyyt.jpg
                        fit: BoxFit.cover,
                        width: 1000.0,
                        colorBlendMode:
                        BlendMode.dstIn, //desplegar imagen de fondo
                        color: Colors.blue.withOpacity(0.5),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: _buildCarouselSlider() // llamamos carousel
                    )
                  ],
                ), //imagen de fondo, se crea widget tipo stack para sobreponer
              ), //desplegar carrusel
            )
          ];
        },
        body: ListView(
          children: <Widget>[
            _buildMoviesListViewup(upcomingMovies, "PROXIMAMENTE Pág.$_pageNumberup"),
            _buildMoviesListViewpop(popularMovies, "POPULARES Pág.$_pageNumber"),
            _buildMoviesListViewtop(topRateMovies, "MEJOR VALORADO Pág.$_pageNumbertop")
          ],
        ), //ingresar listas
      ),
    );
  } //privado

}
