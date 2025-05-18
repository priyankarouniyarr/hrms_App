import 'dart:io';
import 'dart:math';
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

  Future<void> fetchAttendanceData(
    BuildContext context,
  ) async {
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
    } on SocketException catch (e) {
      String errorMessage;
      if (e.osError != null && e.osError!.errorCode == 101) {
        errorMessage =
            'Network is unreachable. Please check your internet connection.';
      } else {
        errorMessage = 'Network error: ${e.message}';
      }

      print("SocketException: $errorMessage");

      await showErrorDialog(
        context: context,
        title: "Connection Error",
        message: errorMessage,
      );
    } catch (error) {
      String errorMessage = 'Error: $error';
      await showErrorDialog(
        context: context,
        title: "Error",
        message: errorMessage,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  void fetchAttendanceSummary(
      DateTime dateTime, DateTime dateTime2, String s) {}
  Future<void> showErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
