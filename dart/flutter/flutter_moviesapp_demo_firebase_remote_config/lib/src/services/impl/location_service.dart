import 'dart:convert';

import 'package:http/http.dart' show Client;

import '../../models/impl/geolocationdb.dart';

class LocationService {
  static late GeolocationDBResponse locationResponse;
  final Client client;

  LocationService(this.client);

  Future<void> load() async {
    // appel asynchrone
    final response =
        await client.get(Uri.parse("https://geolocation-db.com/json/"));

    if (response.statusCode != 200) {
      print('LocationService - Request Error: ${response.statusCode}');
    }

    // Décoder le contenu de la response ici
    final data = json.decode(response.body);

    locationResponse = GeolocationDBResponse.fromJson(data);
  }
}
