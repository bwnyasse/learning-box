import 'package:gcloud/db.dart' as db;
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@db.Kind()
class StockConfig extends db.Model {
  @db.StringProperty()
  String symbol = '';

  @db.IntProperty()
  int shares = 0;
}

@JsonSerializable()
class StockRequest {
  final String symbol;

  StockRequest({required this.symbol});

  factory StockRequest.fromJson(Map<String, dynamic> json) =>
      _$StockRequestFromJson(json);

  Map<String, dynamic> toJson() => _$StockRequestToJson(this);
}

@JsonSerializable()
class StockResponse {
  final String symbol;
  final String lastPrice;
  final String dividend;
  final String companyName;
  final String securityName;
  final String industry;
  final String sector;
  final String issueType;

  StockResponse({
    required this.symbol,
    required this.lastPrice,
    required this.dividend,
    required this.companyName,
    required this.securityName,
    required this.industry,
    required this.sector,
    required this.issueType,
  });

  factory StockResponse.fromJson(Map<String, dynamic> json) =>
      _$StockResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StockResponseToJson(this);
}
