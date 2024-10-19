import 'package:flutter/material.dart';
import 'grade.dart';
import 'grades_model.dart';
import 'grade_form.dart';

// The screen that displays a list of grades.
class ListGrades extends StatefulWidget {
  const ListGrades({Key? key}) : super(key: key);

  @override
  _ListGradesState createState() => _ListGradesState();
}

class _ListGradesState extends State<ListGrades> {
  final GradesModel _gradesModel = GradesModel();
  List<Grade> _grades = [];
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _loadGrades();
  }

  // Loads grades from the database and updates the state.
  Future<void> _loadGrades() async {
    final grades = await _gradesModel.getAllGrades();
    setState(() {
      _grades = grades;
    });
  }

  // Navigates to the GradeForm to add a new grade.
  void _addGrade() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => GradeForm()),
    ).then((result) {
      if (result != null) {
        _gradesModel.insertGrade(result).then((_) => _loadGrades());
      }
    });
  }

  // Navigates to the GradeForm to edit the selected grade.
  void _editGrade() {
    if (_selectedIndex != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => GradeForm(grade: _grades[_selectedIndex!])),
      ).then((result) {
        if (result != null) {
          _gradesModel.updateGrade(result).then((_) => _loadGrades());
        }
      });
    }
  }

  // Deletes the selected grade from the database.
  void _deleteGrade() {
    if (_selectedIndex != null) {
      _gradesModel.deleteGradeById(_grades[_selectedIndex!].id!).then((_) => _loadGrades());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Grades'),
        backgroundColor: const Color.fromARGB(255, 166, 216, 240),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _editGrade),
          IconButton(icon: const Icon(Icons.delete), onPressed: _deleteGrade),
        ],
      ),
      body: ListView.builder(
        itemCount: _grades.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              color: _selectedIndex == index ? const Color.fromARGB(255, 227, 185, 255) : null,
              child: ListTile(
                title: Text(_grades[index].sid),
                subtitle: Text(_grades[index].grade),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGrade,
        child: const Icon(Icons.add),
      ),
    );
  }
}