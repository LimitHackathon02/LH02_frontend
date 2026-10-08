import 'package:flutter/material.dart';
import 'screens/date_select_screen.dart';

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
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 원본 이미지 비율: 372 x 811
          const imageWidth = 372.0;
          const imageHeight = 811.0;
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          return Center(
            child: SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: Stack(
                children: [
                  // 메인 화면 이미지 전체 표시
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/mainscreen.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  // 직접 약속 잡기 버튼 터치 영역
                  Positioned(
                    left: screenWidth * (23 / imageWidth),
                    top: screenHeight * (669 / imageHeight),
                    width: screenWidth * (331 / imageWidth),
                    height: screenHeight * (44 / imageHeight),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DateSelectScreen(),
                          ),
                        );
                      },
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
