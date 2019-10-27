import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

enum WeatherCondition {
  snow,
  sleet,
  hail,
  thunderstorm,
  heavyRain,
  lightRain,
  showers,
  heavyCloud,
  lightCloud,
  clear,
  unknown
}

@JsonSerializable()
class ConsolidatedWeather {
  @JsonKey(name: 'weather_state_name')
  final weatherStateName;

  @JsonKey(name: 'weather_state_abbr')
  final weatherStateAbbr;

  @JsonKey(name: 'created')
  final created;

  @JsonKey(name: 'min_temp')
  final minTemp;

  @JsonKey(name: 'max_temp')
  final maxTemp;

  @JsonKey(name: 'the_temp')
  final temp;

  ConsolidatedWeather({
    this.weatherStateName,
    this.weatherStateAbbr,
    this.created,
    this.minTemp,
    this.maxTemp,
    this.temp,
  });

  factory ConsolidatedWeather.fromJson(Map<String, dynamic> json) =>
      _$ConsolidatedWeatherFromJson(json);

  WeatherCondition getCondition() {
    WeatherCondition state;
    switch (weatherStateAbbr) {
      case 'sn':
        state = WeatherCondition.snow;
        break;
      case 'sl':
        state = WeatherCondition.sleet;
        break;
      case 'h':
        state = WeatherCondition.hail;
        break;
      case 't':
        state = WeatherCondition.thunderstorm;
        break;
      case 'hr':
        state = WeatherCondition.heavyRain;
        break;
      case 'lr':
        state = WeatherCondition.lightRain;
        break;
      case 's':
        state = WeatherCondition.showers;
        break;
      case 'hc':
        state = WeatherCondition.heavyCloud;
        break;
      case 'lc':
        state = WeatherCondition.lightCloud;
        break;
      case 'c':
        state = WeatherCondition.clear;
        break;
      default:
        state = WeatherCondition.unknown;
    }
    return state;
  }
}

@JsonSerializable()
class Weather {
  @JsonKey(name: 'title')
  final location;

  @JsonKey(name: 'location_type')
  final locationType;

  final woeid;

  @JsonKey(name: 'latt_long')
  final latlong;

  final timezone;

  final DateTime lastUpdated = DateTime.now();

  @JsonKey(name: 'consolidated_weather')
  final List<ConsolidatedWeather> consolidatedWeather;

  Weather({
    this.location,
    this.locationType,
    this.woeid,
    this.latlong,
    this.timezone,
    this.consolidatedWeather,
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
}
