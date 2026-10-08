// ignore_for_file: file_names, camel_case_types
import 'package:flutter/material.dart';
import 'step2_question_page.dart';
import '2-1-3.dart';

class Screen2_1_2 extends StatelessWidget {
  const Screen2_1_2({required this.answers, super.key});
  final Step2Answers answers;

  @override
  Widget build(BuildContext context) => Step2QuestionPage(
    step: 1,
    answers: answers,
    onBack: () => Navigator.of(context).pop(),
    onNext: () => Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => Screen2_1_3(answers: answers))),
  );
}
