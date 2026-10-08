// ignore_for_file: file_names, camel_case_types
import 'package:flutter/material.dart';
import '../models/quick_recommendation.dart';
import 'restaurant_recommendation_screen.dart';

/// 추천 결과 목록 화면(3-1).
class Screen3_1 extends StatelessWidget {
  const Screen3_1({this.recommendations = const [], super.key});

  final List<QuickRecommendation> recommendations;

  @override
  Widget build(BuildContext context) => RestaurantRecommendationScreen(recommendations: recommendations);
}
