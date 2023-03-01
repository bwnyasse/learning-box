import 'package:json_annotation/json_annotation.dart';

part 'geolocationdb.g.dart';

@JsonSerializable()
class GeolocationDBResponse {
  @JsonKey(name: 'state_prov', defaultValue: 'UNKNOWN')
  final String stateProv;

  @JsonKey(name: 'country_name', defaultValue: 'UNKNOWN')
  final String countryName;

  @JsonKey(name: 'city', defaultValue: 'UNKNOWN')
  final String city;

  GeolocationDBResponse({
    required this.stateProv,
    required this.countryName,
    required this.city,
  });

  factory GeolocationDBResponse.fromJson(Map<String, dynamic> json) =>
      _$GeolocationDBResponseFromJson(json);
}
