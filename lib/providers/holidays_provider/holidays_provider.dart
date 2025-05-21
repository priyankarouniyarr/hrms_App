import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/holidays/holidays_model.dart';

class HolidayProvider with ChangeNotifier {
  List<Holidays> _pastHolidays = [];
  List<Holidays> _upcomingHolidays = [];
  List<Holidays> _allHolidays = [];

  List<Holidays> get pastHolidays => _pastHolidays;
  List<Holidays> get upcomingHolidays => _upcomingHolidays;
  List<Holidays> get allHolidays => _allHolidays;

  final SecureStorageService _secureStorageService = SecureStorageService();

  List<Map<String, dynamic>> get allHolidayDatePairs {
    List<Map<String, dynamic>> dates = [];

    for (var holiday in _pastHolidays) {
      for (var holidayDate in holiday.holidayDates) {
        dates.add({
          'npDate': holiday.fromDateNp,
          'enDate': holidayDate.holidayDate,
          'description': holidayDate.description,
          'weekDay': holidayDate.isWeekOff,
          'color': holiday.color,
        });
      }
    }

    for (var holiday in _upcomingHolidays) {
      for (var holidayDate in holiday.holidayDates) {
        dates.add({
          'npDate': holiday.fromDateNp,
          'enDate': holidayDate.holidayDate,
          'description': holidayDate.description,
          'color': holiday.color,
          'weekDay': holidayDate.isWeekOff,
        });
      }
    }

    return dates;
  }

  Future<void> fetchPastHolidays() async {
    try {
      final branchId =
          await _secureStorageService.readData('selected_workingbranchId');
      final token = await _secureStorageService.readData('auth_token');
      final fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (branchId == null || token == null || fiscalYear == null) {
        throw Exception(
            'Missing required data: branchId, token, or fiscalYear');
      }

      final response = await http.get(
        Uri.parse(
            '${dotenv.env['base_url']}api/HolidayList/GetPastHolidayList'),
        headers: {
          'Authorization': 'Bearer $token',
          'workingBranchId': branchId,
          'fiscalYear': fiscalYear,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> holidayData = json.decode(response.body);
        _pastHolidays =
            holidayData.map((data) => Holidays.fromJson(data)).toList();

        notifyListeners();
      } else {
        throw Exception('Failed to load past holidays');
      }
    } catch (e) {
      print("Error fetching past holidays: $e");
    }
  }

  // Fetch Upcoming Holidays
  Future<void> fetchUpcomingHolidays() async {
    try {
      final branchId =
          await _secureStorageService.readData('selected_workingbranchId');
      final token = await _secureStorageService.readData('auth_token');
      final fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (branchId == null || token == null || fiscalYear == null) {
        throw Exception(
            'Missing required data: branchId, token, or fiscalYear');
      }

      final response = await http.get(
        Uri.parse(
            '${dotenv.env['base_url']}api/HolidayList/GetUpcommingHolidayList'),
        headers: {
          'Authorization': 'Bearer $token',
          'workingBranchId': branchId,
          'fiscalYear': fiscalYear,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> holidayData = json.decode(response.body);
        _upcomingHolidays =
            holidayData.map((data) => Holidays.fromJson(data)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load upcoming holidays');
      }
    } catch (e) {
      print("Error fetching upcoming holidays: $e");
    }
  }

  // Fetch All Holidays
  Future<void> fetchAllHolidays() async {
    try {
      final branchId =
          await _secureStorageService.readData('selected_workingbranchId');
      final token = await _secureStorageService.readData('auth_token');
      final fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (branchId == null || token == null || fiscalYear == null) {
        throw Exception(
            'Missing required data: branchId, token, or fiscalYear');
      }

      final response = await http.get(
        Uri.parse('${dotenv.env['base_url']}api/HolidayList/GetHolidayList'),
        headers: {
          'Authorization': 'Bearer $token',
          'workingBranchId': branchId,
          'fiscalYear': fiscalYear,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> holidayData = json.decode(response.body);
        _allHolidays =
            holidayData.map((data) => Holidays.fromJson(data)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load all holidays');
      }
    } catch (e) {
      print("Error fetching all holidays: $e");
      throw e;
    }
  }
}
