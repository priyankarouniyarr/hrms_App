import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/storage/hosptial_code_storage.dart';
import 'package:hrms_app/models/branches_models/branch_id_models.dart';

class BranchProvider with ChangeNotifier {
  bool _loading = false;
  String _errorMessage = '';
  List<BranchModel> _branches = [];
  String? _selectedBranchId;
  final SecureStorageService _secureStorageService = SecureStorageService();
  final HosptialCodeStorage _hospitalCodeStorage = HosptialCodeStorage();
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

  Future<String?> _getBaseUrl() async {
    return await _hospitalCodeStorage.getBaseUrl();
  }

  Future<void> _storeBaseUrl(String baseUrl) async {
    await _hospitalCodeStorage.storeBaseUrl(baseUrl);
    debugPrint("Stored Base URL in branch: $baseUrl");
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
      final baseUrl = await _getBaseUrl();
      if (baseUrl == null) {
        _setErrorMessage(
            "Base URL not found. Please enter hospital code again.");
        return;
      }
      // Store the base URL to ensure it’s persisted
      await _storeBaseUrl(baseUrl);
      final response = await http.get(
        Uri.parse('$baseUrl/Account/GetUserBranches'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      log("Fetching branches from: $baseUrl/Account/GetUserBranches");
      if (response.statusCode == 200) {
        log("Response status: ${response.statusCode}");
        List<dynamic> jsonData = json.decode(response.body);
        if (jsonData.isEmpty) {
          _branches = [];
        } else {
          _branches =
              jsonData.map((branch) => BranchModel.fromJson(branch)).toList();
        }

        notifyListeners();
      } else {
        _setErrorMessage(" Failed to load branches");
      }
    } catch (e) {
      _setErrorMessage("Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    _errorMessage = '';
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
