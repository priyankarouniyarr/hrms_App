import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/profiles.models.dart';
import 'package:hrms_app/screen/profile/subcategories/emergency_conatct.dart';

class EmployeeProvider with ChangeNotifier {
  final SecureStorageService secureStorageService = SecureStorageService();
  List<Employee> _employees = [];
  bool isLoading = false;
  String? _branch;
  String? _department;
  String? _designation;
  String? _joiningDate;
  String? _fullname;
  String? _email;
  String? _phone;
  String? _gender;
  String? _maritalStatus;
  String? _bloodGroup;
  EmployeePermanentAddress? _permanentAddress;
  String? _dateofBirth;
  String? _devnagariName;
  String? errorMessage;
  EmployeeTemporaryAddress? _temporaryAddress;
  EmployeeEmergencyContact? _emergencyContact;
  EmployeeCurrentShift? _currentShift;
  List<EmployeeDocument> _document = [];
  String formatToPascalCase(String text) {
    return text
        .replaceAll(RegExp(r'[_\s]+'), ' ')
        .trim()
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }

  List<EmployeeInsuranceDetail> _insuranceDetail = [];
  String get email => _email ?? '';
  String get phone => _phone ?? '';
  String get gender => _gender ?? '';
  String get branch => _branch ?? '';
  String get department => _department ?? '';
  String get desgination => _designation ?? '';
  String get dateOfJoining => _joiningDate ?? '';
  String get dateofBirth => _dateofBirth ?? '';
  String get maritalStatus => _maritalStatus ?? '';
  String get bloodGroup => _bloodGroup ?? '';
  String get fullname => _fullname ?? '';
  String get devnagariName => _devnagariName ?? '';
  EmployeeEmergencyContact get emergenecycontact =>
      _emergencyContact ??
      EmployeeEmergencyContact(
        contactPerson: '',
        phoneNumber: '',
        relation: '',
        employeeId: '',
      );

  List<EmployeeDocument> get documents => _document;
  EmployeeCurrentShift get currentShift =>
      _currentShift ??
      EmployeeCurrentShift(
        primaryShiftName: '',
        primaryShiftStart: '',
        primaryShiftEnd: '',
        extendedShiftName: '',
        extendedShiftStart: '',
        extendedShiftEnd: '',
      );
  List<EmployeeInsuranceDetail> get insurance => _insuranceDetail;

  EmployeePermanentAddress get permanentAddress =>
      _permanentAddress ??
      EmployeePermanentAddress(
          addressLine1: '', city: '', ward: '', municipalName: '');
  List<Employee> get employee => _employees;
  EmployeeTemporaryAddress get temporaryAddress =>
      _temporaryAddress ??
      EmployeeTemporaryAddress(
          addressLine1: '', city: '', ward: '', municipalName: '');

  // Method to fetch employee details
  Future<void> fetchEmployeeDetails() async {
    try {
      isLoading = true;
      notifyListeners();

      // Retrieve token and branchId from secure storage
      String? token = await secureStorageService.readData('auth_token');
      String? branchId = await secureStorageService.readData('workingBranchId');

      if (token == null || branchId == null) {
        errorMessage = 'Token or BranchId is missing';
        isLoading = false;
        notifyListeners();
        return;
      }

      // Define API endpoint
      final url =
          Uri.parse('http://45.117.153.90:5004/api/Employee/GetEmployeeDetail');

      // Make GET request to fetch employee details
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'workingBranchId': branchId,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Document fetching
        List<dynamic> jsonResponse = data['employeeDocuments'] ?? 'null';
        _document =
            jsonResponse.map((e) => EmployeeDocument.fromJson(e)).toList();
        List<dynamic> jsonResponse1 =
            data['employeeInsuranceDetails'] ?? 'null';
        _insuranceDetail = jsonResponse1
            .map((e) => EmployeeInsuranceDetail.fromJson(e))
            .toList();

        _fullname = data['employeeFullName'] ?? 'null';
        _designation = data['designationTitle'] ?? 'null';
        _branch = data['workBranchTitle'] ?? 'null';
        _joiningDate = data['joiningDateNp'] ?? 'null';
        _department = data['departmentTitle'] ?? 'null';
        _devnagariName = data['devnagariName'] ?? 'null';
        _email = data['homeEmail'] ?? 'null';
        _phone = data['homePhone'] ?? 'null';
        _gender = data['gender'] ?? 'null';
        _maritalStatus = data['maritalStatus'] ?? 'null';
        _bloodGroup = data['bloodGroup'] ?? 'null';

        // Birthdate formatting
        if (data.containsKey('birthDate') && data['birthDate'] != null) {
          DateTime birthDate = DateTime.parse(data['birthDate']);
          _dateofBirth = DateFormat('yyyy-MM-dd').format(birthDate);
        } else {
          _dateofBirth = 'null';
        }

        // Permanent Address
        if (data.containsKey('permanentAddress') &&
            data['permanentAddress'] != null) {
          var permanentAddressData = data['permanentAddress'];
          _permanentAddress =
              EmployeePermanentAddress.fromJson(permanentAddressData);
        } else {
          _permanentAddress = EmployeePermanentAddress(
              addressLine1: 'null',
              city: 'null',
              ward: 'null',
              municipalName: 'null');
        }

        // Temporary Address
        if (data.containsKey('temporaryAddress') &&
            data['temporaryAddress'] != null) {
          var temporaryAddressData = data['temporaryAddress'];
          _temporaryAddress =
              EmployeeTemporaryAddress.fromJson(temporaryAddressData);
        } else {
          _temporaryAddress = EmployeeTemporaryAddress(
              addressLine1: 'null',
              city: 'null',
              ward: 'null',
              municipalName: 'null');
        }

        // Emergency Contact
        if (data.containsKey('employeeEmergencyContacts') &&
            data['employeeEmergencyContacts'] != null) {
          var employeeEmergencyContacts = data['employeeEmergencyContacts'];

          // Iterate through all emergency contacts in the list
          if (employeeEmergencyContacts.isNotEmpty) {
            _emergencyContact = EmployeeEmergencyContact(
              contactPerson: formatToPascalCase(
                  employeeEmergencyContacts[0]['contactPerson']),
              phoneNumber: employeeEmergencyContacts[0]['phoneNumber'],
              relation:
                  formatToPascalCase(employeeEmergencyContacts[0]['relation']),
            );
          } else {
            // If the list is empty, assign default values
            _emergencyContact = EmployeeEmergencyContact(
              contactPerson: '',
              phoneNumber: '',
              relation: '',
            );
          }
        } else {
          _emergencyContact = EmployeeEmergencyContact(
            contactPerson: 'null',
            phoneNumber: 'null',
            relation: 'null',
          );
        }

        // Current Shift Details
        if (data.containsKey('employeeCurrentShift') &&
            data['employeeCurrentShift'] != null) {
          var shiftData = data['employeeCurrentShift'];

          if (shiftData is Map<String, dynamic>) {
            var primaryShiftName = shiftData['primaryShiftName'];
            var primaryShiftStart = shiftData['primaryShiftStart'];
            var primaryShiftEnd = shiftData['primaryShiftEnd'];

            var extendedShiftName = shiftData['extendedShiftName'];
            var extendedShiftStart = shiftData['extendedShiftStart'];
            var extendedShiftEnd = shiftData['extendedShiftEnd'];

            _currentShift = EmployeeCurrentShift(
              primaryShiftName: primaryShiftName,
              primaryShiftStart: primaryShiftStart,
              primaryShiftEnd: primaryShiftEnd,
              extendedShiftName: extendedShiftName,
              extendedShiftStart: extendedShiftStart,
              extendedShiftEnd: extendedShiftEnd,
            );
          } else {
            _currentShift = EmployeeCurrentShift(
              primaryShiftName: 'null',
              primaryShiftStart: 'null',
              primaryShiftEnd: 'null',
              extendedShiftName: 'null',
              extendedShiftStart: 'null',
              extendedShiftEnd: 'null',
            );
          }
        } else {
          _currentShift = EmployeeCurrentShift(
            primaryShiftName: 'null',
            primaryShiftStart: 'null',
            primaryShiftEnd: 'null',
            extendedShiftName: 'null',
            extendedShiftStart: 'null',
            extendedShiftEnd: 'null',
          );
        }

        // Notify listeners after all updates
        notifyListeners();
      } else {
        errorMessage = 'Failed to load employee details';
      }
    } catch (e) {
      errorMessage = 'Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
