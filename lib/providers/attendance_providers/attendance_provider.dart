import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/attendance%20_models/attendence_models.dart';

class AttendanceProvider with ChangeNotifier {
  List<Attendance> _primaryShiftAttendance = [];
  List<Attendance> _extendedShiftAttendance = [];
  bool _isLoading = false;
  String _errorMessage = '';
  final SecureStorageService _secureStorageService = SecureStorageService();

  String? _branchId;
  String? _token;
  String? _fiscalYear;

  List<Attendance> get primaryShiftAttendance => _primaryShiftAttendance;
  List<Attendance> get extendedShiftAttendance => _extendedShiftAttendance;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  get attendanceReport => null;

  Future<void> fetchAttendanceData() async {
    _branchId =
        await _secureStorageService.readData('selected_workingbranchId');
    _token = await _secureStorageService.readData('auth_token');
    _fiscalYear = await _secureStorageService.readData('selected_fiscal_year');

    if (_token == null || _branchId == null || _fiscalYear == null) {
      _errorMessage = 'No token or branchId found';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final responsePrimary = await http.get(
        Uri.parse(
            'http://45.117.153.90:5004/api/EmployeeAttendance/GetMyCurrentMonthAttendanceSheetPrimary'),
        headers: {
          'Authorization': 'Bearer $_token',
          'workingBranchId': _branchId!,
          'workingFinancialId': _fiscalYear!,
        },
      );

      final responseExtended = await http.get(
        Uri.parse(
            'http://45.117.153.90:5004/api/EmployeeAttendance/GetMyCurrentMonthAttendanceSheetExtended'),
        headers: {
          'Authorization': 'Bearer $_token',
          'workingBranchId': _branchId!,
          'workingFinancialId': _fiscalYear!,
        },
      );

      if (responsePrimary.statusCode == 200 &&
          responseExtended.statusCode == 200) {
        final List<dynamic> primaryData = json.decode(responsePrimary.body);
        final List<dynamic> extendedData = json.decode(responseExtended.body);

        _primaryShiftAttendance = primaryData
            .map((attendanceData) => Attendance.fromJson(attendanceData))
            .toList();
        _extendedShiftAttendance = extendedData
            .map((attendanceData) => Attendance.fromJson(attendanceData))
            .toList();
        _errorMessage = '';
      } else {
        _errorMessage = 'Failed to load data.';
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
    }

    _isLoading = false;
    notifyListeners();
  }

  void fetchAttendanceSummary(
      DateTime dateTime, DateTime dateTime2, String s) {}
}
