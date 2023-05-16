// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockRequest _$StockRequestFromJson(Map<String, dynamic> json) => StockRequest(
      symbol: json['symbol'] as String,
    );

Map<String, dynamic> _$StockRequestToJson(StockRequest instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
    };

StockResponse _$StockResponseFromJson(Map<String, dynamic> json) =>
    StockResponse(
      symbol: json['symbol'] as String,
      lastPrice: json['lastPrice'] as String,
      dividend: json['dividend'] as String,
      companyName: json['companyName'] as String,
      securityName: json['securityName'] as String,
      industry: json['industry'] as String,
      sector: json['sector'] as String,
      issueType: json['issueType'] as String,
    );

Map<String, dynamic> _$StockResponseToJson(StockResponse instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'lastPrice': instance.lastPrice,
      'dividend': instance.dividend,
      'companyName': instance.companyName,
      'securityName': instance.securityName,
      'industry': instance.industry,
      'sector': instance.sector,
      'issueType': instance.issueType,
    };
