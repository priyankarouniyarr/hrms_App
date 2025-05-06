import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';

class FcmnotificationProvider with ChangeNotifier {
  String? _fcmToken;
  bool _isLoading = false; // Loading indicator
  bool get isLoading => _isLoading;
  String? get fcmToken => _fcmToken;
//device token
  final SecureStorageService _secureStorageService = SecureStorageService();

  // Private method to send the FCM token to the server
  Future<void> sendFcmTokenToServer(
      String fcmToken, String applicationId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Fetch stored data (branchId, authToken, fiscalYear)
      final branchId =
          await _secureStorageService.readData('selected_workingbranchId');
      final authToken = await _secureStorageService.readData('auth_token');
      final fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (branchId == null || authToken == null || fiscalYear == null) {
        print('Error: branchId, authToken, or fiscalYear is null');
        _isLoading = false;
        notifyListeners();
        return; // Early return if any of these are null
      }

      final url = Uri.parse(
          'http://45.117.153.90:5004/api/FcmDeviceToken/DeviceTokenPost');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
        'selected_workingbranchId': branchId,
        'selected_fiscal_year': fiscalYear,
      };

      final body = jsonEncode({
        "Token": fcmToken,
        "ApplicationId": applicationId,
      });

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('FCM token sent successfully: $fcmToken');
        _isLoading = false;
        notifyListeners();
      } else {
        print('Failed to send FCM token: ${response.body}');
        _isLoading = false;
        notifyListeners();
      }
    } catch (error) {
      print('Error occurred while sending FCM token: $error');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendFcmDeviceTokenPostAnonymous(
      String fcmDeviceTokenPostAnonymous, String applicationId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final branchId =
          await _secureStorageService.readData('selected_workingbranchId');
      final authToken = await _secureStorageService.readData('auth_token');
      final fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (branchId == null || authToken == null || fiscalYear == null) {
        print('Error: branchId, authToken, or fiscalYear is null');
        _isLoading = false;
        notifyListeners();
        return;
      }

      final url = Uri.parse(
          'http://45.117.153.90:5004/api/FcmDeviceToken/DeviceTokenPostAnonymous');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
        'selected_workingbranchId': branchId,
        'selected_fiscal_year': fiscalYear,
      };

      final body = jsonEncode({
        "Token": fcmDeviceTokenPostAnonymous,
        "ApplicationId": applicationId,
      });

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print(
            'FCMDeviceTokenPostAnonymous token sent successfully: $fcmDeviceTokenPostAnonymous');
        _isLoading = false;
        notifyListeners();
      } else {
        print('Failed to send FCM token: ${response.body}');
        _isLoading = false;
        notifyListeners();
      }
    } catch (error) {
      print('Error occurred while sending FCM token: $error');
      _isLoading = false;
      notifyListeners();
    }
  }
}
