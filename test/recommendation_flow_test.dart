import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lh02_frontend/screens/2-1-3.dart';
import 'package:lh02_frontend/screens/step2_question_page.dart';
import 'package:lh02_frontend/services/backend_client.dart';

import 'backend_client_test.dart' show recommendationJson;

void main() {
  final answers = Step2Answers()
    ..depLoc = '노원역'
    ..likeText = '파스타';

  testWidgets('전송 실패 시 입력 화면에 남고 다시 요청할 수 있다', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final backend = BackendClient(
      client: MockClient(
        (_) async => http.Response.bytes(
          utf8.encode(
            jsonEncode({
              'detail': {'message': '출발 위치를 역 이름으로 적어 주세요.'},
            }),
          ),
          400,
        ),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Screen2_1_3(answers: answers, backendClient: backend),
      ),
    );
    await tester.tap(find.text('다음  →'));
    await tester.pumpAndSettle();
    expect(find.byType(Screen2_1_3), findsOneWidget);
    expect(find.text('출발 위치를 역 이름으로 적어 주세요.'), findsOneWidget);
    expect(find.text('이런 장소 어때요?'), findsNothing);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNotNull,
    );
  });

  testWidgets('서버 추천 목록과 선택한 장소의 상세 결과를 표시한다', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final backend = BackendClient(
      client: MockClient(
        (_) async => http.Response.bytes(
          utf8.encode(jsonEncode(recommendationJson)),
          200,
        ),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Screen2_1_3(answers: answers, backendClient: backend),
      ),
    );
    await tester.tap(find.text('다음  →'));
    await tester.pumpAndSettle();
    expect(find.text('서버 추천 식당'), findsOneWidget);
    expect(find.text('졸리앤몰트'), findsNothing);
    await tester.tap(find.text('서버 추천 식당'));
    await tester.pumpAndSettle();
    expect(find.text('입력한 조건과 가까워요.'), findsOneWidget);
    expect(find.text('나 · 약 14분'), findsOneWidget);
  });
}
