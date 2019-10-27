import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class WeatherEvent extends Equatable {}

class FetchWeather extends WeatherEvent {
  final String city;

  FetchWeather({@required this.city}) : assert(city != null);

  @override
  List<Object> get props => [city];
}

class RefreshWeather extends WeatherEvent {
  final String city;

  RefreshWeather({@required this.city}) : assert(city != null);

  @override
  List<Object> get props => [city];
}
