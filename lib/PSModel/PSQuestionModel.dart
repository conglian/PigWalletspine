import '../PSTool/PSLocale.dart';
import 'package:json_annotation/json_annotation.dart';

part 'PSQuestionModel.g.dart';

@JsonSerializable()
class QuestionModel {
  final String question;
  final String a;
  final String b;
  final String answer;
  String get localizedQuestion => PSLocale.tr(question);
  String get localizedA => PSLocale.tr(a);
  String get localizedB => PSLocale.tr(b);

  QuestionModel({
    required this.question,
    required this.a,
    required this.b,
    required this.answer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    // 兼容旧题库直接保存答案文字的题目；判题仍使用选项标识，不依赖翻译。
    final answer = json['answer'];
    final option = answer == 'a' || answer == 'b'
        ? answer
        : answer == json['a']
        ? 'a'
        : answer == json['b']
        ? 'b'
        : answer;
    return _$QuestionModelFromJson({...json, 'answer': option});
  }

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}
