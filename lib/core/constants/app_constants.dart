// core/constants/app_constants.dart
class AppConstants {
  static const String appName = 'College Finder Pro';
  static const String appVersion = '1.0.0';

  // Demo data
  static const List<Map<String, dynamic>> demoDeadlines = [
    {
      'title': 'MIT Application',
      'date': '2023-12-15',
      'description': 'Submit all required documents',
    },
    {
      'title': 'Stanford Scholarship',
      'date': '2023-11-30',
      'description': 'Apply for financial aid',
    },
  ];

  static const List<Map<String, dynamic>> demoRecommendations = [
    {
      'name': 'Computer Science',
      'university': 'Harvard University',
      'location': 'Cambridge, MA',
    },
    {
      'name': 'Business Administration',
      'university': 'Stanford University',
      'location': 'Stanford, CA',
    },
  ];
}