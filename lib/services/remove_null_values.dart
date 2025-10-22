import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> cleanFirestoreCollection(String collectionName) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference collectionRef = firestore.collection(collectionName);

  try {
    QuerySnapshot querySnapshot = await collectionRef.get();
    WriteBatch batch = firestore.batch();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> updatedData = {};

      // Remove null values from fields
      data.forEach((key, value) {
        if (value != null) {
          updatedData[key] = value;
        }
      });

      if (updatedData.isEmpty) {
        // If all fields were null, delete the document
        batch.delete(doc.reference);
        print("🗑 Deleted empty document: ${doc.id}");
      } else if (updatedData.length != data.length) {
        // If some fields were removed, update the document
        batch.update(doc.reference, updatedData);
        print("✅ Updated document: ${doc.id}");
      }
    }

    await batch.commit();
    print("🎉 Firestore cleanup completed for $collectionName!");
  } catch (e) {
    print("❌ Error cleaning Firestore: $e");
  }
}
