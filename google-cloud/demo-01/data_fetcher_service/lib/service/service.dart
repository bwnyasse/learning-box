import 'dart:convert';
import 'dart:io';

import 'package:gcloud/db.dart';
import 'package:gcloud/storage.dart';
import 'package:gcloud/datastore.dart' as datastore;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:gcloud/service_scope.dart' as ss;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../models/models.dart';

extension CleanBodyResponse on String {
  String cleanValue() => replaceAll('"', '').trim();
}

String isRunningInDockerContainer() =>
    Platform.environment["FETCHER_SERVICE_IN_DOCKER"] == 'true' ? '' : 'assets';
String getApiKey() => File(p.join(
      Directory.current.path,
      isRunningInDockerContainer(),
      'sa-key-iexcloud',
    )).readAsStringSync();

String getSAKey() => File(p.join(
      Directory.current.path,
      isRunningInDockerContainer(),
      'sa-key.json',
    )).readAsStringSync();

void loadStockConfiguration() async {
  // Read the service account credentials from the file.
  final accountCredentials =
      auth.ServiceAccountCredentials.fromJson(getSAKey());

  final client = await auth.clientViaServiceAccount(
      accountCredentials, datastore.Datastore.Scopes);

  try {
    ss.fork(() async {
      final db = DatastoreDB(datastore.Datastore(client, 'learning-sandbox'));
      // register the services in the new service scope.
      registerDbService(db);

      // Run application using these services.
      var person = StockConfig()
        ..symbol = 'HOLA'
        ..shares = 42;
      await dbService.commit(inserts: [person]);
      // var stocks = (await db.query<StockConfig>().run()).toList();
    });
  } finally {
    client.close();
  }
}

Future<StockResponse> fetchStock(String symbol) async {
  final apiKey = getApiKey();
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

  List<Future<http.Response>> apiCalls =
      urls.map((url) => http.Client().get(Uri.parse(url))).toList();

  final responses = await Future.wait(apiCalls);
  return StockResponse.fromJson({
    'symbol': symbol,
    'lastPrice': responses[0].body.cleanValue(),
    'dividend': responses[1].body.cleanValue(),
    'companyName': responses[2].body.cleanValue(),
    'securityName': responses[4].body.cleanValue(),
    'industry': responses[4].body.cleanValue(),
    'sector': responses[5].body.cleanValue(),
    'issueType': responses[6].body.cleanValue(),
  });
}

Future<void> writeToStorage(String symbol, String bodyAsString) async {
  // Read the service account credentials from the file.
  final accountCredentials =
      auth.ServiceAccountCredentials.fromJson(getSAKey());

  // When running on Google Computer Engine, AppEngine or GKE credentials can
  // be obtained from a meta-data server as follows.
  final client =
      await auth.clientViaServiceAccount(accountCredentials, Storage.SCOPES);
  try {
    final storage = Storage(client, 'learning-sandbox');
    final b = storage.bucket('test-bucket-learning-sandbox');
    DateTime now = DateTime.now();
    String formatDate = DateFormat('yyyy-MM-dd-hhmmss').format(now);

    await b.writeBytes(
        'stocks/$symbol-$formatDate.json', utf8.encode(bodyAsString));
  } finally {
    client.close();
  }
}
