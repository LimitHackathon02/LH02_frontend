// ignore_for_file: file_names, camel_case_types
import 'package:flutter/material.dart';
import 'restaurant_recommendation_screen.dart';
import '../models/recommendation_result.dart';

/// 추천 결과 목록 화면(3-1).
class Screen3_1 extends StatelessWidget {
  const Screen3_1({required this.result, super.key});
  final RecommendationResult result;

  @override
  Widget build(BuildContext context) =>
      RestaurantRecommendationScreen(result: result);
}
