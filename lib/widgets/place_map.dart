import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/quick_recommendation.dart';

/// 선택한 장소의 좌표로 지도를 표시합니다. 식당 홈페이지 URL은 사용하지 않습니다.
class PlaceMap extends StatelessWidget {
  const PlaceMap({required this.place, super.key});

  final QuickRecommendation? place;

  @override
  Widget build(BuildContext context) {
    final item = place;
    if (item == null) {
      return const _MapMessage('장소를 선택하면 지도가 표시돼요.');
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      if (!item.hasCoordinates) {
        return const _MapMessage('이 장소의 위치 정보가 없어요.');
      }
      return UiKitView(
        key: ValueKey('${item.latitude},${item.longitude},${item.name}'),
        viewType: 'lh02/place_map',
        layoutDirection: TextDirection.ltr,
        creationParams: {
          'latitude': item.latitude,
          'longitude': item.longitude,
          'name': item.name,
          'address': item.address,
        },
        creationParamsCodec: const StandardMessageCodec(),
        gestureRecognizers: {
          Factory<OneSequenceGestureRecognizer>(EagerGestureRecognizer.new),
        },
      );
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final query = '${item.address} ${item.name}'.trim();
      if (query.isEmpty) {
        return const _MapMessage('이 장소의 위치 정보가 없어요.');
      }
      return _WebPlaceMap(key: ValueKey(query), query: query);
    }
    return const _MapMessage('지도는 모바일 앱에서 확인할 수 있어요.');
  }
}

class _WebPlaceMap extends StatefulWidget {
  const _WebPlaceMap({required this.query, super.key});

  final String query;

  @override
  State<_WebPlaceMap> createState() => _WebPlaceMapState();
}

class _WebPlaceMapState extends State<_WebPlaceMap> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.https('m.map.naver.com', '/search', {'query': widget.query}),
      );
  }

  @override
  Widget build(BuildContext context) => WebViewWidget(controller: _controller);
}

class _MapMessage extends StatelessWidget {
  const _MapMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color(0xFFF4F5F7),
    child: Center(
      child: Text(message, style: const TextStyle(color: Color(0xFF666666))),
    ),
  );
}
