import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:try1/Adddoc.dart';
import 'package:try1/addpatientadmin.dart';

class Adminpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Container(
        decoration: BoxDecoration(
          // image: DecorationImage(
            // image: AssetImage("assets/logo.png"),
            // fit: BoxFit.cover,
          ),
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 110.0),
            Center(
              child: Container(
                width: 300.0,
                height: 450.0,
                margin: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                    gradient: LinearGradient(
                      colors: [Colors.cyan.shade300, Colors.grey.shade200],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.2, 1.0],
                    ),
                  ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ // Changed here
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        // context,
                        // MaterialPageRoute(builder: (context) => CaretakerProfileDisplay()),
                        // );
                      },
                      child: Image.asset(
                        'assets/logo.png',
                        width: 150,
                        height: 150,
                      ),
                    ),
                    SizedBox(height: 40), // Added SizedBox for spacing
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Adddoctor()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                      ),
                      child: Text('Add Doctor', style: TextStyle(fontSize: 18)),
                    ),
                    SizedBox(height: 40), // Added SizedBox for spacing
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddPatientAdmin()),
                        );

                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                      ),
                      child: Text('Add Patient', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}