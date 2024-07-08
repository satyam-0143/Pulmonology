import 'package:flutter/material.dart';
import 'package:try1/addpt.dart';
import 'package:try1/appointmentacceptance.dart';
import 'package:try1/doctorlogin.dart';
import 'package:try1/video.dart';
import 'package:try1/viewpt.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Navdoctor extends StatefulWidget {
  final String userId;

  Navdoctor({Key? key, required this.userId}) : super(key: key);

  @override
  _NavdoctorState createState() => _NavdoctorState();
}

class _NavdoctorState extends State<Navdoctor> {
  String? _doctorImageUrl;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchDoctorData();
  }

  Future<void> _fetchDoctorData() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.148.130:80/test/drnavbarimg.php'), // Update with your correct URL
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'D_id': widget.userId,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('image')) {
          setState(() {
            _doctorImageUrl = 'http://192.168.148.130:80/test/doc/' + (data['image'] ?? '');
            _isLoading = false;
          });
        } else {
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.cyan.shade800, Colors.grey.shade100],
                  ),
                ),
                child: Center(
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : _hasError
                      ? CircleAvatar(
                    child: Icon(Icons.error, size: 60, color: Colors.red),
                    backgroundColor: Colors.transparent,
                    radius: 60,
                  )
                      : _doctorImageUrl != null
                      ? CircleAvatar(
                    backgroundImage: NetworkImage(_doctorImageUrl!),
                    radius: 60,
                  )
                      : CircleAvatar(
                    child: Icon(Icons.person, size: 60, color: Colors.black),
                    backgroundColor: Colors.transparent,
                    radius: 60,
                  ),
                ),
              ),
              SizedBox(height: 100),
              ListTile(
                leading: Icon(Icons.person_add_alt_1),
                title: Text('Add Patient'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPatient(userId: widget.userId),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.upload),
                title: Text('Add Exercise Videos'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Uploadvideo(userId: widget.userId),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.touch_app),
                title: Text('Appointment Acceptance'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Appointment(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person_search),
                title: Text('View Patient'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewPatient(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
