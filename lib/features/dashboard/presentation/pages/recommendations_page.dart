// features/dashboard/presentation/pages/recommendations_page.dart
import 'package:flutter/material.dart';
import 'package:newcollegefinder/core/constants/app_constants.dart';
import 'package:newcollegefinder/core/widgets/recommendation_card.dart';

class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...AppConstants.demoRecommendations.map(
                (recommendation) => RecommendationCard(
              recommendation: recommendation,
            ),
          ),
        ],
      ),
    );
  }
}