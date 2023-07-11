import 'dart:async';
import 'dart:convert';

import 'package:data_fetcher_service/utils/utils.dart';
import 'package:functions_framework/functions_framework.dart';
import 'models/models.dart';
import 'service/service.dart' as service;
import 'package:shelf/shelf.dart';

// Export models so builder can use them when generating `bin/server.dart`.
export 'models/models.dart';

@CloudFunction()
Future<Response> function(Request request) async {
  try {
    // LOAD STOCK CONFIGURATION
    List<StockConfig> stocks = await service.loadStockConfiguration();

    List<Future<void>> apiCalls = stocks.map((element) async {
      // FETCH STOCK QUOTE
      StockQuoteResponse response =
          await service.fetchStockQuote(element.stock, element.exchange);

      final jsonToStore = mergeJson(response.toJson(), element.toJson());

      // WRITE TO STORAGE
      await service.writeToStorage(element.stock, jsonEncode(jsonToStore));
      print(
          'Context - symbol : ${element.stock} - Response: ${jsonToStore['lastPrice']}');
    }).toList();

    await Future.wait(apiCalls);
  } catch (error, stackTrace) {
    // Handle or report the error accordingly.
    print('An error occurred: $error\n$stackTrace');
  }

  return Response.ok('Cloud run with Dart Lang is OK !');
}
