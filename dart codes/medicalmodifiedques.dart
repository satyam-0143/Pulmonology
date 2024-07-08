// import 'package:flutter/material.dart';
// import 'package:try1/graph3.dart';
//
// class ModifiedMedical extends StatefulWidget {
//   final String id;
//
//   const ModifiedMedical({
//     required this.id,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _ModifiedMedicalState createState() => _ModifiedMedicalState();
// }
//
// class _ModifiedMedicalState extends State<ModifiedMedical> {
//   // Variable to track the currently selected option
//   int? _selectedOption;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Modified Medical Research Council Dyspnoea Scale',
//           style: TextStyle(fontSize: 17),
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
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             const Text(
//               'Choose an Option:',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             // List of options
//             _buildOptionTile(
//               context,
//               index: 0,
//               text: 'I only get breathless with strenuous exercise',
//             ),
//             _buildOptionTile(
//               context,
//               index: 1,
//               text: 'I get short of breath when hurrying on the level or walking up a slight hill',
//             ),
//             _buildOptionTile(
//               context,
//               index: 2,
//               text: 'I walk slower than people of the same age on the level because of breathlessness or have to stop for breath when walking at my own pace on the level',
//             ),
//             _buildOptionTile(
//               context,
//               index: 3,
//               text: 'I stop for breath after walking about 100 yards or after a few minutes on the level',
//             ),
//             _buildOptionTile(
//               context,
//               index: 4,
//               text: '"I am too breathless to leave the house" or "I am breathless when dressing"',
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(30.0),
//         child: SizedBox(
//           width: double.infinity, // Make button stretch horizontally
//           height: 40,
//           child: ElevatedButton(
//             onPressed: _onSubmit,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF66D0D0),
//             ),
//             child: const Text(
//               'SUBMIT',
//               style: TextStyle(color: Colors.white, fontSize: 17),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Function to create each option tile with visual feedback for selection
//   Widget _buildOptionTile(BuildContext context, {required int index, required String text}) {
//     return RadioListTile<int>(
//       title: Text(text),
//       value: index,
//       groupValue: _selectedOption,
//       onChanged: (int? newValue) {
//         // Update the selected option when a RadioListTile is selected
//         setState(() {
//           _selectedOption = newValue;
//         });
//         print('Option ${index + 1} selected');
//       },
//       activeColor: Colors.blue, // Customize the radio button color
//     );
//   }
//
//   // Function to handle submit button press
//   void _onSubmit() {
//     // Check if an option is selected
//     if (_selectedOption != null) {
//       print('Option ${_selectedOption! + 1} selected');
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => Graph3(id: widget.id)),
//       );
//
//
//     } else {
//       print('No option selected');
//     }
//   }
// }
