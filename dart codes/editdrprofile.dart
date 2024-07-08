import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  final String userId;
  final String name;
  final String designation;
  final String phno;
  final String imageUrl;

  const EditProfilePage({
    Key? key,
    required this.userId,
    required this.name,
    required this.designation,
    required this.phno,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController designationController;
  late TextEditingController phnoController;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    designationController = TextEditingController(text: widget.designation);
    phnoController = TextEditingController(text: widget.phno);
  }

  @override
  void dispose() {
    nameController.dispose();
    designationController.dispose();
    phnoController.dispose();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> updateProfile() async {
    try {
      var uri = Uri.parse('http://192.168.148.130:80/test/dprofileU.php');
      var request = http.MultipartRequest('POST', uri);

      request.fields['field1'] = widget.userId;
      request.fields['field2'] = nameController.text;
      request.fields['field3'] = designationController.text;
      request.fields['field4'] = phnoController.text;

      // Check if the image is selected
      if (selectedImage != null) {
        var fileStream = http.ByteStream(selectedImage!.openRead());
        var length = await selectedImage!.length();
        var multipartFile = http.MultipartFile(
          'image',
          fileStream,
          length,
          filename: selectedImage!.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonData = json.decode(responseData);

        if (jsonData['status'] == true) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text(jsonData['message']),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pop(context, true);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          print('Failed to update profile: ${jsonData['message']}');
        }
      } else {
        print('Failed to update profile: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to update profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text('Take a photo'),
                                onTap: () {
                                  pickImage(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text('Choose from gallery'),
                                onTap: () {
                                  pickImage(ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: selectedImage != null
                      ? Image.file(
                    selectedImage!,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                      : Image.network(
                    widget.imageUrl,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        size: 150,
                        color: Colors.black,
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                _buildEditableTextFieldRow('Name', nameController),
                SizedBox(height: 20),
                _buildEditableTextFieldRow(
                    'Designation', designationController),
                SizedBox(height: 20),
                _buildEditableTextFieldRow('Phno', phnoController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF66D0D0),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableTextFieldRow(
      String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 10),
          Text(
            '$labelText:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding:
              EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
