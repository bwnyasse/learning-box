import 'dart:io';
import 'dart:convert';
import 'package:flutter_invoice_document_ai_backend/models/models.dart';
import 'package:googleapis/documentai/v1.dart';
import 'package:path/path.dart' as p;

/// An extension on [String] that provides utility methods for string manipulation.
extension StringManipulation on String {
  /// Cleans the string value by removing double quotes and trimming whitespace.
  ///
  /// Returns the cleaned string value.
  String cleanValue() => replaceAll('"', '').trim();

  /// Removes newline characters from the string.
  ///
  /// Returns the string without newline characters.
  String removeNewlines() => replaceAll("\n", "").replaceAll("\r", "");
}

/// Checks if the code is running inside a Docker container.
///
/// Returns an empty string if the code is running inside a Docker container, or the string 'assets' if it's not running in a Docker container.
String isRunningInDockerContainer() =>
    Platform.environment["FETCHER_SERVICE_IN_DOCKER"] == 'true' ? '' : 'assets';

/// Retrieves the API key from a file.
///
/// Returns the API key as a [String].
String getApiKey() => File(p.join(
      Directory.current.path,
      isRunningInDockerContainer(),
      'sa-key-api',
    )).readAsStringSync();

/// Retrieves the service account key from a file.
///
/// Returns the service account key as a [String].
String getSAKey() => File(p.join(
      Directory.current.path,
      isRunningInDockerContainer(),
      'sa-key.json',
    )).readAsStringSync();

Map<String, dynamic> mergeJson(
    Map<String, dynamic> json1, Map<String, dynamic> json2) {
  final Map<String, dynamic> mergedJson = {};
  mergedJson.addAll(json1);
  mergedJson.addAll(json2);
  return mergedJson;
}

String jsonPrettyPrint(String jsonString) {
  var buffer = StringBuffer();
  var pos = 0;
  var indent = 0;
  var length = jsonString.length;
  var char;

  void writeIndent() {
    for (var i = 0; i < indent; i++) {
      buffer.write('  ');
    }
  }

  while (pos < length) {
    char = jsonString[pos];
    if (char == '{' || char == '[') {
      buffer.write(char);
      buffer.write('\n');
      indent++;
      writeIndent();
    } else if (char == '}' || char == ']') {
      buffer.write('\n');
      indent--;
      writeIndent();
      buffer.write(char);
    } else if (char == ',') {
      buffer.write(char);
      buffer.write('\n');
      writeIndent();
    } else {
      buffer.write(char);
    }
    pos++;
  }

  return buffer.toString();
}

class ProcessUtils {
  static InvoiceData parseEntitiesToInvoiceData(
      GoogleCloudDocumentaiV1ProcessResponse response) {
    // Initialize variables for all the invoice fields
    String invoiceDate = '';
    String invoiceId = '';
    String totalAmount = '';
    String receiverName = '';
    String supplierEmail = '';
    String supplierName = '';
    String currency = '';
    String invoiceType = '';
    String supplierAddress = '';
    String supplierWebsite = '';
    String receiverEmail = '';
    String remitToAddress = '';
    List<LineItem> lineItems = [];

    for (var entity in response.document?.entities ?? []) {
      var conf = (entity.confidence * 100).toStringAsFixed(2);

      if (entity.type == 'line_item') {
        var lineItem = LineItem(
          description: _extractEntityValue(entity, 'line_item/description'),
          quantity: _extractEntityValue(entity, 'line_item/quantity'),
          unitPrice: _extractEntityValue(entity, 'line_item/unit_price'),
          amount: _extractEntityValue(entity, 'line_item/amount'),
        );
        lineItems.add(lineItem);

        print('* Line Item:');
        print('  - Description: ${lineItem.description} (${conf}% confident)');
        print('  - Quantity: ${lineItem.quantity} (${conf}% confident)');
        print('  - Unit Price: ${lineItem.unitPrice} (${conf}% confident)');
        print('  - Amount: ${lineItem.amount} (${conf}% confident)');
      } else {
        // Map other entities to respective fields
        var textValue = entity.textAnchor?.content ?? '';
        switch (entity.type) {
          case 'invoice_date':
            invoiceDate = textValue;
            break;
          case 'invoice_id':
            invoiceId = textValue;
            break;
          case 'total_amount':
            totalAmount = textValue;
            break;
          case 'receiver_name':
            receiverName = textValue;
            break;
          case 'supplier_email':
            supplierEmail = textValue;
            break;
          case 'supplier_name':
            supplierName = textValue;
            break;
          case 'currency':
            currency = textValue;
            break;
          case 'invoice_type':
            invoiceType = textValue;
            break;
          case 'supplier_address':
            supplierAddress = textValue;
            break;
          case 'supplier_website':
            supplierWebsite = textValue;
            break;
          case 'receiver_email':
            receiverEmail = textValue;
            break;
          case 'remit_to_address':
            remitToAddress = textValue;
            break;
          // Add any other cases as needed
        }

        print('* "${entity.type}": "$textValue" (${conf}% confident)');
      }
    }

    return InvoiceData(
      invoiceDate: invoiceDate,
      invoiceId: invoiceId,
      totalAmount: totalAmount,
      receiverName: receiverName,
      supplierEmail: supplierEmail,
      supplierName: supplierName,
      currency: currency,
      invoiceType: invoiceType,
      supplierAddress: supplierAddress,
      supplierWebsite: supplierWebsite,
      receiverEmail: receiverEmail,
      remitToAddress: remitToAddress,
      lineItems: lineItems,
    );
  }

  static String _extractEntityValue(
      GoogleCloudDocumentaiV1DocumentEntity entity, String type) {
    return entity.properties
            ?.firstWhere((prop) => prop.type == type,
                orElse: () => GoogleCloudDocumentaiV1DocumentEntity())
            .textAnchor
            ?.content ??
        '';
  }
}
