import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:try1/common.dart';
import 'package:try1/doctor.dart';
import 'package:try1/patientinfoform.dart';
import 'package:try1/navbardoctor.dart';
import 'package:try1/doctorprofile.dart'; // Assuming this is the correct import for DoctorProfile
import 'package:try1/addpt.dart' as addpt1;
import 'package:try1/video.dart';

import 'appointmentacceptance.dart';

class CustomCardView extends StatefulWidget {
  final String userId;

  const CustomCardView({Key? key, required this.userId}) : super(key: key);

  @override
  _CustomCardViewState createState() => _CustomCardViewState();
}

class _CustomCardViewState extends State<CustomCardView> {
  int _currentIndex = 0;
  late List<Map<String, String>> filteredPatients = [];
  late List<Map<String, String>> patients = [];
  List<MonthData> graphData = []; // Define graphData as a state variable
  final PageController _pageController = PageController();


  @override
  void initState() {
    super.initState();
    _fetchPatients();
    _fetchGraphData(); // Fetch graph data
  }

  Future<void> _fetchPatients() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.148.130:80/test/todayappo.php'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          patients = jsonData.cast<Map<String, dynamic>>().map((json) {
            return {
              'pid': json['pid'].toString(),
              'name': json['name'].toString(),
              'date': json['date'].toString(),
              'P_phno': json['P_phno'].toString(),
              'img': json['img'].toString(),
            };
          }).toList();
          filteredPatients = List.from(patients);
        });
      } else {
        throw Exception('Failed to load patients: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching patients: $e');
    }
  }

  Future<void> _fetchGraphData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.148.130:80/test/graph.php'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          graphData = jsonData.map((json) => MonthData.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load graph data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching graph data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (_currentIndex != 0) {
            setState(() {
              _currentIndex = 0;
              _pageController.jumpToPage(0);
            });

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => LoginPage()),
            // );
            return false;
          }
          return true;
        },

        child: Scaffold(
          drawer: Navdoctor(userId: widget.userId),
          appBar: _currentIndex == 0 ? AppBar(
            toolbarHeight: 90,
            title: Text('Dr.Gopal Krishna'),
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, semanticLabel: 'menu'),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DProfile(userId: widget.userId)),
                  );
                },
              )
            ],
          ) : null,
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              _buildHomePage(),
              addpt1.AddPatient(userId: widget.userId),
              Uploadvideo(userId: widget.userId),
              Appointment(),
              LoginPage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.black),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_add_alt_1, color: Colors.black),
                label: 'Add Patient',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.upload, color: Colors.black),
                label: 'Add Exercise Videos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.touch_app, color: Colors.black),
                label: 'Appointment Acceptance',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.logout, color: Colors.black),
                label: 'Logout',
              ),
            ],
            currentIndex: _currentIndex,
            selectedItemColor: Colors.blue,
            onTap: (index) {
              if (index == 4) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              } else {
                setState(() {
                  _currentIndex = index;
                });
                _pageController.jumpToPage(index);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHomePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            "Patients Graph",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: VerticalBarChart(data: graphData),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Appointment",
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OtherPage(userId: widget.userId)),
                  );
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var patient in filteredPatients)
                  _buildPatientCard(
                    id: patient['pid']!,
                    name: patient['name']!,
                    date: patient['date']!,
                    phno: patient['P_phno']!,
                    img: patient['img']!,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPatientCard({
    required String id,
    required String name,
    required String date,
    required String phno,
    required String img,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PatientInfo(id: id)));
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPatientDetail('ID', id),
                    _buildPatientDetail('Name', name),
                    _buildPatientDetail('Date', date),
                    _buildPatientDetail('Phno', phno),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(img),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientDetail(String key, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$key: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class VerticalBarChart extends StatelessWidget {
  final List<MonthData> data;

  VerticalBarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<MonthData, String>> series = [
      charts.Series(
        id: "Patients",
        data: data,
        domainFn: (MonthData data, _) => data.month,
        measureFn: (MonthData data, _) => data.value,
        colorFn: (MonthData data, _) {
          if (data.value <= 2) {
            return charts.MaterialPalette.green.shadeDefault;
          } else if (data.value <= 5) {
            return charts.MaterialPalette.teal.shadeDefault;
          } else if (data.value <= 6) {
            return charts.MaterialPalette.yellow.shadeDefault;
          } else {
            return charts.MaterialPalette.blue.shadeDefault;
          }
        },
        labelAccessorFn: (MonthData data, _) => '${data.value}',
      )
    ];
  // Widget build(BuildContext context) {
  //   List<charts.Series<MonthData, String>> series = [
  //   charts.Series(
  //       id: "Patients",
  //       data: data,
  //       // domainFn: (MonthData data, _) => data.month
  //     domainFn: (MonthData data, _) => data.month,
  //     measureFn: (MonthData data, _) => data.count,
  //     colorFn: (MonthData data, _) => charts.ColorUtil.fromDartColor(Colors.blue),
  //   )
  //   ];

    return charts.BarChart(
      series,
      animate: true,
      vertical: true,
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            color: charts.MaterialPalette.black,
          ),
          lineStyle: charts.LineStyleSpec(
            thickness: 0,
          ),
        ),
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredTickCount: 12,
        ),
      ),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            color: charts.MaterialPalette.black,
          ),
          lineStyle: charts.LineStyleSpec(
            thickness: 0,
          ),
        ),
      ),
    );
  }
}


class MonthData {
  final String month;
  final int value;

  MonthData(this.month, this.value);

  factory MonthData.fromJson(Map<String, dynamic> json) {
    return MonthData(
      json['month'] as String,
      int.parse(json['patients'] as String), // Ensure patients count is parsed as an integer
    );
  }
}



class OtherPage extends StatefulWidget {

  final String userId;

  OtherPage({required this.userId});

  @override
  _OtherPageState createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  late TextEditingController _searchController;
  late List<Map<String, String>> patients = [];
  late List<Map<String, String>> filteredPatients = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _fetchPatients();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      filteredPatients = patients.where((patient) =>
      patient['name']!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          patient['pid']!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          patient['P_phno']!.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    });
  }

  Future<void> _fetchPatients() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.148.130:80/test/todayappo.php'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          patients = jsonData.cast<Map<String, dynamic>>().map((json) {
            return {
              'pid': json['pid'].toString(),
              'name': json['name'].toString(),
              'date': json['date'].toString(),
              'P_phno': json['P_phno'].toString(),
              // Using the modified image URL
              'img': json['img'].toString(),
            };
          }).toList();
          filteredPatients = List.from(patients);
        });
      } else {
        throw Exception('Failed to load patients: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching patients: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to FormDoc page when back button is pressed
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CustomCardView(userId: widget.userId)),
        );
        // Return false to prevent the current screen from popping
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Patient Search',
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var patient in filteredPatients)
                        _buildPatientCard(
                          id: patient['pid']!,
                          name: patient['name']!,
                          date: patient['date']!,
                          phno: patient['P_phno']!,
                          img: patient['img']!,
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

  Widget _buildPatientCard({
    required String id,
    required String name,
    required String date,
    required String phno,
    required String img,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PatientInfo(id: id)));
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPatientDetail('ID', id),
                    _buildPatientDetail('Name', name),
                    _buildPatientDetail('Date', date ?? 'Date not available'),
                    _buildPatientDetail('Phno', phno),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 30,
                // Loading image from the modified URL
                backgroundImage: NetworkImage(img),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientDetail(String key, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$key: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

