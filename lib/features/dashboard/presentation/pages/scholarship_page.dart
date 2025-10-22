import 'package:flutter/material.dart';
import 'package:newcollegefinder/core/models/scholarships.dart';
import 'package:newcollegefinder/services/scholarship_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ScholarshipPage extends StatelessWidget {
  final ScholarshipService _service = ScholarshipService();

  ScholarshipPage({super.key});

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scholarships')),
      body: StreamBuilder<List<Scholarship>>(
        stream: _service.getScholarships(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No scholarships available.'));
          }
          final scholarships = snapshot.data!;
          return ListView.builder(
            itemCount: scholarships.length,
            itemBuilder: (context, index) {
              final scholarship = scholarships[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(scholarship.scholarshipName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Eligibility: ${scholarship.eligibility}"),
                      Text("Benefits: ${scholarship.benefits}"),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: () => _launchURL(scholarship.applicationPortal),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}