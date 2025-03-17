class Employee {
  final int id;
  final String employeeName;
  final String firstName;
  final String middleName;
  final String lastName;
  final String shortName;
  final String devnagariName;
  final String employeeCode;
  final String designationTitle;
  final String mobileNumber;
  final String workBranchTitle;
  final String workAddress;
  final String homeEmail;
  final String panNumber;
  final String maritalStatus;
  final String gender;
  final String birthDate;
  final String birthPlace;
  final String nationalityCountryId;
  final String religionId;
  final String ethnicityId;
  final String motherTongue;
  final String visaNo;
  final String workPermitNo;
  final String bloodGroup;
  final String imagePath;
  final String status;
  final String employeeDisplayName;
  final String employeeFullName;
  final DateTime joiningDate;
  final String salaryType;
  final String bankName;
  final String bankAccountNumber;
  final String bankAccountType;
  final List<EmployeeEducation> employeeEducations;
  final List<EmployeeEmergencyContact> employeeEmergencyContacts;
  final List<EmployeeNominee> employeeNominees;
  final EmployeePermanentAddress permanentAddress;
  final EmployeeTemporaryAddress temporaryAddress;
  final List<EmployeeInsuranceDetail> employeeInsuranceDetails;
  final List<EmployeeDocument> employeeDocuments;
  final EmployeeCurrentShift employeeCurrentShift;

  Employee({
    required this.id,
    required this.employeeName,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.shortName,
    required this.devnagariName,
    required this.employeeCode,
    required this.designationTitle,
    required this.mobileNumber,
    required this.workBranchTitle,
    required this.workAddress,
    required this.homeEmail,
    required this.panNumber,
    required this.maritalStatus,
    required this.gender,
    required this.birthDate,
    required this.birthPlace,
    required this.nationalityCountryId,
    required this.religionId,
    required this.ethnicityId,
    required this.motherTongue,
    required this.visaNo,
    required this.workPermitNo,
    required this.bloodGroup,
    required this.imagePath,
    required this.status,
    required this.employeeDisplayName,
    required this.employeeFullName,
    required this.joiningDate,
    required this.salaryType,
    required this.bankName,
    required this.bankAccountNumber,
    required this.bankAccountType,
    required this.employeeEducations,
    required this.employeeEmergencyContacts,
    required this.employeeNominees,
    required this.permanentAddress,
    required this.temporaryAddress,
    required this.employeeInsuranceDetails,
    required this.employeeDocuments,
    required this.employeeCurrentShift,
  });

  // Method to create an instance from JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      employeeName: json['employeeName'] ?? '',
      firstName: json['firstName'],
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'],
      shortName: json['shortName'] ?? '',
      devnagariName: json['devnagariName'],
      employeeCode: json['employeeCode'],
      designationTitle: json['designationTitle'],
      mobileNumber: json['mobileNumber'] ?? '',
      workBranchTitle: json['workBranchTitle'],
      workAddress: json['workAddress'] ?? '',
      homeEmail: json['homeEmail'],
      panNumber: json['panNumber'] ?? '',
      maritalStatus: json['maritalStatus'],
      gender: json['gender'],
      birthDate: json['birthDate'],
      birthPlace: json['birthPlace'],
      nationalityCountryId: json['countryOfBirth'].toString(),
      religionId: json['religionId'].toString(),
      ethnicityId: json['ethnicityId'].toString(),
      motherTongue: json['motherTongue'],
      visaNo: json['visaNo'] ?? '',
      workPermitNo: json['workPermitNo'] ?? '',
      bloodGroup: json['bloodGroup'],
      imagePath: json['imagePath'] ?? '',
      status: json['status'],
      employeeDisplayName: json['employeeDisplayName'],
      employeeFullName: json['employeeFullName'],
      joiningDate: DateTime.parse(json['joiningDate']),
      salaryType: json['salaryType'],
      bankName: json['bankName'],
      bankAccountNumber: json['bankAccountNumber'],
      bankAccountType: json['bankAccountType'],
      employeeEducations: (json['employeeEducations'] as List)
          .map((e) => EmployeeEducation.fromJson(e))
          .toList(),
      employeeEmergencyContacts: (json['employeeEmergencyContacts'] as List)
          .map((e) => EmployeeEmergencyContact.fromJson(e))
          .toList(),
      employeeNominees: (json['employeeNominees'] as List)
          .map((e) => EmployeeNominee.fromJson(e))
          .toList(),
      permanentAddress:
          EmployeePermanentAddress.fromJson(json['permanentAddress']),
      temporaryAddress:
          EmployeeTemporaryAddress.fromJson(json['temporaryAddress']),
      employeeInsuranceDetails: (json['employeeInsuranceDetails'] as List)
          .map((e) => EmployeeInsuranceDetail.fromJson(e))
          .toList(),
      employeeDocuments: (json['employeeDocuments'] as List)
          .map((e) => EmployeeDocument.fromJson(e))
          .toList(),
      employeeCurrentShift:
          EmployeeCurrentShift.fromJson(json['employeeCurrentShift']),
    );
  }
}

class EmployeeEducation {
  final String school;
  final String qualification;

  EmployeeEducation({
    required this.school,
    required this.qualification,
  });

  factory EmployeeEducation.fromJson(Map<String, dynamic> json) {
    return EmployeeEducation(
      school: json['school'] ?? '',
      qualification: json['qualification'] ?? '',
    );
  }
}

class EmployeeEmergencyContact {
  final int id;
  final int employeeId;
  final String contactPerson;
  final String phoneNumber;
  final String relation;
  final String? employeeName;
  final String? employeeCode;

  EmployeeEmergencyContact({
    required this.id,
    required this.employeeId,
    required this.contactPerson,
    required this.phoneNumber,
    required this.relation,
    this.employeeName,
    this.employeeCode,
  });

  // Factory method to create an instance from JSON
  factory EmployeeEmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmployeeEmergencyContact(
      id: json['id'],
      employeeId: json['employeeId'],
      contactPerson: json['contactPerson'],
      phoneNumber: json['phoneNumber'],
      relation: json['relation'],
      employeeName: json['employeeName'],
      employeeCode: json['employeeCode'],
    );
  }

  // Method to convert the object into a JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'contactPerson': contactPerson,
      'phoneNumber': phoneNumber,
      'relation': relation,
      'employeeName': employeeName,
      'employeeCode': employeeCode,
    };
  }
}

class EmployeeNominee {
  final String name;
  final String relation;

  EmployeeNominee({
    required this.name,
    required this.relation,
  });

  factory EmployeeNominee.fromJson(Map<String, dynamic> json) {
    return EmployeeNominee(
      name: json['name'] ?? '',
      relation: json['relation'] ?? '',
    );
  }
}

class EmployeePermanentAddress {
  final String addressLine1;
  final String? city;
  final String ward;
  final String municipalName;

  EmployeePermanentAddress({
    required this.addressLine1,
    this.city,
    required this.ward,
    required this.municipalName,
  });

  factory EmployeePermanentAddress.fromJson(Map<String, dynamic> json) {
    return EmployeePermanentAddress(
      addressLine1: json['addressLine1'] ?? '',
      city: json['city'] ?? '',
      ward: json['ward'] ?? '',
      municipalName: json['municipalName'] ?? '',
    );
  }
}

class EmployeeTemporaryAddress {
  final String addressLine1;
  final String? city;
  final String ward;
  final String municipalName;

  EmployeeTemporaryAddress({
    required this.addressLine1,
    this.city,
    required this.ward,
    required this.municipalName,
  });

  factory EmployeeTemporaryAddress.fromJson(Map<String, dynamic> json) {
    return EmployeeTemporaryAddress(
      addressLine1: json['addressLine1'] ?? '',
      city: json['city'] ?? '',
      ward: json['ward'] ?? '',
      municipalName: json['municipalName'] ?? '',
    );
  }
}

class EmployeeInsuranceDetail {
  final String? employeeCode;
  final String type;
  final String enddate;
  final String startdate;
  final String policyNumber;
  final String employeeName;
  final String amount;
  final String isIncomeTaxExceptionApplicable;
  final String company;

  EmployeeInsuranceDetail({
    this.employeeCode,
    required this.company,
    required this.type,
    required this.enddate,
    required this.startdate,
    required this.policyNumber,
    required this.employeeName,
    required this.amount,
    required this.isIncomeTaxExceptionApplicable,
  });

  factory EmployeeInsuranceDetail.fromJson(Map<String, dynamic> json) {
    return EmployeeInsuranceDetail(
      company: json['company']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      startdate: json['insuredFromDate']?.toString() ?? '',
      enddate: json['insuredToDate']?.toString() ?? '',
      policyNumber: json['policyNumber']?.toString() ?? '',
      employeeName: json['employeeName']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
      isIncomeTaxExceptionApplicable:
          json['isIncomeTaxExemptionApplicable']?.toString() ?? '',
    );
  }
}

class EmployeeDocument {
  final int? id;
  final int? documentNumberSequence;
  final String documentNumber;
  final int? employeeId;
  final int? documentTypeId;
  final String? attachmentPath;
  final String? issueDate;
  final String? issueDateNp;
  final String? issuePlace;
  final String? expiryDateNp;
  final String? expiryDate;
  final String? notificationType;
  final int? days;
  final String employeeName;
  final String? employeeCode;
  final String? documentType;

  EmployeeDocument({
    this.id,
    this.documentNumberSequence,
    required this.documentNumber,
    this.employeeId,
    this.documentTypeId,
    this.attachmentPath,
    this.issueDate,
    this.issueDateNp,
    this.issuePlace,
    this.expiryDateNp,
    this.expiryDate,
    this.notificationType,
    this.days,
    required this.employeeName,
    this.employeeCode,
    this.documentType,
  });

  // Convert JSON to Model
  factory EmployeeDocument.fromJson(Map<String, dynamic> json) {
    return EmployeeDocument(
      id: json['id'] ?? 0,
      documentNumberSequence: json['documentNumberSequence'] ?? 0,
      documentNumber: json['documentNumber'] ?? '',
      employeeId: json['employeeId'] ?? 0,
      documentTypeId: json['documentTypeId'] ?? 0,
      attachmentPath: json['attachmentPath'] ?? '',
      issueDate: json['issueDate'] ?? '',
      issueDateNp: json['issueDateNp'] ?? '',
      issuePlace: json['issuePlace'] ?? '',
      expiryDateNp: json['expiryDateNp'],
      expiryDate: json['expiryDate'],
      notificationType: json['notificationType'],
      days: json['days'] ?? 0,
      employeeName: json['employeeName'] ?? '',
      employeeCode: json['employeeCode'] ?? '',
      documentType: json['documentType'] ?? '',
    );
  }

  // Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentNumberSequence': documentNumberSequence,
      'documentNumber': documentNumber,
      'employeeId': employeeId,
      'documentTypeId': documentTypeId,
      'attachmentPath': attachmentPath,
      'issueDate': issueDate,
      'issueDateNp': issueDateNp,
      'issuePlace': issuePlace,
      'expiryDateNp': expiryDateNp,
      'expiryDate': expiryDate,
      'notificationType': notificationType,
      'days': days,
      'employeeName': employeeName,
      'employeeCode': employeeCode,
      'documentType': documentType,
    };
  }

  // Convert a list of JSON objects to a list of EmployeeDocument objects
  static List<EmployeeDocument> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => EmployeeDocument.fromJson(json)).toList();
  }
}

class EmployeeCurrentShift {
  String? currentDate;
  String? currentDateNp;
  bool? hasMultiShift;
  int? primaryShiftTypeId;
  int? extendedShiftTypeId;
  String? primaryShiftName;
  String? primaryShiftTime;
  String? primaryShiftStart;
  String? primaryShiftEnd;
  String? breakEndTime;
  String? breakStartTime;
  String? extendedShiftName;
  String? extendedShiftTime;
  String? extendedShiftStart;
  String? extendedShiftEnd;
  int? employeeId;
  bool? isContinuousShift;
  bool? hasBreak;
  bool? isFlexibleBreak;
  String? primaryBreakDuration;

  EmployeeCurrentShift({
    this.currentDate,
    this.currentDateNp,
    this.hasMultiShift,
    this.primaryShiftTypeId,
    this.extendedShiftTypeId,
    this.primaryShiftName,
    this.primaryShiftTime,
    this.primaryShiftStart,
    this.primaryShiftEnd,
    this.breakEndTime,
    this.breakStartTime,
    this.extendedShiftName,
    this.extendedShiftTime,
    this.extendedShiftStart,
    this.extendedShiftEnd,
    this.employeeId,
    this.isContinuousShift,
    this.hasBreak,
    this.isFlexibleBreak,
    this.primaryBreakDuration,
  });

  // Factory method to create an instance from a JSON object
  factory EmployeeCurrentShift.fromJson(Map<String, dynamic> json) {
    return EmployeeCurrentShift(
      currentDate: json['currentDate'],
      currentDateNp: json['currentDateNp'],
      hasMultiShift: json['hasMultiShift'],
      primaryShiftTypeId: json['primaryShiftTypeId'],
      extendedShiftTypeId: json['extendedShiftTypeId'],
      primaryShiftName: json['primaryShiftName'],
      primaryShiftTime: json['primaryShiftTime'],
      primaryShiftStart: json['primaryShiftStart'],
      primaryShiftEnd: json['primaryShiftEnd'],
      breakEndTime: json['breakEndTime'],
      breakStartTime: json['breakStartTime'],
      extendedShiftName: json['extendedShiftName'],
      extendedShiftTime: json['extendedShiftTime'],
      extendedShiftStart: json['extendedShiftStart'],
      extendedShiftEnd: json['extendedShiftEnd'],
      employeeId: json['employeeId'],
      isContinuousShift: json['isContinuousShift'],
      hasBreak: json['hasBreak'],
      isFlexibleBreak: json['isFlexibleBreak'],
      primaryBreakDuration: json['primaryBreakDuration'],
    );
  }

  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'currentDate': currentDate,
      'currentDateNp': currentDateNp,
      'hasMultiShift': hasMultiShift,
      'primaryShiftTypeId': primaryShiftTypeId,
      'extendedShiftTypeId': extendedShiftTypeId,
      'primaryShiftName': primaryShiftName,
      'primaryShiftTime': primaryShiftTime,
      'primaryShiftStart': primaryShiftStart,
      'primaryShiftEnd': primaryShiftEnd,
      'breakEndTime': breakEndTime,
      'breakStartTime': breakStartTime,
      'extendedShiftName': extendedShiftName,
      'extendedShiftTime': extendedShiftTime,
      'extendedShiftStart': extendedShiftStart,
      'extendedShiftEnd': extendedShiftEnd,
      'employeeId': employeeId,
      'isContinuousShift': isContinuousShift,
      'hasBreak': hasBreak,
      'isFlexibleBreak': isFlexibleBreak,
      'primaryBreakDuration': primaryBreakDuration,
    };
  }
}
