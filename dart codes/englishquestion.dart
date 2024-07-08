import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:try1/querypt.dart';

class EnglishQuestion extends StatefulWidget {
  final String userId;

  const EnglishQuestion({
    required this.userId,
    Key?key,

}): super(key: key);


  @override
  _EnglishQuestionState createState() => _EnglishQuestionState();
}

class _EnglishQuestionState extends State<EnglishQuestion> {
  int firstTimeScore = 0;
  int secondTimeScore = 0;



  String? _selectedOptionQuestion1;
  String? _selectedOptionQuestion2;
  String? _selectedOptionQuestion3;
  String? _selectedOptionQuestion4;
  String? _selectedOptionQuestion5;
  String? _selectedOptionQuestion6;
  String? _selectedOptionQuestion7;
  String? _selectedOptionQuestion8;
  String? _selectedOptionQuestion14;

  List<bool> checkBoxValues9 = [false, false, false, false, false];
  List<bool> checkBoxValues10 = [false, false, false, false, false];
  List<bool> checkBoxValues11 = [false, false, false, false, false,false,false];
  List<bool> checkBoxValues12 = [false, false, false, false, false,false,false,false];
  List<bool> checkBoxValues13 = [false, false, false, false,false];

  // Method to calculate the total score
  int _calculateTotalScore() {
    int totalScore = 0;

    // Add scores for each question based on selected options
    // Assigning arbitrary scores for demonstration
    if (_selectedOptionQuestion1 == 'Most days a week') totalScore += 1;
    else if (_selectedOptionQuestion1 == 'Several days a week') totalScore += 2;
    else if (_selectedOptionQuestion1 == 'Only with respiratory infection') totalScore += 3;
    else if (_selectedOptionQuestion1 == 'Not at all') totalScore += 4;

    if (_selectedOptionQuestion2 == 'Most days a week') totalScore += 1;
    else if (_selectedOptionQuestion2 == 'Several days a week') totalScore += 2;
    else if (_selectedOptionQuestion2 == 'Only with respiratory infection') totalScore += 3;
    else if (_selectedOptionQuestion2 == 'Not at all') totalScore += 4;

    if (_selectedOptionQuestion3 == 'Most days a week') totalScore += 1;
    else if (_selectedOptionQuestion3 == 'Several days a week') totalScore += 2;
    else if (_selectedOptionQuestion3 == 'Only with respiratory infection') totalScore += 3;
    else if (_selectedOptionQuestion3 == 'Not at all') totalScore += 4;

    if (_selectedOptionQuestion4 == 'Most days a week') totalScore += 1;
    else if (_selectedOptionQuestion4 == 'Several days a week') totalScore += 2;
    else if (_selectedOptionQuestion4 == 'Only with respiratory infection') totalScore += 3;
    else if (_selectedOptionQuestion4 == 'Not at all') totalScore += 4;

    if (_selectedOptionQuestion5 == '3 or more attacks') totalScore += 1;
    else if (_selectedOptionQuestion5 == '1 or 2 attacks') totalScore += 2;
    else if (_selectedOptionQuestion5 == 'Not at all') totalScore += 3;

    if (_selectedOptionQuestion6 == 'No good days') totalScore += 1;
    else if (_selectedOptionQuestion6 == 'A few good days') totalScore += 2;
    else if (_selectedOptionQuestion6 == 'Most days are good') totalScore += 3;
    else if (_selectedOptionQuestion6 == 'Every day is good') totalScore += 4;


    if (_selectedOptionQuestion7 == 'Yes') totalScore += 1;
    else if (_selectedOptionQuestion7 == 'No') totalScore += 2;

    if (_selectedOptionQuestion8 == 'Cause me a lot of problems or are the most important physical problems I have') totalScore += 1;
    else if (_selectedOptionQuestion8 == 'Cause me a few problems') totalScore += 2;
    else if (_selectedOptionQuestion8 == 'Cause no problems') totalScore += 3;

    if (_selectedOptionQuestion14 == 'They do not stop me from doing anything i would like to do') totalScore += 4;
    else if (_selectedOptionQuestion14 == 'They do not stop me from doing one or two things i would like to do') totalScore += 3;
    else if (_selectedOptionQuestion14 == 'They stop me from doing most of the things i would like to do') totalScore += 2;
    else if (_selectedOptionQuestion14 == 'They stop me from doing everything i would like to do') totalScore += 1;


    totalScore += checkBoxValues9.map((value) => value ? 1 : 2).reduce((a, b) => a + b);
    totalScore += checkBoxValues10.map((value) => value ? 1 : 2).reduce((a, b) => a + b);
    totalScore += checkBoxValues11.map((value) => value ? 1 : 2).reduce((a, b) => a + b);
    totalScore += checkBoxValues12.map((value) => value ? 1 : 2).reduce((a, b) => a + b);
    totalScore += checkBoxValues13.map((value) => value ? 1 : 2).reduce((a, b) => a + b);

    return totalScore;
  }

  // Method to display an alert dialog with the total score
  Future<void> _submitScore(String type) async {
    int totalScore = _calculateTotalScore();
    String url = 'http://192.168.148.130:80/test/english.php'; // Replace with your actual URL

    Map<String, dynamic> data = {
      "P_id": widget.userId,
      if (type == 'pre') "first_time_score": totalScore,
      if (type == 'post') "second_time_score": totalScore,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        String message = jsonResponse['message'];
        if (mounted) {
          _showTotalScoreAlert(totalScore, message);
          _navigateToGraphPage(totalScore);
        }
      } else {
        throw Exception('Failed to save data');
      }
    } catch (e) {
      if (mounted) {
        _showErrorAlert(e.toString());
      }
    }
  }

  void _navigateToGraphPage(int totalScore) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Query(userId: widget.userId, totalScore: totalScore),
      ),
          (Route<dynamic> route) => false, // Remove all previous routes
    );
  }



  void _showTotalScoreAlert(int totalScore, String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Total Score'),
            content: Text('Your total score is $totalScore\n$message'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _showErrorAlert(String error) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asthma Questionnaire'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "1) I cough",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile(
                  title: Text('Most days a week'),
                  value: 'Most days a week',
                  groupValue: _selectedOptionQuestion1,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion1 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Several days a week'),
                  value: 'Several days a week',
                  groupValue: _selectedOptionQuestion1,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion1 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Only with respiratory infection'),
                  value: 'Only with respiratory infection',
                  groupValue: _selectedOptionQuestion1,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion1 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Not at all'),
                  value: 'Not at all',
                  groupValue: _selectedOptionQuestion1,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion1 = value as String?;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              "2) I bring up phlegm",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile(
                  title: Text('Most days a week'),
                  value: 'Most days a week',
                  groupValue: _selectedOptionQuestion2,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion2 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Several days a week'),
                  value: 'Several days a week',
                  groupValue: _selectedOptionQuestion2,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion2 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Only with respiratory infection'),
                  value: 'Only with respiratory infection',
                  groupValue: _selectedOptionQuestion2,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion2 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Not at all'),
                  value: 'Not at all',
                  groupValue: _selectedOptionQuestion2,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion2 = value as String?;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              "3) I have shortness of breath",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile(
                  title: Text('Most days a week'),
                  value: 'Most days a week',
                  groupValue: _selectedOptionQuestion3,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion3 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Several days a week'),
                  value: 'Several days a week',
                  groupValue: _selectedOptionQuestion3,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion3 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Only with respiratory infection'),
                  value: 'Only with respiratory infection',
                  groupValue: _selectedOptionQuestion3,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion3 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Not at all'),
                  value: 'Not at all',
                  groupValue: _selectedOptionQuestion3,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion3 = value as String?;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              "4) I have attacks of wheezing",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile(
                  title: Text('Most days a week'),
                  value: 'Most days a week',
                  groupValue: _selectedOptionQuestion4,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion4 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Several days a week'),
                  value: 'Several days a week',
                  groupValue: _selectedOptionQuestion4,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion4 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Only with respiratory infection'),
                  value: 'Only with respiratory infection',
                  groupValue: _selectedOptionQuestion4,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion4 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Not at all'),
                  value: 'Not at all',
                  groupValue: _selectedOptionQuestion4,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion4 = value as String?;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              "5) How many attacks of chest trouble did you have during last year?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile(
                  title: Text('3 or more attacks'),
                  value: '3 or more attacks',
                  groupValue: _selectedOptionQuestion5,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion5 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('1 or 2 attacks'),
                  value: '1 or 2 attacks',
                  groupValue: _selectedOptionQuestion5,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion5 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Not at all'),
                  value: 'Not at all',
                  groupValue: _selectedOptionQuestion5,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion5 = value as String?;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              "6) How often do you have good days (few with respiratory problems)?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile(
                  title: Text('No good days'),
                  value: 'No good days',
                  groupValue: _selectedOptionQuestion6,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion6 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('A few good days'),
                  value: 'A few good days',
                  groupValue: _selectedOptionQuestion6,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion6 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Most days are good'),
                  value: 'Most days are good',
                  groupValue: _selectedOptionQuestion6,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion6 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Every day is good'),
                  value: 'Every day is good',
                  groupValue: _selectedOptionQuestion6,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion6 = value as String?;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              "7) If you have a wheeze, is it worse when you get up in the morning?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile(
                  title: Text('Yes'),
                  value: 'Yes',
                  groupValue: _selectedOptionQuestion7,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion7 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('No'),
                  value: 'No',
                  groupValue: _selectedOptionQuestion7,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion7 = value as String?;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              "8) How could you describe your respiratory problems?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile(
                  title: Text('Cause me a lot of problems or are the most important physical problems I have'),
                  value: 'Cause me a lot of problems or are the most important physical problems I have',
                  groupValue: _selectedOptionQuestion8,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion8 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Cause me a few problems'),
                  value: 'Cause me a few problems',
                  groupValue: _selectedOptionQuestion8,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion8 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Cause no problems'),
                  value: 'Cause no problems',
                  groupValue: _selectedOptionQuestion8,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion8 = value as String?;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              "9) Question about what activities usually make you feel breathless. For each statement, please tell me which applies to you these days.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                CheckboxListTile(
                  title: Text('a) Washing or\ndressing yourself'),
                  value: checkBoxValues9[0],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues9[0] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('b) Walking around\nthe house'),
                  value: checkBoxValues9[1],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues9[1] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('c)Walking outside\non the level\nground'),
                  value: checkBoxValues9[2],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues9[2] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('d) Walking up a     \nflight of\nstairs'),
                  value: checkBoxValues9[3],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues9[3] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('e) Walking up        \nhills  '),
                  value: checkBoxValues9[4],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues9[4] = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              "10) Some more questions about your cough and breathlessness. For each statement, please tell me which applies to you these days.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                CheckboxListTile(
                  title: Text('a) Coughing hurts'),
                  value: checkBoxValues10[0],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues10[0] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('b) Coughing           \nmakes me tired'),
                  value: checkBoxValues10[1],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues10[1] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Ac) I am short of     \nbreathe when\nI talk'),
                  value: checkBoxValues10[2],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues10[2] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('d) I am short of     \nbreathe when\nI bend over'),
                  value: checkBoxValues10[3],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues10[3] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('e) I get exhausted \neasily'),
                  value: checkBoxValues10[4],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues10[4] = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              "11) Questions about other effects that your chest trouble may have on you. For each statement, please tell me which applies you these days",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                CheckboxListTile(
                  title: Text('a) my cough or   \nbreathing is\nembarrasing in\npublic'),
                  value: checkBoxValues11[0],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues11[0] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('b) my respiratory\nproblems are a\nnuisance to my\nfamily,friends,\nor neighbors'),
                  value: checkBoxValues11[1],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues11[1] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('c) I get afraid or  \n panic when i \ncannot catch my\nbreathe'),
                  value: checkBoxValues11[2],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues11[2] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('d) I feel that i am\nnot in control of \nmy respiratory\nproblems'),
                  value: checkBoxValues11[3],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues11[3] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('e) I have become\nfrail or an invalid\nbecuase of my\n respiratory\n problems'),
                  value: checkBoxValues11[4],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues11[4] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('f) Exercise is not \nsafe for me'),
                  value: checkBoxValues11[5],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues11[5] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('g) Everything       \nseems too\nmuch of an\neffort'),
                  value: checkBoxValues11[6],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues11[6] = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              "12) These are questions about how your activities might be affected by your respiratory problems. For each statement, please tell me which applies toy you because of your breathing",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                CheckboxListTile(
                  title: Text('a)I take a long time\nto get washed\nor dressed'),
                  value: checkBoxValues12[0],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues12[0] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('b)I cannot take a    \nbath or shower\nor i take a long\ntime to do'),
                  value: checkBoxValues12[1],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues12[1] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('c)I walk slower\nthan other people,  \nor i stop to rest'),
                  value: checkBoxValues12[2],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues12[2] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('d)Jobs such as    \nhouse chores take \na long time,or\ni have to stop\nto rest'),
                  value: checkBoxValues12[3],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues12[3] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('e)If i walk up one   \nflight of stairs,I   \nhave to stop \nor slow down'),
                  value: checkBoxValues12[4],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues12[4] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('f)if i hurry or           \nwalk fast,i have\nto go slowly\nor stop'),
                  value: checkBoxValues12[5],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues12[5] = value!;
                    });
                  },
                ),

                CheckboxListTile(
                  title: Text('g)my breathing      \nmakes it difficult\nto do things such\nas walk up hills\n,carry things up\nstairs,do light\ngardening such\nas wedding,\ndance,bowl,\nor play golf'),
                  value: checkBoxValues12[6],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues12[6] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('h)my breathing      \nmakes it difficult\nto do things\nsuch as carry\nheavy load\ndig garden or\nshovel snow,jog\nor walk briskly\n,play tennis\nor swim'),
                  value: checkBoxValues12[7],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues12[7] = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              "13) We should like to know how your chest usually effects your daily life. For each statement please tell me which applies to you because of your breathing",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                CheckboxListTile(
                  title: Text('a)I cannot play      \nsports or do\nother physical\nactivities'),
                  value: checkBoxValues13[0],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues13[0] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('b)I cannot go out  \nfor entertainment\nor recreation'),
                  value: checkBoxValues13[1],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues13[1] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('c)i cannot go out  \nof the house to\ndo shopping'),
                  value: checkBoxValues13[2],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues13[2] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('d)i cannot do\nhousehold chores '),
                  value: checkBoxValues13[3],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues13[3] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('e)i cannot move    \nfar from my bed\nor chair'),
                  value: checkBoxValues13[4],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues13[4] = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              "14)how do your respiratory problems affects you?Please pick one response",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile(
                  title: Text('They do not stop me from doing anything i would like to do'),
                  value: 'They do not stop me from doing anything i would like to do',
                  groupValue: _selectedOptionQuestion14,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion14 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('They do not stop me from doing one or two things i would like to do'),
                  value: 'They do not stop me from doing one or two things i would like to do',
                  groupValue: _selectedOptionQuestion14,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion14 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('They stop me from doing most of the things i would like to do'),
                  value: 'They stop me from doing most of the things i would like to do',
                  groupValue: _selectedOptionQuestion14,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion14 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('They stop me from doing everything i would like to do'),
                  value: 'They stop me from doing everything i would like to do',
                  groupValue: _selectedOptionQuestion14,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion14 = value as String?;
                    });
                  },
                ),

              ],
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
                _submitScore('pre');
              },
              child: Text('Submit (Pre)'),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                _submitScore('post');
              },
              child: Text('Submit (Post)'),
            ),
          ],
        ),
      ),
    );
  }
}