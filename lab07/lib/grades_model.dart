import 'package:cloud_firestore/cloud_firestore.dart';
import 'grade.dart';

class GradesModel {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('grades');

  // Fetches all grades from Firestore.
  Future<List<Grade>> getGrades() async {
    final QuerySnapshot snapshot = await collection.get();
    return snapshot.docs.map((doc) => Grade.fromSnapshot(doc)).toList();
  }

  // Adds a new grade to Firestore.
  Future<DocumentReference> addGrade(Grade grade) {
    return collection.add(grade.toJson());
  }

  // Updates an existing grade in Firestore.
  void updateGrade(Grade grade) async {
    await grade.reference?.update(grade.toJson());
  }

  // Deletes a grade from Firestore.
  void deleteGrade(Grade grade) async {
    await grade.reference?.delete();
  }

  // Returns a stream of grades from Firestore.
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
}