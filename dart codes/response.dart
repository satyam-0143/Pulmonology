import 'package:flutter/material.dart';
import 'package:try1/englishquestion.dart';
import 'package:try1/tamilqs.dart';
import 'package:flutter/src/material/checkbox_list_tile.dart';

class Language extends StatelessWidget {
  final String userId;
  final int totalScore; // Define totalScore here

  const Language({Key? key, required this.userId, required this.totalScore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose Your Language',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 230,
              // Increased width for Button 1
              margin: EdgeInsets.only(bottom: 20),
              // Adjust spacing between buttons
              decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EnglishQuestion(userId: userId)),
                  );
                },
                child: Text(
                  'English',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              height: 50,
              width: 230, // Increased width for Button 2
              decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TamilQuestion(userId: userId)),
                  );
                },
                child: Text(
                  'Tamil',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
