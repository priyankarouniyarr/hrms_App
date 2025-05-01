import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hrms_app/providers/notifications/notification_provider.dart';

class TokenStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Store access token securely
  Future<void> storeToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  // Retrieve access token securely with try-catch
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: 'auth_token');
    } catch (e) {
      // print("Error reading auth token: $e");
      return null;
    }
  }

  // Remove access token securely
  Future<void> removeToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  // Store refresh token securely
  Future<void> storeRefreshToken(String refreshToken) async {
    await _secureStorage.write(key: 'refresh_token', value: refreshToken);
  }

  // Retrieve refresh token securely with try-catch
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: 'refresh_token');
    } catch (e) {
      // print("Error reading refresh token: $e");
      return null;
    }
  }

  // Remove refresh token securely
  Future<void> removeRefreshToken() async {
    await _secureStorage.delete(key: 'refresh_token');
  }

  // Store username
  Future<void> storeUsername(String username) async {
    await _secureStorage.write(key: 'username', value: username);
  }

  // Retrieve username securely with try-catch
  Future<String?> getUsername() async {
    try {
      return await _secureStorage.read(key: 'username');
    } catch (e) {
      return null;
    }
  }

//Stores the expiration time of the token
  Future<void> storeExpiationTime(DateTime time) async {
    await _secureStorage.write(key: 'expiration_time', value: time.toString());
  }

  // Retrieves the expiration time of the token securely with try-catch
  Future<DateTime?> getExpirationtime() async {
    try {
      final response = await _secureStorage.read(key: 'expiration_time');
      if (response != null) {
        return DateTime.parse(response);
      }
    } catch (e) {
      // print("Error reading auth token: $e");
    }
    return null;
  }

  // Fetch and store the FCM token
  Future<void> getfcmToken(BuildContext context) async {
    String? fcmtoken = await _firebaseMessaging.getToken();
    if (fcmtoken != null) {
      print("FCM Token: $fcmtoken");
      await _saveTokenfcm(fcmtoken, context);
      print("hlo :$fcmtoken"); // Save token to secure storage
    }
  }

  Future<void> _saveTokenfcm(String fcmtoken, BuildContext context) async {
    await _secureStorage.write(key: 'fcm_token', value: fcmtoken);
    print("Stored FCM token locally: $fcmtoken");

    try {
      final notificationProvider =
          Provider.of<FcmnotificationProvider>(context, listen: false);

      final hospitalCode = await getHospitalCode();
      print("hosptialcode: $hospitalCode");

      if (hospitalCode != null) {
        await notificationProvider.sendFcmTokenToServer(fcmtoken, hospitalCode);
        print("FCM token successfully sent to server.");
      } else {
        print("Hospital code not found. Cannot send FCM token.");
      }
    } catch (e) {
      print('Error sending FCM token to server: $e');
    }
  }

  Future<void> getfcmDeviceTokenPostAnynomus(BuildContext context) async {
    String? fcmDeviceTokenPostAnynomus = await _firebaseMessaging.getToken();
    if (fcmDeviceTokenPostAnynomus != null) {
      print("FCM Token: $fcmDeviceTokenPostAnynomus");
      await _saveDeviceTokenPostAnynomus(fcmDeviceTokenPostAnynomus, context);
      print("hlo :$fcmDeviceTokenPostAnynomus");
    }
  }

  Future<void> _saveDeviceTokenPostAnynomus(
      String fcmDeviceTokenPostAnynomus, BuildContext context) async {
    await _secureStorage.write(
        key: 'fcm_token', value: fcmDeviceTokenPostAnynomus);
    print("Stored FCM token locally: $fcmDeviceTokenPostAnynomus");

    try {
      final notificationProvider =
          Provider.of<FcmnotificationProvider>(context, listen: false);

      final hospitalCode = await getHospitalCode();
      print("hosptialcode: $hospitalCode");

      if (hospitalCode != null) {
        await notificationProvider.sendFcmTokenToServer(
            fcmDeviceTokenPostAnynomus, hospitalCode);
        print("FCM token successfully sent to server.");
      } else {
        print("Hospital code not found. Cannot send FCM token.");
      }
    } catch (e) {
      print('Error sending FCM token to server: $e');
    }
    print("fcmtoken: $fcmDeviceTokenPostAnynomus");
  }

// Store hospital code securely
  Future<void> storeHospitalCode(String hospitalCode) async {
    await _secureStorage.write(key: 'hospital_code', value: hospitalCode);
  }

  // Retrieve hospital code securely
  Future<String?> getHospitalCode() async {
    try {
      return await _secureStorage.read(key: 'hospital_code');
    } catch (e) {
      print("Error reading hospital code: $e");
      return null;
    }
  }

  Future<void> removeHospitalCode() async {
    await _secureStorage.delete(key: 'hospital_code');
  }
}
