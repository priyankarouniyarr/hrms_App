import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/check_in_models/check_in_history%20.dart';

class CheckInProvider with ChangeNotifier {
  bool _loading = false;
  String _errorMessage = '';
  String? _successMessage;
  String? _latitude;
  String? _longitude;
  List<EmployeePunch> getPunches = [];
  String? _address;

  String? get aDDress => _address;
  final SecureStorageService _secureStorageService = SecureStorageService();

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get latitude => _latitude;
  String? get longitude => _longitude;

  Future<void> punchPost() async {
    _setLoading(true);
    try {
      String? token = await _secureStorageService.readData('auth_token');
      String? _fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      String? _branchId =
          await _secureStorageService.readData('workingBranchId');

      if (_branchId == null || _fiscalYear == null || token == null) {
        _setErrorMessage("No branch selected. Please select a branch.");
        return;
      }

//permission checking here

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

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
      await _secureStorageService.writeData('checkinPositionLat', _latitude!);
      await _secureStorageService.writeData('checkinPositionLong', _longitude!);

      List<Placemark> address =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (address.isNotEmpty) {
        _address =
            '${address[0].name}, ${address[0].locality}, ${address[0].administrativeArea}';
      }

      final response = await http.post(
        Uri.parse('http://45.117.153.90:5004/api/Employee/PunchPost'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "workingBranchId": _branchId,
          "fiscalYearId": _fiscalYear
        },
        body: json.encode({
          "latitude": _latitude,
          "longitude": _longitude,
        }),
      );

      if (response.statusCode == 200) {
        _setSuccessMessage("Punch  successful  ");
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

  Future<void> getpunches() async {
    _loading = true;
    notifyListeners();

    try {
      String? _branchId =
          await _secureStorageService.readData('workingBranchId');
      String? _token = await _secureStorageService.readData('auth_token');
      String? _fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (_token == null || _branchId == null || _fiscalYear == null) {
        _errorMessage = 'Missing required credentials';
        _loading = false;
        notifyListeners();
        return;
      }

      final response = await http.get(
        Uri.parse('http://45.117.153.90:5004/api/Employee/GetTodayPunches'),
        headers: {
          'Authorization': 'Bearer $_token',
          'workingBranchId': _branchId,
          'workingFinancialId': _fiscalYear,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        getPunches = jsonData.map((e) => EmployeePunch.fromJson(e)).toList();

        // Print all punch times
        // for (var punch in getPunches) {
        //   // print('Punch Time: ${punch.systemDtl}');
        // }
      } else {
        _errorMessage = "Failed to fetch punch data: ${response.statusCode}";
      }
    } catch (error) {
      _errorMessage = "Error fetching punch data: $error";
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // // Method to clear check-in data

  void _setLoading(bool value) {
    _loading = value;
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
