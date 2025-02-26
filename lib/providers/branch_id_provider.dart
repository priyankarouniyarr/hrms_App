import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/models/branch_id_models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BranchProvider with ChangeNotifier {
  bool _loading = false;
  String _errorMessage = '';
  List<BranchModel> _branches = [];

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  List<BranchModel> get branches => _branches;

  // Fetch User Branches
  Future<void> fetchUserBranches() async {
    _setLoading(true);

    try {
      // Retrieve token from secure storage
      String? token = await _secureStorage.read(key: 'auth_token');

      if (token == null) {
        _setErrorMessage("No token found. Please log in again.");
        return;
      }

      final response = await http.get(
        Uri.parse('http://45.117.153.90:5004/Account/GetUserBranches'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print('Branch Fetch Status Code: ${response.statusCode}');
      print('Branch Fetch Status Code: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);

        // Convert JSON data to List<BranchModel>
        _branches =
            jsonData.map((branch) => BranchModel.fromJson(branch)).toList();
        notifyListeners();
      } else {
        _setErrorMessage("Failed to fetch branches");
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

  void clearErrorMessage() {
    if (_errorMessage.isNotEmpty) {
      _errorMessage = '';
      notifyListeners();
    }
  }
}
