import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/notices_models/notices_models.dart';

class NoticesProvider with ChangeNotifier {
  List<Notices> _notices = [];
  String _errorMessage = '';
  List<Notices> get notices => _notices;

  String get errorMessage => _errorMessage;
  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<void> fetchNotice() async {
    try {
      final branchId =
          await _secureStorageService.readData('selected_workingbranchId');

      final token = await _secureStorageService.readData('auth_token');
      final fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (branchId == null || token == null || fiscalYear == null) {
        throw Exception('No branchId or token found');
      }

      final response = await http.get(
        Uri.parse('${dotenv.env['base_url']}api/Notice/GetAllNotices'),
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
        _errorMessage = 'Failed to load notices';
      }
    } catch (error) {
      _errorMessage = 'Error: $error';
      print("Error: $error");
    }
  }

  Future<void> fetchNoticesbyId() async {
    try {
      final branchId =
          await _secureStorageService.readData('selected_workingbranchId');
      final token = await _secureStorageService.readData('auth_token');
      final fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (branchId == null || token == null || fiscalYear == null) {
        throw Exception('No branchId or token found');
      }

      final response = await http.get(
        Uri.parse('${dotenv.env['base_url']}api/Notice/GetNoticeById/1'),
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
        _errorMessage = 'Failed to load notices';
      }
    } catch (error) {
      _errorMessage = 'Error: $error';
      print("Error: $error");
    }
  }
}
