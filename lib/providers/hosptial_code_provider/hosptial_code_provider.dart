import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms_app/storage/hosptial_code_storage.dart';
import 'package:hrms_app/models/hosptial_code_models/hospital_code.dart';

class HospitalCodeProvider with ChangeNotifier {
  String _baseUrl = '';
  String _errorMessage = '';
  bool _isLoading = false;
  final String _applicationId = '';
  final String _hospitalCode = '';
  final HosptialCodeStorage _hospitalCodeStorage = HosptialCodeStorage();

  String get applicationId => _applicationId;
  String get baseUrl => _baseUrl;
  String get errorMessage => _errorMessage;
  String get hospitalCode => _hospitalCode;
  bool get isLoading => _isLoading;

  // Reset provider state
  void resetState() {
    _baseUrl = '';
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchBaseUrl(String hosptialcode) async {
    _isLoading = true;
    _baseUrl = ''; // Reset baseUrl before fetching
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['parent_url']}/api/CodeUrl/$hosptialcode'),
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        HospitalCode hospitalCode = HospitalCode.fromJson(decodedResponse);
        _baseUrl = hospitalCode.url;
        log("Success: Base URL fetched - $_baseUrl");
        // Store the base URL in secure storage

        //await _hospitalCodeStorage.storeHospitalCode(hospitalCode); // Store hospital code
        await _hospitalCodeStorage.storeBaseUrl(_baseUrl); // Store base URL
        String? storedBaseUrl = await _hospitalCodeStorage.getBaseUrl();
        log("Stored Base URL: $storedBaseUrl");
        notifyListeners();
      } else {
        _errorMessage = 'Invalid hospital code. Please try again.';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage =
          'An error occurred. Please check your network and try again.';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
