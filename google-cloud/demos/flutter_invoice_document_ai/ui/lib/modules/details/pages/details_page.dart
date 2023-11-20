import 'package:flutter/material.dart';

import '../../invoices/models/invoice_models.dart';

class DetailsPage extends StatelessWidget {
  final InvoiceData invoiceData;
  final String invoiceImageUrl; // URL or path to the invoice image

  const DetailsPage({
    super.key,
    required this.invoiceData,
    required this.invoiceImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Details'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
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
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Container(
              color: Colors.black, // Set background color to black
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('♦︎ Invoice ID: ${invoiceData.invoiceId}',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    Text('♦︎ Date: ${invoiceData.invoiceDate}',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    Text(
                        '♦︎ Total Amount: ${invoiceData.totalAmount} ${invoiceData.currency}',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    Text('♦︎ Receiver Name: ${invoiceData.receiverName}',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    Text('♦︎ Supplier Name: ${invoiceData.supplierName}',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    // Add more fields as needed
                    SizedBox(height: 20),
                    Text('Line Items:',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    for (var item in invoiceData.lineItems)
                      ListTile(
                        title: Text(item.description,
                            style: TextStyle(color: Colors.white)),
                        subtitle: Text(
                            'Quantity: ${item.quantity}, Unit Price: ${item.unitPrice}'),
                        trailing: Text('Amount: ${item.amount}',
                            style: TextStyle(color: Colors.white)),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
