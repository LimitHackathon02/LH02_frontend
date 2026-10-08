import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController =
      TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      String location = _locationController.text.trim();
      debugPrint('입력된 장소: $location');

      // TODO: 다음 페이지 이동 기능 추가 예정
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 뒤로가기 버튼
              Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  top: 10,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),

              const SizedBox(height: 5),

              // STEP 표시
              const Center(
                child: Text(
                  'STEP. 2',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // 진행바
              const StepProgress(),

              const SizedBox(height: 35),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 38,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    // =====================================
                    // TODO: 캐릭터 PNG 이미지 추가하기
                    //
                    // 현재는 이미지가 없어서 빈 공간만 설정
                    //
                    // 나중에 캐릭터 이미지가 준비되면
                    // 아래 SizedBox를 삭제하고
                    // 다음 코드로 교체하면 됨
                    //
                    // Image.asset(
                    //   'assets/images/character.png',
                    //   width: 70,
                    //   height: 70,
                    // )
                    //
                    // pubspec.yaml에 assets 경로 등록 필요
                    // =====================================

                    const SizedBox(
                      width: 70,
                      height: 70,
                    ),

                    const SizedBox(height: 10),

                    // 제목
                    const Text(
                      '여기서 출발해요!',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF321515),
                      ),
                    ),

                    const SizedBox(height: 7),

                    // 설명
                    const Text(
                      '출발하는 장소를 작성해주세요.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // 장소 입력
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          hintText:
                              'ex) 경희대학교 예술디자인대학',
                          hintStyle: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(25),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: Color(0xFFD0D0D0),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return '장소를 입력해 주세요.';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 14),

                    // 다음 버튼
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 77,
                        height: 27,
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFFFEDB2),
                            foregroundColor: Colors.grey[700],
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(25),
                              side: const BorderSide(
                                color: Color(0xFFD8D8D8),
                              ),
                            ),
                          ),
                          child: const Text(
                            '다음 →',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// STEP 진행바
class StepProgress extends StatelessWidget {
  const StepProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 245,
        height: 30,
        child: Stack(
          children: [
            Positioned(
              top: 7,
              left: 0,
              right: 0,
              child: Container(
                height: 1,
                color: Colors.grey[400],
              ),
            ),
            const Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: [
                StepDot(label: 'START', active: true),
                StepDot(label: 'GOOD', active: false),
                StepDot(label: 'BAD', active: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 진행바 원 표시
class StepDot extends StatelessWidget {
  final String label;
  final bool active;

  const StepDot({
    super.key,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? Colors.grey : Colors.white,
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
