import 'package:flutter_test/flutter_test.dart';
import 'package:lh02_frontend/main.dart';

void main() {
  testWidgets('기본 실행 확인 문구를 표시한다', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('LH02 프론트엔드 실행 확인'), findsOneWidget);
  });
}
