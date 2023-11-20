import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../invoices/models/invoice_models.dart';

class DetailsPage extends StatefulWidget {
  final Invoice invoice;

  const DetailsPage({
    super.key,
    required this.invoice,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late InvoiceData invoiceData;
  late String invoiceImageUrl; //

  @override
  void initState() {
    super.initState();
    Invoice invoice = widget.invoice;
    invoiceData = invoice.data;
    invoiceImageUrl = invoice.gcsUri.replaceAll('gs://', 'https://storage.cloud.google.com/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Details'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Modular.to
                .navigate('/invoices/'); // Navigate back to the previous page
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Image.network(
                invoiceImageUrl,
                fit: BoxFit.cover,
                // Placeholder in case of loading or error
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
Card(
  color: Colors.black, // Set background color to black
  margin: const EdgeInsets.all(30.0),
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('♦︎ Invoice ID: ${invoiceData.invoiceId}',
            style: const TextStyle(fontSize: 18, color: Colors.white)),
        const SizedBox(height: 10),
        Text('♦︎ Date: ${invoiceData.invoiceDate}',
            style: const TextStyle(fontSize: 18, color: Colors.white)),
        const SizedBox(height: 10),
        Text(
            '♦︎ Total Amount: ${invoiceData.totalAmount} ${invoiceData.currency}',
            style: const TextStyle(fontSize: 18, color: Colors.white)),
        const SizedBox(height: 10),
        Text('♦︎ Receiver Name: ${invoiceData.receiverName}',
            style: const TextStyle(fontSize: 18, color: Colors.white)),
        const SizedBox(height: 10),
        Text('♦︎ Supplier Name: ${invoiceData.supplierName}',
            style: const TextStyle(fontSize: 18, color: Colors.white)),
        const SizedBox(height: 20),
        const Text('Line Items:',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        ...invoiceData.lineItems.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text(
            '• ${item.description}: ${item.quantity} x ${item.unitPrice} (${item.amount})',
            style: const TextStyle(color: Colors.white),
          ),
        )).toList(),
      ],
    ),
  ),
)

          ],
        ),
      ),
    );
  }
}
