import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

class SearchOutPut {
  String output;

  SearchOutPut({
    required this.output,
  });
}

@JsonSerializable()
class SearchResponse {
  List<AIResponse> ai;

  @JsonKey(name: 'final_answer')
  String finalAnswer;

  SearchResponse({
    required this.ai,
    required this.finalAnswer,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResponseToJson(this);
}

@JsonSerializable()
class AIResponse {
  @JsonKey(name: 'thought')
  String? thought;

  @JsonKey(name: 'action')
  String? action;

  @JsonKey(name: 'action_input')
  String? actionInput;

  @JsonKey(name: 'observation')
  String? observation;

  AIResponse({
    required this.thought,
    required this.action,
    required this.actionInput,
    required this.observation,
  });

  factory AIResponse.fromJson(Map<String, dynamic> json) =>
      _$AIResponseFromJson(json);
}
