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
  // Read the service account credentials from the file.
  final accountCredentials =
      auth.ServiceAccountCredentials.fromJson(utils.getSAKey());

  //TODO: Next step will be to retrieve the configuration from Cloud Datastore or another Cloud resource ?
  // For the moment, it is not possible to use Cloud Datastore , because of dart:mirrors not supported with dart compile
  // https://github.com/dart-lang/gcloud/issues/163

  /*
  final client = await auth.clientViaServiceAccount(accountCredentials, datastore.Datastore.Scopes);
  final db = DatastoreDB(datastore.Datastore(client, 'learning-box-369917'));
  await (db.query<StockConfig>().run()).toList()
   */

  // Workaround : Reading the configuration from assets
  final stockJsonAsString = utils.getStockConfig();
  final List<dynamic> stockAsDynamicLit = json.decode(stockJsonAsString);
  return stockAsDynamicLit.map((json) => StockConfig.fromJson(json)).toList();
}

/// Fetches stock quote for the given stock asynchronously.
///
/// - [stock]:
/// - [exchange]:
///
/// Returns a [Future] that resolves to a [StockResponse] object containing the fetched stock information.
Future<StockQuoteResponse> fetchStockQuote(
    String stock, String exchange) async {
  final apiKey = utils.getApiKey();
  final path =
      'https://api.twelvedata.com/quote?apikey=$apiKey&symbol=$stock&exchange=$exchange';

  final client = http.Client();
  final response = await client.get(Uri.parse(path));

  client.close();


   final data = json.decode(response.body);

  return StockQuoteResponse.fromJson({
    'stock': stock,
    'lastPrice': data['close'],
  });
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
  final accountCredentials =
      auth.ServiceAccountCredentials.fromJson(utils.getSAKey());

  final client =
      await auth.clientViaServiceAccount(accountCredentials, Storage.SCOPES);
  final storage = Storage(client, 'learning-sandbox');
  final bucket = storage.bucket('test-bucket-learning-sandbox');

  final now = DateTime.now();
  final formattedDate = DateFormat('yyyy-MM-dd-hhmmss').format(now);

  final filePath =
      'stocks/${now.year}/${now.month}/${now.day}/$symbol/$symbol-$formattedDate.json';
  final fileBytes = utf8.encode(bodyAsString);

  await bucket.writeBytes(filePath, fileBytes);

  client.close();
}
