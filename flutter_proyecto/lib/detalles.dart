import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; //libreria para realizar conversion de JSON
import 'Modelos/pelicula_detalles.dart'; // importamos file
import 'package:intl/intl.dart'; //paquete modificar formato de fecha
import 'Modelos/pelicula_modelos.dart'; // importamos file
import 'Modelos/pelicula_creditos.dart';

const apiKey = "?api_key=5053a39cc3fbd46cff101eeca1bdf2f3";

const baseUrl = "https://api.themoviedb.org/3/movie/";
const baseImagenUrl = "https://image.tmdb.org/t/p/";
String duracion="Duración",lanzamiento="Lanzamiento",sinopsis="Sinopsis",actores="Actores",equipo1="Equipo",detalles="Detalles";

class MovieDetail extends StatefulWidget {
  final Results pelicula;

  //constructor
  MovieDetail({this.pelicula});

  @override
  _MovieDetails createState() => new _MovieDetails();
}

class _MovieDetails extends State<MovieDetail> {
  String movieDetailUrl;
  String movieCreditsUrl;
  MovieDetailModel movieDetails;
  MovieCredits movieCredits;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //contruir url
    movieDetailUrl = "$baseUrl${widget.pelicula.id}$apiKey";
    movieCreditsUrl = "$baseUrl${widget.pelicula.id}/credits$apiKey";
    _fetchMovieCredits();
    _fetchMovieDetails();
  }

  void _fetchMovieDetails() async {
    var response = await http.get(movieDetailUrl);
    var decodedJson = jsonDecode(response.body);
    setState(() {
      movieDetails = MovieDetailModel.fromJson(decodedJson);
    });
  }

  void _fetchMovieCredits() async {
    var response = await http.get(movieCreditsUrl);
    var decodedJson = jsonDecode(response.body);
    setState(() {
      movieCredits = MovieCredits.fromJson(decodedJson);
    });
  }

  String _getMovieDuration(int runtime) {
    if (runtime == null) return "0";
    double movieHours = runtime / 60.0;
    int movieMinutes = ((movieHours - movieHours.floor()) * 60).round();
    return "$duracion: ${movieHours.floor()}h ${movieMinutes}min";
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final moviePoster = Container(
      // variable para despegar el poster de cada pelicula
      height: 350.0,
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Center(
        child: Card(
          elevation: 15.0,
          child: Hero(
              tag: widget.pelicula.heroTag,
              child: Image.network(
                "${baseImagenUrl}w342${widget.pelicula.posterPath}",
                fit: BoxFit.cover,
              )),
        ),
      ),
    );

    final movieTitle = Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
      child: Center(
        child: Text(
          widget.pelicula.title,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

    final movieDate = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          movieDetails != null
              ? _getMovieDuration(movieDetails.runtime)
              : "", //duracion de la pelicula
          style: TextStyle(fontSize: 14.0),
        ),
        Container(
          height: 20.0,
          width: 1.0,
          color: Colors.white70,
        ),
        Text(
          "$lanzamiento: ${DateFormat("dd-MM-yyyy").format(DateTime.parse(widget.pelicula.releaseDate))}",
          style: TextStyle(fontSize: 14.0),
        ) //,
        // conversion de formato de fecha
      ],
    );

    final contenido = Container(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(),
          Text(
            "$sinopsis",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
                fontSize: 20.0),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            widget.pelicula.overview, // contenido de la sipnosiss
            style: TextStyle(color: Colors.grey[300], fontSize: 14.0),
          )
        ],
      ),
    );

    final generosList = Container(
      height: 25.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: movieDetails == null
              ? <Widget>[]
              : movieDetails.genres
                  .map((g) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          backgroundColor: Colors.teal,
                          labelStyle: TextStyle(fontSize: 10.0),
                          label: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(g.name),
                          ),
                          onSelected: (b) {},
                        ),
                      ))
                  .toList(),
        ),
      ),
    );


    final creditos = Container(
      height: 115.0,
      padding: EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              "$actores",
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
          ),
          Flexible(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: movieCredits == null
                  ? <Widget>[
                Center(
                  child: CircularProgressIndicator(),
                )
              ]
                  : movieCredits.cast.map((c) => Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Container(
                  width: 65.0,
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                          radius: 28.0,
                          backgroundImage: c.profilePath != null
                              ? NetworkImage(
                            "${baseImagenUrl}w154${c.profilePath}",
                          )
                              : AssetImage("")),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          c.name,
                          style: TextStyle(fontSize: 8.0,fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        c.character,
                        style: TextStyle(fontSize: 8.0),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              )).toList(),
            ),
          )
        ],
      ),
    );

    final equipo = Container(
      height: 115.0,
      padding: EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              "$equipo1",
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
          ),
          Flexible(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: movieCredits == null
                  ? <Widget>[
                Center(
                  child: CircularProgressIndicator(),
                )
              ]
                  : movieCredits.crew.map((c) => Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Container(
                  width: 65.0,
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                          radius: 28.0,
                          backgroundImage: c.profilePath != null
                              ? NetworkImage(
                            "${baseImagenUrl}w154${c.profilePath}",
                          )
                              : AssetImage("")),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          c.name,
                          style: TextStyle(fontSize: 8.0,fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        c.job,
                        style: TextStyle(fontSize: 8.0),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              )).toList(),
            ),
          )
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "$detalles",
          style: TextStyle(
              color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: <Widget>[
          moviePoster,
          movieTitle,
          Divider(),
          movieDate,
          Text(""),
          generosList,
          contenido,
          creditos,
          Divider(),
          equipo,
          Text("\n\n"),
        ],
      ), //detalles de la pelicula
    );
  }
}
