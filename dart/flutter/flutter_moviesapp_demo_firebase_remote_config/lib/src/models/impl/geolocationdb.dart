import 'package:json_annotation/json_annotation.dart';

part 'geolocationdb.g.dart';

@JsonSerializable()
class GeolocationDBResponse {
  @JsonKey(name: 'country_code')
  final String countryCode;

  @JsonKey(name: 'country_name')
  final String countryName;

  @JsonKey(name: 'postal',defaultValue: 'UNKNOWN')
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
