import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'post.dart';
import 'chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'lab08/09',
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: const MyHomePage(title: 'DataTable and Charts'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Post> _posts;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _posts = Post.generateData();
  }

  void _sort<T>(
    Comparable<T> Function(Post post) getField,
    int columnIndex,
    bool ascending,
  ) {
    _posts.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex; // Always update sort column index
      _sortAscending = ascending;     // Always update sort ascending
    });
  }

  void _incrementUpVotes(Post post) {
    setState(() {
      post.numUpVotes++;
    });
  }

  void _incrementDownVotes(Post post) {
    setState(() {
      post.numDownVotes++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChartPage(posts: _posts),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20,
          headingRowHeight: 56,
          dataRowHeight: 70,
          sortAscending: _sortAscending,
          sortColumnIndex: _sortColumnIndex,
          columns: [
            DataColumn(
              label: Text('Title'), // Removed the Container with fixed width
              onSort: (index, ascending) =>
                  _sort((post) => post.title, index, ascending),
            ),
            DataColumn(
              label: Icon(Icons.arrow_drop_up),
              numeric: true,
              onSort: (index, ascending) =>
                  _sort((post) => post.numUpVotes, index, ascending),
            ),
            DataColumn(
              label: Icon(Icons.arrow_drop_down), 
              numeric: true,
              onSort: (index, ascending) =>
                  _sort((post) => post.numDownVotes, index, ascending),
            ),
          ],
          rows: _posts.map((post) {
            return DataRow(
              cells: [
                DataCell(
                  Container(
                    width: 200,
                    child: Text(
                      post.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      Text('${post.numUpVotes}'),
                      IconButton(
                        icon: Icon(Icons.arrow_upward),
                        onPressed: () => _incrementUpVotes(post),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      Text('${post.numDownVotes}'),
                      IconButton(
                        icon: Icon(Icons.arrow_downward),
                        onPressed: () => _incrementDownVotes(post),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ChartPage extends StatelessWidget {
  final List<Post> posts;

  const ChartPage({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    // Prepare the data for the chart
    List<ChartData> chartData = posts.map((post) {
      return ChartData(
        post.title,
        post.numUpVotes,
        post.numDownVotes,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Stats'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
            title: AxisTitle(text: 'Posts'),
            labelPlacement: LabelPlacement.onTicks,
            maximumLabelWidth: 150,
            labelAlignment: LabelAlignment.start,
            interval: 1,
            // Added padding
            plotOffset: 20,
            // Optional: Rotate labels if needed
            // labelRotation: 45,
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Number of Votes'),
            interval: 2,
            majorGridLines: MajorGridLines(width: 1),
            majorTickLines: MajorTickLines(size: 6),
          ),
          series: <CartesianSeries<dynamic, dynamic>>[
            BarSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.postTitle.length > 20
                  ? '${data.postTitle.substring(0, 20)}...'
                  : data.postTitle,
              yValueMapper: (ChartData data, _) => data.upVotes,
              name: 'Up Votes',
              color: Colors.blue,
              width: 0.3,
            ),
            BarSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.postTitle.length > 20
                  ? '${data.postTitle.substring(0, 20)}...'
                  : data.postTitle,
              yValueMapper: (ChartData data, _) => data.downVotes,
              name: 'Down Votes',
              color: Colors.red,
              width: 0.3,
            ),
          ],
        ),
      ),
    );
  }
}
