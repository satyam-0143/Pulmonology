import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'common.dart'; // Import your common file for base URL access

class Appointment extends StatefulWidget {
  const Appointment({Key? key}) : super(key: key);

  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  PageController _pageController = PageController();
  String _status = 'Pending'; // Default status
  List<dynamic> pendingAppointments = [];
  List<dynamic> approvedAppointments = [];
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // Method to fetch appointments based on the selected status
  Future<void> fetchAppointments() async {
    try {
      // Fetch Pending appointments
      final pendingResponse = await http.post(
        Uri.parse(Pendingstatus),
        headers: {'Content-Type': 'application/json'},
      );
      if (pendingResponse.statusCode == 200) {
        setState(() {
          pendingAppointments = jsonDecode(pendingResponse.body);
        });
      } else {
        print('Failed to load pending appointments: ${pendingResponse.statusCode}');
      }

      // Fetch Approved appointments
      final approvedResponse = await http.post(
        Uri.parse(Approvedstatus),
        headers: {'Content-Type': 'application/json'},
      );
      if (approvedResponse.statusCode == 200) {
        setState(() {
          approvedAppointments = jsonDecode(approvedResponse.body);
        });
      } else {
        print('Failed to load approved appointments: ${approvedResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
    }
  }
  // Method to accept an appointment
  Future<void> acceptAppointment(String pid) async {
    final url = Acceptappointment;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'pid': pid}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          sendNotification(pid); // Send notification
          fetchAppointments(); // Refresh appointments list if the status update is successful
        } else {
          print('Failed to update appointment: ${responseData['message']}');
        }
      } else {
        print('Failed to update appointment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating appointment: $e');
    }
  }


  Future<void> sendNotification(String pid) async {
    final url = 'https://fcm.googleapis.com/fcm/send';
    final serverKey = 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCxFqQuVHCTrdf6\nRzX+Kg2bhUNMU6BgzEupwQvgR+c+TMQBKS5O8sOPbXpCyJa2AicePYRU4NY9YUU8\nvnZZd2poRxnZHi14MnqNz6dNCnzdOmCmAdsuS2BcSfWOIud9W46gqWhlafVVIilg\nAVDLS47BsNnXpCFG1/WpUMGIisWQzPI44G8hJarUegLlXNqb2YbqIXIjhCUtnD/Y\nJG6sXGxHZ/GWmidjnuXglqHO1pnwAgtMYNItWeiJeFV+2J8XxJoP18XMwUy9euEj\nzaQNjCOvuLRayNMw/8uK70ya2vqnLN00kSUflUmLMsQdCkoI3ueI7Aozcsakf8U8\n+wD6FgkFAgMBAAECggEACdlT0N0F+wiobuh//CTgzd0uN+c2XIijZ3HWB1rB/yjs\nBV6B3CBluCsWdiYyAs+a1yeeHc34mSa5Eyt9z8Fm+La5NsyWKpp86DjI04cssgcg\nC4uMSGzAk4SfgUPqspuhePw2OXgYdDj3d4a+Z7GwYyn2Htqngrxz34wfJckGCBgH\ns4rpX7fZjQFB2GjbHguAFXwgBw8FGpOo0Y3yiiaVUsRpIP2bqEHEqfHi45yvMcLU\n7tkplhSZa6Oc3g90M1pTGO9vm1YgtKAqG+vhrF+uAcjwz9iDq4MBLrBt0U9utoc7\nKeM+Ot3nHzSVmUVzlcV8XlN96IQe033j+3WXGia77wKBgQDrr/269jgAHEBBIOOx\n1h/jRtjxkDDT3VgU/j8Hnv8kf6LTeVM8FYnNm/K6Y1DhquhXiqC6B0m5TZjK/omZ\nr07My6hbVPlGFkkafSm816HGAkuSxNYVejIJh33TyUQ3mZRq2EpYr1yIlq6UNHq1\nozWNjfeIEYaldvpaFke0eIAy7wKBgQDAWcVbvyE+Id2ectT2MiyI6hYrvyRODD8D\nMDtD8RmjhmK/INemOWV4bRXLfNSEIZZye1Gj4OH0p7Pue5gqrm03Lwj681RcHlRQ\nr102PgfsFrLImUogYrS7xunwUi3LPP58IPvM34Vfv8iL9GYjEjXP2Rj41E20TGjO\nfPx1XbazSwKBgQDZVuKhTTqZB3RNWtn9/ZpMSOH36OLODPiT610OVxWrf7QUVXZn\nGumH3H56WOmWILe/Oow64EuhAKic0RrsyRfejRPEnVh9xEFHlxItHaAF68nrH27Y\nQWXxGavz6E7rAso1uRzeKWAoaOO2sapS452X2sngBWFoJo55EsCu8MwvqwKBgEZd\nEIs9YcW+0blyvGDLfesf5rheFcPPSwW5kRSLkBt3v4u3Uevmty3UidKEeaFUQBrk\n7bqLO10qM/IbmFCUujMjq59RgByqo6FYZTrAells/D3RhYJPWVoPq+hTx5i/WUDD\nOBl78uhR2eUIpIxTzweXnUD5OOupv/U5V4j/nSP9AoGAEm/5D5xzOVc83gvto1Ga\n+YqbosfS8wFzTPi8KG2mZsRuuTtGgKYe8vq3bg1KphsmVCyN9htGO1GC+n2W4wpl\n+ioMaBJUT7Fhi1YRTeMINfxItESc71yQ6tpLdsGAY1PBCh1evxcqkduz2WiPJBNr\n1Em5keZD8udvCzS9unAQJPY=",';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode({
          'to': '/topics/appointments',
          'notification': {
            'title': 'Appointment Approved',
            'body': 'Your appointment with PID: $pid has been approved.',
          },
          'data': {
            'pid': pid,
          },
        }),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAppointments();
    _firebaseMessaging.subscribeToTopic("appointments");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Appointment Booking',
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
      body: Column(
        children: [
          _buildStatusButtons(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _status = index == 0 ? 'Pending' : 'Approved';
                });
              },
              children: [
                // Pending Page
                _buildAppointmentsList(pendingAppointments),
                // Approved Page
                _buildAppointmentsList(approvedAppointments),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method to build status buttons
  // Method to build status buttons
  Widget _buildStatusButtons() {
    return Row(
      children: [
        // Pending button
        Expanded(
          child: StatusButton(
            text: 'Pending',
            isSelected: _status == 'Pending',
            onTap: () {
              _pageController.animateToPage(
                0,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ),
        // Approved button
        Expanded(
          child: StatusButton(
            text: 'Approved',
            isSelected: _status == 'Approved',
            onTap: () {
              _pageController.animateToPage(
                1,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ),
      ],
    );
  }


  // Method to build appointments list
  Widget _buildAppointmentsList(List<dynamic> appointments) {
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 10),
          elevation: 3,
          child: ListTile(
            title: Text('Name: ${appointment['name']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PID: ${appointment['pid']}'),
                Text('Date: ${appointment['date']}'),
                Text('Status: ${appointment['status']}'),
              ],
            ),
            trailing: appointment['status'] == 'pending'
                ? ElevatedButton(
              onPressed: () {
                // Show AlertDialog for confirmation
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Confirm Appointment'),
                      content: Text(
                        'Are you sure you want to accept this appointment?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            acceptAppointment(appointment['pid']);
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Accept'),
            )
                : null,
          ),
        );
      },
    );
  }
}

class StatusButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const StatusButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? (text == 'Pending' ? Colors.red : Colors.green) : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
