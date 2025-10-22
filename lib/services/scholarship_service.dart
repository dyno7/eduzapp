import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/models/scholarships.dart';

class ScholarshipService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Scholarship>> getScholarships() {
    return _db.collection('scholarships').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Scholarship.fromMap(doc.data()))
          .toList();
    });
  }
}