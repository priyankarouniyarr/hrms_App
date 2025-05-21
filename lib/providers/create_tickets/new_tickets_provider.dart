import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/createtickets/new_tickets_creation_model.dart';

class TicketProvider with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  final SecureStorageService _secureStorageService = SecureStorageService();
  String? _branchId;
  String? _token;
  String? _fiscalYear;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Maximum file size in bytes (5MB)
  static const int maxFileSize = 5 * 1024 * 1024;

  Future<bool> createTicket(TicketCreationRequest request) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Validate credentials first
      _branchId =
          await _secureStorageService.readData('selected_workingbranchId');
      _token = await _secureStorageService.readData('auth_token');
      _fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (_token == null || _branchId == null || _fiscalYear == null) {
        _errorMessage = 'Missing required credentials';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Validate request data
      if (request.title.isEmpty || request.description.isEmpty) {
        _errorMessage = 'Title and description are required';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Initialize Dio with custom options
      final dio = Dio(BaseOptions(
        validateStatus: (status) => status! < 500, // Don't throw for 4xx errors
      ));

      dio.options.headers = {
        'content-type': 'application/json',
        'Authorization': 'Bearer $_token',
        'workingBranchId': _branchId!,
        'workingFinancialId': _fiscalYear!,
      };

      // Process attachments with size validation
      List<MultipartFile> multipartFiles = [];
      if (request.attachmentPaths != null &&
          request.attachmentPaths!.isNotEmpty) {
        for (var filePath in request.attachmentPaths!) {
          final file = File(filePath);
          final fileSize = await file.length();
          final fileName = filePath.split('/').last;

          print('File: $fileName - Size: ${_formatBytes(fileSize)}');

          if (fileSize > maxFileSize) {
            _errorMessage =
                'File $fileName is too large (max ${_formatBytes(maxFileSize)})';
            _isLoading = false;
            notifyListeners();
            return false;
          }

          multipartFiles.add(
            await MultipartFile.fromFile(
              filePath,
              filename: fileName,
              contentType: MediaType('application', 'octet-stream'),
            ),
          );
        }
      }

      final formData = FormData.fromMap({
        "TicketCategoryId": request.ticketCategoryId,
        "Title": request.title,
        "Description": request.description,
        "Severity": request.severity,
        "Priority": request.priority,
        "AssignToEmployeeId": request.assignToEmployeeId,
        'AttachmentFiles': multipartFiles,
      });

      // Log the request payload for debugging
      print('Sending ticket creation request: ${request.toJson()}');

      final response = await dio.post(
        '${dotenv.env['base_url']}api/Ticket/CreateTicketPost',
        data: formData,
      );

      // Handle response
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is bool && responseData) {
          return true;
        } else if (responseData is Map && responseData['success'] == true) {
          return true;
        } else {
          _errorMessage = responseData['message'] ?? 'Ticket creation failed';
          return false;
        }
      } else if (response.statusCode == 400) {
        // Handle 400 Bad Request specifically
        final errorData = response.data;
        if (errorData is Map) {
          _errorMessage = errorData['message'] ??
              errorData['errors']?.toString() ??
              'Invalid request data';
        } else {
          _errorMessage = 'Invalid request: ${errorData.toString()}';
        }
        return false;
      } else {
        _errorMessage = 'Request failed with status ${response.statusCode}';
        return false;
      }
    } on DioException catch (error) {
      if (error.response != null) {
        final errorData = error.response?.data;
        if (errorData is Map) {
          _errorMessage = errorData['message'] ??
              errorData['errors']?.toString() ??
              'Server error occurred';
        } else {
          _errorMessage =
              'Error: ${error.response?.statusCode} - ${errorData.toString()}';
        }
      } else {
        // Handle Dio errors without response
        _errorMessage = "Network error: ${error.message}";
      }
      return false;
    } catch (error) {
      _errorMessage = "Unexpected error: $error";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper function to format bytes
  String _formatBytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    final i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
