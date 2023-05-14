

import 'dart:convert';

import 'package:functions_framework/functions_framework.dart';
import 'package:http/http.dart' as http;

import 'models/models.dart';

// Export models so builder can use them when generating `bin/server.dart`.
export 'models/models.dart';

@CloudFunction()
 Future<MoviesResponse> function(MovieRequest request, RequestContext context) async{
  final isoCode = request.isoCode ?? 'CA'; // Default is Canada
  
  final response = await loadMovies(isoCode);
  context.logger.info('Context - isoCode : $isoCode - MoviesResponse: ${response.toJson()}');
  return response;
}

  Future<MoviesResponse> loadMovies(String isoCode) async {
    final apiKey = '4205ec1d93b1e3465f636f0956a98c64';
    final api = 'https://api.themoviedb.org/3';
    final urlPath = 'movie/now_playing';
    final path = '$api/$urlPath?api_key=$apiKey&language=en-US&region=$isoCode';

    // appel asynchrone
    final response = await http.Client().get(Uri.parse(path));
    print(response.body);
    // Décoder le contenu de la response ici
    final data = json.decode(response.body);

    return MoviesResponse.fromJson(data);
  }