import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:hrms_app/models/check_inmodels.dart';
import 'package:hrms_app/providers/branch_id_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CheckInProvider with ChangeNotifier {
  bool _loading = false;
  String _errorMessage = '';
  String? _successMessage;

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final BranchProvider _branchProvider;

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  CheckInProvider(this._branchProvider);

  Future<void> punchPost() async {
    _setLoading(true);

    try {
      String? token = await _secureStorage.read(key: 'auth_token');
      if (token == null) {
        _setErrorMessage("No token found. Please log in again.");
        return;
      }

      String? branchId = _branchProvider.selectedBranchId;
      if (branchId == null) {
        _setErrorMessage("No branch selected.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      CheckIn checkInData = CheckIn(
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
      );

      final response = await http.post(
        Uri.parse('http://45.117.153.90:5004/api/Employee/PunchPost'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "BranchId": branchId,
        },
        body: json.encode(checkInData.toJson()),
      );

      print('Punch Post Status Code: ${response.statusCode}');
      print('Punch Post Response: ${response.body}');

      if (response.statusCode == 200) {
        _setSuccessMessage(
            "Check-in successful! Location: ${position.latitude}, ${position.longitude}");
        print('Location: ${position.latitude}, ${position.longitude}');
      } else {
        _setErrorMessage("Failed to submit check-in");
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

  void clearErrorMessage() {
    if (_errorMessage.isNotEmpty) {
      _errorMessage = '';
      notifyListeners();
    }
  }
}
