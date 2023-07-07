import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

class StockConfig {
  final String symbol;

  int shares;

  StockConfig({
    required this.symbol,
    this.shares = 0,
  });
}

@JsonSerializable()
class StockRequest {
  final String symbol;

  StockRequest(this.symbol);

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
