import 'dart:convert';

import 'package:flutter_invoice_document_ai_backend/models/models.dart';
import 'package:flutter_invoice_document_ai_backend/service/service.dart'
    as service;
import 'package:flutter_invoice_document_ai_backend/utils/utils.dart';

void main(List<String> args) async {
  List<String> uris = await demofetchPdfUrlsFromCloudStorage();

  print(uris);
  // Map each URI to a Future<Invoice> by calling demoProcessPdfWithGcsUri
  var invoiceFutures = uris.map((uri) => demoProcessPdfWithGcsUri('gs://$uri'));

  // Wait for all futures to complete and return the list of Invoices
  List<Invoice> invoices = await Future.wait(invoiceFutures);

  InvoiceResponse response = InvoiceResponse(invoices: invoices);

  String output = jsonEncode(response);
  print(output);
}

Future<Invoice> demoProcessPdfWithGcsUri(final gcsUriValue) async {
  return await service.processPdfWithGcsUri(
    gcsUri: gcsUriValue,    
  );
}

Future<List<String>> demofetchPdfUrlsFromCloudStorage() async {
  final List<String> quote = await service.fetchPdfUrlsFromCloudStorage();

  final jsonString = jsonEncode(quote);
  print("---- LOCAL TESTER : demofetchPdfUrlsFromCloudStorage ----");
  print(jsonPrettyPrint(jsonString));

  return quote;
}
