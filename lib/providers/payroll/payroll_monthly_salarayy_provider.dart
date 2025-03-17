import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/models/payrolls_models/monthly_salary_models.dart';

class SalaryProvider with ChangeNotifier {
  GetMyCurrentMonthSalary? currentMonthSalary;
  GetMyMonthSalary? monthSalary;

  String _errorMessage = '';
  bool _isLoading = false;

  // Getter for errorMessage
  String get errorMessage => _errorMessage;

  // Getter for loading state
  bool get isLoading => _isLoading;

  // GET: GetMyCurrentMonthSalary
  Future<void> fetchCurrentMonthSalary() async {
    _isLoading = true;
    _errorMessage = ''; // Reset the error message
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(
          'http://45.117.153.90:5004/api/Payroll/GetMyCurrentMonthSalary'));

      if (response.statusCode == 200) {
        currentMonthSalary =
            GetMyCurrentMonthSalary.fromJson(json.decode(response.body));
      } else {
        _errorMessage = 'Failed to load current month salary';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // POST: GetMyMonthSalary
  Future<void> fetchMonthSalary(int month, int year) async {
    _isLoading = true;
    _errorMessage = ''; // Reset the error message
    notifyListeners();

    try {
      final request = GetMyMonthSalaryRequest(month: month, year: year);
      final response = await http.post(
        Uri.parse('http://45.117.153.90:5004/api/Payroll/GetMyMonthSalary'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        monthSalary = GetMyMonthSalary.fromJson(json.decode(response.body));
      } else {
        _errorMessage = 'Failed to load month salary';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
