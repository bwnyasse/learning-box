import 'dart:convert';

import 'package:http/http.dart' show Client;

import '../../models/models.dart';

class LocationService {
  static late GeolocationDBResponse locationResponse;
  final Client client;

  LocationService(this.client);

  Future<void> load() async {
    // appel asynchrone
    final response =
        await client.get(Uri.parse("https://api.ipgeolocation.io/ipgeo?apiKey=18c2dc6c6cb644908f3e75e781cb1105"));

    if (response.statusCode != 200) {
      //FIXME: better logging
      print('LocationService - Request Error: ${response.statusCode}');
    }

    // Décoder le contenu de la response ici
    final data = json.decode(response.body);

    locationResponse = GeolocationDBResponse.fromJson(data);
  }
}
