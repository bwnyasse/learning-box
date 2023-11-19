import 'dart:convert';

import 'package:flutter_invoice_document_ai_backend/service/service.dart'
    as service;
import 'package:flutter_invoice_document_ai_backend/utils/utils.dart';

void main(List<String> args) async {
  demoProcessPdfWithGcsUri();
  // demofetchPdfUrlsFromCloudStorage();
}

Future<void> demoProcessPdfWithGcsUri() async {
  String output = await service.processPdfWithGcsUri(
    gcsUri: "gs://flutter_invoice_document_ai/invoice-01-2023.png",
    processorId: "f5fede58434ad0c",
    projectId: "learning-box-369917",
    location: "us",
  );
  print(output);
}

Future<void> demofetchPdfUrlsFromCloudStorage() async {
  final List<String> quote = await service.fetchPdfUrlsFromCloudStorage();

  final jsonString = jsonEncode(quote);
  print("---- LOCAL TESTER : demofetchPdfUrlsFromCloudStorage ----");
  print(jsonPrettyPrint(jsonString));
}
