import 'package:flutter/material.dart';
import 'grade.dart';

// The form screen for adding or editing a grade.
class GradeForm extends StatelessWidget {
  final Grade? grade;

  const GradeForm({super.key, this.grade});

  @override
  Widget build(BuildContext context) {
    final TextEditingController sidController = TextEditingController(text: grade?.sid);
    final TextEditingController gradeController = TextEditingController(text: grade?.grade);

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
        onPressed: () {
          final newGrade = Grade(
            id: grade?.id,
            sid: sidController.text,
            grade: gradeController.text,
          );
          Navigator.pop(context, newGrade);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}