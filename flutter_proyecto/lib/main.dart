import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; //libreria para realizar conversion de JSON
import 'Modelos/pelicula_modelos.dart'; // importamos file
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart'; //paquete modificar formato de fecha
import 'detalles.dart';

const baseUrl =
    "https://api.themoviedb.org/3/movie/"; //constante peliculas now playing
const baseImagenUrl =
    "https://image.tmdb.org/t/p/"; //url base  para accder a imagenes
const apiKey = "5053a39cc3fbd46cff101eeca1bdf2f3";

const nuevoUrl = "${baseUrl}now_playing?api_key=$apiKey&language=es"; // completamos url para acceso api lo mas nuevo
const popularUrl = "${baseUrl}popular?api_key=$apiKey&language=es";
const proximosUrl = "${baseUrl}upcoming?api_key=$apiKey&language=es";
const mejorvaloradoUrl = "${baseUrl}top_rated?api_key=$apiKey&language=es";

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false, //ocultar barra modo debug
      title: "PELICULAS",
      theme: ThemeData.dark(), // asignamos tema dark
      /*theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.amber,
          accentColorBrightness: Brightness.dark),*/
      home: MyPeliculasApp(),
    ));

class MyPeliculasApp extends StatefulWidget {
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

  int heroTag = 0;
  int _currentIndex =0;//cmabio de icono seleccionadp

  @override
  void initState() {
    //constructor clase padre
    super.initState();
    //funcion para trae datos
    _fetchNowPlayingMovies();
    _fetchUpcomingMovies();
    _fetchPopularMovies();
    _fetchTopRateMovies();
  }

  //crear funbcion retornar peliculas
  void _fetchNowPlayingMovies() async {
    var response =
        await http.get(nuevoUrl); //almacenar resultado de http variable
    var decodeJson = jsonDecode(response.body); //ejecutar json
    //actualizar informacion
    setState(() {
      nowPlayingMovies = Pelicula.fromJson(
          decodeJson); //llamamos metodo json para decodificacion
    });
    //metodo de tipo asyncrono
  }

  void _fetchUpcomingMovies() async {
    var response =
        await http.get(proximosUrl); //almacenar resultado de http variable
    var decodeJson = jsonDecode(response.body); //ejecutar json
    //actualizar informacion
    setState(() {
      upcomingMovies = Pelicula.fromJson(
          decodeJson); //llamamos metodo json para decodificacion
    });
  }

  void _fetchPopularMovies() async {
    var response =
        await http.get(popularUrl); //almacenar resultado de http variable
    var decodeJson = jsonDecode(response.body); //ejecutar json
    //actualizar informacion
    setState(() {
      popularMovies = Pelicula.fromJson(
          decodeJson); //llamamos metodo json para decodificacion
    });
  }

  void _fetchTopRateMovies() async {
    var response =
        await http.get(mejorvaloradoUrl); //almacenar resultado de http variable
    var decodeJson = jsonDecode(response.body); //ejecutar json
    //actualizar informacion
    setState(() {
      topRateMovies = Pelicula.fromJson(
          decodeJson); //llamamos metodo json para decodificacion
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
  Widget _buildMoviesListView(Pelicula pelicula, String movieListTittle) =>
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
              child: ListView(
                  scrollDirection: Axis.horizontal, //direccion del scroll
                  children: pelicula == null
                      ? <Widget>[
                          Center(
                            child: CircularProgressIndicator(),
                          )
                        ]
                      : pelicula.results
                          .map((movieItem) => Padding(
                                padding: EdgeInsets.only(left: 6.0, right: 2.0),
                                child: _buildMoviesListItem(movieItem),//elementos desplegados
                              ))
                          .toList() //*************************************************************************************************************************
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
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            //icono
          },
        ),
        actions: <Widget>[
          //ingresar serie de widgets
          IconButton(
            icon: Icon(Icons.search), //icono de busqueda
            onPressed: () {},
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
            _buildMoviesListView(upcomingMovies, "PROXIMAMENTE"),
            _buildMoviesListView(popularMovies, "POPULARES"),
            _buildMoviesListView(topRateMovies, "MEJOR VALORADO")
          ],
        ), //ingresar listas
      ),
      /*bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.amber,
        currentIndex: _currentIndex,
        onTap: (int index){
          setState(() =>_currentIndex= index);//almacenar indice actual
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.local_movies),
          title: Text("Todas las peliculas")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tag_faces),
            title: Text("Tikets"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Usuario")
          )
        ],
      ),*/
    );
  } //privado

}
