import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class StockConfig {
  final String stock;

  @JsonKey(name: 'security_name')
  final String securityName;

  final String exchange;
  final String industry;
  final String sector;
  final String shares;
  final int frequency;

  @JsonKey(name: 'last_dividend_amount')
  final String lastDividendAmount;

  @JsonKey(name: 'last_dividend_payment_date')
  final String lastDividendPaymentDate;

  @JsonKey(name: 'is_etf')
  final bool isETF;

  StockConfig({
    required this.stock,
    required this.securityName,
    required this.exchange,
    required this.industry,
    required this.sector,
    required this.shares,
    required this.frequency,
    required this.lastDividendAmount,
    required this.lastDividendPaymentDate,
    required this.isETF,
  });

  factory StockConfig.fromJson(Map<String, dynamic> json) =>
      _$StockConfigFromJson(json);

  Map<String, dynamic> toJson() => _$StockConfigToJson(this);
}

@JsonSerializable()
class StockRequest {
  final String stock;

  StockRequest(this.stock);

  factory StockRequest.fromJson(Map<String, dynamic> json) =>
      _$StockRequestFromJson(json);

  Map<String, dynamic> toJson() => _$StockRequestToJson(this);
}

@JsonSerializable()
class StockQuoteResponse {
  final String stock;
  final String lastPrice;

  StockQuoteResponse({
    required this.stock,
    required this.lastPrice,
  });

  factory StockQuoteResponse.fromJson(Map<String, dynamic> json) =>
      _$StockQuoteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StockQuoteResponseToJson(this);
}
