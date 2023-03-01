// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geolocationdb.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeolocationDBResponse _$GeolocationDBResponseFromJson(
        Map<String, dynamic> json) =>
    GeolocationDBResponse(
      stateProv: json['state_prov'] as String? ?? 'UNKNOWN',
      countryName: json['country_name'] as String? ?? 'UNKNOWN',
      city: json['city'] as String? ?? 'UNKNOWN',
    );

Map<String, dynamic> _$GeolocationDBResponseToJson(
        GeolocationDBResponse instance) =>
    <String, dynamic>{
      'state_prov': instance.stateProv,
      'country_name': instance.countryName,
      'city': instance.city,
    };
