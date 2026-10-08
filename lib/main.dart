import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD25F),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: double.infinity,
            height: 430,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 흰색 광 이미지
                Positioned(
                  top: 0,
                  child: Image.asset(
                    'assets/images/text.png',
                    width: 340,
                    height: 280,
                    fit: BoxFit.contain,
                  ),
                ),

                // 별 캐릭터 이미지
                Positioned(
                  top: 35,
                  child: Image.asset(
                    'assets/images/star.png',
                    width: 165,
                    height: 165,
                    fit: BoxFit.contain,
                  ),
                ),

                // 안내 문구
                Positioned(
                  top: 230,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDF0),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color(0xFFD8C69B),
                        width: 0.8,
                      ),
                    ),
                    child: const Text(
                      '시간부터 장소까지, 한 번에 정해요',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                ),

                // 만나미 로고
                Positioned(
                  top: 285,
                  child: Image.asset(
                    'assets/images/mannami.png',
                    width: 180,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
