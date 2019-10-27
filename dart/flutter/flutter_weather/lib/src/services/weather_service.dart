import 'dart:async';

import 'package:flutter_weather/src/models/weather.dart';
import 'package:flutter_weather/src/services/services.dart';
import 'package:meta/meta.dart';

class WeatherService {
  final WeatherApiClient apiClient;

  WeatherService({@required this.apiClient})
      : assert(apiClient != null);

  Future<Weather> getWeather(String city) async {
    final int locationId = await apiClient.getWoeid(city);
    return await apiClient.fetchWeather(locationId);
  }
}
