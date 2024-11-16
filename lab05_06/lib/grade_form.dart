import 'package:flutter/material.dart';
import 'grade.dart';
import 'grades_model.dart';

// The form screen for adding or editing a grade.
class GradeForm extends StatelessWidget {
  final Grade? grade;

  const GradeForm({super.key, this.grade});

  @override
  Widget build(BuildContext context) {
    final TextEditingController sidController = TextEditingController(text: grade?.sid);
    final TextEditingController gradeController = TextEditingController(text: grade?.grade);
    final GradesModel _gradesModel = GradesModel();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Grade'),
        backgroundColor: const Color.fromARGB(255, 166, 216, 240),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: sidController,
              decoration: const InputDecoration(labelText: 'Student ID'),
            ),
            TextFormField(
              controller: gradeController,
              decoration: const InputDecoration(labelText: 'Grade'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newGrade = Grade(
            sid: sidController.text,
            grade: gradeController.text,
          );

          if (grade == null) {
            // Add new grade
            await _gradesModel.insertGrade(newGrade);
          } else {
            // Update existing grade
            newGrade.id = grade!.id;
            await _gradesModel.updateGrade(newGrade);
          }

          Navigator.pop(context, true);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}