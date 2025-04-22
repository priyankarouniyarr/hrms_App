import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMsg {
  final msgService = FirebaseMessaging.instance;
  initFCM() async {
    await msgService.requestPermission();
    var token = msgService.getToken();
    print("FCM Token: $token");
    print("hello");

    FirebaseMessaging.onBackgroundMessage(handleNotification);
    FirebaseMessaging.onMessage.listen((handleNotification));
  }
}

Future<void> handleNotification(RemoteMessage message) async {}
