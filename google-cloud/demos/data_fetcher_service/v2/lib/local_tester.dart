import 'dart:convert';

import 'package:data_fetcher_service/models/models.dart';
import 'package:data_fetcher_service/service/service.dart' as service;
import 'package:data_fetcher_service/utils/utils.dart';

void main(List<String> args) async {
  demoLoadStockConfiguration();

  demoFetchStockQuote();

  demowriteToStorage();
}

Future<void> demoLoadStockConfiguration() async {
  final List<StockConfig> stockConfigs = await service.loadStockConfiguration();

  final jsonString = jsonEncode(stockConfigs);
  print("---- LOCAL TESTER : LOAD STOCK CONFIG ----");
  print(jsonPrettyPrint(jsonString));
}

Future<void> demoFetchStockQuote() async {
  final StockQuoteResponse quote = await service.fetchStockQuote('HD', 'NYSE');

  final jsonString = jsonEncode(quote);
  print("---- LOCAL TESTER : FETCH A STOCK QUOTE ----");
  print(jsonPrettyPrint(jsonString));
}

Future<void> demowriteToStorage() async {
  service.writeToStorage('DEMO',
      jsonEncode({"stock": "DEMO", "security_name": "Flutter Montreal"}));
}
