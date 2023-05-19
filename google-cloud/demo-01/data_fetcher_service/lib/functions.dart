import 'dart:async';
import 'dart:convert';

import 'package:functions_framework/functions_framework.dart';
import 'models/models.dart';
import 'service/service.dart' as service;

// Export models so builder can use them when generating `bin/server.dart`.
export 'models/models.dart';

@CloudFunction()
Future<void> function(StockRequest request, RequestContext context) async {
  try {
    List<StockConfig> stocks = await service.loadStockConfiguration();

    List<Future<void>> apiCalls = stocks.map((element) async {
      StockResponse response = await service.fetchStock(element.symbol);
      await service.writeToStorage(
          element.symbol, jsonEncode(response.toJson()));
      context.logger.info(
          'Context - symbol : ${element.symbol} - Response: ${response.toJson()}');
    }).toList();

    await Future.wait(apiCalls);
  } catch (error, stackTrace) {
    context.logger.error('An error occurred: $error\n$stackTrace');
    // Handle or report the error accordingly.
  }
}
