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
  EmployeeEmergencyContact get emergenecycontact =>
      _emergencyContact ??
      EmployeeEmergencyContact(
        contactPerson: '',
        phoneNumber: '',
        relation: '',
      );

  EmployeeInsuranceDetail get insuranceDetail =>
      _insuranceDetail ??
      EmployeeInsuranceDetail(
          type: '',
          isIncomeTaxExceptionApplicable: '',
          policyNumber: '',
          startdate: '',
          enddate: '',
          amount: '',
          employeeName: '');

  String formatToPascalCase(String text) {
    return text
        .replaceAll(RegExp(r'[_\s]+'),
            ' ') // Replace underscores & multiple spaces with a single space
        .trim()
        .split(' ') // Split by space
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' '); // Join words back
  }

  EmployeeInsuranceDetail? _insuranceDetail;
  String get email => _email ?? '';
  String get phone => _phone ?? '';
  String get gender => _gender ?? '';
  String get dateofBirth => _dateofBirth ?? '';
  String get maritalStatus => _maritalStatus ?? '';
  String get bloodGroup => _bloodGroup ?? '';
  String get fullname => _fullname ?? '';
  String get devnagariName => _devnagariName ?? '';
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
      notifyListeners(); // Notify listeners when loading starts

      // Retrieve token and branchId from secure storage
      String? token = await secureStorageService.readData('auth_token');
      String? branchId = await secureStorageService.readData('workingBranchId');

      if (token == null || branchId == null) {
        errorMessage = 'Token or BranchId is missing';
        isLoading = false;
        notifyListeners(); // Notify listeners when an error occurs
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

      final data = json.decode(response.body);
      //print(data); // Inspect the structure of the response

      if (data.containsKey('employeeFullName') &&
          data['employeeFullName'] != null) {
        _fullname = data['employeeFullName'];
        // print(_fullname);
      } else {
        _fullname = 'null';
      }

      if (data.containsKey('devnagariName') && data['devnagariName'] != null) {
        _devnagariName = data['devnagariName'];
      } else {
        _devnagariName = 'null';
      }
      if (data.containsKey('homeEmail') && data['homeEmail'] != null) {
        _email = data['homeEmail'];
      } else {
        _email = 'null';
      }
      if (data.containsKey('homePhone') && data['homePhone'] != null) {
        _phone = data['homePhone'];
        // print(_phone);
      } else {
        _phone = 'null';
        //print("hello");
      }
      if (data.containsKey('gender') && data['gender'] != null) {
        _gender = data['gender'];
      } else {
        _gender = 'null';
      }
      if (data.containsKey('maritalStatus') && data['maritalStatus'] != null) {
        _maritalStatus = data['maritalStatus'];
      } else {
        _maritalStatus = 'null';
      }
      if (data.containsKey('bloodGroup') && data['bloodGroup'] != null) {
        _bloodGroup = data['bloodGroup'];
      } else {
        _bloodGroup = 'null';
      }
      if (data.containsKey('birthDate') && data['birthDate'] != null) {
        DateTime birthDate = DateTime.parse(data['birthDate']);
        _dateofBirth = DateFormat('yyyy-MM-dd').format(birthDate);
      } else {
        _dateofBirth = 'null';
      }

      // Handling Permanent Address
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

      // Handling Temporary Address
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

      //emergency contact
      if (data.containsKey('employeeEmergencyContacts') &&
          data['employeeEmergencyContacts'] != null) {
        var employeeEmergencyContacts = data['employeeEmergencyContacts'];

        // Iterate through all emergency contacts in the list
        if (employeeEmergencyContacts.isNotEmpty) {
          _emergencyContact = EmployeeEmergencyContact(
            contactPerson: formatToPascalCase(
                employeeEmergencyContacts[0]['contactPerson'] ?? 'null'),
            phoneNumber: employeeEmergencyContacts[0]['phoneNumber'] ?? 'null',
            relation: formatToPascalCase(
                employeeEmergencyContacts[0]['relation'] ?? 'null'),
          );
        } else {
          // If the list is empty, assign default values
          _emergencyContact = EmployeeEmergencyContact(
            contactPerson: 'null',
            phoneNumber: 'null',
            relation: 'null',
          );
        }
      } else {
        // If the key doesn't exist or the data is null, assign default values
        _emergencyContact = EmployeeEmergencyContact(
          contactPerson: 'null',
          phoneNumber: 'null',
          relation: 'null',
        );
      }

      if (data.containsKey('employeeInsuranceDetails') &&
          data['employeeInsuranceDetails'] != null &&
          data['employeeInsuranceDetails'].isNotEmpty) {
        var insuranceData = data['employeeInsuranceDetails'];

        if (insuranceData.isNotEmpty) {
          var firstItem = insuranceData[0];

          _insuranceDetail = EmployeeInsuranceDetail.fromJson(firstItem);
          //print(insuranceDetail!.policyNumber);
        } else {
          _insuranceDetail = EmployeeInsuranceDetail(
            type: 'N/A',
            enddate: 'N/A',
            startdate: 'N/A',
            policyNumber: 'N/A',
            employeeName: 'N/A',
            amount: 'N/A',
            isIncomeTaxExceptionApplicable: 'N/A',
          );
        }
      } else {
        _insuranceDetail = EmployeeInsuranceDetail(
          type: 'N/A',
          enddate: 'N/A',
          startdate: 'N/A',
          policyNumber: 'N/A',
          employeeName: 'N/A',
          amount: 'N/A',
          isIncomeTaxExceptionApplicable: 'N/A',
        );

        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
