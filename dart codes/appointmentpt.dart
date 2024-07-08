import 'package:flutter/material.dart';
import 'package:try1/requestpage.dart';

class Calenderview extends StatelessWidget {
  final String userId;

  const Calenderview({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    DateTime initialDate = DateTime.now();

    // Ensure initialDate is not a Sunday
    if (initialDate.weekday == DateTime.sunday) {
      initialDate = initialDate.add(Duration(days: 1)); // Move to next day if today is Sunday
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar View'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 300), // Adjust the bottom padding as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CalendarDatePicker(
                  initialDate: initialDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                  selectableDayPredicate: (DateTime date) {
                    // Disable Sundays
                    return date.weekday != DateTime.sunday;
                  },
                  onDateChanged: (date) {
                    // Convert the DateTime object to a string in 'yyyy-MM-dd' format
                    String dateString = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

                    // Pass the dateString to the Request page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Request(userId: userId, selectedDate: dateString),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.10), // Adjust the left padding as needed
                child: Center(
                  child: Image.asset(
                    'assets/calenderview.png', // Replace 'your_image.png' with your actual image asset path
                    width: screenWidth * 0.9, // Adjust width as needed, here using 90% of the screen width
                    height: screenWidth * 0.9, // Adjust height as needed, maintaining aspect ratio
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
