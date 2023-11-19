import 'dart:async';
import 'dart:convert';

import 'package:flutter_invoice_document_ai_backend/models/models.dart';
import 'package:flutter_invoice_document_ai_backend/utils/utils.dart' as utils;
import 'package:googleapis/storage/v1.dart' as storage;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/documentai/v1.dart' as documentai;

Future<String> process() async {
  List<String> uris = await fetchPdfUrlsFromCloudStorage();

  // Map each URI to a Future<Invoice> by calling demoProcessPdfWithGcsUri
  var invoiceFutures =
      uris.map((uri) => processPdfWithGcsUri(gcsUri: 'gs://$uri'));

  // Wait for all futures to complete and return the list of Invoices
  List<Invoice> invoices = await Future.wait(invoiceFutures);

  InvoiceResponse response = InvoiceResponse(invoices: invoices);

  return jsonEncode(response);
}

/// Retrieves the URLs of PDF files from the specified bucket in the storage.
///
/// This function reads the list of PDF files from a specified bucket in a storage service, such as Google Cloud Storage.
/// It uses the service account credentials obtained from a file to authenticate the client.
///
/// Returns a [Future] that completes with a list of PDF file URLs.
Future<List<String>> fetchPdfUrlsFromCloudStorage() async {
  final accountCredentials =
      auth.ServiceAccountCredentials.fromJson(utils.getSAKey());

  const scopes = [storage.StorageApi.devstorageReadOnlyScope];

  final client = await auth.clientViaServiceAccount(accountCredentials, scopes);

  var storageApi = storage.StorageApi(client);
  String bucketName = 'flutter_invoice_document_ai';

  List<String> pdfUrls = [];

  try {
    var objects = await storageApi.objects.list(bucketName);

    // Filtering for PDF files and constructing their URLs
    pdfUrls = objects.items
            ?.where((object) => object.name!.endsWith('.png'))
            .map((object) => '$bucketName/${object.name}')
            .toList() ??
        [];
  } catch (e) {
    print('Error occurred: $e');
  } finally {
    client.close();
  }

  // https://storage.cloud.google.com/ to add authenticate
  // gs:// to add gcs url
  return pdfUrls;
}

Future<Invoice> processPdfWithGcsUri({
  required String gcsUri,
  String processorId = "f5fede58434ad0c",
  String projectId = "learning-box-369917",
  String location = "us",
}) async {
  final accountCredentials =
      auth.ServiceAccountCredentials.fromJson(utils.getSAKey());

  const scopes = [
    storage.StorageApi.devstorageReadOnlyScope,
    'https://www.googleapis.com/auth/cloud-platform'
  ];

  final client = await auth.clientViaServiceAccount(accountCredentials, scopes);

  final endpointName =
      'projects/$projectId/locations/$location/processors/$processorId';
  final documentApi = documentai.DocumentApi(client);

  try {
    // Prepare the request payload for DocumentAI processing
    final document = documentai.GoogleCloudDocumentaiV1GcsDocument()
      ..gcsUri = gcsUri
      ..mimeType = 'image/png';

    final request = documentai.GoogleCloudDocumentaiV1ProcessRequest()
      ..gcsDocument = document
      ..skipHumanReview = true;

    // Send the request to process the document
    final response = await documentApi.projects.locations.processors.process(
      request,
      endpointName,
    );

    // Display the processing results
    print('Document processing complete.');
    print('Review status: ${response.humanReviewStatus?.state ?? 'N/A'}\n');

    // Implement the printEntities logic as per your needs
    InvoiceData invoiceData =
        utils.ProcessUtils.parseEntitiesToInvoiceData(response);

    return Invoice(
      gcsUri: gcsUri,
      data: invoiceData,
    );
  } catch (e) {
    print('Error occurred during processing: $e');
    return Invoice(
      gcsUri: gcsUri,
      data: InvoiceData.fromJson(
        {},
      ),
    );
  }
}
