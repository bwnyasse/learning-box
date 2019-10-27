import 'dart:convert';

import 'package:flutter_weather/src/models/weather.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class WeatherApiClient {
  static const baseUrl = 'https://www.metaweather.com';
 final http.Client httpClient;

  WeatherApiClient({@required this.httpClient}) : assert(httpClient != null);

  //
  // https://www.metaweather.com/api/
  // Retrieve The 'Where On Earth ID'
  // [city] to search for
  //
  Future<int> getWoeid(String city) async {
    final locationUrl = '$baseUrl/api/location/search/?query=$city';
    final locationResponse = await this.httpClient.get(locationUrl);
    if (locationResponse.statusCode != 200) {
      throw Exception('error getting locationId for city');
    }

    final locationJson = jsonDecode(locationResponse.body) as List;
    return (locationJson.first)['woeid'];
  }

  //
  // https://www.metaweather.com/api/
  // Location 
  // [woeid] Where On Earth ID. 
  //
  Future<Weather> fetchWeather(int woeid) async {
    final weatherUrl = '$baseUrl/api/location/$woeid';
    final weatherResponse = await this.httpClient.get(weatherUrl);

    if (weatherResponse.statusCode != 200) {
      throw Exception('error getting weather for location');
    }

    final weatherJson = jsonDecode(weatherResponse.body);
    return Weather.fromJson(weatherJson);
  }
}
