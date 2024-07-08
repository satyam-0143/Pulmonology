import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:try1/graph4.dart';

class Modifiedbrog extends StatefulWidget {
  final String id;

  const Modifiedbrog({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  State<Modifiedbrog> createState() => _ModifiedbrogState();
}

class _ModifiedbrogState extends State<Modifiedbrog> {
  int? _selectedOptionPre;
  int? _selectedOptionPost;

  Future<void> _submitPreMark() async {
    bool result = await _submitData(_selectedOptionPre, 'mbds1');
    if (result) Navigator.pop(context, true);
  }

  Future<void> _submitPostMark() async {
    bool result = await _submitData(_selectedOptionPost, 'mbds2');
    if (result) Navigator.pop(context, true);
  }

  Future<bool> _submitData(int? selectedOption, String column) async {
    if (selectedOption != null) {
      final url = 'http://192.168.148.130:80/test/pmbds.php';
      final score = 10 - selectedOption;

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'P_id': widget.id,
          column: score.toString(),
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          final s1 = responseData['s1'];
          final s2 = responseData['s2'];
          print('s1: $s1, s2: $s2');
          return true;
        } else {
          print('Failure: ${responseData['message']}');
          return false;
        }
      } else {
        print('Error: ${response.reasonPhrase}');
        return false;
      }
    } else {
      print('No option selected');
      return false;
    }
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'How much difficulty is your breathing causing you right now?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildOptionTile(context, index: 0, text: '0 | Nothing at all'),
              _buildOptionTile(context, index: 1, text: '1 | Very, very slight'),
              _buildOptionTile(context, index: 2, text: '2 | Very slight'),
              _buildOptionTile(context, index: 3, text: '3 | Slight'),
              _buildOptionTile(context, index: 4, text: '4 | Moderate'),
              _buildOptionTile(context, index: 5, text: '5 | Somewhat severe'),
              _buildOptionTile(context, index: 6, text: '6 | Severe'),
              _buildOptionTile(context, index: 7, text: '7 | Very severe'),
              _buildOptionTile(context, index: 8, text: '8 | Very, very severe (almost maximal)'),
              _buildOptionTile(context, index: 9, text: '9 | Almost maximal'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _selectedOptionPre != null ? _submitPreMark : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'SUBMIT (Pre)',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            ElevatedButton(
              onPressed: _selectedOptionPost != null ? _submitPostMark : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'SUBMIT (Post)',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, {required int index, required String text}) {
    return RadioListTile<int>(
      title: Text(text),
      value: index,
      groupValue: _selectedOptionPre,
      onChanged: (int? newValue) {
        setState(() {
          _selectedOptionPre = newValue;
          _selectedOptionPost = newValue;
        });
        print('Option ${index + 1} selected');
      },
      activeColor: Colors.blue,
    );
  }
}
