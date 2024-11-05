import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'grade.dart';
import 'grades_model.dart';
import 'grade_form.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class ListGrades extends StatefulWidget {
  const ListGrades({Key? key}) : super(key: key);

  @override
  _ListGradesState createState() => _ListGradesState();
}

class _ListGradesState extends State<ListGrades> {
  final GradesModel _gradesModel = GradesModel();
  TextEditingController _searchController = TextEditingController();
  int? _selectedIndex;

  // Master list containing all grades from Firestore
  List<Grade> _allGrades = [];

  // Filtered list based on search and sort criteria
  List<Grade> _filteredGrades = [];

  // Current sort criteria
  String _currentSortCriteria = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Listener for search input changes
  void _onSearchChanged() {
    _applyFilters();
  }

  // Loads grades from the GradesModel.
  void _loadGrades() async {
    // Fetch grades using Stream (real-time updates)
    _gradesModel.getStream().listen((snapshot) {
      List<Grade> gradesList = snapshot.docs.map((doc) => Grade.fromSnapshot(doc)).toList();
      setState(() {
        _allGrades = gradesList;
        _applyFilters(); // Apply current search and sort
      });
    });
  }

  // Navigates to the GradeForm to add a new grade.
  void _addGrade() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => GradeForm()),
    ).then((_) {
      // After adding, Firestore stream updates _allGrades automatically
    });
  }

  // Deletes a grade from the list.
  void _deleteGrade(Grade grade) async {
    _gradesModel.deleteGrade(grade);
    // Firestore stream updates _allGrades automatically
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Grade for SID ${grade.sid} deleted')),
    );
  }

  // Edits a grade in the list.
  void _editGrade(Grade grade) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => GradeForm(grade: grade)),
    ).then((_) {
      // After editing, Firestore stream updates _allGrades automatically
    });
  }

  // Converts grade letters to numeric values for accurate sorting
  int _gradeToNumeric(String grade) {
    Map<String, int> gradeMap = {
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
    return gradeMap[grade.toUpperCase()] ?? 0;
  }

  // Sorts the grades based on the selected criteria.
  void _sortGrades(String criteria) {
    setState(() {
      _currentSortCriteria = criteria;
      _applyFilters();
    });
  }

  // Applies search and sort filters to the grades
  void _applyFilters() {
    List<Grade> tempGrades = List.from(_allGrades);

    // Apply search filter
    String query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      tempGrades = tempGrades.where((grade) {
        return grade.sid.toLowerCase().contains(query) ||
               grade.grade.toLowerCase().contains(query);
      }).toList();
    }

    // Apply sorting
    if (_currentSortCriteria.isNotEmpty) {
      switch (_currentSortCriteria) {
        case 'sid_asc':
          tempGrades.sort((a, b) => a.sid.compareTo(b.sid));
          break;
        case 'sid_desc':
          tempGrades.sort((a, b) => b.sid.compareTo(a.sid));
          break;
        case 'grade_asc':
          tempGrades.sort((a, b) => _gradeToNumeric(a.grade).compareTo(_gradeToNumeric(b.grade)));
          break;
        case 'grade_desc':
          tempGrades.sort((a, b) => _gradeToNumeric(b.grade).compareTo(_gradeToNumeric(a.grade)));
          break;
        default:
          break;
      }
    }

    setState(() {
      _filteredGrades = tempGrades;
    });
  }

  // Shows a DataTable with a bar chart of the grade data.
  void _showDataTable() {
    Map<String, int> gradeFrequency = {};
    for (var grade in _allGrades) {
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

    barGroups.sort((a, b) => a.x.compareTo(b.x)); // Ensure bars are in order

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
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        final input = file.readAsBytesSync();
        final decoded = utf8.decode(input);
        final fields = CsvToListConverter().convert(decoded);

        // Skip the header row
        for (var i = 1; i < fields.length; i++) {
          var row = fields[i];
          if (row.length >= 2) {
            String sid = row[0].toString();
            String grade = row[1].toString();
            Grade newGrade = Grade(sid: sid, grade: grade);
            await _gradesModel.addGrade(newGrade);
          }
        }
        // Firestore stream updates _allGrades automatically
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
      List<List<dynamic>> rows = [];
      rows.add(["sid", "grade"]);
      for (var grade in _allGrades) {
        List<dynamic> row = [];
        row.add(grade.sid);
        row.add(grade.grade);
        rows.add(row);
      }

      String csv = const ListToCsvConverter().convert(rows);
      final directory = await getApplicationDocumentsDirectory();
      final path = "${directory.path}/grades_export.csv";
      final file = File(path);
      await file.writeAsString(csv);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Grades exported to $path')),
      );
    } catch (e) {
      print('Error exporting CSV file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting CSV file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize loading grades if not already done
    if (_allGrades.isEmpty) {
      _loadGrades();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Grades'),
        backgroundColor: const Color.fromARGB(255, 166, 216, 240),
        actions: [
          PopupMenuButton<String>(
            onSelected: _sortGrades,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                    value: 'sid_asc', child: Text('Sort by SID Ascending')),
                PopupMenuItem(
                    value: 'sid_desc', child: Text('Sort by SID Descending')),
                PopupMenuItem(
                    value: 'grade_asc', child: Text('Sort by Grade Ascending')),
                PopupMenuItem(
                    value: 'grade_desc', child: Text('Sort by Grade Descending')),
              ];
            },
          ),
          IconButton(
            icon: Icon(Icons.table_chart),
            onPressed: _showDataTable,
            tooltip: 'Show Grade Distribution',
          ),
          IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: _importCSV,
            tooltip: 'Import CSV',
          ),
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: _exportCSV,
            tooltip: 'Export CSV',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Student ID or Grade',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _applyFilters();
                  },
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Grades List
          Expanded(
            child: _filteredGrades.isEmpty
                ? Center(child: Text('No grades found.'))
                : ListView.builder(
                    itemCount: _filteredGrades.length,
                    itemBuilder: (context, index) {
                      final grade = _filteredGrades[index];
                      return Dismissible(
                        key: Key(grade.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _deleteGrade(grade);
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          onLongPress: () {
                            _editGrade(grade);
                          },
                          child: Container(
                            color: _selectedIndex == index
                                ? const Color.fromARGB(255, 227, 185, 255)
                                : null,
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${grade.sid}'),
                                  Text('${grade.grade}'),
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
        tooltip: 'Add Grade',
      ),
    );
  }
}