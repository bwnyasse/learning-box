import '../models/model.dart';

abstract class SearchState {}

class SearchInitState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchLoadedState extends SearchState {
  final SearchOutPut response;

  SearchLoadedState({required this.response});
}

class SearchErrorState extends SearchState {
  final String message;

  SearchErrorState({required this.message});
}
