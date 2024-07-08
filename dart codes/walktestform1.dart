import 'package:flutter/material.dart';

class Pulmonaryfunctiontest extends StatelessWidget {
  const Pulmonaryfunctiontest({Key? key}) : super(key: key);

  // Define the _buildTextFieldRow method
  Widget _buildTextFieldRow(String labelText, {String? hintText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0), // Add padding for vertical spacing
      child: Row(
        children: [
          Text(
            labelText,
            style: TextStyle(
              // fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          // Add some spacing between the label and text field
          SizedBox(width: 10),
          // Expanded widget makes sure the TextField takes the remaining space
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hintText ?? 'Enter value', // Optional placeholder text
                border: UnderlineInputBorder(), // Only an underline border
                focusedBorder: UnderlineInputBorder(), // Underline border when focused
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pulmonary function test',
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
                'PRE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 10), // Space above the first text field
              _buildTextFieldRow('FEV1/FVC:', hintText: 'Enter FEV1/FVC value'),
              SizedBox(height: 20),
              _buildTextFieldRow('FVC:', hintText: 'Enter FVC value'),
              SizedBox(height: 20),
              _buildTextFieldRow('FEV1:', hintText: 'Enter FEV1 value'),
              SizedBox(height: 20),
              _buildTextFieldRow('FEV 25-75:', hintText: 'Enter FEV 25-75 value'),
              SizedBox(height: 45),
              Text(
                'POST',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              _buildTextFieldRow('FEV1/FVC:', hintText: 'Enter FEV1/FVC value'),
              SizedBox(height: 20),
              _buildTextFieldRow('FVC:', hintText: 'Enter FVC value'),
              SizedBox(height: 20),
              _buildTextFieldRow('FEV1:', hintText: 'Enter FEV1 value'),
              SizedBox(height: 20),
              _buildTextFieldRow('FEV 25-75:', hintText: 'Enter FEV 25-75 value'),
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
              'SAVE TEXT',
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
