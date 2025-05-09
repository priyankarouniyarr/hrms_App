import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/utlis/socket_handle.dart';
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/attendance%20_models/attendance_details_models.dart';

class AttendanceDetailsProvider with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  final SecureStorageService _secureStorageService = SecureStorageService();

  AttendanceReport? _attendanceReport;
  String? _branchId;
  String? _token;
  String? _fiscalYear;
  List<String> _shiftTypes = ["Primary", "Extended"];
  List<AttendanceSummary> _summaryAttendance = [];
  List<AttendanceDetails> _detsilsAttendance = [];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  AttendanceReport? get attendanceReport => _attendanceReport;
  List<String> get shiftTypes => _shiftTypes;
  List<AttendanceSummary> get summaryAttendance => _summaryAttendance;
  List<AttendanceDetails> get detailsAttendance =>
      _detsilsAttendance; // Details attendance

  Future<void> fetchAttendanceSummary(Filter filter) async {
    _isLoading = true;
    notifyListeners();

    _branchId =
        await _secureStorageService.readData('selected_workingbranchId');
    _token = await _secureStorageService.readData('auth_token');
    _fiscalYear = await _secureStorageService.readData('selected_fiscal_year');

    if (_token == null || _branchId == null || _fiscalYear == null) {
      _errorMessage = 'No token or branchId found';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'http://45.117.153.90:5004/api/EmployeeAttendance/GetMyAttendanceSummary'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'workingBranchId': _branchId!,
          'workingFinancialId': _fiscalYear!,
        },
        body: json.encode(filter.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _attendanceReport = AttendanceReport.fromJson(responseData);

        final List<dynamic> summaryData =
            responseData['attendanceSummary'] ?? [];

        final List<dynamic> detailsData =
            responseData['attendanceDetails'] ?? [];

        _summaryAttendance = summaryData
            .map((attendanceData) => AttendanceSummary.fromJson(attendanceData))
            .toList();

        _detsilsAttendance = detailsData
            .map((attendanceData) => AttendanceDetails.fromJson(attendanceData))
            .toList();

        notifyListeners();
      } else {
        _errorMessage =
            'Failed to load attendance summary: ${response.statusCode}';
      }
    } catch (error) {
      _errorMessage = 'Error: $error';
    }

    _isLoading = false;
    notifyListeners();
  }
}
