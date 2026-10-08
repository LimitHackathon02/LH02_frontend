// ignore_for_file: file_names, camel_case_types
import 'package:flutter/material.dart';
import 'step2_question_page.dart';
import '2-1-2.dart';

class Screen2_1_1 extends StatefulWidget {
  const Screen2_1_1({super.key});
  @override
  State<Screen2_1_1> createState() => _Screen2_1_1State();
}

class _Screen2_1_1State extends State<Screen2_1_1> {
  final _answers = Step2Answers();

  @override
  Widget build(BuildContext context) => Step2QuestionPage(
    step: 0,
    answers: _answers,
    onBack: () => Navigator.of(context).maybePop(),
    onNext: () => Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => Screen2_1_2(answers: _answers))),
  );
}
