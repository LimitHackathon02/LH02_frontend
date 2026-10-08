// ignore_for_file: file_names, camel_case_types
import 'package:flutter/material.dart';

import '../services/backend_client.dart';
import '3-1.dart';
import 'step2_question_page.dart';

class Screen2_1_3 extends StatefulWidget {
  const Screen2_1_3({required this.answers, super.key});
  final Step2Answers answers;

  @override
  State<Screen2_1_3> createState() => _Screen2_1_3State();
}

class _Screen2_1_3State extends State<Screen2_1_3> {
  late final BackendClient _backendClient;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _backendClient = BackendClient();
  }

  @override
  void dispose() {
    _backendClient.close();
    super.dispose();
  }

  Future<void> _submitAndContinue() async {
    setState(() => _isSubmitting = true);
    try {
      String? requestError;
      try {
        final payload = Step2Answers.toRequestJson([widget.answers]);
        await _backendClient.submitPeople(payload);
      } catch (error) {
        requestError = error.toString();
      }

      if (!mounted) return;
      if (requestError != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('백엔드 전송 실패: $requestError')));
      }
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const Screen3_1()));
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
