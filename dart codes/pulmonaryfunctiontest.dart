import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:try1/formdoc.dart';
// import 'package:try1/prepulmonaryform.dart';
import 'package:try1/postpulmonaryform.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:try1/prepulmonaryfunction.dart';

class pulmonary extends StatefulWidget {
  final String id;

  const pulmonary({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  _pulmonaryState createState() => _pulmonaryState();
}

class _pulmonaryState extends State<pulmonary> {
  int firstTimeScore = 0;
  int secondTimeScore = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var url = Uri.parse('http://192.168.148.130:80/test/fetch_data6.php');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'P_id': widget.id}),
    );

    if (response.statusCode == 200) {
      try {
        var responseData = jsonDecode(response.body);

        if (responseData.containsKey('status') && responseData['status'] == 'success') {
          var scores = responseData['data'];
          setState(() {
            firstTimeScore = int.parse(scores['apr']);
            secondTimeScore = int.parse(scores['bpr']);
          });
        } else {
          print('Error: ${responseData['message']}');
        }
      } catch (e) {
        print('Error: ${e.toString()}');
      }
    } else {
      print('Error: HTTP ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Prepulmonaryform(id: widget.id)),
                    );
                    if (result == true) {
                      fetchData();
                    }
                  },
                  child: Text(
                    'PRE RECORD',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    minimumSize: Size(270, 50),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Postpulmonaryform(id: widget.id)),
                    );
                    if (result == true) {
                      fetchData();
                    }
                  },
                  child: Text(
                    'POST RECORD',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    minimumSize: Size(270, 50),
                  ),
                ),
              ),
            ),
            SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.only(right: 150.0),
              child: Text(
                'First Time Score: $firstTimeScore \nSecond Time Score: $secondTimeScore ',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 300,
              padding: EdgeInsets.all(16),
              child: VerticalBarChart([
                ChartData('Pre', firstTimeScore),
                ChartData('Post', secondTimeScore),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String category;
  final int value;

  ChartData(this.category, this.value);
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
        colorFn: (ChartData series, _) => charts.MaterialPalette.blue.shadeDefault,
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
