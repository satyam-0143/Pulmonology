// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'package:try1/stopbang.dart';
//
// class Graph1 extends StatefulWidget {
//   final String id;
//   final List<int> firstTimeScores; // Add firstTimeScores parameter
//   final List<int> secondTimeScores; // Add secondTimeScores parameter
//
//   const Graph1({
//     required this.id,
//     required this.firstTimeScores, // Add required keyword
//     required this.secondTimeScores, // Add required keyword
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _Graph1State createState() => _Graph1State();
// }
//
// class _Graph1State extends State<Graph1> {
//   late int totalFirstTimeScore;
//   late int totalSecondTimeScore;
//
//   @override
//   void initState() {
//     super.initState();
//     calculateTotalScores();
//   }
//
//   void calculateTotalScores() {
//     totalFirstTimeScore = widget.firstTimeScores.reduce((a, b) => a + b);
//     totalSecondTimeScore = widget.secondTimeScores.reduce((a, b) => a + b);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Form',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
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
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.only(left: 25.0, top: 70),
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => StopBang(
//                         patientId: widget.id,
//                         firstTimeScores: widget.firstTimeScores,
//                         secondTimeScores: widget.secondTimeScores,
//                         onSubmit: (firstTimeScores, secondTimeScores) {
//                           setState(() {
//                             widget.firstTimeScores = firstTimeScores;
//                             widget.secondTimeScores = secondTimeScores;
//                             calculateTotalScores();
//                           });
//                         },
//                       ),
//                     ),
//                   );
//                 },
//                 child: Text(
//                   'FILL THE FORM',
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.cyan,
//                 ),
//               ),
//             ),
//             SizedBox(height: 100),
//             Padding(
//               padding: const EdgeInsets.only(right: 150.0),
//               child: Text(
//                 'First Time Score: $totalFirstTimeScore\nSecond Time Score: $totalSecondTimeScore',
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//             SizedBox(height: 80),
//             Container(
//               height: 300,
//               padding: EdgeInsets.all(16),
//               child: VerticalBarChart([
//                 ChartData(
//                     'Pre',
//                     totalFirstTimeScore,
//                     charts.ColorUtil.fromDartColor(Colors.green)),
//                 ChartData(
//                     'Post',
//                     totalSecondTimeScore,
//                     charts.ColorUtil.fromDartColor(Colors.yellow)),
//               ]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ChartData {
//   final String category;
//   final int value;
//   final charts.Color fillColor;
//
//   ChartData(this.category, this.value, this.fillColor);
// }
//
// class VerticalBarChart extends StatelessWidget {
//   final List<ChartData> data;
//
//   VerticalBarChart(this.data);
//
//   @override
//   Widget build(BuildContext context) {
//     List<charts.Series<ChartData, String>> series = [
//       charts.Series(
//         id: 'ChartData',
//         data: data,
//         domainFn: (ChartData series, _) => series.category,
//         measureFn: (ChartData series, _) => series.value,
//         colorFn: (ChartData series, _) => series.fillColor,
//       )
//     ];
//
//     return charts.BarChart(
//       series,
//       animate: true,
//       barGroupingType: charts.BarGroupingType.grouped,
//       vertical: true,
//       primaryMeasureAxis: charts.NumericAxisSpec(
//         tickProviderSpec: charts.BasicNumericTickProviderSpec(
//           desiredTickCount: 7,
//         ),
//       ),
//       domainAxis: charts.OrdinalAxisSpec(
//         renderSpec: charts.SmallTickRendererSpec(
//           labelRotation: 45,
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Graph1(
//         id: '12345',
//         firstTimeScores: List.filled(8, 0),
//         secondTimeScores: List.filled(8, 0),
//       ),
//     );
//   }
// }
