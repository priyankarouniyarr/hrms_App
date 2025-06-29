import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/storage/hosptial_code_storage.dart';
import 'package:hrms_app/models/createtickets/new_tickets_models.dart';

// NewTicketProvider class
class NewTicketProvider extends ChangeNotifier {
  List<Tickets> categories = [];
  List<Tickets> userList = [];
  bool _isLoading = false;
  String _errorMessage = '';
  final SecureStorageService _secureStorageService = SecureStorageService();
  final HosptialCodeStorage _hospitalCodeStorage = HosptialCodeStorage();
  String? _branchId;
  String? _token;
  String? _fiscalYear;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Future<String?> _getBaseUrl() async {
    return await _hospitalCodeStorage.getBaseUrl();
  }

  Future<void> _storeBaseUrl(String baseUrl) async {
    await _hospitalCodeStorage.storeBaseUrl(baseUrl);
    debugPrint("Stored Base URL of payroll: $baseUrl");
  }

  // Method to fetch ticket categories
  Future<void> fetchTicketCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Read required data from Secure Storage
      _branchId =
          await _secureStorageService.readData('selected_workingbranchId');
      _token = await _secureStorageService.readData('auth_token');
      _fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');
      print(_branchId);
      print(_token);
      print(_fiscalYear);

      if (_token == null || _branchId == null || _fiscalYear == null) {
        _errorMessage = 'Missing required credentials';
        _isLoading = false;
        notifyListeners();
        return;
      }
      final baseUrl = await _getBaseUrl();
      if (baseUrl == null) {
        _errorMessage = 'No base URL found';
        notifyListeners();
        return;
      }
      // Store the base URL to ensure it’s persisted
      await _storeBaseUrl(baseUrl);

      // Make the GET request
      final response = await http.get(
        Uri.parse('$baseUrl/api/Ticket/GetTicketCategories'),
        headers: {
          'Authorization': 'Bearer $_token',
          'workingBranchId': _branchId!,
          'workingFinancialId': _fiscalYear!
        },
      );
      final response1 = await http.get(
        Uri.parse('$baseUrl/api/Ticket/GetUserList'),
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
