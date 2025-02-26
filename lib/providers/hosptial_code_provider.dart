import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/models/hospital_code.dart';

class HospitalCodeProvider with ChangeNotifier {
  String _baseUrl = '';
  String _errorMessage = '';
  bool _isLoading =
      false; //A flag indicating whether an API request is in progress

  String get baseUrl => _baseUrl;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> fetchBaseUrl(String code) async {
    _isLoading = true; // Indicate that a request is in progress
    notifyListeners();
    print("hello");
    try {
      final response = await http
          .get(Uri.parse('http://45.117.153.90:5005/api/CodeUrl/$code'));
      print(response.body);

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        HospitalCode hospitalCode = HospitalCode.fromJson(decodedResponse);

        _baseUrl = hospitalCode.url;
        //  print(_baseUrl);
        notifyListeners();
      } else {
        _errorMessage = 'Invalid hospital code. Please try again.';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage =
          'An error occurred. Please check your network and try again.';
      notifyListeners();
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
