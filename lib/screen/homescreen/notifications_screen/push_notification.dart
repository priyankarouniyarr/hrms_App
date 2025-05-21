import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../firebase_options.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hrms_app/screen/homescreen/notifications_screen/localnotifications.dart';

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

  static Future<String> _getServerAccessToken() async {
    final serviceAccount = {
      'type': dotenv.env['SA_TYPE'],
      'project_id': dotenv.env['SA_PROJECT_ID'],
      'private_key': dotenv.env['SA_PRIVATE_KEY']!,
      'client_email': dotenv.env['SA_CLIENT_EMAIL'],
      'client_id': dotenv.env['SA_CLIENT_ID'],
      'auth_uri': dotenv.env['SA_AUTH_URI'],
      'token_uri': dotenv.env['SA_TOKEN_URI'],
      'auth_provider_x509_cert_url': dotenv.env['SA_AUTH_PROVIDER_CERT_URL'],
      'client_x509_cert_url': dotenv.env['SA_CLIENT_CERT_URL'],
      'universe_domain': dotenv.env['SA_UNIVERSE_DOMAIN'],
    };

    const scopes = <String>[
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    // Create an authenticated HTTP client
    final client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccount),
      scopes,
    );

    // Exchange the JWT for an access token
    final creds = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccount),
      scopes,
      client,
    );
    client.close();

    return creds.accessToken.data;
  }
}
