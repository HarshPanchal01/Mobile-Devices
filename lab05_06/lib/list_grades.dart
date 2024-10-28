import 'package:flutter/material.dart';
import 'grade.dart';
import 'grades_model.dart';
import 'grade_form.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:permission_handler/permission_handler.dart';

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
  TextEditingController _searchController = TextEditingController();

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
      if (result == true) {
        _loadGrades();
      }
    });
  }

  // Deletes a grade from the list.
  void _deleteGrade(int index) async {
    if (_grades[index].id != null) {
      await _gradesModel.deleteGradeById(_grades[index].id!);
    }
    setState(() {
      _grades.removeAt(index);
    });
  }

  // Edits a grade in the list.
  void _editGrade(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => GradeForm(grade: _grades[index])),
    ).then((result) {
      if (result == true) {
        _loadGrades();
      }
    });
  }

  // Sorts the grades based on the selected criteria.
  void _sortGrades(String criteria) {
    setState(() {
      if (criteria == 'sid_asc') {
        _grades.sort((a, b) => a.sid.compareTo(b.sid));
      } else if (criteria == 'sid_desc') {
        _grades.sort((a, b) => b.sid.compareTo(a.sid));
      } else if (criteria == 'grade_asc') {
        _grades.sort((a, b) => a.grade.compareTo(b.grade));
      } else if (criteria == 'grade_desc') {
        _grades.sort((a, b) => b.grade.compareTo(a.grade));
      }
    });
  }

  // Shows a DataTable with a bar chart of the grade data.
  void _showDataTable() {
    Map<String, int> gradeFrequency = {};
    for (var grade in _grades) {
      gradeFrequency[grade.grade] = (gradeFrequency[grade.grade] ?? 0) + 1;
    }

    // Mapping grades to numeric values
    Map<String, int> gradeToNumeric = {
      'A+': 12,
      'A': 11,
      'A-': 10,
      'B+': 9,
      'B': 8,
      'B-': 7,
      'C+': 6,
      'C': 5,
      'C-': 4,
      'D+': 3,
      'D': 2,
      'D-': 1,
      'F': 0,
    };

    List<BarChartGroupData> barGroups = gradeFrequency.entries.map((entry) {
      return BarChartGroupData(
        x: gradeToNumeric[entry.key] ?? 0,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.blue,
          ),
        ],
      );
    }).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Grade Distribution'),
          content: Container(
            height: 400,
            width: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barGroups: barGroups,
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString());
                      },
                    ),
                    axisNameWidget: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text('Frequency'),
                    ),
                    axisNameSize: 30,
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 12:
                            return Text('A+');
                          case 11:
                            return Text('A');
                          case 10:
                            return Text('A-');
                          case 9:
                            return Text('B+');
                          case 8:
                            return Text('B');
                          case 7:
                            return Text('B-');
                          case 6:
                            return Text('C+');
                          case 5:
                            return Text('C');
                          case 4:
                            return Text('C-');
                          case 3:
                            return Text('D+');
                          case 2:
                            return Text('D');
                          case 1:
                            return Text('D-');
                          case 0:
                            return Text('F');
                          default:
                            return Text('');
                        }
                      },
                    ),
                    axisNameWidget: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text('Grades'),
                    ),
                    axisNameSize: 30,
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Imports grades from a CSV file.
  void _importCSV() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
      if (result != null) {
        File file = File(result.files.single.path!);
        final input = file.readAsBytesSync();
        final decoded = utf8.decode(input);
        final fields = CsvToListConverter().convert(decoded);

        // Skip the header row
        for (var i = 1; i < fields.length; i++) {
          var row = fields[i];
          if (row.length == 2) {
            String sid = row[0].toString();
            String grade = row[1].toString();
            Grade newGrade = Grade(sid: sid, grade: grade);
            await _gradesModel.insertGrade(newGrade);
          }
        }
        _loadGrades();
      }
    } catch (e) {
      print('Error importing CSV file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error importing CSV file: $e')),
      );
    }
  }

  // Exports grades to a CSV file.
  void _exportCSV() async {
    try {
      // Request storage permission first
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        // Also request manage external storage permission for Android 11+
        status = await Permission.manageExternalStorage.request();
      }

      if (status.isGranted) {
        List<List<dynamic>> rows = [];
        rows.add(["sid", "grade"]);
        for (var grade in _grades) {
          List<dynamic> row = [];
          row.add(grade.sid);
          row.add(grade.grade);
          rows.add(row);
        }
        String csv = const ListToCsvConverter().convert(rows);

        final file = File('/sdcard/Download/grades_export.csv');
        await file.writeAsString(csv);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Grades exported to Download folder')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Storage permission is required to export')),
        );
      }
    } catch (e) {
      print('Error exporting CSV file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting CSV file: $e')),
      );
    }
  }

  // Searches grades by student ID.
  void _searchGrades(String query) {
    if (query.isEmpty) {
      _loadGrades(); // Reload all grades if the search query is empty
    } else {
      final results = _grades.where((grade) => grade.sid.contains(query)).toList();
      setState(() {
        _grades = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Grades'),
        backgroundColor: const Color.fromARGB(255, 166, 216, 240),
        actions: [
          PopupMenuButton<String>(
            onSelected: _sortGrades,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(value: 'sid_asc', child: Text('Sort by SID Ascending')),
                PopupMenuItem(value: 'sid_desc', child: Text('Sort by SID Descending')),
                PopupMenuItem(value: 'grade_asc', child: Text('Sort by Grade Ascending')),
                PopupMenuItem(value: 'grade_desc', child: Text('Sort by Grade Descending')),
              ];
            },
          ),
          IconButton(
            icon: Icon(Icons.table_chart),
            onPressed: _showDataTable,
          ),
          IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: _importCSV,
          ),
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: _exportCSV,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Student ID',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchGrades(_searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _grades.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_grades[index].id.toString()),
                  onDismissed: (direction) {
                    _deleteGrade(index);
                  },
                  background: Container(color: Colors.red),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    onLongPress: () {
                      _editGrade(index);
                    },
                    child: Container(
                      color: _selectedIndex == index ? const Color.fromARGB(255, 227, 185, 255) : null,
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_grades[index].sid),
                            Text(_grades[index].grade),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGrade,
        child: const Icon(Icons.add),
      ),
    );
  }
}