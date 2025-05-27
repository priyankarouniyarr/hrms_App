import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms_app/models/hosptial_code_models/hospital_code.dart';

class HospitalCodeProvider with ChangeNotifier {
  String _baseUrl = '';
  String _errorMessage = '';
  final String _applicationId = '';
  bool _isLoading = false;
  String get applicationId => _applicationId;
  String get baseUrl => _baseUrl;
  String get errorMessage => _errorMessage;
  final String _hospitalCode = '';
  String get hospitalCode => _hospitalCode;

  bool get isLoading => _isLoading;

  Future<void> fetchBaseUrl(String hosptialcode) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
          Uri.parse('${dotenv.env['parent_url']}api/CodeUrl/$hosptialcode'));

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        HospitalCode hospitalCode = HospitalCode.fromJson(decodedResponse);

        _baseUrl = hospitalCode.url;
        print(_baseUrl);

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
