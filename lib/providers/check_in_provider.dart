import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:hrms_app/storage/branch_id_storage.dart';

class CheckInProvider with ChangeNotifier {
  bool _loading = false;
  String _errorMessage = '';
  String? _successMessage;

  final SecureStorageService _secureStorageService = SecureStorageService();

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<void> punchPost() async {
    _setLoading(true);
    try {
      // Fetch token from secure storage
      String? token = await _secureStorageService.readData('auth_token');
      print(token);
      if (token == null) {
        _setErrorMessage("No token found. Please log in again.");
        return;
      }

      // Fetch selected branch ID from secure storage
      String? branchId =
          await _secureStorageService.readData('workingBranchId');
      print("branch_id :$branchId");
      if (branchId == null) {
        _setErrorMessage("No branch selected. Please select a branch.");
        return;
      }

      // Fetch current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Send API request
      final response = await http.post(
        Uri.parse('http://45.117.153.90:5004/api/Employee/PunchPost'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "workingBranchId": branchId,
        },
        body: json.encode({
          "latitude": position.latitude.toString(),
          "longitude": position.longitude.toString(),
        }),
      );

      if (response.statusCode == 200) {
        _setSuccessMessage("Check-in successful!");
      } else {
        _setErrorMessage("Failed to submit check-in: ${response.statusCode}");
      }
    } catch (e) {
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

  void _setSuccessMessage(String message) {
    _successMessage = message;
    notifyListeners();
  }
}
