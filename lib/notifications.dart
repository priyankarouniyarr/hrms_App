import 'package:hrms_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin flutterLocalNotoficationsPlugin =
      FlutterLocalNotificationsPlugin();
// To check if app was launched via notification from terminated state
  static bool openedFromNotification = false;
  //handles message when the app is in the background or terminated
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    //firebase must be initalized in background isolate
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //Initalize local notifications plugin and show notification
    await _initalizelocalNotification();
    await _showFlutterNotifications(message);
  }

//initalizes firebase messaging and local notifications
  static Future<void> initalizeNotifications() async {
    await _firebaseMessaging.requestPermission();

    //called when message is recieved while app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _showFlutterNotifications(message);
    });

    //called when app is brought to foreground from background by tapping a notification
    FirebaseMessaging.onMessageOpenedApp.listen((
      RemoteMessage message,
    ) {});
    await _getFcmToken();
    //intailize the local notifications plugins
    await _initalizelocalNotification();
    //check if app was launched by tapping on a notification
    await _getInitalNotification();
  }

//fetches and prints fcm token (optional )
  static Future<void> _getFcmToken() async {
    String? token = await _firebaseMessaging.getToken();
    print("fcm token : $token");
    // use this token to send messages
  }

  //show a local notifications when a message is recived
  static Future<void> _showFlutterNotifications(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    Map<String, dynamic>? data = message.data;
    String title = notification?.title ?? data['title'] ?? 'No title';
    String body = notification?.body ?? data['body'] ?? 'No body';

    //android notifications config
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'Notifications channel for basic tests',
      priority: Priority.high,
      importance: Importance.high,
    );

    //ios  notifications confrig
    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    //combine platform -specfic settings
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    //show notifications
    await flutterLocalNotoficationsPlugin.show(
      0, //notificationid
      title,
      body,
      notificationDetails,
    );
  }

  //initialize the local notifications system (both andorid and ios)
  static Future<void> _initalizelocalNotification() async {
    const AndroidInitializationSettings androidInt =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    final InitializationSettings initSettings =
        InitializationSettings(android: androidInt, iOS: iosInit);
    await flutterLocalNotoficationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (
      NotificationResponse response,
    ) {
      print('Notification tapped:${response.payload}');
    });
  }

  //handles notification tap when app is terminated
  static Future<void> _getInitalNotification() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      print(
          "App launched from terminated state via notification :${message.data}");
    } else {
      print("App launchednot normally");
    }
  }
}
