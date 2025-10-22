import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await uploadScholarships();
  print("✅ Scholarships uploaded successfully!");
}

Future<void> uploadScholarships() async {
  final firestore = FirebaseFirestore.instance;

  try {
    // Load JSON
    String jsonData = await rootBundle.loadString('assets/scholarships.json');
    List<dynamic> scholarships = json.decode(jsonData);

    for (var scholarship in scholarships) {
      await firestore.collection('scholarships').add(scholarship);
      print("📚 Uploaded: ${scholarship['scholarship_name']}");
    }
  } catch (e) {
    print("❌ Error uploading scholarships: $e");
  }
}