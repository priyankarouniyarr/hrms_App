import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
          await _secureStorageService.readData('selected_workingbranchId');

      if (_branchId == null || _fiscalYear == null || token == null) {
        _setErrorMessage("No branch selected. Please select a branch.");
        return;
      }

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

      List<Placemark> address =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (address.isNotEmpty) {
        _address =
            '${address[0].name}, ${address[0].locality}, ${address[0].administrativeArea}';
      }

      final response = await http.post(
        Uri.parse('${dotenv.env['base_url']}api/Employee/PunchPost'),
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
    } on SocketException catch (e) {
      if (e.osError != null && e.osError!.errorCode == 101) {
        _errorMessage =
            'Network is unreachable. Please check your internet connection.';
      } else {
        _errorMessage = 'Network error: ${e.message}';
      }
      print("SocketException: $_errorMessage");
    } catch (e) {
      _setErrorMessage("Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getcurrentlocation() async {
    _setLoading(true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _latitude = position.latitude.toString();
      _longitude = position.longitude.toString();

      await _secureStorageService.writeData('checkinPositionLat', _latitude!);
      await _secureStorageService.writeData('checkinPositionLong', _longitude!);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        _address =
            '${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea}';
      }
    } on SocketException catch (e) {
      if (e.osError != null && e.osError!.errorCode == 101) {
        _errorMessage =
            'Network is unreachable. Please check your internet connection.';
      } else {
        _errorMessage = 'Network error: ${e.message}';
      }
      print("SocketException: $_errorMessage");
    } catch (e) {
      _setErrorMessage("Failed to get location: $e");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> getpunches(BuildContext context) async {
    _loading = true;
    notifyListeners();

    try {
      String? _branchId =
          await _secureStorageService.readData('selected_workingbranchId');
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
        Uri.parse('${dotenv.env['base_url']}api/Employee/GetTodayPunches'),
        headers: {
          'Authorization': 'Bearer $_token',
          'workingBranchId': _branchId,
          'workingFinancialId': _fiscalYear,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        getPunches = jsonData.map((e) => EmployeePunch.fromJson(e)).toList();
      } else {
        _errorMessage = "Failed to fetch punch data: ${response.statusCode}";
      }
    } on SocketException catch (e) {
      if (e.osError != null && e.osError!.errorCode == 101) {
        _errorMessage =
            'Network is unreachable. Please check your internet connection.';
      } else {
        _errorMessage = 'Network error: ${e.message}';
      }
      print("SocketException: $_errorMessage");
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
