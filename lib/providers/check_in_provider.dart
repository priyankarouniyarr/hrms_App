import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hrms_app/storage/securestorage.dart';

class CheckInProvider with ChangeNotifier {
  bool _loading = false;
  String _errorMessage = '';
  String? _successMessage;
  String? _latitude;
  String? _longitude;
  String? _branchId;

  String? _address;
  String? _checkInTime;
  String? _checkOutTime; // Stores check-out time
  bool _isCheckedIn = false; // Flag to track if check-in is done
  String? get aDDress => _address;
  final SecureStorageService _secureStorageService = SecureStorageService();

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get branchId => _branchId;
  String? get checkInTime => _checkInTime;
  String? get checkOutTime => _checkOutTime;
  bool get isCheckedIn => _isCheckedIn; // Getter for check-in status
  void clearData() => _clearData();
  Future<void> loadCheckInData() async {
    _checkInTime = await _secureStorageService.readData('lastCheckInTime');
    print(_checkInTime);
    _checkOutTime = await _secureStorageService.readData('lastCheckOutTime');
    print(_checkOutTime);
    notifyListeners();
  }

  Future<void> punchPost() async {
    _setLoading(true);
    try {
      String? token = await _secureStorageService.readData('auth_token');
      if (token == null) {
        _setErrorMessage("No token found. Please log in again.");
        return;
      }

      _branchId = await _secureStorageService.readData('workingBranchId');
      if (_branchId == null) {
        _setErrorMessage("No branch selected. Please select a branch.");
        return;
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }
      print(serviceEnabled);

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _setErrorMessage("Location permission denied.");
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _setErrorMessage("Location permission denied forever.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      _latitude = position.latitude.toString();
      _longitude = position.longitude.toString();
      List<Placemark> address =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (address.isNotEmpty) {
        _address =
            '${address[0].name},${address[0].locality},${address[0].administrativeArea}';
      }
      print(_address);
      print(position);

      // Store Check-in or Check-out time
      String currentTime = DateFormat('hh:mm a').format(DateTime.now());

      if (!_isCheckedIn) {
        _checkInTime = currentTime;
        await _secureStorageService.writeData('lastCheckInTime', _checkInTime!);
        _isCheckedIn = true;
      } else {
        _checkOutTime = currentTime;
        await _secureStorageService.writeData(
            'lastCheckOutTime', _checkOutTime!);
        _isCheckedIn = false;
      }

      final response = await http.post(
        Uri.parse('http://45.117.153.90:5004/api/Employee/PunchPost'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "workingBranchId": _branchId!,
        },
        body: json.encode({
          "latitude": _latitude,
          "longitude": _longitude,
        }),
      );

      if (response.statusCode == 200) {
        _setSuccessMessage(_isCheckedIn
            ? "Check-in successful at $_checkInTime"
            : "Check-out successful at $_checkOutTime");
      } else {
        _setErrorMessage(
            "Failed to submit: ${response.statusCode}\n ${response.body}");
      }
    } catch (e) {
      _setErrorMessage("Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  // Method to clear check-in data
  void _clearData() {
    _checkInTime = null;
    _checkOutTime = null;

    notifyListeners();
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

  void clearSuccessMessage() {
    _successMessage = null;
    notifyListeners();
  }
}
