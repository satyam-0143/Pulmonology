import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: Graph2(id: ''),
  ));
}

class Graph2 extends StatefulWidget {
  final String id;

  const Graph2({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  _Graph2State createState() => _Graph2State();
}

class _Graph2State extends State<Graph2> {
  // Initialize scores as nullable list
  List<int>? scores;

  @override
  void initState() {
    super.initState();
    fetchScores();
  }

  Future<void> fetchScores() async {
    try {
      var url = Uri.parse('http://192.168.148.130:80/test/fetch_data2.php');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': widget.id}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Response Data: $responseData'); // Print response data for debugging

        if (responseData['status'] == 'success') {
          // Check if 'data' is not null
          if (responseData['data'] != null) {
            // Parse ess1 and ess2, assign 0 if empty
            final ess1 = responseData['data']['ess1'].isEmpty ? 0 : int.parse(responseData['data']['ess1']);
            final ess2 = responseData['data']['ess2'].isEmpty ? 0 : int.parse(responseData['data']['ess2']);

            setState(() {
              // Update scores only after fetching data
              scores = [ess1, ess2];
            });
          } else {
            // No valid data available, scores should remain null
            setState(() {
              scores = null;
            });
          }
        } else {
          // Handle failure case
          print('Failed to fetch scores: ${responseData['message']}');
        }
      } else {
        // Handle HTTP request failure
        print('Failed to fetch scores: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching scores: $error');
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Graph2',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: scores == null
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Your UI widgets that depend on the scores data
          Padding(
            padding: EdgeInsets.only(left: 25.0, top: 70),
            // child: ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => Epsworth(id: widget.id)),
            //     );
            //   },

            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Epsworth(id: widget.id)),
                );

                if (result == true) {
                  // Refetch scores after returning from the form
                  fetchScores();
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
              'First Time Score: ${scores![0]}\nSecond Time Score: ${scores![1]}',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 80),
          Container(
            height: 300,
            padding: EdgeInsets.all(16),
            child: VerticalBarChart([
              ChartData('Pre', scores![0]),
              ChartData('Post', scores![1]),
            ]),
          ),
        ],
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
        colorFn: (ChartData series, _) => charts.ColorUtil.fromDartColor(Colors.blue),
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

class Epsworth extends StatefulWidget {
  final String id;

  const Epsworth({required this.id, Key? key}) : super(key: key);

  @override
  State<Epsworth> createState() => _EpsworthState();
}

class _EpsworthState extends State<Epsworth> {
  // Declare a list of values to hold the selected option for each question
  List<int?> selectedOptions = List.filled(8, null);

  // MCQ Questions with marks for each option
  List<MCQQuestion> mcqQuestions = [
    MCQQuestion(
      questionText: "Sitting inactive in a public place",
      options: ["0", "1", "2", "3"],
      correctAnswerIndex: 0,
      marks: [1, 2, 3, 4],
    ),
    MCQQuestion(
      questionText: "Sitting quietly after lunch without alcohol",
      options: ["0", "1", "2", "3"],
      correctAnswerIndex: 0,
      marks: [1, 2, 3, 4],
    ),
    MCQQuestion(
      questionText: "Sitting and reading",
      options: ["0", "1", "2", "3"],
      correctAnswerIndex: 0,
      marks: [1, 2, 3, 4],
    ),
    MCQQuestion(
      questionText: "Watching TV",
      options: ["0", "1", "2", "3"],
      correctAnswerIndex: 0,
      marks: [1, 2, 3, 4],
    ),
    MCQQuestion(
      questionText: "Sitting and talking to someone",
      options: ["0", "1", "2", "3"],
      correctAnswerIndex: 0,
      marks: [1, 2, 3, 4],
    ),
    MCQQuestion(
      questionText: "Lying down to rest during the day when circumstances permit",
      options: ["0", "1", "2", "3"],
      correctAnswerIndex: 0,
      marks: [1, 2, 3, 4],
    ),
    MCQQuestion(
      questionText: "As a passenger in a car without a break",
      options: ["0", "1", "2", "3"],
      correctAnswerIndex: 0,
      marks: [1, 2, 3, 4],
    ),
    MCQQuestion(
      questionText: "In a car, while stopped for few minutes in traffic",
      options: ["0", "1", "2", "3"],
      correctAnswerIndex: 0,
      marks: [1, 2, 3, 4],
    ),
  ];

  // Flag to check if the submit button should be enabled
  bool isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Epsworth Sleepiness Score',
          style: TextStyle(
            fontSize: 20,
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
      body: Column(
        children: [
          // Top container with a Row to divide it into two halves
          Container(
            width: double.infinity, // Stretch the container to fill the screen width
            color: Colors.blue[100], // Container background color
            child: Row(
              children: [
                // First half of the container
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      '*How likely are you to doze or fall asleep in the following situations in contrast to just feeling tired?\n'
                          '*This refers to your usual way in recent times.\n'
                          '*Even if you have not done some of these things recently, try to work out how they would have been.',
                      style: TextStyle(color: Colors.black, fontSize: 12.5),
                    ),
                  ),
                ),
                // Second half of the container
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Right Text:\n'
                          '0 = Would never doze\n'
                          '1 = Slight chance of dozing\n'
                          '2 = Moderate chance of dozing\n'
                          '3 = High chance of dozing',
                      style: TextStyle(color: Colors.black, fontSize: 12.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Expanded to handle remaining content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: List.generate(mcqQuestions.length, (index) {
                  return buildQuestion(mcqQuestions[index], index);
                }),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed:  isButtonEnabled
                ? () {
              // Calculate total marks
              int totalMarks = calculateTotalMarks();

              // Update server with score
              updateServerWithScore(totalMarks);
            }
            :null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF66D0D0), // Button background color
            ),
            child: Text(
              'SUBMIT',
              style: TextStyle(color: Colors.white, fontSize: 17), // Button text color and size
            ),
          ),
        ),
      ),
    );
  }

  // Function to build a question with options 0 to 3
  Widget buildQuestion(MCQQuestion question, int questionIndex) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        children: [
          // Flexible widget for the question text
          Flexible(
            flex: 3, // Controls the space for question text
            child: Text(
              question.questionText,
              style: TextStyle(fontSize: 13, color: Colors.black),
              maxLines: 5, // Allow the question to wrap to three lines if necessary
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Row for options 0 to 3
          Row(
            children: List.generate(4, (index) {
              return Row(
                children: [
                  Radio<int>(
                    value: index,
                    groupValue: selectedOptions[questionIndex],
                    onChanged: (int? value) {
                      setState(() {
                        selectedOptions[questionIndex] = value;
                        isButtonEnabled = selectedOptions.every((option) => option != null);
                      });
                    },
                  ),
                  Text(
                    '${question.options[index]}',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  // Add spacing between radio options
                  if (index != 3) SizedBox(width: 10),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // Function to calculate total marks based on selected options
  int calculateTotalMarks() {
    int totalMarks = 0;
    for (int i = 0; i < mcqQuestions.length; i++) {
      int selectedOptionIndex = selectedOptions[i] ?? 0;
      totalMarks += mcqQuestions[i].marks[selectedOptionIndex];
    }
    return totalMarks;
  }

  // Function to update server with the score
  Future<void> updateServerWithScore(int score) async {
    var url = Uri.parse('http://192.168.148.130:80/test/ESS.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'score': score.toString(),
        'P_id': widget.id,
      }),
    );

    if (response.statusCode == 200) {
      // Handle the response from the server
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => Graph2(id: widget.id)),
        // );
        // Pop the current page from the navigation stack
        Navigator.pop(context,true);
      } else {
        // Handle failure case
        print('Failed to update score: ${responseData['message']}');
        print('Error: ${response.body}');
      }
    } else {
      // Handle HTTP request failure
      print('Failed to update score: ${response.statusCode}');
    }
  }
}

class MCQQuestion {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final List<int> marks; // Marks for each option

  MCQQuestion({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.marks,
  });
}
