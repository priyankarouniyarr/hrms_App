import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationFirebase.instance._setupFlutterNotifications();
  await NotificationFirebase.instance.showNotification(message);
}

class NotificationFirebase {
  NotificationFirebase._();
  static final NotificationFirebase instance = NotificationFirebase._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isFlutterLocalNotificationInitialized = false;

  Future<void> initialize() async {
    // Initialize Firebase if not already done
    await Firebase.initializeApp();
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    // Ask for notification permissions
    await _requestPermission();
    // Setup local notification settings
    await _setupFlutterNotifications();
    // Handle foreground and opened messages
    await _setupMessageHandlers();

    // Get and print FCM token
    final token = await _messaging.getToken();
    print("FCM Token: $token");
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
      announcement: true,
      criticalAlert: true,
      carPlay: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("✅ Notification permission granted");
    } else {
      print("❌ Notification permission denied");
    }
  }

  Future<void> _setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationInitialized) return;

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitSettings = DarwinInitializationSettings();

    final initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) async {
        // Handle notification tap
        print("Notification Tapped with payload: ${details.payload}");
      },
    );

    _isFlutterLocalNotificationInitialized = true;
  }

  Future<void> _setupMessageHandlers() async {
    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received: ${message.notification?.title}");
      showNotification(message);
    });

    // App opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleMessage(message);
    });

    // App opened from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(initialMessage);
    }
  }

  void handleMessage(RemoteMessage message) {
    print("Notification tapped. Data: ${message.data}");
  }

  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }
}
