// import 'package:flutter/material.dart';
// import 'package:try1/graph2.dart';
//
// class Epsworth extends StatefulWidget {
//   final String id;
//   const Epsworth({ required this.id,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<Epsworth> createState() => _EpsworthState();
// }
//
// class _EpsworthState extends State<Epsworth> {
//   // Declare a list of values to hold the selected option for each question
//   List<int?> selectedOptions = List.filled(8, null);
//
//   // Function to build a question with options 1 to 4
//   Widget buildQuestion(String questionText, int questionIndex) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 7.0),
//       child: Row(
//         children: [
//           // Flexible widget for the question text
//           Flexible(
//             flex: 3, // Controls the space for question text
//             child: Text(
//               questionText,
//               style: TextStyle(fontSize: 13, color: Colors.black),
//               maxLines: 5, // Allow the question to wrap to three lines if necessary
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           // Row for options 1 to 4
//           Row(
//             children: List.generate(4, (index) {
//               return Row(
//                 children: [
//                   Radio<int>(
//                     value: index + 1,
//                     groupValue: selectedOptions[questionIndex],
//                     onChanged: (int? value) {
//                       setState(() {
//                         selectedOptions[questionIndex] = value;
//                       });
//                     },
//                   ),
//                   Text(
//                     '${index + 1}',
//                     style: TextStyle(fontSize:12, color: Colors.black),
//                   ),
//                   // Add spacing between radio options
//                   if (index != 3) SizedBox(width: 0),
//                 ],
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Epsworth Sleepiness Score',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.cyan.shade300, Colors.white],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               stops: [0.5, 1.0],
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           // Top container with a Row to divide it into two halves
//           Container(
//             width: double.infinity, // Stretch the container to fill the screen width
//             color: Colors.blue[100], // Container background color
//             child: Row(
//               children: [
//                 // First half of the container
//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Text(
//                       '*How likely are you to doze or fall asleep in the following situations in contrast to just feeling tired?\n'
//                           '*This refers to your usual way in recent times.\n'
//                           '*Even if you have not done some of these things recently, try to work out how they would have been.',
//                       style: TextStyle(color: Colors.black, fontSize: 12.5),
//                     ),
//                   ),
//                 ),
//                 // Second half of the container
//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Text(
//                       'Right Text:\n'
//                           '0 = Would never doze\n'
//                           '1 = Slight chance of dozing\n'
//                           '2 = Moderate chance of dozing\n'
//                           '3 = High chance of dozing',
//                       style: TextStyle(color: Colors.black, fontSize: 12.5),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Expanded to handle remaining content
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.all(15.0),
//               child: Column(
//                 children: [
//                   // Question 1
//                   buildQuestion(
//                     'Sitting inactive in a public place',
//                     0,
//                   ),
//                   SizedBox(height: 10),
//                   // Question 2
//                   buildQuestion(
//                     'Sitting quitely after lunch without alcohol',
//                     1,
//                   ),
//                   SizedBox(height: 10),
//                   // Question 3
//                   buildQuestion(
//                     'Sitting and reading',
//                     2,
//                   ),
//                   SizedBox(height: 10),
//                   // Question 4
//                   buildQuestion(
//                     'Watching TV            ',
//                     3,
//                   ),
//                   SizedBox(height: 10),
//                   // Question 3
//                   buildQuestion(
//                     'Sitting and talking to someone',
//                     4,
//                   ),
//                   SizedBox(height: 10),
//                   // Question 3
//                   buildQuestion(
//                     'Lying down to rest during the day when circumstances permit',
//                     5,
//                   ),
//                   SizedBox(height: 10),
//                   // Question 3
//                   buildQuestion(
//                     'As a passenger in a car without break',
//                     6,
//                   ),
//                   SizedBox(height: 10),
//                   // Question 3
//                   buildQuestion(
//                     'In a car, while stopped for few minutes in a traffic',
//                     7,
//                   ),
//
//
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(30.0),
//         child: SizedBox(
//           width: double.infinity,
//           height: 40,
//           child: ElevatedButton(
//             onPressed: () {
//               // Handle button press here
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => Graph2(id: widget.id)), // Adjust the navigation target as needed
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Color(0xFF66D0D0), // Button background color
//             ),
//             child: Text(
//               'SUBMIT',
//               style: TextStyle(color: Colors.white, fontSize: 17), // Button text color and size
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
