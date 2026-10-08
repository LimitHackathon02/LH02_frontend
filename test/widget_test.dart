import 'package:flutter_test/flutter_test.dart';
import 'package:lh02_frontend/main.dart';
import 'package:lh02_frontend/screens/2-1-1.dart';

void main() {
  testWidgets('시작 화면에서 약속 질문 화면으로 이동한다', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('만나미가 약속을 잡아줄게요'), findsOneWidget);
    await tester.tap(find.text('직접 약속 잡기'));
    await tester.pumpAndSettle();
    expect(find.byType(Screen2_1_1), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
