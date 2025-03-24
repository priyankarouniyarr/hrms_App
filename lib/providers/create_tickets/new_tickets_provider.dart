import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/createtickets/new_tickets_creation_model.dart';

class TicketProvider with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  final SecureStorageService _secureStorageService = SecureStorageService();
  String? _branchId;
  String? _token;
  String? _fiscalYear;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Future<void> createTicket(TicketCreationRequest request) async {
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
      final response = await http.post(
          Uri.parse('http://45.117.153.90:5004/api/Ticket/CreateTicketPost'),
          headers: {
            'Authorization': 'Bearer $_token',
            'workingBranchId': _branchId!,
            'workingFinancialId': _fiscalYear!,
            'Content-Type': 'application/json',
          },
          body: jsonEncode([request.toJson()]));
      if (response.statusCode == 200) {
        // Success
        _errorMessage = '';
        print('Ticket created successfully');
        notifyListeners();
      } else {
        _errorMessage = 'Failed to create ticket: ${response.body}';
      }
    } catch (error) {
      _errorMessage = "Error fetching : $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
