import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'formdoc.dart';

class PatientInfo extends StatefulWidget {
  final String id;

  const PatientInfo({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  _PatientInfoState createState() => _PatientInfoState();
}

class _PatientInfoState extends State<PatientInfo> {
  String name = '';
  String age = '';
  String gender = '';
  String cause = '';

  @override
  void initState() {
    super.initState();
    fetchPatientInfo();
  }

  Future<void> fetchPatientInfo() async {
    final url = Uri.parse('http://192.168.148.130:80/test/printPatientInfo.php');
    final response = await http.post(
      url,
      body: {'P_id': widget.id},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        name = jsonData[0]['P_name'];
        age = jsonData[0]['P_age'];
        gender = jsonData[0]['P_gender'];
        cause = jsonData[0]['cause'];
      });
    } else {
      print('Failed to fetch patient info');
    }
  }

  Future<bool> _onWillPop() async {
    // You can show a dialog here if you want to confirm the action
    return true; // return true to allow the back navigation, false to block it
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'View Patient',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan.shade300, Colors.grey.shade200],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.2, 1.0],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 170),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(
                    colors: [Colors.cyan.shade300, Colors.grey.shade200],
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    stops: [0.2, 1.0],),
                  // color: Colors.cyan,
                  // borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTextFieldRow('PID        :', widget.id),
                    SizedBox(height: 20),
                    _buildTextFieldRow('Name    :', name),
                    SizedBox(height: 20),
                    _buildTextFieldRow('Age        :', age),
                    SizedBox(height: 20),
                    _buildTextFieldRow('Gender   :', gender),
                    SizedBox(height: 20),
                    _buildTextFieldRow('Cause    :', cause),
                  ],
                ),
              ),
              SizedBox(height: 45),
              Container(
                height: 50,
                width: 100,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                ),
                child: TextButton(
                  onPressed: () {
                    // Navigate to Formdoc page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Formdoc(id: widget.id)),
                    );
                  },
                  child: Text(
                    'Form',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              // SizedBox(height: 20), // Add spacing between the button and the image
              // Center(
              //   child: Image.asset(
              //     'assets/lungs.jpg', // Replace with your image path
              //     width: 400, // Adjust the width as needed
              //     height: 200, // Adjust the height as needed
              //   ),
              // ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                // Perform save operation here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF66D0D0),
              ),
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 30),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
