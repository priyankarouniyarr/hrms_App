import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/notices_models/notices_models.dart';

class NoticesProvider with ChangeNotifier {
  List<Notices> _notices = [];

  List<Notices> get notices => _notices;

  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<void> fetchNotice() async {
    final branchId =
        await _secureStorageService.readData('selected_workingbranchId');

    final token = await _secureStorageService.readData('auth_token');
    final fiscalYear =
        await _secureStorageService.readData('selected_fiscal_year');

    if (branchId == null || token == null || fiscalYear == null) {
      throw Exception('No branchId or token found');
    }

    final response = await http.get(
      Uri.parse('http://45.117.153.90:5004/api/Notice/GetAllNotices'),
      headers: {
        'Authorization': 'Bearer $token',
        "workingBranchId": branchId,
        "workingFinancialId": fiscalYear,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> noticedata = json.decode(response.body);

      _notices = noticedata.map((data) => Notices.fromJson(data)).toList();

      notifyListeners();
    } else {
      throw Exception('Failed to load notices ');
    }
  }

  Future<void> fetchNoticesbyId() async {
    final branchId =
        await _secureStorageService.readData('selected_workingbranchId');
    final token = await _secureStorageService.readData('auth_token');
    final fiscalYear =
        await _secureStorageService.readData('selected_fiscal_year');

    if (branchId == null || token == null || fiscalYear == null) {
      throw Exception('No branchId or token found');
    }

    final response = await http.get(
      Uri.parse('http://45.117.153.90:5004/api/Notice/GetNoticeById/1'),
      headers: {
        'Authorization': 'Bearer $token',
        "workingBranchId": branchId,
        "workingFinancialId": fiscalYear,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> holidayData = json.decode(response.body);

      _notices = holidayData.map((data) => Notices.fromJson(data)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load notices ');
    }
  }
}
