import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/invoice_models.dart';

class InvoicesService {

  Future<InvoiceResponse> fetchInvoices() async {
    final response = await http.get(Uri.parse('https://flutter-invoice-document-ai-backend-o2f4t6inaa-nn.a.run.app'));
    if (response.statusCode == 200) {
      return InvoiceResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load invoices');
    }
  }
}
