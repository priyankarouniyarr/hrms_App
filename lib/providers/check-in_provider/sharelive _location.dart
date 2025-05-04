import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hrms_app/storage/securestorage.dart';

class ShareliveLocation with ChangeNotifier {
  bool _loading = false;
  String _errorMessage = '';
  String? _successMessage;
  String? _latitude;
  String? _longitude;
  String? _address;

  final SecureStorageService _secureStorageService = SecureStorageService();

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get aDDress => _address;

  Future<void> sharelivelocation() async {
    _setLoading(true);
    try {
      String? token = await _secureStorageService.readData('auth_token');
      String? fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');
      String? branchId =
          await _secureStorageService.readData('workingBranchId');

      if (branchId == null || fiscalYear == null || token == null) {
        _setErrorMessage("No branch selected. Please select a branch.");
        return;
      }

      final response = await http.post(
        Uri.parse(
            'http://45.117.153.90:5004/api/Employee/LiveLocationSharePost'),
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

      if (response.statusCode == 200) {
        _setSuccessMessage("Live Location shared successfully!");
      } else {
        _setErrorMessage(
            "Failed to submit: ${response.statusCode}\n${response.body}");
      }
    } catch (e) {
      _setErrorMessage("Unexpected Error: $e");
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

        return sharelivelocation();
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return sharelivelocation();
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
    } catch (e) {
      _setErrorMessage("Failed to get location: $e");
    } finally {
      _setLoading(false);
    }

    Future.microtask(() => notifyListeners());
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

  void stopLiveLocation() {
    _loading = false;
    notifyListeners();
  }
}
