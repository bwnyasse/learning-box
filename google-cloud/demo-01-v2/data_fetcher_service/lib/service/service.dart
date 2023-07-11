import 'dart:convert';

import 'package:data_fetcher_service/utils/utils.dart' as utils;
import 'package:gcloud/storage.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/models.dart';

/// Loads the stock configuration asynchronously.
///
/// This function retrieves the stock configuration from a cloud resource (e.g., Cloud Datastore) or another cloud service.
/// Note that due to the limitation of `dart:mirrors` not being supported with `dart compile`, the current implementation
/// does not use Cloud Datastore.
///
/// Returns a [Future] that resolves to a [List] of [StockConfig] objects representing the stock configuration.
Future<List<StockConfig>> loadStockConfiguration() async {
  //
  //
  //TODO: 1- Load Stock Configuration

  return Future.value([]);
}

/// Fetches stock quote for the given stock asynchronously.
///
/// - [stock]:
/// - [exchange]:
///
/// Returns a [Future] that resolves to a [StockResponse] object containing the fetched stock information.
Future<StockQuoteResponse> fetchStockQuote(
    String stock, String exchange) async {
  //
  //
  //TODO: 2- Fetch Stock Quote

  return StockQuoteResponse.fromJson({});
}

/// Writes the given data to the storage asynchronously.
///
/// This function writes the provided data to a storage service, such as Google Cloud Storage. It uses the service account credentials
/// obtained from a file to authenticate the client.
///
/// - [symbol]: The symbol associated with the data.
/// - [bodyAsString]: The data to be written as a string.
///
/// Returns a [Future] that completes when the data has been successfully written to the storage.
Future<void> writeToStorage(String symbol, String bodyAsString) async {
  //
  //
  //TODO: 3- Write to Storage
}
