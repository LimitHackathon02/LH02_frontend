import 'package:flutter_test/flutter_test.dart';
import 'package:lh02_frontend/main.dart';

void main() {
  testWidgets('메인 화면을 표시한다', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MainScreen), findsOneWidget);
  });
}
