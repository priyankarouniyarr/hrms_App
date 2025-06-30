import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms_app/storage/securestorage.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:hrms_app/storage/hosptial_code_storage.dart';
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class FcmnotificationProvider with ChangeNotifier {
  String? _fcmToken;
  bool _isLoading = false;
  String _errorMessage = '';
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String? get fcmToken => _fcmToken;

  final SecureStorageService _secureStorageService = SecureStorageService();
  final HosptialCodeStorage _hospitalCodeStorage = HosptialCodeStorage();

  Future<String?> _getBaseUrl() async {
    return await _hospitalCodeStorage.getBaseUrl();
  }

  Future<void> _storeBaseUrl(String baseUrl) async {
    await _hospitalCodeStorage.storeBaseUrl(baseUrl);
    log("Stored Base URL of notifications_baseurl: $baseUrl");
  }

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
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );
    client.close();
    return credentials.accessToken.data;
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Set error message
  void setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
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

      final baseUrl = await _getBaseUrl();
      if (baseUrl == null) {
        _errorMessage = 'Base URL not found. Please enter hospital code again.';
        _isLoading = false;
        notifyListeners();
        return;
      }
      await _storeBaseUrl(baseUrl);

      final branchId =
          await _secureStorageService.readData('selected_workingbranchId');
      final authToken = await _secureStorageService.readData('auth_token');
      final fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (branchId == null || authToken == null || fiscalYear == null) {
        print('Error: branchId, authToken, or fiscalYear is null');
        _errorMessage = 'Required authentication data is missing.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final url = Uri.parse('$baseUrl/api/FcmDeviceToken/DeviceTokenPost');
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
        _errorMessage = '';
        _isLoading = false;
        notifyListeners();
      } else {
        print('Failed to send FCM token: ${response.body}');
        _errorMessage = 'Failed to send FCM token: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
      }
    } catch (error) {
      print('Error occurred while sending FCM token: $error');
      _errorMessage = 'Error occurred while sending FCM token: $error';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendFcmDeviceTokenPostAnonymous(
      String fcmDeviceTokenPostAnonymous, String applicationId) async {
    final String severkey = await getAcessToken();
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      // Check if applicationId is not null or empty
      if (applicationId.isEmpty) {
        _errorMessage = 'Application ID (Hospital Code) cannot be empty.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final baseUrl = await _getBaseUrl();
      log('FCM Token1: $fcmDeviceTokenPostAnonymous');
      log('Application ID2: $applicationId');
      log('Base URL3: $baseUrl');

      if (baseUrl == null) {
        _errorMessage = 'Base URL not found. Please enter hospital code again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      await _storeBaseUrl(baseUrl);

      final url =
          Uri.parse('$baseUrl/api/FcmDeviceToken/DeviceTokenPostAnonymous');
      log('Request URL: $url');

      final headers = {
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        "Token": fcmDeviceTokenPostAnonymous,
        "ApplicationId": applicationId,
      });

      log('Request Body: $body');

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        log('FCMDeviceTokenPostAnonymous token sent successfully');
        _errorMessage = '';
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        log('Failed to send FCM token: ${response.body}');
        _errorMessage = 'Failed to send FCM token: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (error) {
      log('Error occurred while sending FCM token: $error');
      _errorMessage = 'Error occurred: $error';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
