import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/models/fiscalyear_id.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FiscalYearProvider with ChangeNotifier {
  bool _loading = false;
  String _errorMessage = '';
  List<FiscalYearModel> _fiscalYears = [];

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  List<FiscalYearModel> get fiscalYears => _fiscalYears;

  // Assuming you get branchId from secure storage or another source
  Future<void> fetchFiscalYears(int branchId) async {
    _setLoading(true);

    try {
      // Retrieve token from secure storage
      String? token = await _secureStorage.read(key: 'auth_token');
      print("Token: $token"); // Log token to check if it's correct

      if (token == null) {
        _setErrorMessage("No token found. Please log in again.");
        return;
      }

      final response = await http.get(
        Uri.parse('http://45.117.153.90:5004/Account/GetUserFinancialYear'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          if (branchId != null)
            "workingBranchId": branchId.toString(), // Ensure proper format
        },
      );
      print('Fiscal Year Fetch Status Code: ${response.statusCode}');
      print('Raw Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);

        if (jsonData.isEmpty) {
          _setErrorMessage("No fiscal years found.");
        } else {
          // Convert JSON data to List<FiscalYearModel>
          _fiscalYears = jsonData
              .map((fiscalYear) => FiscalYearModel.fromJson(fiscalYear))
              .toList();
          print("Fetched Fiscal Years: $_fiscalYears");
          notifyListeners();
        }
      } else {
        _setErrorMessage(
            "Failed to fetch fiscal years: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e"); // Log the error
      _setErrorMessage("Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearErrorMessage() {
    if (_errorMessage.isNotEmpty) {
      _errorMessage = '';
      notifyListeners();
    }
  }
}
