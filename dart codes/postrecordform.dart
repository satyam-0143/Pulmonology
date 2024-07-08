import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:try1/formdoc.dart';

class Postrecordform extends StatefulWidget {
  final String id;
  final Function onSaveSuccess;

  Postrecordform({required this.id, required this.onSaveSuccess});

  @override
  _PostrecordformState createState() => _PostrecordformState();
}

class _PostrecordformState extends State<Postrecordform> {
  final TextEditingController ebpController = TextEditingController();
  final TextEditingController ehrController = TextEditingController();
  final TextEditingController edysController = TextEditingController();
  final TextEditingController efatController = TextEditingController();
  final TextEditingController spO2Controller = TextEditingController();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    ebpController.addListener(_checkIfFieldsAreFilled);
    ehrController.addListener(_checkIfFieldsAreFilled);
    edysController.addListener(_checkIfFieldsAreFilled);
    efatController.addListener(_checkIfFieldsAreFilled);
    spO2Controller.addListener(_checkIfFieldsAreFilled);
  }

  @override
  void dispose() {
    ebpController.dispose();
    ehrController.dispose();
    edysController.dispose();
    efatController.dispose();
    spO2Controller.dispose();
    super.dispose();
  }

  void _checkIfFieldsAreFilled() {
    setState(() {
      isButtonEnabled = ebpController.text.isNotEmpty &&
          ehrController.text.isNotEmpty &&
          edysController.text.isNotEmpty &&
          efatController.text.isNotEmpty &&
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
        "ebp": ebpController.text,
        "ehr": ehrController.text,
        "edys": edysController.text,
        "efat": efatController.text,
        "eso2": spO2Controller.text,
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
    await _saveValues('http://192.168.148.130:80/test/smwt2.php'); // Save Pre Test Baseline
    await _saveValues('http://192.168.148.130:80/test/inter7.php'); // Save End Test
    widget.onSaveSuccess();
    Navigator.pop(context);
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
              _buildTextFieldRow('BP:', ebpController),
              SizedBox(height: 20),
              _buildTextFieldRow('HR:', ehrController),
              SizedBox(height: 20),
              _buildTextFieldRow('SpO2:', spO2Controller),
              SizedBox(height: 20),
              _buildTextFieldRow('Dyspnea:', edysController),
              SizedBox(height: 20),
              _buildTextFieldRow('Fatigue:', efatController),
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
