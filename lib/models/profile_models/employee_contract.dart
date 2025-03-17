import 'dart:convert';

class EmployeeContract {
  final int id;
  final int employeeId;
  final String employeeName;
  final String employeeCode;
  final DateTime contractStartDate;
  final String contractStartDateNp;
  final DateTime contractEndDate;
  final String contractEndDateNp;
  final String contractType;
  final String typeOfEmploymentTitle;
  final int typeOfEmploymentId;
  final String? jobDescription;
  final String levelTitle;
  final String gradeNo;
  final String payPackageTitle;
  final bool? isOTAvailable;
  final double otRate;
  final double totalIncome;
  final double totalIncomeYearly;
  final String status;
  final int expireInDays;

  EmployeeContract({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.employeeCode,
    required this.contractStartDate,
    required this.contractStartDateNp,
    required this.contractEndDate,
    required this.contractEndDateNp,
    required this.contractType,
    required this.typeOfEmploymentTitle,
    required this.typeOfEmploymentId,
    this.jobDescription,
    required this.levelTitle,
    required this.gradeNo,
    required this.payPackageTitle,
    this.isOTAvailable,
    required this.otRate,
    required this.totalIncome,
    required this.totalIncomeYearly,
    required this.status,
    required this.expireInDays,
  });

  // Factory method to create an instance from JSON
  factory EmployeeContract.fromJson(Map<String, dynamic> json) {
    return EmployeeContract(
      id: json['id'],
      employeeId: json['employeeId'],
      employeeName: json['employeeName'],
      employeeCode: json['employeeCode'],
      contractStartDate: DateTime.parse(json['contractStartDate']),
      contractStartDateNp: json['contractStartDateNp'],
      contractEndDate: DateTime.parse(json['contractEndDate']),
      contractEndDateNp: json['contractEndDateNp'],
      contractType: json['contractType'],
      typeOfEmploymentTitle: json['typeOfEmploymentTitle'],
      typeOfEmploymentId: json['typeOfEmploymentId'],
      jobDescription: json['jobDescription'],
      levelTitle: json['levelTitle'],
      gradeNo: json['gradeNo'],
      payPackageTitle: json['payPackageTitle'],
      isOTAvailable: json['isOTAvailable'],
      otRate: (json['otRate'] as num).toDouble(),
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalIncomeYearly: (json['totalIncomeYearly'] as num).toDouble(),
      status: json['status'],
      expireInDays: json['expireInDays'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'employeeCode': employeeCode,
      'contractStartDate': contractStartDate.toIso8601String(),
      'contractStartDateNp': contractStartDateNp,
      'contractEndDate': contractEndDate.toIso8601String(),
      'contractEndDateNp': contractEndDateNp,
      'contractType': contractType,
      'typeOfEmploymentTitle': typeOfEmploymentTitle,
      'typeOfEmploymentId': typeOfEmploymentId,
      'jobDescription': jobDescription,
      'levelTitle': levelTitle,
      'gradeNo': gradeNo,
      'payPackageTitle': payPackageTitle,
      'isOTAvailable': isOTAvailable,
      'otRate': otRate,
      'totalIncome': totalIncome,
      'totalIncomeYearly': totalIncomeYearly,
      'status': status,
      'expireInDays': expireInDays,
    };
  }

  // Convert JSON list to a list of EmployeeContract objects
  static List<EmployeeContract> fromJsonList(String jsonString) {
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((e) => EmployeeContract.fromJson(e)).toList();
  }

  // Convert a list of EmployeeContract objects to JSON string
  static String toJsonList(List<EmployeeContract> contracts) {
    final List<Map<String, dynamic>> jsonList =
        contracts.map((e) => e.toJson()).toList();
    return jsonEncode(jsonList);
  }
}
