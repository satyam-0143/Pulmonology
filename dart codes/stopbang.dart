import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Graph1 extends StatefulWidget {
  final String id;


  const Graph1({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  _Graph1State createState() => _Graph1State();
}

class _Graph1State extends State<Graph1> {
  int firstTimeScore = 0;
  int secondTimeScore = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var url = Uri.parse('http://192.168.148.130:80/test/fetch_scores.php');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'P_id': widget.id}),
    );

    if (response.statusCode == 200) {
      try {
        var responseData = jsonDecode(response.body);

        if (responseData.containsKey('status') && responseData['status'] == 'success') {
          var scores = jsonDecode(responseData['scores']);
          setState(() {
            firstTimeScore = scores['first_time_score'];
            secondTimeScore = scores['second_time_score'];
          });
        } else {
          print('Error: ${responseData['message']}');
          print('Error: ${response.body}');
        }
      } catch (e) {
        print('Error: ${e.toString()}');
        print('Error: ${response.body}');
      }
    } else {
      print('Error: HTTP ${response.statusCode}');
      print('Error: ${response.body}');
    }
  }

  void updateScoreInDatabase(int score, {bool isFirstTime = true}) async {
    var url = Uri.parse('http://192.168.148.130:80/test/Qnr1.php');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'P_id': widget.id,
        if (isFirstTime) 'first_time_score': score,
        if (!isFirstTime) 'second_time_score': score,
      }),
    );

    if (response.statusCode == 200) {
      try {
        var responseData = jsonDecode(response.body);

        if (responseData.containsKey('status') && responseData['status'] == 'success') {
          print('Score updated in the database successfully.');
        } else {
          print('Error: ${responseData['message']}');
          print('Error: ${response.body}');
        }
      } catch (e) {
        print('Error: ${e.toString()}');
        print('Error: ${response.body}');
      }
    } else {
      print('Error: HTTP ${response.statusCode}');
      print('Error: ${response.body}');
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StopBang(
                          patientId: widget.id,
                          onSubmit: (score, isFirstTime) {
                            setState(() {
                              if (isFirstTime) {
                                firstTimeScore = score;
                              } else {
                                secondTimeScore = score;
                              }
                            });
                            updateScoreInDatabase(score, isFirstTime: isFirstTime);
                          },
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'FILL THE FORM',
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





class StopBang extends StatefulWidget {
  final String patientId;
  final Function(int, bool) onSubmit;

  const StopBang({
    required this.patientId,
    required this.onSubmit,
    Key? key,
  }) : super(key: key);

  @override
  _StopBangState createState() => _StopBangState();
}

class _StopBangState extends State<StopBang> {
  List<int> _selectedOptions = List.filled(8, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'STOP-BANG',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.black,
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
        ),
        body: SingleChildScrollView(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(height: 20),
    Padding(
    padding: EdgeInsets.only(left: 150.0),
    child: Text(
    'STOP',
    style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    ),
    ),
    ),
    SizedBox(height: 20),
    // Question 1
    buildQuestion(
    'Do you snore loudly?',
    0,
    ),
    SizedBox(height: 10),
    // Question 2
    buildQuestion(
    'Do you often feel TIRED,\nfatigue, or sleepy during\ndaytime?',
    1,
    ),
    SizedBox(height: 10),
    // Question 3
    buildQuestion(
    'Has anyone OBSERVED\nyou stop breathing during\nyour sleep?',
    2,
    ),
    SizedBox(height: 10),
    // Question 4
    buildQuestion(
    'Do you have or are you\nbeing treated for high blood\nPRESSURE?',
    3,
    ),
    SizedBox(height: 20),
    Padding(              padding: EdgeInsets.only(left: 150.0),
      child: Text(
        'BANG',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ),
          SizedBox(height: 20),
          // Question 5
          buildQuestion(
            'BMI more than 35kg/m2?',
            4,
          ),
          SizedBox(height: 20),
          // Question 6
          buildQuestion(
            'AGE over 50 years old?',
            5,
          ),
          SizedBox(height: 20),
          // Question 7
          buildQuestion(
            'NECK circumference>16\ninches?',
            6,
          ),
          SizedBox(height: 20),
          // Question 8
          buildQuestion(
            'GENDER: Male?',
            7,
          ),
        ],
        ),
        ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                int totalScore = _selectedOptions.reduce((sum, item) => sum + item);
                widget.onSubmit(totalScore, true); // Submitting first time score
                Navigator.pop(context); // Navigate back to previous page (Formdoc)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF66D0D0),
              ),
              child: Text(
                'SUBMIT (Pre)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                int totalScore = _selectedOptions.reduce((sum, item) => sum + item);
                widget.onSubmit(totalScore, false); // Submitting second time score
                Navigator.pop(context); // Navigate back to previous page (Formdoc)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF66D0D0),
              ),
              child: Text(
                'SUBMIT (Post)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuestion(String question, int index) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedOptions[index] = 1; // Yes
                  });
                },
                child: SquareRadio(
                  selected: _selectedOptions[index] == 1,
                  onTap: () {
                    setState(() {
                      _selectedOptions[index] = 1;
                    });
                  },
                ),
              ),
              SizedBox(width: 10),
              Text('Yes'),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedOptions[index] = 0; // No
                  });
                },
                child: SquareRadio(
                  selected: _selectedOptions[index] == 0,
                  onTap: () {
                    setState(() {
                      _selectedOptions[index] = 0;
                    });
                  },
                ),
              ),
              SizedBox(width: 10),
              Text('No'),
            ],
          ),
        ],
      ),
    );
  }
}

class SquareRadio extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  SquareRadio({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? Colors.blue : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: selected
            ? Icon(
          Icons.check,
          size: 16,
          color: Colors.blue,
        )
            : null,
      ),
    );
  }
}


