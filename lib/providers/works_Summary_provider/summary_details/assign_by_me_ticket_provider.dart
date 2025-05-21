import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/works_models/getMyTicketSummary.model.dart';

class AssignByMeTicketProvider with ChangeNotifier {
  final SecureStorageService _secureStorageService = SecureStorageService();
  String _errorMessage = '';
  bool _isLoading = false;
  TaskData? _assignByMeSummary; // Add this to hold the TaskData result

  // Getters
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  TaskData? get assignByMeSummary =>
      _assignByMeSummary; // Getter for myTicketSummary

  Future<void> fetchAssignByMeTicket() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Retrieve token, branchId, and fiscalYear from secure storage
      String? token = await _secureStorageService.readData('auth_token');
      String? branchId =
          await _secureStorageService.readData('selected_workingbranchId');
      String? fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      // Check if required data is available
      if (token == null || branchId == null || fiscalYear == null) {
        throw Exception("Missing authentication data.");
      }

      // Define the API URL
      final url = Uri.parse(
          '${dotenv.env['base_url']}api/Ticket/GetTicketAssignedToMeSummary');

      // Send GET request
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'workingBranchId': branchId,
          'workingFinancialId': fiscalYear,
        },
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        _assignByMeSummary = TaskData.fromJson(json.decode(response.body));
        _errorMessage = '';
        notifyListeners();

        // Clear any previous error messages
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
      // Handle any errors that occur
      _errorMessage =
          'An error occurred: ${e.toString()}'; // Improved error message handling
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners about the changes
    }
  }
}
