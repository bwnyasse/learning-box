import 'dart:convert';

import 'package:functions_framework/functions_framework.dart';

import 'models/models.dart';
import 'service/service.dart' as service;

// Export models so builder can use them when generating `bin/server.dart`.
export 'models/models.dart';

@CloudFunction()
Future<StockResponse> function(
    StockRequest request, RequestContext context) async {
  final symbol = request.symbol; // TODO: Default is ... ? Break the cloud run


  StockResponse response = await service.fetchStock(symbol);

  service.writeToStorage(symbol, jsonEncode(response.toJson()));

  context.logger
      .info('Context - symbol : $symbol - Response: ${response.toJson()}');
  return response;
}
