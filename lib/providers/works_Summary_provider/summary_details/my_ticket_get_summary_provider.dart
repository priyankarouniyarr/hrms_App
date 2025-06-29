import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/storage/hosptial_code_storage.dart';
import 'package:hrms_app/models/works_models/getMyTicketSummary.model.dart';

class MyTicketGetSummaryProvider with ChangeNotifier {
  final SecureStorageService _secureStorageService = SecureStorageService();
  final HosptialCodeStorage _hospitalCodeStorage = HosptialCodeStorage();
  String _errorMessage = '';
  bool _isLoading = false;
  TaskData? _myTicketSummary; // Add this to hold the TaskData result

  // Getters
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  TaskData? get myTicketSummary => _myTicketSummary;
  Future<String?> _getBaseUrl() async {
    return await _hospitalCodeStorage.getBaseUrl();
  }

  Future<void> _storeBaseUrl(String baseUrl) async {
    await _hospitalCodeStorage.storeBaseUrl(baseUrl);
    debugPrint("Stored Base URL: $baseUrl");
  }

  // Fetch Current Month Salary
  Future<void> fetchMyTicket() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      String? token = await _secureStorageService.readData('auth_token');
      String? branchId =
          await _secureStorageService.readData('selected_workingbranchId');
      String? fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (token == null || branchId == null || fiscalYear == null) {
        throw Exception("Missing authentication data.");
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

      final url = Uri.parse('$baseUrl/api/Ticket/GetMyTicketSummary');

      // Send GET request
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'workingBranchId': branchId,
          'workingFinancialId': fiscalYear,
        },
      );

      if (response.statusCode == 200) {
        _myTicketSummary = TaskData.fromJson(json.decode(response.body));
        _errorMessage = '';
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load ticket summary';
      }
    } on SocketException catch (e) {
      if (e.osError != null && e.osError!.errorCode == 101) {
        _errorMessage =
            'Network is unreachable. Please check your internet connection.';
      } else {
        _errorMessage = 'Network error: ${e.message}';
      }
      print("SocketException: $_errorMessage");
    } catch (e) {
      _errorMessage = 'An error occurred: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
