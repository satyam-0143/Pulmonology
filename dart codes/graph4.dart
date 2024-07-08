import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:try1/Modifiedbrogques.dart';
import 'package:try1/formdoc.dart';

class Graph4 extends StatefulWidget {
  final String id;

  const Graph4({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  _Graph4State createState() => _Graph4State();
}

class _Graph4State extends State<Graph4> {
  int firstTimeScore = 0;
  int secondTimeScore = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var url = Uri.parse('http://192.168.148.130:80/test/fetch_data4.php');
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
            firstTimeScore = scores.containsKey('mbds1') ? int.tryParse(scores['mbds1']) ?? 0 : 0;
            secondTimeScore = scores.containsKey('mbds2') ? int.tryParse(scores['mbds2']) ?? 0 : 0;
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25.0, top: 70),
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Modifiedbrog(id: widget.id)),
                    );
                    if (result == true) {
                      fetchData();
                    }
                  },
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
                  ChartData('Pre', firstTimeScore),
                  ChartData('Post', secondTimeScore),
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
