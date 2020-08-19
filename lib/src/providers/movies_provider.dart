import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies_course/src/models/actors_model.dart';
import 'package:movies_course/src/models/movies_model.dart';

class MovieProvider {
  String _apikey = 'd6db67302a86cf55284aa1b87c8562df';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularsPage = 0;
  bool _loading = false;

  List<Movie> _populars = new List();

  final _popularsStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularsSink =>
      _popularsStreamController.sink.add; //add

  Stream<List<Movie>> get popularsStream =>
      _popularsStreamController.stream; //escuchar

  void disposeStreams() {
    _popularsStreamController?.close();
  }

  Future<List<Movie>> _processResponse(Uri url) async {
    final response = await http.get(url);
    final decodedData = json.decode(response.body);

    final movies = new Movies.fromJsonList(decodedData['results']);

    return movies.items;
  }

  Future<List<Movie>> getInCinema() async {
    final url = Uri.https(
      _url,
      '3/movie/now_playing',
      {'api_key': _apikey, 'language': _language},
    );

    return await _processResponse(url);
  }

  Future<List<Movie>> getPopularMovies() async {
    if (_loading) return [];

    _loading = true;

    _popularsPage++;
    final url = Uri.https(
      _url,
      '3/movie/popular',
      {
        'api_key': _apikey,
        'language': _language,
        'page': _popularsPage.toString()
      },
    );

    final resp = await _processResponse(url);

    _populars.addAll(resp);
    popularsSink(_populars);

    _loading = false;

    return resp;
  }

  Future<List<Actor>> getCast(String movieId) async {
    final url = Uri.https(
      _url,
      '3/movie/$movieId/credits',
      {'api_key': _apikey, 'language': _language},
    );

    final response = await http.get(url);
    final decodedData = json.decode(response.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actors;
  }
}
