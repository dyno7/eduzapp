import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

class CollegeUploadService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Upload college data from JSON to Firestore
  Future<void> uploadColleges() async {
    try {
      print("📂 Loading college data...");

      // Load JSON data from the assets folder
      String jsonData = await rootBundle.loadString('assets/colleges_data.json');
      List<dynamic> colleges = json.decode(jsonData);

      print("📊 Total colleges found: ${colleges.length}");

      for (var college in colleges) {
        // Prepare the data to upload (excluding unnecessary fields)
        final collegeData = {
          "college_name": college["College Name"] ?? "Unknown",
          "courses": college["Courses"] ?? "Not Specified",
          "city": college["City"] ?? "Unknown",
          "state": college["State"] ?? "Unknown",
          "college_type": college["College Type"] ?? "Unknown",
          "average_fees": (college["Average Fees"] ?? 0).toDouble(), // Ensure double type
        };

        // Upload each college to Firestore
        await _db.collection('colleges').add(collegeData);

        print("✅ Uploaded: ${collegeData["college_name"]}");
      }

      print("🎉 All colleges uploaded successfully!");
    } catch (e) {
      print("❌ Error uploading colleges: $e");
    }
  }
}