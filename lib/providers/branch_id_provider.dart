import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/models/branch_id_models.dart';
import 'package:hrms_app/storage/branch_id_storage.dart';

class BranchProvider with ChangeNotifier {
  bool _loading = false;
  String _errorMessage = '';
  List<BranchModel> _branches = [];
  String? _selectedBranchId;

  final SecureStorageService _secureStorageService = SecureStorageService();

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  List<BranchModel> get branches => _branches;
  String? get selectedBranchId => _selectedBranchId;
  Future<void> setSelectedBranch(String branchId) async {
    _selectedBranchId = branchId;
    await _secureStorageService.writeData('workingBranchId', branchId);
    notifyListeners();
  }

  Future<void> loadSelectedBranch() async {
    String? storedBranchId =
        await _secureStorageService.readData('workingBranchId');
    if (storedBranchId != null) {
      _selectedBranchId = storedBranchId;
    }
    notifyListeners();
  }

  Future<void> fetchUserBranches() async {
    _setLoading(true);
    try {
      String? token = await _secureStorageService
          .readData('auth_token'); // Use service to read token
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
      print(response.body);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
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
