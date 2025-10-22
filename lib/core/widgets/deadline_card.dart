// core/widgets/deadline_card.dart
import 'package:flutter/material.dart';

class DeadlineCard extends StatelessWidget {
  final Map<String, dynamic> deadline;

  const DeadlineCard({super.key, required this.deadline});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              deadline['title'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Deadline: ${deadline['date']}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              deadline['description'],
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}