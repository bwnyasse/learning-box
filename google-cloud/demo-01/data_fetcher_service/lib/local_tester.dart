import 'dart:convert';

import 'models/models.dart';
import 'service/service.dart' as service;

void main(List<String> args) async {
   service.loadStockConfiguration();

  //StockResponse response = await service.fetchStock('COST');

  //service.writeToStorage('COST', jsonEncode(response.toJson()));
}
