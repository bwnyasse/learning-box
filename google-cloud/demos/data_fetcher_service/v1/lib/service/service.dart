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

  //TODO: Next step will be to retrieve the configuration fron Cloud Datastore or another Cloud resource ?
  // For the moment, it is not possible to use Cloud Datastore , because of dart:mirrors not supported with dart compile
  // https://github.com/dart-lang/gcloud/issues/163

  /*
  final client = await auth.clientViaServiceAccount(accountCredentials, datastore.Datastore.Scopes);
  final db = DatastoreDB(datastore.Datastore(client, 'learning-box-369917'));
  await (db.query<StockConfig>().run()).toList()
   */

  return [
    StockConfig(symbol: 'O'),
    StockConfig(symbol: 'AMZN'),
    StockConfig(symbol: 'WMT'),
    StockConfig(symbol: 'WM'),
    StockConfig(symbol: 'COST'),
    StockConfig(symbol: 'MSFT'),
    StockConfig(symbol: 'HD'),
  ];
}

/// Fetches stock information for the given symbol asynchronously.
///
/// This function retrieves various stock information for the specified symbol using the IEX Cloud API. It makes multiple API calls
/// to fetch different data points such as the latest price, dividend amount, company name, security name, industry, sector, and
/// issue type.
///
/// - [symbol]: The stock symbol for which to fetch the information.
///
/// Returns a [Future] that resolves to a [StockResponse] object containing the fetched stock information.
Future<StockResponse> fetchStock(String symbol) async {
  final apiKey = utils.getApiKey();
  final api = 'https://cloud.iexapis.com';

  final urls = [
    '$api/stable/stock/$symbol/quote/latestPrice?token=$apiKey',
    '$api/stable/data-points/$symbol/LAST-DIVIDEND-AMOUNT?token=$apiKey',
    '$api/stable/data-points/$symbol/COMPANYNAME?token=$apiKey',
    '$api/stable/data-points/$symbol/SECURITYNAME?token=$apiKey',
    '$api/stable/data-points/$symbol/EXCHANGE?token=$apiKey',
    '$api/stable/data-points/$symbol/INDUSTRY?token=$apiKey',
    '$api/stable/data-points/$symbol/SECTOR?token=$apiKey',
    '$api/stable/data-points/$symbol/ISSUETYPE?token=$apiKey',
  ];

  final client = http.Client();
  final responses = await Future.wait(urls.map((url) => client.get(Uri.parse(url))));

  client.close();

  return StockResponse.fromJson({
    'symbol': symbol,
    'lastPrice': responses[0].body.cleanValue(),
    'dividend': responses[1].body.cleanValue(),
    'companyName': responses[2].body.cleanValue(),
    'securityName': responses[4].body.cleanValue(),
    'industry': responses[5].body.cleanValue(),
    'sector': responses[6].body.cleanValue(),
    'issueType': responses[7].body.cleanValue(),
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
  final accountCredentials = auth.ServiceAccountCredentials.fromJson(utils.getSAKey());

  final client = await auth.clientViaServiceAccount(accountCredentials, Storage.SCOPES);
  final storage = Storage(client, 'learning-sandbox');
  final bucket = storage.bucket('test-bucket-learning-sandbox');

  final now = DateTime.now();
  final formattedDate = DateFormat('yyyy-MM-dd-hhmmss').format(now);

  final filePath = 'stocks/${now.year}/${now.month}/${now.day}/$symbol/$symbol-$formattedDate.json';
  final fileBytes = utf8.encode(bodyAsString);

  await bucket.writeBytes(filePath, fileBytes);

  client.close();
}
