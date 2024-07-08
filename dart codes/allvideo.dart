import 'package:flutter/material.dart';
import 'package:try1/patientchat.dart';

class Allvideo extends StatelessWidget {
  final String userId;

  const Allvideo({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Videos'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20), // Add some space at the top
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/video.png',
                    height: 65,
                    width: 65,
                  ),
                  SizedBox(width: 40),
                  Image.asset(
                    'assets/video.png',
                    height: 65,
                    width: 65,
                  ),
                  SizedBox(width: 40),
                  Image.asset(
                    'assets/video.png',
                    height: 65,
                    width: 65,
                  ),
                ],
              ),

              SizedBox(height: 20), // Add some space at the top
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/video.png',
                    height: 65,
                    width: 65,
                  ),
                  SizedBox(width: 40),
                  Image.asset(
                    'assets/video.png',
                    height: 65,
                    width: 65,
                  ),
                  SizedBox(width: 40),
                  Image.asset(
                    'assets/video.png',
                    height: 65,
                    width: 65,
                  ),
                ],
              ),

              SizedBox(height: 20), // Add some space at the top
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/video.png',
                    height: 65,
                    width: 65,
                  ),
                  SizedBox(width: 40),
                  Image.asset(
                    'assets/video.png',
                    height: 65,
                    width: 65,
                  ),
                  SizedBox(width: 40),
                  Image.asset(
                    'assets/video.png',
                    height: 65,
                    width: 65,
                  ),
                ],
              ),

              SizedBox(height: 20), // Add some space at the top
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/video.png',
                    height: 65,
                    width: 65,
                  ),
                  SizedBox(width: 40),
                  Image.asset(
                    'assets/video.png',
                    height: 65,
                    width: 65,
                  ),
                  SizedBox(width: 40),
                  Image.asset(
                    'assets/video.png',
                    height: 65,
                    width: 65,
                  ),
                ],
              ),

              SizedBox(height: 20), // Add some space at the top
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/video.png',
                    height: 65,
                    width: 65,
                  ),
                  SizedBox(width: 40),
                  Image.asset(
                    'assets/video.png',
                    height: 65,
                    width: 65,
                  ),
                  SizedBox(width: 40),
                  Image.asset(
                    'assets/video.png',
                    height: 65,
                    width: 65,
                  ),
                ],
              ),

              SizedBox(height: 20), // Add some space at the top
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/video.png',
                    height: 65,
                    width: 65,
                  ),
                  SizedBox(width: 40),
                  Image.asset(
                    'assets/video.png',
                    height: 65,
                    width: 65,
                  ),
                  SizedBox(width: 40),
                  Image.asset(
                    'assets/video.png',
                    height: 65,
                    width: 65,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context); // Navigate to previous screen
          } else if (index == 1) {
            Navigator.pushAndRemoveUntil( // Navigate to the Patient page and remove all previous routes
              context,
              MaterialPageRoute(builder: (context) => Patient(userId: userId)),
                  (route) => false,
            );
          }
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
              'assets/message.png',
              height: 30,
              width: 30,
            ),
            label: '',
          ),
        ],
        elevation: 0.0,
      ),
    );
  }
}
