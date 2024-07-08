import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Prepulmonaryform extends StatefulWidget {
  final String id;

  Prepulmonaryform({required this.id});

  @override
  _PrepulmonaryformState createState() => _PrepulmonaryformState();
}

class _PrepulmonaryformState extends State<Prepulmonaryform> {
  final TextEditingController _fev1FvcPreController = TextEditingController();
  final TextEditingController _fvcPreController = TextEditingController();
  final TextEditingController _fev1PreController = TextEditingController();
  final TextEditingController _fev25_75PreController = TextEditingController();
  final TextEditingController _fev1FvcPostController = TextEditingController();
  final TextEditingController _fvcPostController = TextEditingController();
  final TextEditingController _fev1PostController = TextEditingController();
  final TextEditingController _fev25_75PostController = TextEditingController();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _fev1FvcPreController.addListener(_checkIfFieldsAreFilled);
    _fvcPreController.addListener(_checkIfFieldsAreFilled);
    _fev1PreController.addListener(_checkIfFieldsAreFilled);
    _fev25_75PreController.addListener(_checkIfFieldsAreFilled);
    _fev1FvcPostController.addListener(_checkIfFieldsAreFilled);
    _fvcPostController.addListener(_checkIfFieldsAreFilled);
    _fev1PostController.addListener(_checkIfFieldsAreFilled);
    _fev25_75PostController.addListener(_checkIfFieldsAreFilled);
  }

  @override
  void dispose() {
    _fev1FvcPreController.dispose();
    _fvcPreController.dispose();
    _fev1PreController.dispose();
    _fev25_75PreController.dispose();
    _fev1FvcPostController.dispose();
    _fvcPostController.dispose();
    _fev1PostController.dispose();
    _fev25_75PostController.dispose();
    super.dispose();
  }

  void _checkIfFieldsAreFilled() {
    setState(() {
      isButtonEnabled = _fev1FvcPreController.text.isNotEmpty &&
          _fvcPreController.text.isNotEmpty &&
          _fev1PreController.text.isNotEmpty &&
          _fev25_75PreController.text.isNotEmpty &&
          _fev1FvcPostController.text.isNotEmpty &&
          _fvcPostController.text.isNotEmpty &&
          _fev1PostController.text.isNotEmpty &&
          _fev25_75PostController.text.isNotEmpty;
    });
  }

  Future<void> _saveData() async {
    final url = 'http://192.168.148.130:80/test/ppopft.php';
    final body = jsonEncode({
      'P_id': widget.id,
      'apr': _fev1FvcPreController.text,
      'aprfvc': _fvcPreController.text,
      'aprfev1': _fev1PreController.text,
      'aprfef': _fev25_75PreController.text,
      'apo': _fev1FvcPostController.text,
      'apofvc': _fvcPostController.text,
      'apofev1': _fev1PostController.text,
      'apofef': _fev25_75PostController.text,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data saved successfully!')),
        );
        Navigator.pop(context, true); // Return true when data is saved successfully
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

  Widget _buildTextFieldRow(String labelText, TextEditingController controller, {String? hintText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Text(
            labelText,
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText ?? 'Enter value',
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(),
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
          'Pulmonary Function Test',
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
              SizedBox(height: 10),
              _buildTextFieldRow('FEV1/FVC:', _fev1FvcPreController, hintText: 'Enter FEV1/FVC value'),
              SizedBox(height: 20),
              _buildTextFieldRow('FVC:', _fvcPreController, hintText: 'Enter FVC value'),
              SizedBox(height: 20),
              _buildTextFieldRow('FEV1:', _fev1PreController, hintText: 'Enter FEV1 value'),
              SizedBox(height: 20),
              _buildTextFieldRow('FEV 25-75:', _fev25_75PreController, hintText: 'Enter FEV 25-75 value'),
              SizedBox(height: 45),
              Text(
                'POST',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              _buildTextFieldRow('FEV1/FVC:', _fev1FvcPostController, hintText: 'Enter FEV1/FVC value'),
              SizedBox(height: 20),
              _buildTextFieldRow('FVC:', _fvcPostController, hintText: 'Enter FVC value'),
              SizedBox(height: 20),
              _buildTextFieldRow('FEV1:', _fev1PostController, hintText: 'Enter FEV1 value'),
              SizedBox(height: 20),
              _buildTextFieldRow('FEV 25-75:', _fev25_75PostController, hintText: 'Enter FEV 25-75 value'),
              SizedBox(height: 45),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isButtonEnabled ? _saveData : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isButtonEnabled ? Colors.cyan : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'SAVE TEXT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
