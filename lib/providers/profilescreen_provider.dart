import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/profiles.models.dart';

class ProfileScreenProvider with ChangeNotifier {
  final SecureStorageService secureStorageService = SecureStorageService();

  Employee? _employee;
  bool _isLoading = false;
  String? _errorMessage;

  Employee? get employee => _employee;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchEmployeeProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      String? token = await secureStorageService.readData('auth_token');
      String? branchId = await secureStorageService.readData('workingBranchId');

      if (token == null || branchId == null) {
        _errorMessage = 'Token or BranchId is missing';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final url =
          Uri.parse('http://45.117.153.90:5004/api/Employee/GetEmployeeDetail');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'workingBranchId': branchId,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        _employee = Employee.fromJson(data);
        _errorMessage = null;
      } else {
        throw Exception(
            "Failed to load profile. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      _errorMessage = "Error fetching profile: $e";
    }

    _isLoading = false;
    notifyListeners();
  }
}
