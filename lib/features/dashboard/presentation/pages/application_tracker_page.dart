// features/dashboard/presentation/pages/application_tracker_page.dart
import 'package:flutter/material.dart';
import 'package:newcollegefinder/core/constants/app_constants.dart';
import 'package:newcollegefinder/core/widgets/deadline_card.dart';
//
// import '../../../../core/constants/app_constants.dart';
// import '../../../../core/widgets/deadline_card.dart';

class ApplicationTrackerPage extends StatelessWidget {
  const ApplicationTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Tracker'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...AppConstants.demoDeadlines.map(
                (deadline) => DeadlineCard(
              deadline: deadline,
            ),
          ),
        ],
      ),
    );
  }
}