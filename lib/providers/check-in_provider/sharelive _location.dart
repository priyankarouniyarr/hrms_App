import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/storage/hosptial_code_storage.dart';


class ShareliveLocation with ChangeNotifier {
  bool _loading = false;
  String _errorMessage = '';
  String? _successMessage;
  String? _latitude;
  String? _longitude;
  String? _address;

  final SecureStorageService _secureStorageService = SecureStorageService();
  final HosptialCodeStorage _hospitalCodeStorage = HosptialCodeStorage();
  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get aDDress => _address;
  Future<String?> _getBaseUrl() async {
    return await _hospitalCodeStorage.getBaseUrl();
  }

  Future<void> _storeBaseUrl(String baseUrl) async {
    await _hospitalCodeStorage.storeBaseUrl(baseUrl);
    debugPrint("Stored Base URL of payroll: $baseUrl");
  }

  Future<void> sharelivelocation(BuildContext context) async {
    _setLoading(true);
    try {
      String? token = await _secureStorageService.readData('auth_token');
      String? fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');
      String? branchId =
          await _secureStorageService.readData('selected_workingbranchId');

      if (branchId == null || fiscalYear == null || token == null) {
        _setErrorMessage("No branch selected. Please select a branch.");
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
      final response = await http.post(
        Uri.parse('$baseUrl/api/Employee/LiveLocationSharePost'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "workingBranchId": branchId,
          "selected_fiscal_year": fiscalYear
        },
        body: json.encode({
          "latitude": _latitude,
          "longitude": _longitude,
        }),
      );
      print(_latitude);
      print(_longitude);
      if (response.statusCode == 200) {
        _setSuccessMessage("Live Location shared successfully!");
        print(successMessage);
      } else {
        _setErrorMessage(
            "Failed to submit: ${response.statusCode}\n${response.body}");
      }
      print("your result");
    } catch (e) {
      _setErrorMessage("Unexpected Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> getcurrentlocation(BuildContext context) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return false;
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

      return true;
    } catch (e) {
      _setErrorMessage("Failed to get location: $e");
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

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

  void clearErrorMessage() {
    _errorMessage = '';
    notifyListeners();
  }

  void resetLocation() {
    _latitude = null;
    _longitude = null;
  }
}
