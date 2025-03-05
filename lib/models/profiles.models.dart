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
  final String relation;
  final int? id;
  final int? employeeId;

  final String contactPerson;
  final String phoneNumber;
  EmployeeEmergencyContact({
    required this.relation,
    this.id, // Optional
    this.employeeId, // Optional
    required this.contactPerson,
    required this.phoneNumber,
  });
  factory EmployeeEmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmployeeEmergencyContact(
      relation: json['relation'] ?? 'Unknown',
      id: json['id'],
      employeeId: json['employeeId'],
      contactPerson: json['contactPerson'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
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
  final String type;
  final String enddate;
  final String startdate;
  final String policyNumber;
  final String employeeName;
  final String amount;
  final String isIncomeTaxExceptionApplicable;

  EmployeeInsuranceDetail({
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
  final String documentType;
  final String attachmentPath;

  EmployeeDocument({
    required this.documentType,
    required this.attachmentPath,
  });

  factory EmployeeDocument.fromJson(Map<String, dynamic> json) {
    return EmployeeDocument(
      documentType: json['documentType'] ?? '',
      attachmentPath: json['attachmentPath'] ?? '',
    );
  }
}

class EmployeeCurrentShift {
  final String primaryShiftName;
  final String primaryShiftTime;

  EmployeeCurrentShift({
    required this.primaryShiftName,
    required this.primaryShiftTime,
  });

  factory EmployeeCurrentShift.fromJson(Map<String, dynamic> json) {
    return EmployeeCurrentShift(
      primaryShiftName: json['primaryShiftName'] ?? '',
      primaryShiftTime: json['primaryShiftTime'] ?? '',
    );
  }
}
