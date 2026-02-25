import 'package:json_annotation/json_annotation.dart';

part 'PSQuestionModel.g.dart';

@JsonSerializable()
class QuestionModel {
  final String question;
  final String a;
  final String b;
  final String answer;

  QuestionModel({
    required this.question,
    required this.a,
    required this.b,
    required this.answer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}