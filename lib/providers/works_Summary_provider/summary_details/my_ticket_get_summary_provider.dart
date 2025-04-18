import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/works_models/getMyTicketSummary.model.dart';

class MyTicketGetSummaryProvider with ChangeNotifier {
  final SecureStorageService _secureStorageService = SecureStorageService();
  String _errorMessage = '';
  bool _isLoading = false;
  TaskData? _myTicketSummary; // Add this to hold the TaskData result

  // Getters
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  TaskData? get myTicketSummary => _myTicketSummary;

  // Fetch Current Month Salary
  Future<void> fetchMyTicket() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      String? token = await _secureStorageService.readData('auth_token');
      String? branchId =
          await _secureStorageService.readData('workingBranchId');
      String? fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      // Check if required data is available
      if (token == null || branchId == null || fiscalYear == null) {
        throw Exception("Missing authentication data.");
      }

      // Define the API URL
      final url =
          Uri.parse('http://45.117.153.90:5004/api/Ticket/GetMyTicketSummary');

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
        // Parse the response and update the _myTicketSummary variable
        _myTicketSummary = TaskData.fromJson(json.decode(response.body));
        _errorMessage = '';
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load ticket summary';
      }
    } catch (e) {
      _errorMessage =
          'An error occurred: ${e.toString()}'; // Improved error message handling
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners about the changes
    }
  }
}
