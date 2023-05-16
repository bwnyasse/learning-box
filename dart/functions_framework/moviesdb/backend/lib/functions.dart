import 'dart:convert';
import 'dart:io';

import 'package:functions_framework/functions_framework.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:gcloud/storage.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'models/models.dart';

// Export models so builder can use them when generating `bin/server.dart`.
export 'models/models.dart';

@CloudFunction()
Future<MoviesResponse> function(
    MovieRequest request, RequestContext context) async {
  final isoCode = request.isoCode ?? 'CA'; // Default is Canada

  final response = await loadMovies(isoCode);
  context.logger.info(
      'Context - isoCode : $isoCode - MoviesResponse: ${response.toJson()}');
  return response;
}

Future<MoviesResponse> loadMovies(String isoCode) async {
  final apiKey = '4205ec1d93b1e3465f636f0956a98c64';
  final api = 'https://api.themoviedb.org/3';
  final urlPath = 'movie/now_playing';
  final path = '$api/$urlPath?api_key=$apiKey&language=en-US&region=$isoCode';

  // appel asynchrone
  final response = await http.Client().get(Uri.parse(path));
  print("hello");
  print(response.body);
  // Décoder le contenu de la response ici
  final data = json.decode(response.body);

  // Write into Cloud Storage
  await testCloudStorage(response.body);

  return MoviesResponse.fromJson(data);
}

Future<void> testCloudStorage(String bodyAsString) async {
  // Read the service account credentials from the file.
  var jsonCredentials = new File('/app/bin/sa-key.json').readAsStringSync();
  var accountCredentials =
      new auth.ServiceAccountCredentials.fromJson(jsonCredentials);

  // When running on Google Computer Engine, AppEngine or GKE credentials can
  // be obtained from a meta-data server as follows.
  final client =
      await auth.clientViaServiceAccount(accountCredentials, Storage.SCOPES);
  try {
    final storage = Storage(client, 'learning-sandbox');
    final b = storage.bucket('test-bucket-learning-sandbox');
    DateTime now = DateTime.now();
    String formatDate = DateFormat('yyyy-MM-dd-hhmmss').format(now);
    await b.writeBytes('movies/now_playing/movies-$formatDate.json',
        utf8.encode(bodyAsString));
  } finally {
    client.close();
  }
}
