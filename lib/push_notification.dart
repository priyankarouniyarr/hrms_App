import 'dart:convert';
import 'dart:developer';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/localnotifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';

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

  /// Generate access token from service account
  static Future<String> _getServerAccessToken() async {
    ///::: Paste your service account here :::: DOn't forget to remove this haii
    final Map<String, String> serviceAccount =
        //{
        //// YOur service.json need to be here

        //};
        {
      "type": "service_account",
      "project_id": "dynamicnotifications-2b375",
      "private_key_id": "841a22b9ab1d2b52f7c138619ae5f11adcbb980d",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDNXVpKKm3W/Apq\nKf7QtNR/sahO+FyV19K6FpsHEmYtIHW77Av07hgLWJPh4M2KFPbrqN2idAMqx8fQ\nb7a6CmQzHZnn5z3GU2ik8pnyDlmkbiO8UihKuFI0W6baI562KH7J93dbebceFNWO\nzmPL1mhzkbb9WT2xInA21E9WHevDd2paoUDGBS3uNiXCRrPrVcGOTieK3BpUcNKi\nQr0x/LzbNnSmoMlhlMAdppvwbe2Eb+oPKlyRPKISlArITNprNNT9Jeoyus70vhr3\nDJEwfhTlnyoOv/F+ys/ldb/XMsux9XSYHfMYE3Q0ANAgOIx7lnQY+XHdsAlqeHEX\nAtNhjq4pAgMBAAECggEARMlZhlEK5IEcfe3eF4sSSEk5/mWLIXeeck1DFQ3RIplm\nRhEs+hfL/vTm57g0MGWQRWQVBKaGLwymvYbFti/n2wU1uWsHkof6m5FVBjJPTVfE\n6X29WDW/9yCh1RwsO4h5221j0cSFlPJWi9ROsgZ5iwhKOjbrhorp+juH7WjtQNWD\nsVW3Pozsu+Y/qBxxx6UmhU29NEENB5Jwx24iFucp7u0dH0886MZWsD1YJiGhT/uz\nOSkOrY3PnRNN/c18hSHu/AQIoMs+5tpvG4HcVBMVzxVf075U0NgLH2aN8+K6uf1+\n8fSYl2vZaT4FLVfi7ELBhTmgxjl4BcdU3K4AhyPMHwKBgQDoN7JzzHYtvJoZoy4Q\n87O3na9tdW0YjBPH1TN+BCtaV+2I7PnUqgtqA94eeOnXOkNvfhda/fSGOLIXkI5Z\n9y9eWc7yeNwROJ7vGutYVMImxlurxVEFDrGZQnc03U/tStLNfBGtRzDl8l/IOmdw\n6UicLSPo8MAWireoJL9iJ8oxUwKBgQDiZZ+aRVe1IgX9pQcz+/FiuUxGpBTEs30a\nXBcPZieI0lpoUt1CAFiB9frviiqL3A9wFAq43ehMDUFH6YzaQXAJMic7rtbX+S4y\nyDGe8unZ1v3cMEDGrI5q6x3IDRRxY5rgugKfLqYUAHTSJJrM1tERUPu+4z5HrYC9\ntDeLZ8VHEwKBgG6jwuGLZC8schuO9O7cvh7ZAXFchmswqmgGu67p26ICzMj1Z58c\nma2cRCMupvOF7gVcBVK0NuIQd0Hk/P3+WNJSZdh/HxMRcCAqKkF+uLZywdCYhZ6s\nPo/v7A4C+AbuJHwFBgMSLUkR7vLeaNSSQacvlrFwq4TR+OkjARCKNrrDAoGAKwaT\nMXdyNrtTliPR3aBI/LEofNhcFhHiear8uvF4G/mWMvNkl1GHgJNl8DY65b+Zs3wr\nmXya1DFEsc0B9syu5SCB8kbFD+CMVhxTydhydvLz5e/Jr7hFjK5IR6estevvGDxh\nmSz9ZRm9Gd7ZCIreysKwRVPclzSzHdptH/JFvL8CgYB9zhe7mi3vAk3MQ2SczeEu\n18CSx3z2q/q6iwV5VZidQZhN0vCDFzMjr548qLJJ4JGKpSfhYEf0C2O0scmFdKJ1\nLShq32DMN3WSa8rww3dtx6wZGrZsMO4K8FHPP5urMHFjr8yNLjvutbQTkgdVqEJM\n7odUDxRY0V5PjWc5OxJktA==\n-----END PRIVATE KEY-----\n",
      "client_email":
          "dynamicemr@dynamicnotifications-2b375.iam.gserviceaccount.com",
      "client_id": "111372402143872705975",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/dynamicemr%40dynamicnotifications-2b375.iam.gserviceaccount.com",
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
