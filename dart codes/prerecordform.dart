import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:try1/formdoc.dart';
import 'package:try1/sixminutewalk.dart';

class Prerecordform extends StatefulWidget {
  final String id;

  Prerecordform({required this.id});

  @override
  _PrerecordformState createState() => _PrerecordformState();
}

class _PrerecordformState extends State<Prerecordform> {
  final TextEditingController pbpController = TextEditingController();
  final TextEditingController phrController = TextEditingController();
  final TextEditingController pdysController = TextEditingController();
  final TextEditingController pfatController = TextEditingController();
  final TextEditingController spO2Controller = TextEditingController(); // Added SpO2 controller

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    pbpController.addListener(_checkIfFieldsAreFilled);
    phrController.addListener(_checkIfFieldsAreFilled);
    pdysController.addListener(_checkIfFieldsAreFilled);
    pfatController.addListener(_checkIfFieldsAreFilled);
    spO2Controller.addListener(_checkIfFieldsAreFilled);
  }

  @override
  void dispose() {
    pbpController.dispose();
    phrController.dispose();
    pdysController.dispose();
    pfatController.dispose();
    spO2Controller.dispose();
    super.dispose();
  }

  void _checkIfFieldsAreFilled() {
    setState(() {
      isButtonEnabled = pbpController.text.isNotEmpty &&
          phrController.text.isNotEmpty &&
          pdysController.text.isNotEmpty &&
          pfatController.text.isNotEmpty &&
          spO2Controller.text.isNotEmpty;
    });
  }

  // Helper method to build a row with a label and a text field
  Widget _buildTextFieldRow(String labelText, TextEditingController controller, [String? hintText]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText ?? 'Enter value',
            border: UnderlineInputBorder(),
            focusedBorder: UnderlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Future<void> _saveValues(String url) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "P_id": widget.id,
        "pbp": pbpController.text,
        "phr": phrController.text,
        "pdys": pdysController.text,
        "pfat": pfatController.text,
        "pso2": spO2Controller.text, // Added SpO2 parameter
      }),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data saved successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save data: ${result['message']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data: ${response.reasonPhrase}')),
      );
    }
  }

  Future<void> _handleSubmit() async {
    await _saveValues('http://192.168.148.130:80/test/smwt.php'); // Save Pre Test Baseline
    await _saveValues('http://192.168.148.130:80/test/inter6.php'); // Save End Test
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Sixminute(id: widget.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SIX MINUTE WALK TEST',
          style: TextStyle(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pre Test? Baseline',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              _buildTextFieldRow('BP:', pbpController),
              SizedBox(height: 20),
              _buildTextFieldRow('HR:', phrController),
              SizedBox(height: 20),
              _buildTextFieldRow('SpO2:', spO2Controller), // Added SpO2 field
              SizedBox(height: 20),
              _buildTextFieldRow('Dyspnea:', pdysController),
              SizedBox(height: 20),
              _buildTextFieldRow('Fatigue:', pfatController),
              SizedBox(height: 45),
              Text(
                'End of Test',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              _buildTextFieldRow('End BP:', TextEditingController()),
              SizedBox(height: 20),
              _buildTextFieldRow('End HR:', TextEditingController()),
              SizedBox(height: 20),
              _buildTextFieldRow('End SpO2:', TextEditingController()),
              SizedBox(height: 20),
              _buildTextFieldRow('End Dyspnea:', TextEditingController()),
              SizedBox(height: 20),
              _buildTextFieldRow('End Fatigue:', TextEditingController()),
              SizedBox(height: 45),
              _buildTextFieldRow('Stopped or pauses before 6 minute completed?', TextEditingController(), 'No/Yes, reason:'),
              SizedBox(height: 45),
              _buildTextFieldRow('Other symptoms at the end of test:', TextEditingController(), 'Angina, dizziness, hip, knee, calf pain, other:'),
              SizedBox(height: 45),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isButtonEnabled ? _handleSubmit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isButtonEnabled ? Colors.cyan : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
