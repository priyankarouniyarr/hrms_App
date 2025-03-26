import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
          'npDate': holiday.fromDateNp, // Nepali date from Holidays
          'enDate': holidayDate.holidayDate, // English date from HolidayDate
          'title': holidayDate.description,

          'color': holiday.color,
        });
        //  print(dates);
      }
    }

    // Uncomment if you want upcoming holidays too
    for (var holiday in _upcomingHolidays) {
      for (var holidayDate in holiday.holidayDates) {
        dates.add({
          'npDate': holiday.fromDateNp,
          'enDate': holidayDate.holidayDate,
          'title': holidayDate.description,
          'color': holiday.color,
        });
      }
    }
    for (var holiday in _allHolidays) {
      for (var holidayDate in holiday.holidayDates) {
        dates.add({
          'npDate': holiday.fromDateNp,
          'enDate': holidayDate.holidayDate,
          'title': holidayDate.description,
          'color': holiday.color,
        });
      }
    }

    return dates;
  }

  List<Map<String, dynamic>> getHolidaysByNepaliMonth(int nepaliMonth) {
    return allHolidayDatePairs.where((holiday) {
      // Extract the Nepali month from the 'npDate'
      String npDate = holiday['npDate'];
      int month = int.tryParse(npDate.split('-')[1]) ?? 0;
      return month == nepaliMonth;
    }).toList();
  }

  Future<void> fetchPastHolidays() async {
    try {
      final branchId = await _secureStorageService.readData('workingBranchId');
      final token = await _secureStorageService.readData('auth_token');
      final fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (branchId == null || token == null || fiscalYear == null) {
        throw Exception(
            'Missing required data: branchId, token, or fiscalYear');
      }

      final response = await http.get(
        Uri.parse(
            'http://45.117.153.90:5004/api/HolidayList/GetPastHolidayList'),
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
      throw e;
    }
  }

  // Fetch Upcoming Holidays
  Future<void> fetchUpcomingHolidays() async {
    try {
      final branchId = await _secureStorageService.readData('workingBranchId');
      final token = await _secureStorageService.readData('auth_token');
      final fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (branchId == null || token == null || fiscalYear == null) {
        throw Exception(
            'Missing required data: branchId, token, or fiscalYear');
      }

      final response = await http.get(
        Uri.parse(
            'http://45.117.153.90:5004/api/HolidayList/GetUpcommingHolidayList'),
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
      throw e;
    }
  }

  // Fetch All Holidays
  Future<void> fetchAllHolidays() async {
    try {
      final branchId = await _secureStorageService.readData('workingBranchId');
      final token = await _secureStorageService.readData('auth_token');
      final fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (branchId == null || token == null || fiscalYear == null) {
        throw Exception(
            'Missing required data: branchId, token, or fiscalYear');
      }

      final response = await http.get(
        Uri.parse('http://45.117.153.90:5004/api/HolidayList/GetHolidayList'),
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
