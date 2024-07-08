import 'package:flutter/material.dart';
import 'package:try1/patientlogin.dart';

class Patient extends StatelessWidget {
  final String userId;

  const Patient({Key? key, required this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Navigate to the previous page
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.account_circle, // Icon representing a user
                  size: 30, // Adjust size if necessary
                  color: Colors.black, // Adjust color if necessary
                ),
              ),
            ),
            SizedBox(width: 20), // Add space between icon and text
            Text(
              'Satyam',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Change the index according to your requirements
        onTap: (index) {
          if (index == 1) {
            // Only navigate when the index is 0 (home) and not 1 (message)
            return;
          }
          Navigator.push(context, MaterialPageRoute(builder:  (context) => Patient2(userId: userId)),);
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/hom.png',
              height: 30,
              width: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/msg.png',
              height: 30,
              width: 30,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
