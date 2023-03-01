import 'dart:convert';

import 'package:http/http.dart' show Client;

import '../../models/models.dart';

class LoadMoviesException implements Exception {
  final String message;

  LoadMoviesException(this.message);
}

class ApiService {
  final Client client;

  ApiService(this.client);

  Future<MoviesResponse> loadMovies(final String restApi) async {
    //FIXME: bnyasse key to access MovieDB API
    const apiKey = '4205ec1d93b1e3465f636f0956a98c64';
    const api = 'https://api.themoviedb.org/3';
    final urlPath = 'movie/$restApi';
    final path = '$api/$urlPath?api_key=$apiKey&language=en-US';

    // appel asynchrone
    final response = await client.get(Uri.parse(path));

    if (response.statusCode != 200) {
      throw LoadMoviesException(
          'LoadMovies - Request Error: ${response.statusCode}');
    }

    // Décoder le contenu de la response ici
    final data = json.decode(response.body);
    data['path'] = restApi;
    return MoviesResponse.fromJson(data);
  }
}
