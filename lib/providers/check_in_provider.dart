import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:hrms_app/storage/branch_id_storage.dart';

class CheckInProvider with ChangeNotifier {
  bool _loading = false;
  String _errorMessage = '';
  String? _successMessage;
  String? _latitude;
  String? _longitude;
  String? _branchId;
  String? _userId; // Declare userId

  final SecureStorageService _secureStorageService = SecureStorageService();

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get branchId => _branchId;

  Future<void> punchPost() async {
    _setLoading(true);
    try {
      // Fetch auth token
      String? token = await _secureStorageService.readData('auth_token');
      if (token == null) {
        _setErrorMessage("No token found. Please log in again.");
        return;
      }

      // Fetch selected branch ID from secure storage
      _branchId = await _secureStorageService.readData('workingBranchId');
      print("Branch ID: $_branchId");
      if (_branchId == null) {
        _setErrorMessage("No branch selected. Please select a branch.");
        return;
      }

      // Check if location is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setErrorMessage("Location services are disabled. Please enable them.");
        return;
      }

      // Request location permission if not granted
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          _setErrorMessage("Location permission denied.");
          return;
        }
      }

      // Fetch current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      _latitude = position.latitude.toString();
      _longitude = position.longitude.toString();
      print("Latitude: $_latitude, Longitude: $_longitude");

      // Send API request with userId and branchId
      final response = await http.post(
        Uri.parse('http://45.117.153.90:5004/api/Employee/PunchPost'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "workingBranchId": _branchId!,
        },
        body: json.encode({
          "user_id": _userId, // Add user_id here
          "latitude": _latitude,
          "longitude": _longitude,
        }),
      );
      print(response.body);

      if (response.statusCode == 200) {
        _setSuccessMessage("Check-in successful for Branch ID: $_branchId!");
      } else {
        _setErrorMessage(
            "Failed to submit check-in: ${response.statusCode}\n ${response.body}");
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
    print("Loading: $_loading");
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
    print("Error: $_errorMessage");
  }

  void _setSuccessMessage(String message) {
    _successMessage = message;
    notifyListeners();
    print("Success: $_successMessage");
  }

  void clearSuccessMessage() {
    _successMessage = null;
    notifyListeners();
  }
}
