import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import shared preferences package
import 'package:try1/backgroundlogin.dart';
import 'package:try1/page3.dart';
import 'doctorlogin.dart';
import 'common.dart';

class LoginPage extends StatefulWidget {

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    var url = Uri.parse(DoctorLogin);

    var data = {
      "D_id": usernameController.text,
      "password": passwordController.text,
    };
    var response = await http.post(
      url,
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    var responseData = json.decode(response.body);

    if (responseData['status'] == 'success') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', usernameController.text);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CustomCardView(userId: usernameController.text)),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('Invalid user id or password'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }



  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> responseData = json.decode(response.body);
  //     if (responseData['status'] == 'success') {
  //       // Save user ID to shared preferences
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       prefs.setString('userId', usernameController.text.trim());
  //
  //       // Navigate to next page
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => CustomCardView()),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Login failed: ${responseData['message']}'),
  //         ),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to load data: ${response.statusCode}'),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.png'),
          fit: BoxFit.cover,
        ),
      ),
        child:WillPopScope(
        onWillPop: () async {
      // Navigate to FormDoc page when back button is pressed
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
      // Return false to prevent the current screen from popping
      return false;
    },
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.4,
                  right: 35,
                  left: 35,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'User Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        alignLabelWithHint: true,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: '  Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 06),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.cyan[300],
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 120,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),),
    );
  }
}
