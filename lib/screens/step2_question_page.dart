import 'package:flutter/material.dart';

class Step2Answers {
  // 2-1 inputs are combined into the QuickReq fields name and text.
  String depLoc = '';
  String likeText = '';
  String disText = '';

  String getValue(int step) => switch (step) {
    0 => depLoc,
    1 => likeText,
    _ => disText,
  };

  Map<String, String> toPersonJson({String name = '나'}) => {
    'name': name.trim().isEmpty ? '사용자' : name.trim(),
    'text': _combinedText,
  };

  String get _combinedText {
    final parts = <String>[];
    final departure = depLoc.trim();
    if (departure.isNotEmpty) {
      final departureText = departure.contains('출발')
          ? departure
          : '$departure에서 출발해요';
      parts.add(_withEnding(departureText));
    }
    if (likeText.trim().isNotEmpty) parts.add(_withEnding(likeText.trim()));
    if (disText.trim().isNotEmpty) parts.add(_withEnding(disText.trim()));
    return parts.join(' ');
  }

  static String _withEnding(String value) {
    if (RegExp(r'[.!?。！？]$').hasMatch(value)) return value;
    return '$value.';
  }

  static Map<String, Object> toRequestJson(
    Iterable<Step2Answers> people, {
    String name = '나',
  }) => {
    'people': people.map((person) => person.toPersonJson(name: name)).toList(),
  };

  void setValue(int step, String value) {
    switch (step) {
      case 0:
        depLoc = value;
      case 1:
        likeText = value;
      default:
        disText = value;
    }
  }
}

class Step2QuestionPage extends StatefulWidget {
  const Step2QuestionPage({
    required this.step,
    required this.answers,
    required this.onNext,
    required this.onBack,
    this.isNextLoading = false,
    super.key,
  });

  final int step;
  final Step2Answers answers;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final bool isNextLoading;

  @override
  State<Step2QuestionPage> createState() => _Step2QuestionPageState();
}

class _Step2QuestionPageState extends State<Step2QuestionPage> {
  late final TextEditingController _controller;

  static const _titles = ['여기서 출발해요!', '이런 약속 원해요!', '이런 약속 싫어요.'];
  static const _subtitles = [
    '출발하는 장소를 작성해주세요.',
    '만남에서 선호하는 것들을 작성해주세요.',
    '만남에서 피하고 싶은 것들을 작성해주세요.',
  ];
  static const _hints = [
    'ex) 경희대학교 국제캠퍼스',
    'ex) 이동시간이 최소화되었으면 좋겠다',
    'ex) 시끄러운 곳은 피하고 싶다',
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.answers.getValue(widget.step),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      top: false,
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale = constraints.maxWidth / 300;
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: constraints.maxWidth * .5,
                child: Image.asset(
                  'assets/screens/2-1-${widget.step + 1}/bgd.png',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Transform.scale(
                  alignment: Alignment.topLeft,
                scale: scale,
                child: SizedBox(
                  width: 300,
                  height: constraints.maxHeight / scale,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Column(
                      children: [
                        _header(),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(29, 4, 29, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 7),
                                  child: Image.asset(
                                    'assets/screens/2-1-${widget.step + 1}/mannami.png',
                                    width: 56,
                                    height: 48,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.only(left: 9),
                                  child: Text(
                                    _titles[widget.step],
                                    style: const TextStyle(
                                      color: Color(0xFF25120F),
                                      fontSize: 21,
                                      height: 1.2,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.only(left: 9),
                                  child: Text(
                                    _subtitles[widget.step],
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF777777),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 21),
                                TextField(
                                  controller: _controller,
                                  onChanged: (value) => widget.answers.setValue(
                                    widget.step,
                                    value,
                                  ),
                                  textInputAction: TextInputAction.done,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF444444),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: _hints[widget.step],
                                    hintStyle: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF888888),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 11,
                                    ),
                                    isDense: true,
                                    filled: true,
                                    fillColor: Colors.white.withValues(
                                      alpha: .92,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFD3D3D3),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFD7B84B),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    height: 25,
                                    child: FilledButton(
                                      onPressed: widget.isNextLoading
                                          ? null
                                          : widget.onNext,
                                      style: FilledButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFFFF2BF,
                                        ),
                                        foregroundColor: const Color(
                                          0xFF4C4636,
                                        ),
                                        disabledBackgroundColor: const Color(
                                          0xFFFFF2BF,
                                        ),
                                        disabledForegroundColor: const Color(
                                          0xFF4C4636,
                                        ),
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        shape: const StadiumBorder(
                                          side: BorderSide(
                                            color: Color(0xFFE8D99C),
                                          ),
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      child: widget.isNextLoading
                                          ? const SizedBox(
                                              width: 12,
                                              height: 12,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1.5,
                                              ),
                                            )
                                          : const Text('다음  →'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _bottomNavigation(),
                      ],
                    ),
                  ),
                  ),
                  ),
              ),
            ],
          );
        },
      ),
    ),
  );

  Widget _header() => SizedBox(
    height: 104,
    child: Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 50,
          child: Image.asset(
            'assets/screens/2-1-${widget.step + 1}/upper step.png',
            width: 300,
            height: 50,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: IconButton(
            onPressed: widget.onBack,
            padding: const EdgeInsets.only(left: 16),
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF9B9B9B)),
          ),
        ),
      ],
    ),
  );

  Widget _bottomNavigation() => SizedBox(
    width: 300,
    height: 62,
    child: Image.asset(
      'assets/screens/2-1-1/underbar.png',
      fit: BoxFit.contain,
    ),
  );
}
