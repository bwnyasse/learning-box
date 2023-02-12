import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_moviesapp_demo_firebase_remote_config/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:math' as math;

part 'geolocationdb.g.dart';

@JsonSerializable()
class GeolocationDBResponse {
  @JsonKey(name: 'country_code')
  final String countryCode;

  @JsonKey(name: 'country_name')
  final String countryName;

  @JsonKey(name: 'postal')
  final String postal;

  @JsonKey(name: 'latitude')
  final double latitude;

  @JsonKey(name: 'longitude')
  final double longitude;

  @JsonKey(name: 'state')
  final String state;

  GeolocationDBResponse({
    required this.countryCode,
    required this.countryName,
    required this.postal,
    required this.latitude,
    required this.longitude,
    required this.state,
  });

    factory GeolocationDBResponse.fromJson(Map<String, dynamic> json) =>
      _$GeolocationDBResponseFromJson(json);
}
