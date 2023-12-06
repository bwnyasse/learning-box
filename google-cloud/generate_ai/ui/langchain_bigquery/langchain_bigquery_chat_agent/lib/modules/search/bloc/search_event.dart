abstract class SearchEvent {}

class SearchResetEvent extends SearchEvent {}

class SearchLoadEvent extends SearchEvent {
  final String prompt;

  SearchLoadEvent({required this.prompt});
}
