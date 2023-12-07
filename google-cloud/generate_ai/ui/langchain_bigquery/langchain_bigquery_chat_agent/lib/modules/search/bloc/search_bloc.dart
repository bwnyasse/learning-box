import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../models/model.dart';
import '../search_service.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchService get service => Modular.get<SearchService>();

  SearchBloc() : super(SearchInitState()) {
    on<SearchLoadEvent>((event, emit) => _onSearchLoadEvent(event, emit));
    on<SearchResetEvent>((_, emit) => _onSearchResetEvent(emit));
  }

  void _onSearchResetEvent(Emitter<SearchState> emit) async =>
      emit(SearchInitState());

  void _onSearchLoadEvent(
      SearchLoadEvent event, Emitter<SearchState> emit) async {
    try {
      emit(SearchLoadingState());
      SearchOutPut output = await service.searchQuery(
        prompt: event.prompt,
        option: event.option,
      );
      emit(SearchLoadedState(response: output));
    } catch (e, _) {
      print(e);
      // Capture more specific error information
      String errorMessage = 'Failed to load';

      // print( '$e\n$s'); // Optional: Print the error and stack trace for debugging purposes
      emit(SearchErrorState(message: errorMessage));
    }
  }
}
