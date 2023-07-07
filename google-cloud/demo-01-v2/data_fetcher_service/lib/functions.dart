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
    List<StockConfig> stocks = await service.loadStockConfiguration();

    List<Future<void>> apiCalls = stocks.map((element) async {
      StockQuoteResponse response =
          await service.fetchStockQuote(element.stock, element.exchange);

      final jsonToStore = mergeJson(response.toJson(), element.toJson());
      await service.writeToStorage(element.stock, jsonEncode(jsonToStore));
      print('Context - symbol : ${element.stock} - Response: ${jsonToStore['lastPrice']}');
     // context.logger.info('Context - symbol : ${element.stock} - Response: jsonToStore');
    }).toList();

    await Future.wait(apiCalls);
  } catch (error, stackTrace) {
     print('An error occurred: $error\n$stackTrace');
    //context.logger.error('An error occurred: $error\n$stackTrace');
    // Handle or report the error accordingly.
  }

  return Response.ok('Work Done !');
}
