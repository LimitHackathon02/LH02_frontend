import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lh02_frontend/models/quick_recommendation.dart';
import 'package:lh02_frontend/widgets/place_map.dart';

void main() {
  test('백엔드가 반환한 숫자와 문자열 좌표를 읽는다', () {
    final place = QuickRecommendation.fromJson({
      'place': {'lat': '37.6575116', 'lng': 127.0617088},
    });
    expect(place.latitude, 37.6575116);
    expect(place.longitude, 127.0617088);
    expect(place.hasCoordinates, isTrue);
  });

  test('누락되거나 범위를 벗어난 좌표로 지도를 열지 않는다', () {
    for (final coordinates in [
      {'lat': null, 'lng': 127},
      {'lat': 37, 'lng': null},
      {'lat': 'NaN', 'lng': 127},
      {'lat': 37, 'lng': 'Infinity'},
      {'lat': 91, 'lng': 127},
      {'lat': 37, 'lng': 181},
    ]) {
      final place = QuickRecommendation.fromJson({'place': coordinates});
      expect(place.hasCoordinates, isFalse, reason: coordinates.toString());
    }
  });

  testWidgets(
    '좌표가 없으면 식당 홈페이지 대신 위치 안내를 표시한다',
    (tester) async {
      final place = QuickRecommendation.fromJson({
        'place': {
          'name': '좌표 없는 식당',
          'url': 'https://www.instagram.com/restaurant',
        },
      });
      await tester.pumpWidget(MaterialApp(home: PlaceMap(place: place)));
      expect(find.text('이 장소의 위치 정보가 없어요.'), findsOneWidget);
      expect(find.byType(UiKitView), findsNothing);
      expect(tester.takeException(), isNull);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.iOS),
  );
}
