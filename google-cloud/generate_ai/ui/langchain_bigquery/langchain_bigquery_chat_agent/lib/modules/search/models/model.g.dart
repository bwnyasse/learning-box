// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResponse _$SearchResponseFromJson(Map<String, dynamic> json) =>
    SearchResponse(
      ai: (json['ai'] as List<dynamic>)
          .map((e) => AIResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      finalAnswer: json['final_answer'] as String,
    );

Map<String, dynamic> _$SearchResponseToJson(SearchResponse instance) =>
    <String, dynamic>{
      'ai': instance.ai,
      'final_answer': instance.finalAnswer,
    };

AIResponse _$AIResponseFromJson(Map<String, dynamic> json) => AIResponse(
      thought: json['thought'] as String?,
      action: json['action'] as String?,
      actionInput: json['action_input'] as String?,
      observation: json['observation'] as String?,
    );

Map<String, dynamic> _$AIResponseToJson(AIResponse instance) =>
    <String, dynamic>{
      'thought': instance.thought,
      'action': instance.action,
      'action_input': instance.actionInput,
      'observation': instance.observation,
    };
