import '../models/invoice_models.dart';

abstract class InvoicesState {}

class InvoicesInitState extends InvoicesState {}

class InvoicesLoadingState extends InvoicesState {}

class InvoicesSuccessState extends InvoicesState {
  final InvoiceResponse response;

  InvoicesSuccessState({required this.response});
}

class InvoicesErrorState extends InvoicesState {
  final String message;

  InvoicesErrorState({required this.message});
}
