import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/models/holidays_model.dart';
import 'package:hrms_app/storage/branch_id_storage.dart';

class HolidayProvider with ChangeNotifier {
  List<Holidays> _pastHolidays = [];
  List<Holidays> _upcomingHolidays = [];
  List<Holidays> _allHolidays = [];

  List<Holidays> get pastHolidays => _pastHolidays;
  List<Holidays> get upcomingHolidays => _upcomingHolidays;
  List<Holidays> get allHolidays => _allHolidays;

  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<void> fetchPastHolidays() async {
    final branchId = await _secureStorageService.readData('workingBranchId');
    //print("branchId:$branchId");
    final token = await _secureStorageService.readData('auth_token');
    //print(token);

    if (branchId == null && token == null) {
      throw Exception('No branchId or token found');
    }

    final response = await http.get(
      Uri.parse(
          'http://45.117.153.90:5004/api/HolidayList/GetPastHolidayList?branchId=$branchId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print("Response body for past holidays: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> holidayData = json.decode(response.body);
      print("Decoded holiday data: $holidayData");
      _pastHolidays =
          holidayData.map((data) => Holidays.fromJson(data)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load past holidays');
    }
    // print('past holidays ${response.statusCode}');
  }

  Future<void> fetchUpcomingHolidays() async {
    final branchId = await _secureStorageService.readData('workingBranchId');
    final token = await _secureStorageService.readData('auth_token');
    // print(branchId);
    // print(token);
    // print("BranchId: $branchId");
    // print("Token: $token");
    if (branchId == null || token == null) {
      throw Exception('No branchId or token found');
    }

    final response = await http.get(
      Uri.parse(
          'http://45.117.153.90:5004/api/HolidayList/GetUpcommingHolidayList?branchId=$branchId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    // print("Response body for upcoming holidays: ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> holidayData = json.decode(response.body);
      print("Decoded holiday data: $holidayData");
      _upcomingHolidays =
          holidayData.map((data) => Holidays.fromJson(data)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load upcoming holidays');
    }
    // print('upcoming holidays ${response.statusCode}');
  }

  Future<void> fetchAllHolidays() async {
    final branchId = await _secureStorageService.readData('workingBranchId');
    final token = await _secureStorageService.readData('auth_token');

    if (branchId == null || token == null) {
      throw Exception('No branchId or token found');
    }

    final response = await http.get(
      Uri.parse(
          'http://45.117.153.90:5004/api/HolidayList/GetHolidayList?branchId=$branchId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    // print("Response body for get holidays: ${response}");
    if (response.statusCode == 200) {
      final List<dynamic> holidayData = json.decode(response.body);
      print("Decoded holiday data: $holidayData");
      _allHolidays =
          holidayData.map((data) => Holidays.fromJson(data)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load all holidays');
    }
    // print('getall holidays ${response.statusCode}');
  }
}
