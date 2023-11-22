import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/utils.dart';
import 'models/invoice_models.dart';

class InvoicesService {
  InvoiceResponse invoiceResponse = InvoiceResponse(invoices: []);
  Map<String, Category> totalPerCategory = {};

  // Real API call
  Future<InvoiceResponse> _fetchInvoicesFromApi() async {
    final response = await http.get(Uri.parse(
        'https://flutter-invoice-document-ai-backend-o2f4t6inaa-nn.a.run.app'));
    if (response.statusCode == 200) {
      return InvoiceResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load invoices');
    }
  }

  // Mock data function
  Future<InvoiceResponse> _fetchMockInvoices() async {
    // Your mock JSON data as a string
    String mockJson =
        '''{"invoices":[{"gcs_uri":"gs://flutter_invoice_document_ai/invoice-01-2023.png","data":{"invoice_date":"15/01/2023","invoice_id":"2023-01","total_amount":"2,100.00","receiver_name":"Olivia Wilson","supplier_email":"hello@flutterfrenzy.ca","supplier_name":"FLUTTER FRENZY INC.","currency":"\$","invoice_type":"","supplier_address":"12 Way, Montreal, QC, H3Z2Z3, Canada","supplier_website":"www.flutterfrenzy.ca","receiver_email":"hello@reallygreatsite.com","remit_to_address":"123 Anywhere St., Any City, ST 12345","line_items":[{"description":"Flutter UI Overhaul","quantity":"2","unit_price":"100.00","amount":"200.00"},{"description":"Cross-Platform Integration","quantity":"1","unit_price":"700.00","amount":"700.00"},{"description":"Flutter Performance Tuning","quantity":"1","unit_price":"600.00","amount":"600.00"},{"description":"Flutter Workshop","quantity":"2","unit_price":"300.00","amount":"600.00"}]}},{"gcs_uri":"gs://flutter_invoice_document_ai/invoice-02-2023.png","data":{"invoice_date":"15/02/2023","invoice_id":"2023-02","total_amount":"1,600.00","receiver_name":"Olivia Wilson","supplier_email":"hello@flutterfrenzy.ca","supplier_name":"FLUTTER FRENZY INC.","currency":"\$","invoice_type":"","supplier_address":"12 Way, Montreal, QC, H3Z2Z3, Canada","supplier_website":"www.flutterfrenzy.ca","receiver_email":"hello@reallygreatsite.com","remit_to_address":"123 Anywhere St., Any City, ST 12345","line_items":[{"description":"Flutter UI Overhaul","quantity":"1","unit_price":"100.00","amount":"100.00"},{"description":"Cross-Platform Integration","quantity":"1","unit_price":"700.00","amount":"700.00"},{"description":"App Lifecyle Management","quantity":"1","unit_price":"200.00","amount":"200.00"},{"description":"Flutter Workshop","quantity":"2","unit_price":"300.00","amount":"600.00"}]}}]}''';

    // Simulating network delay
    await Future.delayed(const Duration(seconds: 2));

    // Decoding the mock JSON and returning
    return InvoiceResponse.fromJson(jsonDecode(mockJson));
  }

  Future<InvoiceResponse> fetchInvoices() async {
    if (invoiceResponse.invoices.isEmpty) {
      // Uncomment the below line when you want to use the real API
      //invoiceResponse = await _fetchInvoicesFromApi();

      // Comment out the below line when switching to the real API
      invoiceResponse = await _fetchMockInvoices();
      // Total per category (assuming description denotes category)
      for (var invoice in invoiceResponse.invoices) {
        for (var item in invoice.data.lineItems) {
          double amount = double.parse(item.amount.replaceAll(',', ''));

          // Check if the category already exists
          if (totalPerCategory.containsKey(item.description)) {
            totalPerCategory[item.description]!.addValue(amount);
          } else {
            // Assign a new color for new category
            Color categoryColor =
                getRandomColor(); // Function to generate a random color

            totalPerCategory[item.description] =
                Category(value: amount, color: categoryColor);
          }
        }
      }
    }

    return invoiceResponse;
  }
}
