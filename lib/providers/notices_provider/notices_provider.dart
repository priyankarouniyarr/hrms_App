import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/storage/hosptial_code_storage.dart';
import 'package:hrms_app/models/notices_models/notices_models.dart';

class NoticesProvider with ChangeNotifier {
  List<Notices> _notices = [];
  String _errorMessage = '';
  List<Notices> get notices => _notices;

  String get errorMessage => _errorMessage;
  final SecureStorageService _secureStorageService = SecureStorageService();
  final HosptialCodeStorage _hospitalCodeStorage = HosptialCodeStorage();
  Future<String?> _getBaseUrl() async {
    return await _hospitalCodeStorage.getBaseUrl();
  }

  Future<void> _storeBaseUrl(String baseUrl) async {
    await _hospitalCodeStorage.storeBaseUrl(baseUrl);
    debugPrint("Stored Base URL: $baseUrl");
  }

  Future<void> fetchNotice() async {
    try {
      final branchId =
          await _secureStorageService.readData('selected_workingbranchId');

      final token = await _secureStorageService.readData('auth_token');
      final fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (branchId == null || token == null || fiscalYear == null) {
        throw Exception('No branchId or token found');
      }
      final baseUrl = await _getBaseUrl();
      if (baseUrl == null) {
        _errorMessage =
            ('Base URL not found. Please enter hospital code again.');
        notifyListeners();

        return;
      }

      // Store the base URL to ensure it’s persisted
      await _storeBaseUrl(baseUrl);
      final response = await http.get(
        Uri.parse('$baseUrl/api/Notice/GetAllNotices'),
        headers: {
          'Authorization': 'Bearer $token',
          "workingBranchId": branchId,
          "workingFinancialId": fiscalYear,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> noticedata = json.decode(response.body);
        _notices = noticedata.map((data) => Notices.fromJson(data)).toList();
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load notices';
      }
    } catch (error) {
      _errorMessage = 'Error: $error';
      print("Error: $error");
    }
  }

  Future<void> fetchNoticesbyId() async {
    try {
      final branchId =
          await _secureStorageService.readData('selected_workingbranchId');
      final token = await _secureStorageService.readData('auth_token');
      final fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (branchId == null || token == null || fiscalYear == null) {
        throw Exception('No branchId or token found');
      }
      final baseUrl = await _getBaseUrl();
      if (baseUrl == null) {
        _errorMessage =
            ('Base URL not found. Please enter hospital code again.');
        notifyListeners();

        return;
      }

      // Store the base URL to ensure it’s persisted
      await _storeBaseUrl(baseUrl);

      final response = await http.get(
        Uri.parse('$baseUrl/api/Notice/GetNoticeById/1'),
        headers: {
          'Authorization': 'Bearer $token',
          "workingBranchId": branchId,
          "workingFinancialId": fiscalYear,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> holidayData = json.decode(response.body);

        _notices = holidayData.map((data) => Notices.fromJson(data)).toList();
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load notices';
      }
    } catch (error) {
      _errorMessage = 'Error: $error';
      print("Error: $error");
    }
  }
}
