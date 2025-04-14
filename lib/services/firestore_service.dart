import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchStories() async {
  try {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('stories').limit(5).get(); // LIMIT to 5

    if (snapshot.docs.isEmpty) {
      print("⚠️ No stories found in Firestore.");
    }

    return snapshot.docs.map((doc) {
      final data = doc.data();
      if (data == null) {
        print("⚠️ Found a null document in Firestore.");
        return <String, dynamic>{}; // Return empty map to prevent crashes
      }
      print("📌 Story Fetched: ${data["title"] ?? "Untitled"}");
      return Map<String, dynamic>.from(data); // Ensure proper type conversion
    }).toList();
  } catch (e) {
    print("❌ Firestore Fetch Error: $e");
    return [];
  }
}

}
