// ignore_for_file: file_names, camel_case_types
import 'package:flutter/material.dart';

import '../services/backend_client.dart';
import '3-1.dart';
import 'step2_question_page.dart';

class Screen2_1_3 extends StatefulWidget {
  const Screen2_1_3({required this.answers, this.backendClient, super.key});
  final Step2Answers answers;
  final BackendClient? backendClient;

  @override
  State<Screen2_1_3> createState() => _Screen2_1_3State();
}

class _Screen2_1_3State extends State<Screen2_1_3> {
  late final BackendClient _backendClient;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _backendClient = widget.backendClient ?? BackendClient();
  }

  @override
  void dispose() {
    _backendClient.close();
    super.dispose();
  }

  Future<void> _submitAndContinue() async {
    if (_isSubmitting) return;
    if (widget.answers.depLoc.trim().isEmpty ||
        widget.answers.likeText.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('출발 장소와 원하는 약속을 입력해주세요.')));
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final payload = Step2Answers.toRequestJson([widget.answers]);
      if (widget.answers.toPersonJson()['text']!.length > 500) {
        throw const BackendConnectionException('답변을 합쳐 500자 이내로 입력해주세요.');
      }
      final result = await _backendClient.submitPeople(payload);
      if (!mounted) return;
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => Screen3_1(result: result)));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) => Step2QuestionPage(
    step: 2,
    answers: widget.answers,
    isNextLoading: _isSubmitting,
    onBack: () => Navigator.of(context).pop(),
    onNext: _submitAndContinue,
  );
}
