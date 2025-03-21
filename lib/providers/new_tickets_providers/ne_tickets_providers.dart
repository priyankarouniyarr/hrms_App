import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/createtickets/new_tickets_models.dart';

// NewTicketProvider class
class NewTicketProvider extends ChangeNotifier {
  List<Tickets> categories = [];
  List<Tickets> userList = [];
  bool _isLoading = false;
  String _errorMessage = '';
  final SecureStorageService _secureStorageService = SecureStorageService();
  String? _branchId;
  String? _token;
  String? _fiscalYear;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Method to fetch ticket categories
  Future<void> fetchTicketCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Read required data from Secure Storage
      _branchId = await _secureStorageService.readData('workingBranchId');
      _token = await _secureStorageService.readData('auth_token');
      _fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (_token == null || _branchId == null || _fiscalYear == null) {
        _errorMessage = 'Missing required credentials';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Make the GET request
      final response = await http.get(
        Uri.parse('http://45.117.153.90:5004/api/Ticket/GetTicketCategories'),
        headers: {
          'Authorization': 'Bearer $_token',
          'workingBranchId': _branchId!,
          'workingFinancialId': _fiscalYear!
        },
      );
      final response1 = await http.get(
        Uri.parse('http://45.117.153.90:5004/api/Ticket/GetUserList'),
        headers: {
          'Authorization': 'Bearer $_token',
          'workingBranchId': _branchId!,
          'workingFinancialId': _fiscalYear!
        },
      );

      // Check if the response is successful
      if (response.statusCode == 200 && response1.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<dynamic> jsonData1 = json.decode(response1.body);

        // Map the JSON data to a list of TicketsCategories
        categories = jsonData.map((e) => Tickets.fromJson(e)).toList();
        userList = jsonData1.map((e) => Tickets.fromJson(e)).toList();
      } else {
        _errorMessage = "Failed to fetch ticket categories";
      }
    } catch (error) {
      _errorMessage = "Error fetching ticket categories: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
