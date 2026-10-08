import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lh02_frontend/models/quick_recommendation.dart';
import 'package:lh02_frontend/screens/3-2.dart';

void main() {
  testWidgets(
    '실제 단일 참여자 응답의 시간을 자동차 아래 표시한다',
    (tester) async {
      final item = QuickRecommendation.fromJson({
        'place': {'name': '추천 식당'},
        'travel': [
          {'member': '사용자', 'distance_km': 0.3, 'est_minutes': 11},
        ],
      });
      await tester.pumpWidget(
        MaterialApp(home: Screen3_2(recommendation: item)),
      );
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('travel-time-1')),
          matching: find.text('11분'),
        ),
        findsOneWidget,
      );
      expect(find.text('평균 시간 11분'), findsOneWidget);
      expect(find.byKey(const ValueKey('travel-time-2')), findsNothing);
      expect(find.text('정보 없음'), findsNothing);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.iOS),
  );

  testWidgets(
    '텍스트 없이 travel 배열만 있어도 보경 1번, 지민 2번에 표시한다',
    (tester) async {
      final item = QuickRecommendation.fromJson({
        'place': {'name': '추천 식당'},
        'travel': [
          {'member': '지민', 'est_minutes': 27},
          {'member': '보경', 'est_minutes': '12'},
        ],
      });
      await tester.pumpWidget(
        MaterialApp(home: Screen3_2(recommendation: item)),
      );
      for (final entry in {1: '12분', 2: '27분'}.entries) {
        expect(
          find.descendant(
            of: find.byKey(ValueKey('travel-time-${entry.key}')),
            matching: find.text(entry.value),
          ),
          findsOneWidget,
        );
      }
      expect(find.text('평균 시간 20분'), findsOneWidget);
      expect(find.text('정보 없음'), findsNothing);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.iOS),
  );

  test('두 필드명 모두 이름으로 자동차 시간을 구분한다', () {
    for (final field in ['tavel_text', 'travel_text']) {
      final item = QuickRecommendation.fromJson({
        field: [
          '영통역(지민) → 식당 - 도보 약 8분 - 자동차 약 27분',
          '망포역(보경) → 식당 - 자동차 약 12분',
        ],
      });
      expect(item.travelMinutesFor('보경'), '12분');
      expect(item.travelMinutesFor('지민'), '27분');
      expect(item.travelMinutesFor('다른 사람'), '정보 없음');
    }
  });

  test('여러 줄 문자열에서 다른 사람의 시간을 가져오지 않는다', () {
    final item = QuickRecommendation.fromJson({
      'tavel_text':
          '망포역( 보경 ) → 식당 - 자동차 정보 없음\n'
          '영통역(지민) → 식당 - 자동차 약  31 분',
    });
    expect(item.travelMinutesFor('보경'), '정보 없음');
    expect(item.travelMinutesFor('지민'), '31분');
  });
}
