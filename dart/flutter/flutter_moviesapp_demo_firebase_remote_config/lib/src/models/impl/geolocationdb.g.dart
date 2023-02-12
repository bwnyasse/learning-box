// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geolocationdb.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeolocationDBResponse _$GeolocationDBResponseFromJson(
        Map<String, dynamic> json) =>
    GeolocationDBResponse(
      countryCode: json['country_code'] as String,
      countryName: json['country_name'] as String,
      postal: json['postal'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      state: json['state'] as String,
    );

Map<String, dynamic> _$GeolocationDBResponseToJson(
        GeolocationDBResponse instance) =>
    <String, dynamic>{
      'country_code': instance.countryCode,
      'country_name': instance.countryName,
      'postal': instance.postal,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'state': instance.state,
    };
