import 'dart:convert';

import 'package:flutter_invoice_document_ai_ui/modules/invoices/models/invoice_models.dart';

void main() async {
  String mockJson =
      '''{"invoices":[{"gcs_uri":"gs://flutter_invoice_document_ai/invoice-01-2023.png","data":{"invoice_date":"15/01/2023","invoice_id":"2023-01","total_amount":"2,100.00","receiver_name":"Olivia Wilson","supplier_email":"hello@flutterfrenzy.ca","supplier_name":"FLUTTER FRENZY INC.","currency":"\$","invoice_type":"","supplier_address":"12 Way, Montreal, QC, H3Z2Z3, Canada","supplier_website":"www.flutterfrenzy.ca","receiver_email":"hello@reallygreatsite.com","remit_to_address":"123 Anywhere St., Any City, ST 12345","line_items":[{"description":"Flutter UI Overhaul","quantity":"2","unit_price":"100.00","amount":"200.00"},{"description":"Cross-Platform Integration","quantity":"1","unit_price":"700.00","amount":"700.00"},{"description":"Flutter Performance Tuning","quantity":"1","unit_price":"600.00","amount":"600.00"},{"description":"Flutter Workshop","quantity":"2","unit_price":"300.00","amount":"600.00"}]}},{"gcs_uri":"gs://flutter_invoice_document_ai/invoice-02-2023.png","data":{"invoice_date":"15/02/2023","invoice_id":"2023-02","total_amount":"1,600.00","receiver_name":"Olivia Wilson","supplier_email":"hello@flutterfrenzy.ca","supplier_name":"FLUTTER FRENZY INC.","currency":"\$","invoice_type":"","supplier_address":"12 Way, Montreal, QC, H3Z2Z3, Canada","supplier_website":"www.flutterfrenzy.ca","receiver_email":"hello@reallygreatsite.com","remit_to_address":"123 Anywhere St., Any City, ST 12345","line_items":[{"description":"Flutter UI Overhaul","quantity":"1","unit_price":"100.00","amount":"100.00"},{"description":"Cross-Platform Integration","quantity":"1","unit_price":"700.00","amount":"700.00"},{"description":"App Lifecyle Management","quantity":"1","unit_price":"200.00","amount":"200.00"},{"description":"Flutter Workshop","quantity":"2","unit_price":"300.00","amount":"600.00"}]}}]}''';

  InvoiceResponse invoiceResponse =
      InvoiceResponse.fromJson(jsonDecode(mockJson));

  Map<String, double> totalPerSupplier = {};
  Map<String, double> totalPerCategory = {};
  Map<String, int> invoiceFrequencyPerSupplier = {};
  Map<String, double> totalPerCurrency = {};

  double totalInvoiceAmount = 0;
  int totalInvoiceCount = invoiceResponse.invoices.length;

  for (var invoice in invoiceResponse.invoices) {
    // Total per supplier
    double totalAmount =
        double.parse(invoice.data.totalAmount.replaceAll(',', ''));
    totalPerSupplier[invoice.data.supplierName] =
        (totalPerSupplier[invoice.data.supplierName] ?? 0) + totalAmount;

    // Total per category (assuming description denotes category)
    for (var item in invoice.data.lineItems) {
      double amount = double.parse(item.amount.replaceAll(',', ''));
      totalPerCategory[item.description] =
          (totalPerCategory[item.description] ?? 0) + amount;
    }
//  Invoice Frequency per Supplier
    invoiceFrequencyPerSupplier[invoice.data.supplierName] =
        (invoiceFrequencyPerSupplier[invoice.data.supplierName] ?? 0) + 1;

    // Average Invoice Value
    totalInvoiceAmount +=
        double.parse(invoice.data.totalAmount.replaceAll(',', ''));

    //Currency Distribution
    double amount = double.parse(invoice.data.totalAmount.replaceAll(',', ''));
    String currency = invoice.data.currency;
    totalPerCurrency[currency] = (totalPerCurrency[currency] ?? 0) + amount;
  }

  double averageInvoiceValue = totalInvoiceAmount / totalInvoiceCount;

  print('Total Per Supplier: $totalPerSupplier');
  print('Total Per Category: $totalPerCategory');
  print('Invoice Frequency Per Supplier: $invoiceFrequencyPerSupplier');
  print('Average Invoice Value: $averageInvoiceValue');
  print(
      'Expense Distribution Among Line Items: $totalPerCategory'); // Already calculated
  print('Currency Distribution: $totalPerCurrency');
}
