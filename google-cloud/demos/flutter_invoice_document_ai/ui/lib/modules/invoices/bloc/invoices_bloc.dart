import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_invoice_document_ai_ui/modules/invoices/models/invoice_models.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../invoices_service.dart';
import 'invoices_event.dart';
import 'invoices_state.dart';

class InvoicesBloc extends Bloc<InvoicesEvent, InvoicesState> {
  InvoicesService get service => Modular.get<InvoicesService>();

  InvoicesBloc() : super(InvoicesInitState()) {
    on<InvoicesLoadEvent>((event, emit) => _onInvoicesLoadEvent(emit));
  }

  void _onInvoicesLoadEvent(Emitter<InvoicesState> emit) async {
    try {
      emit(InvoicesLoadingState());
      InvoiceResponse response = await service.fetchInvoices();
      emit(InvoicesSuccessState(response: response));
    } catch (e, s) {
      // Capture more specific error information
      String errorMessage = 'Failed to load invoices';

     // print( '$e\n$s'); // Optional: Print the error and stack trace for debugging purposes
      emit(InvoicesErrorState(message: errorMessage));
    }
  }
}
