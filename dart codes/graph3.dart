import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: Graph3(id: '12345'),
  ));
}

class Graph3 extends StatefulWidget {
  final String id;

  Graph3({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  _Graph3State createState() => _Graph3State();
}

class _Graph3State extends State<Graph3> {
  String? firstResponse;
  String? secondResponse;

  @override
  void initState() {
    super.initState();
    fetchResponses();
  }

  Future<void> saveResponseToDatabase(String responseText, bool isPre) async {
    try {
      var url = Uri.parse('http://192.168.148.130:80/test/mmr.php');
      var bodyData = {
        'mmr1': isPre ? responseText : firstResponse ?? '', // Ensure firstResponse is not null
        'mmr2': !isPre ? responseText : secondResponse ?? '', // Ensure secondResponse is not null
        'P_id': widget.id,
      };
      print('Data to be sent in the POST request: $bodyData');

      var response = await http.post(
        url,
        body: jsonEncode(bodyData),
        headers: {'Content-Type': 'application/json'},
      );

      print('Server response: ${response.body}');

      if (response.statusCode == 200) {
        print('Response saved to database successfully');
        setState(() {
          if (isPre) {
            firstResponse = responseText;
          } else {
            secondResponse = responseText;
          }
        });
      } else {
        print('Failed to save response to database: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error saving response to database: $e');
    }
  }

  Future<void> fetchResponses() async {
    try {
      var url = Uri.parse('http://192.168.148.130:80/test/fetch_data3.php');
      var bodyData = {'id': widget.id};
      print('Data to be sent in the POST request: $bodyData');

      var response = await http.post(
        url,
        body: jsonEncode(bodyData),
        headers: {'Content-Type': 'application/json'},
      );

      print('Server response: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          firstResponse = data['data']['mmr1'];
          secondResponse = data['data']['mmr2'];
        });
      } else {
        print('Failed to fetch responses: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching responses: $e');
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
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25.0, top: 70),
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModifiedMedical(id: widget.id),
                    ),
                  );
                  if (result != null) {
                    final responseText = result['responseText'] as String;
                    final isPre = result['isPre'] as bool;
                    saveResponseToDatabase(responseText, isPre);
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
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'First Response:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      firstResponse ?? 'Loading...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Second Response:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      secondResponse ?? 'Loading...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class ModifiedMedical extends StatefulWidget {
  final String id;

  const ModifiedMedical({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  _ModifiedMedicalState createState() => _ModifiedMedicalState();
}

class _ModifiedMedicalState extends State<ModifiedMedical> {
  int? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Modified Medical Research Council Dyspnoea Scale',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Choose an Option:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildOptionTile(
              context: context,
              index: 0,
              text: 'I only get breathless with strenuous exercise',
            ),
            _buildOptionTile(
              context: context,
              index: 1,
              text: 'I get short of breath when hurrying on the level or walking up a slight hill',
            ),
            _buildOptionTile(
              context: context,
              index: 2,
              text: 'I walk slower than people of the same age on the level because of breathlessness or have to stop for breath when walking at my own pace on the level',
            ),
            _buildOptionTile(
              context: context,
              index: 3,
              text: 'I stop for breath after walking about 100 yards or after a few minutes on the level',
            ),
            _buildOptionTile(
              context: context,
              index: 4,
              text: '"I am too breathless to leave the house" or "I am breathless when dressing"',
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
                _onSubmit(true); // Pass true for pre response
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
                _onSubmit(false); // Pass false for post response
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

  Widget _buildOptionTile({required BuildContext context, required int index, required String text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        RadioListTile<int>(
          value: index,
          groupValue: _selectedOption,
          onChanged: (int? newValue) {
            setState(() {
              _selectedOption = newValue;
            });
          },
          activeColor: Colors.blue,
        ),
      ],
    );
  }

  void _onSubmit(bool isPre) async {
    if (_selectedOption != null) {
      String selectedOptionText = _getOptionText(_selectedOption!);

      // Pass the selected option text and isPre flag back to the previous page
      Navigator.pop(context, {
        'responseText': selectedOptionText,
        'isPre': isPre,
      });

      // Prepare the data to be sent in the POST request
      Map<String, dynamic> data = {
        'P_id': widget.id,
        isPre ? 'mmr1' : 'mmr2': selectedOptionText,
      };

      print('Data to be sent in the POST request: $data');

      try {
        var response = await http.post(
          Uri.parse('http://192.168.148.130:80/test/mmr.php'),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode == 200) {
          print('Server response: ${response.body}');
          // Handle server response
        } else {
          print('Failed to send POST request: ${response.reasonPhrase}');
          // Handle error
        }
      } catch (e) {
        print('Error sending POST request: $e');
        // Handle error
      }
    }
  }

  String _getOptionText(int index) {
    switch (index) {
      case 0:
        return 'I only get breathless with strenuous exercise';
      case 1:
        return 'I get short of breath when hurrying on the level or walking up a slight hill';
      case 2:
        return 'I walk slower than people of the same age on the level because of breathlessness or have to stop for breath when walking at my own pace on the level';
      case 3:
        return 'I stop for breath after walking about 100 yards or after a few minutes on the level';
      case 4:
        return '"I am too breathless to leave the house" or "I am breathless when dressing"';
      default:
        return '';
    }
  }
}
