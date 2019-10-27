import 'package:equatable/equatable.dart';
import 'package:flutter_weather/src/models/weather.dart';
import 'package:meta/meta.dart';

abstract class WeatherState extends Equatable {
  @override
  List<Object> get props => [];
}

class WeatherError extends WeatherState {}

class WeatherEmpty extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  ConsolidatedWeather consolidatedWeather;

  WeatherLoaded({@required this.weather}) : assert(weather != null) {
    consolidatedWeather = weather.consolidatedWeather[0];
  }

  @override
  List<Object> get props => [weather];
}
