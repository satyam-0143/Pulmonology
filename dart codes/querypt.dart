import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'package:try1/patientlogin.dart';
import 'dart:convert';

import 'package:try1/response.dart';

import 'navbarpatient.dart';

class Query extends StatefulWidget {
  final String userId;
  final int totalScore;

  const Query({Key? key, required this.userId, required this.totalScore}) : super(key: key);

  @override
  _QueryState createState() => _QueryState();
}

class _QueryState extends State<Query> {
  int firstTimeScore = 0;
  int secondTimeScore = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchScores();
  }

  Future<void> fetchScores() async {
    final response = await http.post(
      Uri.parse('http://192.168.148.130:80/test/fetch_data_stques.php'), // Replace with your actual URL
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'P_id': widget.userId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          firstTimeScore = data['data']['Stques1'] as int; // Ensure parsing as int
          secondTimeScore = data['data']['Stques2'] as int; // Ensure parsing as int
          isLoading = false;
        });
      } else {
        // Handle failure
        setState(() {
          isLoading = false;
        });
      }
    } else {
      // Handle server error
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToAnotherPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Language(userId: widget.userId, totalScore: widget.totalScore)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Patient2(userId: widget.userId)),
        );
        return false;
      },
      child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Form',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyan.shade300, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.5, 1.0],
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25.0, top: 70),
              child: ElevatedButton(
                onPressed: navigateToAnotherPage,
                child: Text(
                  'FILL THE FORM/படிவத்தை நிரப்புக',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                ),
              ),
            ),
            SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.only(right: 150.0),
              child: Text(
                'First Time Score: $firstTimeScore\nSecond Time Score: $secondTimeScore',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 80),
            Container(
              height: 300,
              padding: EdgeInsets.all(16),
              child: VerticalBarChart([
                ChartData('Pre', firstTimeScore, charts.ColorUtil.fromDartColor(Colors.green)),
                ChartData('Post', secondTimeScore, charts.ColorUtil.fromDartColor(Colors.yellow)),
              ]),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class ChartData {
  final String category;
  final int value;
  final charts.Color color;

  ChartData(this.category, this.value, this.color);
}

class VerticalBarChart extends StatelessWidget {
  final List<ChartData> data;

  VerticalBarChart(this.data);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ChartData, String>> series = [
      charts.Series(
        id: 'ChartData',
        data: data,
        domainFn: (ChartData series, _) => series.category,
        measureFn: (ChartData series, _) => series.value,
        colorFn: (ChartData series, _) => series.color,
      )
    ];

    return charts.BarChart(
      series,
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
      vertical: true,
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredTickCount: 7,
        ),
      ),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelRotation: 45,
        ),
      ),
    );
  }
}
