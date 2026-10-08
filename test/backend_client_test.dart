import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lh02_frontend/services/backend_client.dart';
import 'package:lh02_frontend/screens/step2_question_page.dart';

final recommendationJson = {
  'center': {'name': '노원역'},
  'group_summary': '조용한 파스타집',
  'fallback': false,
  'recommendations': [
    {
      'rank': 1,
      'score': 85,
      'place': {
        'name': '서버 추천 식당',
        'address': '서울 노원구',
        'category': '음식점>양식',
        'lat': 37.6575116,
        'lng': 127.0617088,
        'url': 'https://www.instagram.com/restaurant',
      },
      'reason': '입력한 조건과 가까워요.',
      'matched': ['조용한'],
      'warnings': ['영업시간을 확인해주세요.'],
      'travel': [
        {'member': '나', 'distance_km': 1.2, 'est_minutes': 14},
      ],
    },
  ],
};

void main() {
  setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.iOS);
  tearDown(() => debugDefaultTargetPlatformOverride = null);
  test('세 답변을 실제 quick API 요청으로 전송하고 한글 결과를 읽는다', () async {
    final answers = Step2Answers()
      ..depLoc = '노원역'
      ..likeText = '파스타'
      ..disText = '시끄러운 곳';
    final backend = BackendClient(
      client: MockClient((request) async {
        expect(
          request.url.toString(),
          'http://127.0.0.1:8000/api/recommend/quick',
        );
        expect(request.method, 'POST');
        final person = (jsonDecode(request.body)['people'] as List).single;
        expect(person['name'], '나');
        expect(person['text'], contains('노원역에서 출발해요.'));
        expect(person['text'], contains('파스타'));
        expect(person['text'], contains('시끄러운 곳'));
        expect(person.containsKey('Dep_loc'), isFalse);
        return http.Response.bytes(
          utf8.encode(jsonEncode(recommendationJson)),
          200,
        );
      }),
    );
    addTearDown(backend.close);
    final result = await backend.submitPeople(
      Step2Answers.toRequestJson([answers]),
    );
    expect(result.centerName, '노원역');
    expect(result.recommendations.single.name, '서버 추천 식당');
    expect(result.recommendations.single.travel.single.minutes, 14);
  });

  test('백엔드가 반환한 사용자 안내를 보존한다', () async {
    final backend = BackendClient(
      client: MockClient(
        (_) async => http.Response.bytes(
          utf8.encode(
            jsonEncode({
              'detail': {
                'code': 'NO_LOCATION',
                'message': '출발 위치를 역 이름으로 적어 주세요.',
              },
            }),
          ),
          400,
        ),
      ),
    );
    addTearDown(backend.close);
    await expectLater(
      backend.submitPeople({'people': []}),
      throwsA(
        isA<BackendRequestException>().having(
          (error) => error.toString(),
          'message',
          '출발 위치를 역 이름으로 적어 주세요.',
        ),
      ),
    );
  });

  test('서버가 없으면 연결 실패로 안내한다', () async {
    final backend = BackendClient(
      client: MockClient((request) async {
        throw http.ClientException('Connection refused', request.url);
      }),
    );
    addTearDown(backend.close);
    await expectLater(
      backend.submitPeople({'people': []}),
      throwsA(isA<BackendConnectionException>()),
    );
  });

  test('추천 목록이 없는 성공 응답을 결과로 사용하지 않는다', () async {
    final backend = BackendClient(
      client: MockClient((_) async => http.Response('{}', 200)),
    );
    addTearDown(backend.close);
    await expectLater(
      backend.submitPeople({'people': []}),
      throwsA(isA<BackendConnectionException>()),
    );
  });
}
