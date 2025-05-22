import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms_app/storage/securestorage.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class FcmnotificationProvider with ChangeNotifier {
  String? _fcmToken;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? get fcmToken => _fcmToken;

  final SecureStorageService _secureStorageService = SecureStorageService();

  static Future<String> getAcessToken() async {
    final serviceAccountJson = {
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
    List<String> scopes = [
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );
    //get the access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );
    client.close();
    return credentials.accessToken.data;
  }

  Future<void> sendFcmTokenToServer(
      String fcmToken, String applicationId) async {
    final String severkey = await getAcessToken();

    final Map<String, String> messagePayload = {
      'Token': fcmToken,
      'ApplicationId': applicationId,
    };
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
          // '${dotenv.env['base_url']}api/FcmDeviceToken/DeviceTokenPost/${dotenv.env['SA_PROJECT_ID']}/messages:send');
          '${dotenv.env['base_url']}api/FcmDeviceToken/DeviceTokenPost');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
        'workingBranchId': branchId,
        'workingFinancialId': fiscalYear,
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(messagePayload),
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('FCM token sent successfully');
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
    final String severkey = await getAcessToken();
    try {
      _isLoading = true;
      notifyListeners();

      final url = Uri.parse(
          // '${dotenv.env['base_url']}api/FcmDeviceToken/DeviceTokenPostAnonymous//${dotenv.env['SA_PROJECT_ID']}/messages:send');
          '${dotenv.env['base_url']}api/FcmDeviceToken/DeviceTokenPostAnonymous');

      final headers = {
        'Content-Type': 'application/json',
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
        print('FCMDeviceTokenPostAnonymous token sent successfully');
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
