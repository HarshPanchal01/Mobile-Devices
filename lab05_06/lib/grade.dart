// A class representing a grade with a student ID and a letter grade.
class Grade {
  int? id;
  String sid;
  String grade;

  Grade({this.id, required this.sid, required this.grade});

  // Converts the Grade object to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sid': sid,
      'grade': grade,
    };
  }

  // Creates a Grade object from a map.
  static Grade fromMap(Map<String, dynamic> map) {
    return Grade(
      id: map['id'],
      sid: map['sid'],
      grade: map['grade'],
    );
  }
}