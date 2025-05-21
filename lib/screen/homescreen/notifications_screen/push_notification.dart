import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../firebase_options.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hrms_app/screen/homescreen/notifications_screen/localnotifications.dart';

//import 'package:push_notification_v2/local_notification_service.dart';

@immutable
final class PushNotificationManager {
  const PushNotificationManager._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Call this on app start
  static Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await _requestPermission();
    await _setupFCMToken();
    _setupForegroundListener();
    _setupBackgroundHandler();
  }

  /// Request notification permission
  static Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("✅ Notification permission granted");
    } else {
      log("❌ Notification permission denied");
    }
  }

  /// Get and log device FCM token
  static Future<void> _setupFCMToken() async {
    final token = await _messaging.getToken();
    log("📱 FCM Token: $token");
    // Save this token in /Firestore for targeted push
  }

  /// Handle foreground messages
  static void _setupForegroundListener() {
    FirebaseMessaging.onMessage.listen((message) {
      log("📥 Foreground Notification Received");
      if (message.notification != null) {
        log("🔔 Title: ${message.notification!.title}");
        log("📃 Body: ${message.notification!.body}");
        LocalNotificationService().showNotification(message);
      }
      log("📦 Data: ${message.data}");
    });
  }

  /// Background handler registration
  static void _setupBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Background handler logic
  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log("📩 Background Notification: ${message.messageId}");
  }

  /// Send notification using FCM HTTP v1 API
  static Future<void> sendNotification({
    required String deviceToken,
    required String message,
  }) async {
    try {
      final String accessToken = await _getServerAccessToken();
      const String projectId = "dynamicnotifications-2b375";

      final body = {
        "message": {
          "token": deviceToken,
          "notification": {"title": "🔥 New Notification", "body": message},
          "data": {}, // Optional custom data
        },
      };

      final response = await http.post(
        Uri.parse(
          "https://fcm.googleapis.com/v1/projects/$projectId/messages:send",
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        log("✅ Notification sent successfully");
      } else {
        log("❌ Failed to send notification: ${response.body}");
      }
    } catch (e) {
      log("❌ Failed to send notification: ${e.toString()}");
    }
  }

  // Generate access token from service account
  static Future<String> _getServerAccessToken() async {
    ///::: Paste your service account here :::: DOn't forget to remove this haii
    final Map<String, String> serviceAccount = {
      "type": "service_account",
      "project_id": "dynamicnotifications-2b375",
      "private_key_id": "93c2267f00a36b917d58356159c969dd73f093fe",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCMWvRgRJDaha2l\nUWr2QuK0FWBaLaF3n8xgYZdviMmQ0TsFdb8IReOz+8FcU0RqzWPhpJrIQMX2KTiH\n+NWqpS/zYq+qLK4B0tKfOHc6NhewH2Kht0jcn3DFNIByCYbATyTyFOVwZkvXkPYv\nekAZFPItJ3Igbe2UuCLBp0YvemHqdRrOAfEljqcU9RXwGmKyucYagbYB7neTVo7D\ntvjkP5YhXP2jh9arOnERTltCGcx6ECc0zDFCiWojpjbRSY/a8eOjITZEl6Z8P7z7\nPllGHVhdQlWqvKHVeX51LqNv7LNUM54SQWXCS+nvuA9C1vg+ccqv12g1ZBf/Pifd\nq5QScLBnAgMBAAECggEACGGvcZxGm4tww4w+0KFNO9HW+iula9OyzG1SMh/qDD2N\nF8C1/Wl8X+rV24yWwQYDmUhPfKFERnSkYpen3X6V2XlNjOJe1c8K3Y/tVsrqKTix\nQX+vgzVQ8ls18cQYiZ1wUws6abbs1TJb8UPiALLGhORzz/SgmR6nPLH04rBH7qH5\np32XkZ6wYVY0xIlbOGs8frED4/RZzteokLFNwHnLVrdHlENX9ZhS6u2IWIk34D1v\nZZ7MQLS9TVpwqXBpJ/qKa5JMcumhaXG10gS0Xjyy8s/n1ALv3sHQflxG6z0wOnG6\n8Xm3A2Gt1GeXdZI4BypxTTd19AFZs9ghTvhXDHgHYQKBgQDC6j3SyFOD3b1a5ZMo\nR3Z4keUPMeydm82SO/yCVayKJWBnZxBfuWZv/EoYPfg+gbF/HUbk9ENffsdK2+Rj\nnBmOX214JVV/S9DZQQ4N/YP5NdBmNX6ZZVg6NhLCJuSjpy9b/X5VLFOHOO7gOS47\nARZ3hcam4aIJeW6eH1FNiYA+8QKBgQC4V3alNSkKUFzmRfq9Up3Lelcwl/SRCrxU\ncUdlf7ZFtaZ8UcYvIGIAY8PKnD31v65Ug4ZPMcxU28o6kdVsldGoIkX1YZpDa59z\nkFWY3aV7h/sKTdYOx/oRinpyfM8Oln7yAOvDOBpG4v+dgfNg5YsWqKy1JuMyLmNL\nGCR2UeEU1wKBgCP3TzMezfJOL0ufgxjyntS+rxKvtqaagkNSmFSAdJcFMJXD+cyA\nDHvrhMyWWsFF8zeuck97Fxd+8E1K6AjNXBXeW/fIg886cS41h99jAUAyAuNpSZQK\nlE4hfjKfNJ9SETYbP3198WfJRKLRSkuO9tNVNwPCLMEszBGXW8w/7A8xAoGBALCW\nOHWyIwpaSWPdjYBm7/nHzFYkeoemvRo3GanFWZoVlNJqk2r5nme5Kgmg+km7wQf8\npmCe15pCocrRgJ1wN1LU4idZxCjpo+lUTmsNiER50qXgQjoOnyLGgN3DaaYTzK+O\n6kosKB/Xu/3qSnZ77W1bT3aJNgMQJNX+3o7piLApAoGAC+gu2pgkNG78YIlFY7z/\nD65F8nMRuYcIGVCyhsmhNDFnsN0C+r6qVTy3wErrRV/yNDbAy6yWJUkt52xZjiR7\n81x4k4nxQcArBJ0EEaHYCRj8MTUbRpCrUNbFp7LiuHjXmubs2nNV2Nq7K4SrhvLA\npsTJWhl1p10tLDaFd2dqT1I=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "dyamicemr@dynamicnotifications-2b375.iam.gserviceaccount.com",
      "client_id": "113674899801892389618",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/dyamicemr%40dynamicnotifications-2b375.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };
    const scopes = ["https://www.googleapis.com/auth/firebase.messaging"];

    final client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccount),
      scopes,
    );

    final credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccount),
      scopes,
      client,
    );

    client.close();
    return credentials.accessToken.data;
  }
}
