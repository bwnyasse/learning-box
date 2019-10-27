// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsolidatedWeather _$ConsolidatedWeatherFromJson(Map<String, dynamic> json) {
  return ConsolidatedWeather(
    weatherStateName: json['weather_state_name'],
    weatherStateAbbr: json['weather_state_abbr'],
    created: json['created'],
    minTemp: json['min_temp'],
    maxTemp: json['max_temp'],
    temp: json['the_temp'],
  );
}

Map<String, dynamic> _$ConsolidatedWeatherToJson(
        ConsolidatedWeather instance) =>
    <String, dynamic>{
      'weather_state_name': instance.weatherStateName,
      'weather_state_abbr': instance.weatherStateAbbr,
      'created': instance.created,
      'min_temp': instance.minTemp,
      'max_temp': instance.maxTemp,
      'the_temp': instance.temp,
    };

Weather _$WeatherFromJson(Map<String, dynamic> json) {
  return Weather(
    location: json['title'],
    locationType: json['location_type'],
    woeid: json['woeid'],
    latlong: json['latt_long'],
    timezone: json['timezone'],
    consolidatedWeather: (json['consolidated_weather'] as List)
        ?.map((e) => e == null
            ? null
            : ConsolidatedWeather.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'title': instance.location,
      'location_type': instance.locationType,
      'woeid': instance.woeid,
      'latt_long': instance.latlong,
      'timezone': instance.timezone,
      'consolidated_weather': instance.consolidatedWeather,
    };
