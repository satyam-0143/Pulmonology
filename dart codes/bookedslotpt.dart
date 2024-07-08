import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class bookedslot extends StatefulWidget {
  final String userId;

  bookedslot({Key? key, required this.userId}) : super(key: key);

  @override
  _bookedslotState createState() => _bookedslotState();
}

class _bookedslotState extends State<bookedslot> {
  Map<String, dynamic> bookedSlot = {}; // Map to store booked slot data

  @override
  void initState() {
    super.initState();
    fetchBookedSlot(); // Fetch booked slot data when the widget initializes
  }

  Future<void> fetchBookedSlot() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.148.130:80/test/bokkedslots.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'pid': widget.userId, // Send the user ID to the PHP backend
        }),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        setState(() {
          bookedSlot = jsonDecode(response.body);
        });
      } else {
        // If the server responds with an error, throw an exception
        throw Exception('Failed to load booked slot');
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Booked Slot',
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
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name : ${bookedSlot["name"] ?? ""}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'ID        : ${bookedSlot["pid"] ?? ""}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Date    : ${bookedSlot["date"] ?? ""}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Status : ${bookedSlot["status"] ?? ""}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
