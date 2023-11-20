// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceResponse _$InvoiceResponseFromJson(Map<String, dynamic> json) =>
    InvoiceResponse(
      invoices: (json['invoices'] as List<dynamic>)
          .map((e) => Invoice.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InvoiceResponseToJson(InvoiceResponse instance) =>
    <String, dynamic>{
      'invoices': instance.invoices,
    };

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice(
      gcsUri: json['gcs_uri'] as String,
      data: InvoiceData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
      'gcs_uri': instance.gcsUri,
      'data': instance.data,
    };

InvoiceData _$InvoiceDataFromJson(Map<String, dynamic> json) => InvoiceData(
      invoiceDate: json['invoice_date'] as String,
      invoiceId: json['invoice_id'] as String,
      totalAmount: json['total_amount'] as String,
      receiverName: json['receiver_name'] as String,
      supplierEmail: json['supplier_email'] as String,
      supplierName: json['supplier_name'] as String,
      currency: json['currency'] as String,
      invoiceType: json['invoice_type'] as String,
      supplierAddress: json['supplier_address'] as String,
      supplierWebsite: json['supplier_website'] as String,
      receiverEmail: json['receiver_email'] as String,
      remitToAddress: json['remit_to_address'] as String,
      lineItems: (json['line_items'] as List<dynamic>)
          .map((e) => LineItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InvoiceDataToJson(InvoiceData instance) =>
    <String, dynamic>{
      'invoice_date': instance.invoiceDate,
      'invoice_id': instance.invoiceId,
      'total_amount': instance.totalAmount,
      'receiver_name': instance.receiverName,
      'supplier_email': instance.supplierEmail,
      'supplier_name': instance.supplierName,
      'currency': instance.currency,
      'invoice_type': instance.invoiceType,
      'supplier_address': instance.supplierAddress,
      'supplier_website': instance.supplierWebsite,
      'receiver_email': instance.receiverEmail,
      'remit_to_address': instance.remitToAddress,
      'line_items': instance.lineItems,
    };

LineItem _$LineItemFromJson(Map<String, dynamic> json) => LineItem(
      description: json['description'] as String,
      quantity: json['quantity'] as String,
      unitPrice: json['unit_price'] as String,
      amount: json['amount'] as String,
    );

Map<String, dynamic> _$LineItemToJson(LineItem instance) => <String, dynamic>{
      'description': instance.description,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'amount': instance.amount,
    };
