import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'LH02 프론트엔드',
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Text('LH02 프론트엔드 실행 확인'))),
    );
  }
}
