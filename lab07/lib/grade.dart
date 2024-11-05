import 'package:cloud_firestore/cloud_firestore.dart';

class Grade {
  String id;
  String sid;
  String grade;
  DocumentReference? reference;

  Grade({required this.sid, required this.grade, this.id = '', this.reference});

  factory Grade.fromSnapshot(DocumentSnapshot snapshot) {
    final newGrade = Grade.fromJson(snapshot.data() as Map<String, dynamic>);
    newGrade.reference = snapshot.reference;
    newGrade.id = snapshot.id;
    return newGrade;
  }

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      sid: json['sid'] as String,
      grade: json['grade'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sid': sid,
      'grade': grade,
    };
  }
}