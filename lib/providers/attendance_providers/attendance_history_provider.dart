import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/attendance_details_models.dart';

class AttendanceDetailsProvider extends ChangeNotifier {
  final SecureStorageService _secureStorageService = SecureStorageService();

  // State variables
  String? _branchId;
  String? _token;
  bool _isLoading = true;
  AttendanceDetailsModel? _attendanceDetails;

  bool get isLoading => _isLoading;
  AttendanceDetailsModel? get attendanceDetails => _attendanceDetails;

  // Add a getter for shift types
  // Add a getter for shift types
  List<String> get shiftTypes {
    if (_attendanceDetails == null ||
        _attendanceDetails!.filter == null ||
        _attendanceDetails!.attendanceSummary!.isEmpty) {
      print("No attendance summary found or it's empty");
      return [];
    }

    // Extract unique shift types from attendanceSummary
    print("Attendance Summary: ${_attendanceDetails!.attendanceSummary}");
    return _attendanceDetails!.attendanceSummary!
        .map((summary) => summary.category)
        .toSet()
        .toList(); // Return unique shift types
  }

  Future<void> _loadSecureData() async {
    _branchId = await _secureStorageService.readData('workingBranchId');
    _token = await _secureStorageService.readData('auth_token');

    if (_branchId != null && _token != null) {
      await fetchAttendanceData(
        fromDate: DateTime.now().subtract(Duration(days: 30)),
        toDate: DateTime.now(),
        shiftType: '',
      );
    } else {
      print("Error: Branch ID or token is null.");
    }

    notifyListeners();
  }

  Future<void> fetchAttendanceData({
    required DateTime fromDate,
    required DateTime toDate,
    required String shiftType,
  }) async {
    if (_branchId == null || _token == null) {
      print("Error: Branch ID or token is null");
      return;
    }

    final url = Uri.parse(
        'http://45.117.153.90:5004/api/EmployeeAttendance/GetMyAttendanceSummary');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'BranchId': _branchId ?? '',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "FromDate": fromDate.toIso8601String(),
          "ToDate": toDate.toIso8601String(),
          "ShiftType": shiftType,
        }),
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          _attendanceDetails =
              AttendanceDetailsModel.fromJson(json.decode(response.body));
          print("Attendance data fetched successfully");
        } else {
          print("Error: Empty response body.");
        }
      } else {
        print(
            'Failed to load attendance data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error during API call: $e");
    }
  }

  void initialize() async {
    try {
      _isLoading = true;
      notifyListeners();
      await _loadSecureData();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error: $e');
    }
  }
}
