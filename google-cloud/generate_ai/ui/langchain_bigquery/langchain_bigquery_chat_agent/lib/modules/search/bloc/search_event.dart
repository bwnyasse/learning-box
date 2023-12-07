abstract class SearchEvent {}

class SearchResetEvent extends SearchEvent {}

class SearchLoadEvent extends SearchEvent {
  final String prompt;
  final String option;

  SearchLoadEvent({
    required this.prompt,
    required this.option,
  });
}
