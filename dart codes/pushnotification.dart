// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class PushNotifications{
//   static final _firebaseMessaging=FirebaseMessaging.instance;
//
//
//   // request notification permission from device
//
//   static Future<void> init()async{
//     await _firebaseMessaging.requestPermission(
//        alert : true,
//        announcement : true,
//        badge : true,
//        carPlay : false,
//        criticalAlert : false,
//        provisional : false,
//        sound : true,
//     );
//   }
//   // Generating a device fcm token
//
//   final token= await _firebaseMessaging.getAPNSToken();
//   print("Device token: $token");
//   );
//
// }




import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<String> notifications;

  const NotificationsPage({Key? key, required this.notifications}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notifications[index]),
          );
        },
      ),
    );
  }
}
