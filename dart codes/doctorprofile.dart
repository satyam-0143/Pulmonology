import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'editdrprofile.dart';

class DProfile extends StatefulWidget {
  final String userId;

  const DProfile({Key? key, required this.userId}) : super(key: key);

  @override
  _DProfileState createState() => _DProfileState();
}

class _DProfileState extends State<DProfile> {
  Map<String, dynamic>? doctorDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDoctorDetails();
  }

  Future<void> fetchDoctorDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.148.130:80/test/dprofile.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'userid': widget.userId},
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['status'] == true) {
          setState(() {
            doctorDetails = responseBody['doctorDetails'];
          });
        } else {
          setState(() {
            doctorDetails = null;
          });
        }
      } else {
        throw Exception('Failed to load doctor details: ${response.body}');
      }
    } catch (error) {
      print(error);
      setState(() {
        doctorDetails = null;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          doctorDetails != null
              ? 'Dr. ${doctorDetails!['D_name']}'
              : 'Dr. MyDoctor',
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : doctorDetails == null
          ? Center(child: Text('Failed to load doctor details.'))
          : SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'http://192.168.148.130:80/test/doc/' + (doctorDetails!['image'] ?? ''),
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      size: 150,
                      color: Colors.black,
                    );
                  },
                ),
                SizedBox(height: 20),
                _buildTextFieldRow('ID', widget.userId),
                SizedBox(height: 20),
                _buildTextFieldRow('Name', doctorDetails!['D_name'] ?? ''),
                SizedBox(height: 20),
                _buildTextFieldRow('Designation', doctorDetails!['D_dep'] ?? ''),
                SizedBox(height: 20),
                _buildTextFieldRow('Phno', doctorDetails!['D_phno'] ?? ''),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: doctorDetails == null
                ? null
                : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    userId: widget.userId,
                    name: doctorDetails!['D_name'] ?? '',
                    designation: doctorDetails!['D_dep'] ?? '',
                    phno: doctorDetails!['D_phno'] ?? '',
                    imageUrl: 'http://192.168.148.130:80/test/doc/${doctorDetails!['image']}',
                  ),
                ),
              ).then((value) {
                if (value == true) {
                  fetchDoctorDetails();
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF66D0D0),
            ),
            child: Text(
              'Edit',
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldRow(String labelText, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 20),
        Text(
          '$labelText:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
