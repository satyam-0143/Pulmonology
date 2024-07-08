import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:try1/editptprofile.dart';
import 'package:try1/patientlogin.dart';

class Profile extends StatefulWidget {
  final String userId;

  const Profile({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? patientProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatientProfile();
  }

  void _loadPatientProfile() async {
    try {
      // Fetch the patient profile using the provided patient ID
      Map<String, dynamic> profile = await fetchPatientProfile(widget.userId);

      // Update the state with the fetched profile and stop loading
      setState(() {
        patientProfile = profile;
        isLoading = false;
      });
    } catch (error) {
      // Handle errors appropriately
      setState(() {
        isLoading = false;
      });
      // Display error message (e.g., in a snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch patient profile: $error')),
      );
    }
  }

  Future<Map<String, dynamic>> fetchPatientProfile(String pid) async {
    final url = 'http://192.168.148.130:80/test/D_profile.php';
    final headers = {'Content-Type': 'application/json'};

    // Create the request body
    final body = jsonEncode({'P_id': pid});

    // Make the POST request
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    // Check the response status
    if (response.statusCode == 200) {
      // Check if the response body is empty
      if (response.body.isEmpty) {
        throw Exception(
            'Failed to fetch patient profile: Server returned empty response');
      }

      // Try to parse the JSON response
      try {
        return json.decode(response.body);
      } catch (e) {
        // Handle JSON parsing errors
        throw Exception(
            'Failed to fetch patient profile: Invalid JSON response');
      }
    } else {
      // Handle different HTTP status codes
      throw Exception(
          'Failed to fetch patient profile: HTTP ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Patient2(userId: widget.userId)),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : patientProfile == null
            ? Center(child: Text('Failed to load profile'))
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 75,
                backgroundImage: NetworkImage(
                  'http://192.168.148.130:80/test/${patientProfile!['img']}',
                ),
              ),
              SizedBox(height: 20),
              buildProfileDetail('Username ', patientProfile!['P_name']),
              buildProfileDetail('Gender       ', patientProfile!['P_gender']),
              buildProfileDetail('ID                ', widget.userId),
              buildProfileDetail('Contact no ', patientProfile!['P_phno']),
              Spacer(),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the EditProfile page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfile(
                          patientProfile: patientProfile!,
                          userId: widget.userId,
                          imageUrl: 'http://192.168.148.130:80/test/${patientProfile!['img']}',
                        ),
                      ),
                    ).then((result) {
                      // Refresh profile data if editing was successful
                      if (result == true) {
                        _loadPatientProfile();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF66D0D0),
                  ),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 20),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
