// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockConfig _$StockConfigFromJson(Map<String, dynamic> json) => StockConfig(
      stock: json['stock'] as String,
      securityName: json['security_name'] as String,
      exchange: json['exchange'] as String,
      industry: json['industry'] as String,
      sector: json['sector'] as String,
      shares: json['shares'] as String,
      frequency: json['frequency'] as int,
      lastDividendAmount: json['last_dividend_amount'] as String,
      lastDividendPaymentDate: json['last_dividend_payment_date'] as String,
      isETF: json['is_etf'] as bool,
    );

Map<String, dynamic> _$StockConfigToJson(StockConfig instance) =>
    <String, dynamic>{
      'stock': instance.stock,
      'security_name': instance.securityName,
      'exchange': instance.exchange,
      'industry': instance.industry,
      'sector': instance.sector,
      'shares': instance.shares,
      'frequency': instance.frequency,
      'last_dividend_amount': instance.lastDividendAmount,
      'last_dividend_payment_date': instance.lastDividendPaymentDate,
      'is_etf': instance.isETF,
    };

StockRequest _$StockRequestFromJson(Map<String, dynamic> json) => StockRequest(
      json['stock'] as String,
    );

Map<String, dynamic> _$StockRequestToJson(StockRequest instance) =>
    <String, dynamic>{
      'stock': instance.stock,
    };

StockQuoteResponse _$StockQuoteResponseFromJson(Map<String, dynamic> json) =>
    StockQuoteResponse(
      stock: json['stock'] as String,
      lastPrice: json['lastPrice'] as String,
    );

Map<String, dynamic> _$StockQuoteResponseToJson(StockQuoteResponse instance) =>
    <String, dynamic>{
      'stock': instance.stock,
      'lastPrice': instance.lastPrice,
    };
