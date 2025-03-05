import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/attendence_models.dart';

class AttendanceProvider extends ChangeNotifier {
  final SecureStorageService _secureStorageService = SecureStorageService();

  String? _branchId;
  String? _token;

  Attendance? _attendance;
  bool _isLoading = true;

  AttendanceProvider() {
    _loadSecureData();
  }

  // Load branchId and token from secure storage
  Future<void> _loadSecureData() async {
    _branchId = await _secureStorageService.readData('workingBranchId');
    _token = await _secureStorageService.readData('auth_token');

    print("Loaded branchId: $_branchId");
    print("Loaded token: $_token");

    if (_branchId != null && _token != null) {
      _isLoading = false;
      await fetchAttendanceData(); // Fetch data after loading secure storage
    }

    notifyListeners();
  }

  // Fetch attendance data
  Future<void> fetchAttendanceData() async {
    if (_isLoading) {
      return;
    }

    if (_branchId == null || _token == null) {
      print("Missing branchId or token");
      return;
    }

    final urlPrimary = Uri.parse(
        'http://45.117.153.90:5004/api/EmployeeAttendance/GetMyCurrentMonthAttendanceSheetPrimary');
    final urlExtended = Uri.parse(
        'http://45.117.153.90:5004/api/EmployeeAttendance/GetMyCurrentMonthAttendanceSheetExtended');

    try {
      final responsePrimary = await http.get(urlPrimary, headers: {
        'Authorization': 'Bearer $_token',
        'workingBranchId': _branchId!,
      });

      final responseExtended = await http.get(urlExtended, headers: {
        'Authorization': 'Bearer $_token',
        'workingBranchId': _branchId!,
      });

      // print("Raw Primary API Response: ${responsePrimary.body}");
      // print("Raw Extended API Response: ${responseExtended.body}");

      if (responsePrimary.statusCode == 200 &&
          responseExtended.statusCode == 200) {
        final primaryData = json.decode(responsePrimary.body) as List;
        final extendedData = json.decode(responseExtended.body) as List;

        _processAttendanceData(primaryData, extendedData);

        notifyListeners();
      }
    } catch (e) {
      print("Error fetching attendance data: $e");
    }
  }

  void _processAttendanceData(
      List<dynamic> primaryData, List<dynamic> extendedData) {
    Map<String, dynamic> primaryMap = {};
    Map<String, dynamic> extendedMap = {};

    for (var item in primaryData) {
      primaryMap[item['category']] = item['qty'];
    }

    for (var item in extendedData) {
      extendedMap[item['category']] = item['qty'];
    }

    _attendance = Attendance.fromJson(primaryMap, extendedMap);
  }

  Attendance? get attendance => _attendance;
}
