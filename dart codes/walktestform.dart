import 'package:flutter/material.dart';

class Walktestform extends StatelessWidget {
  const Walktestform({Key? key}) : super(key: key);

  // Helper method to build a row with a label and a text field
  Widget _buildTextFieldRow(String labelText, [String? hintText]) {
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
          decoration: InputDecoration(
            hintText: hintText ?? 'Enter value', // Optional placeholder text
            border: UnderlineInputBorder(), // Only an underline border
            focusedBorder: UnderlineInputBorder(), // Underline border when focused
          ),
        ),
      ],
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
              SizedBox(height: 10), // Space above the first text field
              _buildTextFieldRow('BP           :'),
              SizedBox(height: 20),
              _buildTextFieldRow('HR           :'),
              SizedBox(height: 20),
              _buildTextFieldRow('SpO2       :'),
              SizedBox(height: 20),
              _buildTextFieldRow('Dyspnea :'),
              SizedBox(height: 20),
              _buildTextFieldRow('Fatigue   :'),
              SizedBox(height: 45),
              Text(
                'End of Test',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10), // Space above the first text field
              _buildTextFieldRow('BP           :'),
              SizedBox(height: 20),
              _buildTextFieldRow('HR           :'),
              SizedBox(height: 20),
              _buildTextFieldRow('SpO2       :'),
              SizedBox(height: 20),
              _buildTextFieldRow('Dyspnea :'),
              SizedBox(height: 20),
              _buildTextFieldRow('Fatigue   :'),
              SizedBox(height: 45),
              _buildTextFieldRow(
                'Stopped or pauses before 6 minute completed?',
                'No/Yes, reason:',
              ),
              SizedBox(height: 45),
              _buildTextFieldRow(
                'Other symptoms at the end of test:',
                'Agina, dizziness, hip, knee, calf pain, other:',
              ),
              SizedBox(height: 45),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SizedBox(
          width: double.infinity, // Make the button stretch horizontally
          height: 50, // Increase the button height
          child: ElevatedButton(
            onPressed: () {
              // Add your save functionality here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan, // Set the button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Add button border radius
              ),
            ),
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold, // Set font weight for readability
              ),
            ),
          ),
        ),
      ),
    );
  }
}
