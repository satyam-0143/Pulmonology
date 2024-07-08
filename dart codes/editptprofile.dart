import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:try1/ptprofile.dart';

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> patientProfile;
  final String userId;
  final String imageUrl;
  final Function()? onUpdate;

  const EditProfile({
    Key? key,
    required this.patientProfile,
    required this.userId,
    required this.imageUrl,
    this.onUpdate,
  }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _phNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.patientProfile['P_name'];
    _genderController.text = widget.patientProfile['P_gender'];
    _phNoController.text = widget.patientProfile['P_phno'];
  }

  Future<void> updateProfile() async {
    final url = 'http://192.168.148.130:80/test/D_profileUpdate.php';
    final headers = {'Content-Type': 'application/json'};

    // Create the request body
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['P_id'] = widget.userId;
    request.fields['P_name'] = _nameController.text;
    request.fields['P_gender'] = _genderController.text;
    request.fields['P_phno'] = _phNoController.text;

    // Send the POST request
    var response = await request.send();

    // Check the response status
    if (response.statusCode == 200) {
      // Decode and print the response body
      final responseJson = jsonDecode(await response.stream.bytesToString());
      print(responseJson);
      // Navigate back to the Profile page after updating
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(userId: widget.userId),
        ),
      );
    } else {
      // Handle different HTTP status codes
      print('Failed to update profile: HTTP ${response.statusCode}');
      // Handle the error accordingly (e.g., show error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Profile(userId: widget.userId)),
              );
              return false;
              },
          child:Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.0),
              CircleAvatar(
                radius: 75,
                backgroundImage: NetworkImage(widget.imageUrl),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _genderController,
                      decoration: InputDecoration(labelText: 'Gender'),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _phNoController,
                      decoration: InputDecoration(labelText: 'Phone Number'),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: updateProfile,
                child: Text('Update Profile'),
              ),
            ],
          ),
        ),
          ),
      );
    }
  }

