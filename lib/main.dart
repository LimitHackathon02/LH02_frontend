import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/0.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: const [SystemUiOverlay.bottom],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'LH02 프론트엔드',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'Pretendard',
      scaffoldBackgroundColor: Colors.white,
    ),
    home: const WelcomeScreen(),
  );
}
