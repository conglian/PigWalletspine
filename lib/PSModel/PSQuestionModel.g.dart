// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PSQuestionModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    QuestionModel(
      question: json['question'] as String,
      a: json['a'] as String,
      b: json['b'] as String,
      answer: json['answer'] as String,
    );

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      'question': instance.question,
      'a': instance.a,
      'b': instance.b,
      'answer': instance.answer,
    };
