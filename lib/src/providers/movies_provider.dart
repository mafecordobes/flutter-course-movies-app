import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies_course/src/models/movies_model.dart';

class MovieProvider {
  String _apikey = 'd6db67302a86cf55284aa1b87c8562df';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

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
    final url = Uri.https(
      _url,
      '3/movie/popular',
      {'api_key': _apikey, 'language': _language},
    );

    return await _processResponse(url);
  }
}
