import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:try1/querypt.dart';

class TamilQuestion extends StatefulWidget {
  final String userId;

  const TamilQuestion({
    required this.userId,
    Key?key,

  }): super(key: key);


  @override
  _TamilQuestionState createState() => _TamilQuestionState();
}

class _TamilQuestionState extends State<TamilQuestion> {

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
    if (_selectedOptionQuestion1 == 'வாரத்தில் பெரும்பாலான நாட்கள்') totalScore += 1;
    else if (_selectedOptionQuestion1 == 'வாரத்தில் பல நாட்கள்') totalScore += 2;
    else if (_selectedOptionQuestion1 == 'சுவாச நோய்த்தொற்றுடன் மட்டுமே') totalScore += 3;
    else if (_selectedOptionQuestion1 == 'எப்போதும் இல்லை') totalScore += 4;

    if (_selectedOptionQuestion2 == 'வாரத்தில் பெரும்பாலான நாட்கள்') totalScore += 1;
    else if (_selectedOptionQuestion2 == 'வாரத்தில் பல நாட்கள்') totalScore += 2;
    else if (_selectedOptionQuestion2 == 'சுவாச நோய்த்தொற்றுடன் மட்டுமே') totalScore += 3;
    else if (_selectedOptionQuestion2 == 'எப்போதும் இல்லை') totalScore += 4;

    if (_selectedOptionQuestion3 == 'வாரத்தில் பெரும்பாலான நாட்கள்') totalScore += 1;
    else if (_selectedOptionQuestion3 == 'வாரத்தில் பல நாட்கள்') totalScore += 2;
    else if (_selectedOptionQuestion3 == 'சுவாச நோய்த்தொற்றுடன் மட்டுமே') totalScore += 3;
    else if (_selectedOptionQuestion3 == 'எப்போதும் இல்லை') totalScore += 4;

    if (_selectedOptionQuestion4 == 'வாரத்தில் பெரும்பாலான நாட்கள்') totalScore += 1;
    else if (_selectedOptionQuestion4 == 'வாரத்தில் பல நாட்கள்') totalScore += 2;
    else if (_selectedOptionQuestion4 == 'சுவாச நோய்த்தொற்றுடன் மட்டுமே') totalScore += 3;
    else if (_selectedOptionQuestion4 == 'எப்போதும் இல்லை') totalScore += 4;

    if (_selectedOptionQuestion5 == '3 அல்லது அதற்கு மேற்பட்ட தாக்குதல்கள்') totalScore += 1;
    else if (_selectedOptionQuestion5 == '1 அல்லது 2 தாக்குதல்கள்') totalScore += 2;
    else if (_selectedOptionQuestion5 == 'எப்போதும் இல்லை') totalScore += 3;

    if (_selectedOptionQuestion6 == 'நல்ல நாட்கள் இல்லை') totalScore += 1;
    else if (_selectedOptionQuestion6 == 'சில நல்ல நாட்கள்') totalScore += 2;
    else if (_selectedOptionQuestion6 == 'பெரும்பாலான நாட்கள் நன்றாக இருக்கும்') totalScore += 3;
    else if (_selectedOptionQuestion6 == 'ஒவ்வொரு நாளும் நல்ல நாளே') totalScore += 4;


    if (_selectedOptionQuestion7 == 'ஆம்') totalScore += 1;
    else if (_selectedOptionQuestion7 == 'இல்லை') totalScore += 2;

    if (_selectedOptionQuestion8 == 'எனக்கு நிறைய பிரச்சினைகளை ஏற்படுத்துகின்றன அல்லது எனக்கு இருக்கும் மிக முக்கியமான உடல் பிரச்சினைகள்') totalScore += 1;
    else if (_selectedOptionQuestion8 == 'எனக்கு சில பிரச்சனைகளை ஏற்படுத்தும்') totalScore += 2;
    else if (_selectedOptionQuestion8 == 'எந்த பிரச்சனையும் இல்லை') totalScore += 3;

    if (_selectedOptionQuestion14 == 'நான் செய்ய விரும்பும் எதையும் செய்வதிலிருந்து அவை என்னைத் தடுப்பதில்லை') totalScore += 4;
    else if (_selectedOptionQuestion14 == 'நான் செய்ய விரும்பும் ஒன்று அல்லது இரண்டு விஷயங்களைச் செய்வதிலிருந்து அவை என்னைத் தடுக்காது') totalScore += 3;
    else if (_selectedOptionQuestion14 == 'நான் செய்ய விரும்பும் பெரும்பாலான விஷயங்களைச் செய்வதிலிருந்து அவை என்னைத் தடுக்கின்றன') totalScore += 2;
    else if (_selectedOptionQuestion14 == 'நான் செய்ய விரும்பும் அனைத்தையும் செய்ய அவர்கள் என்னைத் தடுக்கிறார்கள்') totalScore += 1;


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
    String url = 'http://192.168.148.130:80/test/english.php'; // Replace with your actual

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
        _showTotalScoreAlert(totalScore, message);
        _navigateToGraphPage(totalScore);
      } else {
        throw Exception('Failed to save data');
      }
    } catch (e) {
      _showErrorAlert(e.toString());
    }
  }

  void _navigateToGraphPage(int totalScore) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Query(userId: widget.userId, totalScore: totalScore),
      ),
    );
  }

  void _showTotalScoreAlert(int totalScore, String message) {
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

  void _showErrorAlert(String error) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          "St George's respiratory Questions",
          style: TextStyle(fontSize: 17),
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "1) எனக்கு இருமல்",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile(
                  title: Text('வாரத்தில் பெரும்பாலான நாட்கள்'),
                  value: 'வாரத்தில் பெரும்பாலான நாட்கள்',
                  groupValue: _selectedOptionQuestion1,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion1 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('வாரத்தில் பல நாட்கள்'),
                  value: 'வாரத்தில் பல நாட்கள்',
                  groupValue: _selectedOptionQuestion1,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion1 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('சுவாச நோய்த்தொற்றுடன் மட்டுமே'),
                  value: 'சுவாச நோய்த்தொற்றுடன் மட்டுமே',
                  groupValue: _selectedOptionQuestion1,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion1 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('எப்போதும் இல்லை'),
                  value: 'எப்போதும் இல்லை',
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
              "2) நான் கபத்தை வளர்க்கிறேன்",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile(
                  title: Text('வாரத்தில் பெரும்பாலான நாட்கள்'),
                  value: 'வாரத்தில் பெரும்பாலான நாட்கள்',
                  groupValue: _selectedOptionQuestion2,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion2 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('வாரத்தில் பல நாட்கள்'),
                  value: 'வாரத்தில் பல நாட்கள்',
                  groupValue: _selectedOptionQuestion2,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion2 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('சுவாச நோய்த்தொற்றுடன் மட்டுமே'),
                  value: 'சுவாச நோய்த்தொற்றுடன் மட்டுமே',
                  groupValue: _selectedOptionQuestion2,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion2 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('எப்போதும் இல்லை'),
                  value: 'எப்போதும் இல்லை',
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
              "3) எனக்கு மூச்சுத் திணறல் உள்ளது",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile(
                  title: Text('வாரத்தில் பெரும்பாலான நாட்கள்'),
                  value: 'வாரத்தில் பெரும்பாலான நாட்கள்',
                  groupValue: _selectedOptionQuestion3,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion3 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('வாரத்தில் பல நாட்கள்'),
                  value: 'வாரத்தில் பல நாட்கள்',
                  groupValue: _selectedOptionQuestion3,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion3 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('சுவாச நோய்த்தொற்றுடன் மட்டுமே'),
                  value: 'சுவாச நோய்த்தொற்றுடன் மட்டுமே',
                  groupValue: _selectedOptionQuestion3,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion3 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('எப்போதும் இல்லை'),
                  value: 'எப்போதும் இல்லை',
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
              "4) எனக்கு மூச்சுத்திணறல் தாக்குதல்கள் உள்ளன",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile(
                  title: Text('வாரத்தில் பெரும்பாலான நாட்கள்'),
                  value: 'வாரத்தில் பெரும்பாலான நாட்கள்',
                  groupValue: _selectedOptionQuestion4,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion4 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('வாரத்தில் பல நாட்கள்'),
                  value: 'வாரத்தில் பல நாட்கள்',
                  groupValue: _selectedOptionQuestion4,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion4 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('சுவாச நோய்த்தொற்றுடன் மட்டுமே'),
                  value: 'சுவாச நோய்த்தொற்றுடன் மட்டுமே',
                  groupValue: _selectedOptionQuestion4,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion4 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('எப்போதும் இல்லை'),
                  value: 'எப்போதும் இல்லை',
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
              "5) கடந்த ஆண்டில் உங்களுக்கு எத்தனை நெஞ்சு வலி ஏற்பட்டது?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile(
                  title: Text('3 அல்லது அதற்கு மேற்பட்ட தாக்குதல்கள்'),
                  value: '3 அல்லது அதற்கு மேற்பட்ட தாக்குதல்கள்',
                  groupValue: _selectedOptionQuestion5,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion5 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('1 அல்லது 2 தாக்குதல்கள்'),
                  value: '1 அல்லது 2 தாக்குதல்கள்',
                  groupValue: _selectedOptionQuestion5,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion5 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('எப்போதும் இல்லை'),
                  value: 'எப்போதும் இல்லை',
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
              "6) உங்களுக்கு எவ்வளவு அடிக்கடி நல்ல நாட்கள் உள்ளன (சில சுவாச பிரச்சினைகள் உள்ளன)?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile(
                  title: Text('நல்ல நாட்கள் இல்லை'),
                  value: 'நல்ல நாட்கள் இல்லை',
                  groupValue: _selectedOptionQuestion6,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion6 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('சில நல்ல நாட்கள்'),
                  value: 'சில நல்ல நாட்கள்',
                  groupValue: _selectedOptionQuestion6,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion6 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('பெரும்பாலான நாட்கள் நன்றாக இருக்கும்'),
                  value: 'பெரும்பாலான நாட்கள் நன்றாக இருக்கும்',
                  groupValue: _selectedOptionQuestion6,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion6 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('ஒவ்வொரு நாளும் நல்ல நாளே'),
                  value: 'ஒவ்வொரு நாளும் நல்ல நாளே',
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
              "7) உங்களுக்கு மூச்சுத்திணறல் இருந்தால், நீங்கள் காலையில் எழுந்தவுடன் மோசமாக இருக்கிறதா?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile(
                  title: Text('ஆம்'),
                  value: 'ஆம்',
                  groupValue: _selectedOptionQuestion7,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion7 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('இல்லை'),
                  value: 'இல்லை',
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
              "8) உங்கள் சுவாசப் பிரச்சினைகளை எவ்வாறு விவரிக்க முடியும்?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile(
                  title: Text('எனக்கு நிறைய பிரச்சினைகளை ஏற்படுத்துகின்றன அல்லது எனக்கு இருக்கும் மிக முக்கியமான உடல் பிரச்சினைகள்'),
                  value: 'எனக்கு நிறைய பிரச்சினைகளை ஏற்படுத்துகின்றன அல்லது எனக்கு இருக்கும் மிக முக்கியமான உடல் பிரச்சினைகள்',
                  groupValue: _selectedOptionQuestion8,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion8 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('எனக்கு சில பிரச்சனைகளை ஏற்படுத்தும்'),
                  value: 'Cஎனக்கு சில பிரச்சனைகளை ஏற்படுத்தும்',
                  groupValue: _selectedOptionQuestion8,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion8 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('எந்த பிரச்சனையும் இல்லை'),
                  value: 'எந்த பிரச்சனையும் இல்லை',
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
              "9) எந்த நடவடிக்கைகள் பொதுவாக உங்களுக்கு மூச்சுத் திணறலை ஏற்படுத்துகின்றன என்பது பற்றிய கேள்வி. ஒவ்வொரு கூற்றுக்கும், இந்த நாட்களில் உங்களுக்கு எது பொருந்தும் என்று எனக்குக் கூறுங்கள்..",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                CheckboxListTile(
                  title: Text('அ) உங்களை  \n  கழுவுதல் அல்லது     \nஆடை அணிதல்'),
                  value: checkBoxValues9[0],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues9[0] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('ஆ) வீட்டைச் சுற்றி       \nநடப்பது'),
                  value: checkBoxValues9[1],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues9[1] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('இ)சமமான தரையில் \n  வெளியே நடப்பது'),
                  value: checkBoxValues9[2],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues9[2] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('ஈ) படிக்கட்டுகளில்      \nஏறி இறங்கி'),
                  value: checkBoxValues9[3],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues9[3] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('உ)மலைகளில் நடந்து\nசெல்வது'),
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
                  title: Text('அ)  இருமல்                 \nவலிக்கிறது'),
                  value: checkBoxValues10[0],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues10[0] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('ஆ)இருமல் என்னை\nசோர்வடையச்\nசெய்கிறது'),
                  value: checkBoxValues10[1],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues10[1] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('இ)நான் பேசும்போது\nஎனக்கு மூச்சுத்\nதிணறல் ஏற்படுகிறது'),
                  value: checkBoxValues10[2],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues10[2] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('ஈ)நான் குனியும்போ\n-து எனக்கு மூச்சுத்\nதிணறல் ஏற்படுகிறது'),
                  value: checkBoxValues10[3],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues10[3] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('உ) நான் எளிதாக         \nசோர்வடைகிறேன்'),
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
                  title: Text('அ) எனது இருமல்\nஅல்லது சுவாசம்\nபொதுவில் சங்கடமா\n-க இருக்கிறது'),
                  value: checkBoxValues11[0],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues11[0] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('ஆ)எனது சுவாசப்\nபிரச்சினைகள் எனது\nகுடும்பம், நண்பர்கள்\nஅல்லது \nஅயலவர்களுக்கு ஒரு\n தொல்லை'),
                  value: checkBoxValues11[1],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues11[1] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('இ) என் சுவாசத்தைப்\nபிடிக்க முடியாதபோது\nநான் பயப்படுகிறேன்\nஅல்லது \nபீதியடைகிறேன்'),
                  value: checkBoxValues11[2],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues11[2] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('ஈ) எனது சுவாசப்\nபிரச்சினைகளை \nநான் கட்டுப்படுத்தவி\n-ல்லை என \nஉணர்கிறேன்'),
                  value: checkBoxValues11[3],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues11[3] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('உ)எனது சுவாசப்\n பிரச்சினைகள் \nகாரணமாக \nநான் பலவீனமடைந்\n-துள்ளேன் அல்லது\nநோயாளியாகிவிட்\n-டேன்'),
                  value: checkBoxValues11[4],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues11[4] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('ஊ)உடற்பயிற்சி\nஎனக்கு பாதுகாப்பா\n-னது அல்ல'),
                  value: checkBoxValues11[5],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues11[5] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('எ)எல்லாமே \nமிகையான முயற்சி\n-யாகத் தெரிகிறது'),
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
                  title: Text('அ)நான் குளிப்பதற்\n-கோ அல்லது ஆடை\n அணிவதற்கோ\nநீண்ட நேரம்\nஎடுத்துக்கொள்கி\n-றேன்'),
                  value: checkBoxValues12[0],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues12[0] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('ஆ)என்னால் \nகுளிக்கவோ\n அல்லது குளிக்கவோ\nமுடியாது அல்லது\n நான் செய்ய நீண்ட\nநேரம் எடுத்துக்கொள்\n-கிறேன்'),
                  value: checkBoxValues12[1],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues12[1] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('இ)நான் மற்றவர்கள\nவிட மெதுவா\nநடக்கிறேன்,அல்லது\nநான் ஓய்வெடுப்பதை\n நிறுத்துகிறேன்'),
                  value: checkBoxValues12[2],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues12[2] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('ஈ) வீட்டு வேலைகள்\nபோன்ற வேலைகள்\nநீண்ட நேரம் எடுக்\n-கும்,அல்லது நான்\nஓய்வெடுக்க நிறுத்த\n வேண்டும்'),
                  value: checkBoxValues12[3],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues12[3] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('உ)நான் ஒரு படிக்க\n-ட்டு ஏறினால், நான்\nநிறுத்த வேண்டும்\nஅல்லது மெதுவாக\nசெல்ல வேண்டும்'),
                  value: checkBoxValues12[4],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues12[4] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('ஊ)நான் வேகமாக\nநடந்தாலோ அல்லது\nவேகமாக நடந்தாலோ\n நான் மெதுவாக செல\n வேண்டும் அல்லது\n நிறுத்த வேண்டும்'),
                  value: checkBoxValues12[5],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues12[5] = value!;
                    });
                  },
                ),

                CheckboxListTile(
                  title: Text('எ)மலைகளில்\n நடப்பது\nமாடிப்படிகளில்\nபொருட்களை \nஎடுத்துச் செல்வது,\nதிருமணம், நடனம்,\nகிண்ணம் அல்லது\nகோல்ஃப்\nவிளையாடுவது \nபோன்ற லேசான \nதோட்டக்கலை\nபோன்ற\n விஷயங்களைச்\nசெய்வது எனது \nசுவாசத்தால் \nகடினமாக உள்ளது'),
                  value: checkBoxValues12[6],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues12[6] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('ஏ) எனது சுவாசம்\n கனமான தோட்டம்\n அல்லது மண்வெட்டி\n பனியை சுமப்பது, \nஜாகிங் அல்லது \nவிறுவிறுப்பாக\nநடப்பது, டென்னிஸ்\nவிளையாடுவது\nஅல்லது நீச்சல்\nபோன்ற \nவிஷயங்களைச்\nசெய்வதை\nகடினமாக்குகிறது'),
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
                  title: Text('அ) என்னால்\n விளையாடவோ\nஅல்லது பிற உடல்\nசெயல்பாடுகளில்\nஈடுபடவோ முடியாது'),
                  value: checkBoxValues13[0],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues13[0] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('ஆ) பொழுதுபோக்கு\nஅல்லது\nபொழுதுபோக்கிற்\n-காக என்னால் \nவெளியே\nசெல்ல முடியாது'),
                  value: checkBoxValues13[1],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues13[1] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('இ)நான் ஷாப்பிங்\nசெய்ய வீட்டை விட்டு\nவெளியே செல்ல\n முடியாது'),
                  value: checkBoxValues13[2],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues13[2] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('ஈ) என்னால் வீட்டு\nவேலைகளைச்\nசெய்ய முடியாது'),
                  value: checkBoxValues13[3],
                  onChanged: (value) {
                    setState(() {
                      checkBoxValues13[3] = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('உ) எனது படுக்கை\nஅல்லது \nநாற்காலியில்\nஇருந்து என்னால்\n வெகு தூரம்\n நகர முடியாது'),
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
              "14)உங்கள் சுவாச பிரச்சினைகள் உங்களை எவ்வாறு பாதிக்கின்றன? ஒரு பதிலைத் தேர்ந்தெடுக்கவும்",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile(
                  title: Text('நான் செய்ய விரும்பும் எதையும் செய்வதிலிருந்து அவை என்னைத் தடுப்பதில்லை'),
                  value: 'நான் செய்ய விரும்பும் எதையும் செய்வதிலிருந்து அவை என்னைத் தடுப்பதில்லை',
                  groupValue: _selectedOptionQuestion14,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion14 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('நான் செய்ய விரும்பும் ஒன்று அல்லது இரண்டு விஷயங்களைச் செய்வதிலிருந்து அவை என்னைத் தடுக்காது'),
                  value: 'நான் செய்ய விரும்பும் ஒன்று அல்லது இரண்டு விஷயங்களைச் செய்வதிலிருந்து அவை என்னைத் தடுக்காது',
                  groupValue: _selectedOptionQuestion14,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion14 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('நான் செய்ய விரும்பும் பெரும்பாலான விஷயங்களைச் செய்வதிலிருந்து அவை என்னைத் தடுக்கின்றன'),
                  value: 'நான் செய்ய விரும்பும் பெரும்பாலான விஷயங்களைச் செய்வதிலிருந்து அவை என்னைத் தடுக்கின்றன',
                  groupValue: _selectedOptionQuestion14,
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionQuestion14 = value as String?;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('நான் செய்ய விரும்பும் அனைத்தையும் செய்ய அவர்கள் என்னைத் தடுக்கிறார்கள்'),
                  value: 'நான் செய்ய விரும்பும் அனைத்தையும் செய்ய அவர்கள் என்னைத் தடுக்கிறார்கள்',
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