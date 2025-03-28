class Leave {
  final String leaveType;
  final double allocated;
  final double taken;
  final double balance;
  final DateTime fromDate;
  final DateTime toDate;
  final String fromDateNp;
  final String toDateNp;

  Leave({
    required this.leaveType,
    required this.allocated,
    required this.taken,
    required this.balance,
    required this.fromDate,
    required this.toDate,
    required this.fromDateNp,
    required this.toDateNp,
  });

  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
      leaveType: json['leaveType'],
      allocated: (json['allocated'] as num).toDouble(),
      taken: (json['taken'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
      fromDateNp: json['fromDateNp'],
      toDateNp: json['toDateNp'],
    );
  }
}

class LeaveApplication {
  final int id;
  final String applicationDate;
  final String applicationDateNp;
  final int leaveTypeId;
  final int employeeId;
  final String fromDate;
  final String fromDateNp;
  final String toDate;
  final String toDateNp;
  final dynamic halfDayStatus;
  final double totalLeaveDays;
  final dynamic extendedFromDate;
  final dynamic extendedToDate;
  final dynamic extendedFromDateNp;
  final dynamic extendedToDateNp;
  final dynamic extendedLeaveTypeId;
  final dynamic extendedHalfDayStatus;
  final double extendedTotalLeaveDays;
  final String reason;
  final String status;
  final String leaveTypeName;
  final dynamic extendedLeaveTypeName;
  final String employeeDisplayName;
  final bool isRecommendationApproved;
  final bool isApproved;
  final bool isSubstituteAccepted;
  final String substitutationStatus;
  final String recommendationStatus;
  final String leaveNo;
  final bool isInValidForApproval;
  final dynamic leaveApprovedBy;
  final dynamic approveRemarks;
  final dynamic leaveApprovedOn;
  final dynamic rejectedBy;
  final dynamic recommendationApprovedBy;
  final dynamic recommendationApprovedOn;
  final dynamic recommendationRemarks;
  final dynamic substituteAcceptRejectBy;
  final dynamic substituteAcceptRejectOn;
  final dynamic substituteRemarks;
  final dynamic substituteEmployeeName;
  final dynamic recommendedByEmployeeName;

  LeaveApplication({
    required this.id,
    required this.applicationDate,
    required this.applicationDateNp,
    required this.leaveTypeId,
    required this.employeeId,
    required this.fromDate,
    required this.fromDateNp,
    required this.toDate,
    required this.toDateNp,
    this.halfDayStatus,
    required this.totalLeaveDays,
    this.extendedFromDate,
    this.extendedToDate,
    this.extendedFromDateNp,
    this.extendedToDateNp,
    this.extendedLeaveTypeId,
    this.extendedHalfDayStatus,
    required this.extendedTotalLeaveDays,
    required this.reason,
    required this.status,
    required this.leaveTypeName,
    this.extendedLeaveTypeName,
    required this.employeeDisplayName,
    required this.isRecommendationApproved,
    required this.isApproved,
    required this.isSubstituteAccepted,
    required this.substitutationStatus,
    required this.recommendationStatus,
    required this.leaveNo,
    required this.isInValidForApproval,
    this.leaveApprovedBy,
    this.approveRemarks,
    this.leaveApprovedOn,
    this.rejectedBy,
    this.recommendationApprovedBy,
    this.recommendationApprovedOn,
    this.recommendationRemarks,
    this.substituteAcceptRejectBy,
    this.substituteAcceptRejectOn,
    this.substituteRemarks,
    this.substituteEmployeeName,
    this.recommendedByEmployeeName,
  });

  // Factory method to convert JSON to Leave object
  factory LeaveApplication.fromJson(Map<String, dynamic> json) {
    return LeaveApplication(
      id: json['id'],
      applicationDate: json['applicationDate'],
      applicationDateNp: json['applicationDateNp'],
      leaveTypeId: json['leaveTypeId'],
      employeeId: json['employeeId'],
      fromDate: json['fromDate'],
      fromDateNp: json['fromDateNp'],
      toDate: json['toDate'],
      toDateNp: json['toDateNp'],
      halfDayStatus: json['halfDayStatus'],
      totalLeaveDays: json['totalLeaveDays'].toDouble(),
      extendedFromDate: json['extendedFromDate'],
      extendedToDate: json['extendedToDate'],
      extendedFromDateNp: json['extendedFromDateNp'],
      extendedToDateNp: json['extendedToDateNp'],
      extendedLeaveTypeId: json['extendedLeaveTypeId'],
      extendedHalfDayStatus: json['extendedHalfDayStatus'],
      extendedTotalLeaveDays: json['extendedTotalLeaveDays'].toDouble(),
      reason: json['reason'],
      status: json['status'],
      leaveTypeName: json['leaveTypeName'],
      extendedLeaveTypeName: json['extendedLeaveTypeName'],
      employeeDisplayName: json['employeeDisplayName'],
      isRecommendationApproved: json['isRecommendationApproved'],
      isApproved: json['isApproved'],
      isSubstituteAccepted: json['isSubstituteAccepted'],
      substitutationStatus: json['substitutationStatus'],
      recommendationStatus: json['recommendationStatus'],
      leaveNo: json['leaveNo'],
      isInValidForApproval: json['isInValidForApproval'],
      leaveApprovedBy: json['leaveApprovedBy'],
      approveRemarks: json['approveRemarks'],
      leaveApprovedOn: json['leaveApprovedOn'],
      rejectedBy: json['rejectedBy'],
      recommendationApprovedBy: json['recommendationApprovedBy'],
      recommendationApprovedOn: json['recommendationApprovedOn'],
      recommendationRemarks: json['recommendationRemarks'],
      substituteAcceptRejectBy: json['substituteAcceptRejectBy'],
      substituteAcceptRejectOn: json['substituteAcceptRejectOn'],
      substituteRemarks: json['substituteRemarks'],
      substituteEmployeeName: json['substituteEmployeeName'],
      recommendedByEmployeeName: json['recommendedByEmployeeName'],
    );
  }

  // Method to convert Leave object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'applicationDate': applicationDate,
      'applicationDateNp': applicationDateNp,
      'leaveTypeId': leaveTypeId,
      'employeeId': employeeId,
      'fromDate': fromDate,
      'fromDateNp': fromDateNp,
      'toDate': toDate,
      'toDateNp': toDateNp,
      'halfDayStatus': halfDayStatus,
      'totalLeaveDays': totalLeaveDays,
      'extendedFromDate': extendedFromDate,
      'extendedToDate': extendedToDate,
      'extendedFromDateNp': extendedFromDateNp,
      'extendedToDateNp': extendedToDateNp,
      'extendedLeaveTypeId': extendedLeaveTypeId,
      'extendedHalfDayStatus': extendedHalfDayStatus,
      'extendedTotalLeaveDays': extendedTotalLeaveDays,
      'reason': reason,
      'status': status,
      'leaveTypeName': leaveTypeName,
      'extendedLeaveTypeName': extendedLeaveTypeName,
      'employeeDisplayName': employeeDisplayName,
      'isRecommendationApproved': isRecommendationApproved,
      'isApproved': isApproved,
      'isSubstituteAccepted': isSubstituteAccepted,
      'substitutationStatus': substitutationStatus,
      'recommendationStatus': recommendationStatus,
      'leaveNo': leaveNo,
      'isInValidForApproval': isInValidForApproval,
      'leaveApprovedBy': leaveApprovedBy,
      'approveRemarks': approveRemarks,
      'leaveApprovedOn': leaveApprovedOn,
      'rejectedBy': rejectedBy,
      'recommendationApprovedBy': recommendationApprovedBy,
      'recommendationApprovedOn': recommendationApprovedOn,
      'recommendationRemarks': recommendationRemarks,
      'substituteAcceptRejectBy': substituteAcceptRejectBy,
      'substituteAcceptRejectOn': substituteAcceptRejectOn,
      'substituteRemarks': substituteRemarks,
      'substituteEmployeeName': substituteEmployeeName,
      'recommendedByEmployeeName': recommendedByEmployeeName,
    };
  }
}

class LeaveContractPeriodAndFiscalYeAR {
  String text;
  String value;

  LeaveContractPeriodAndFiscalYeAR({
    required this.text,
    required this.value,
  });

  // From JSON to model
  factory LeaveContractPeriodAndFiscalYeAR.fromJson(Map<String, dynamic> json) {
    return LeaveContractPeriodAndFiscalYeAR(
      text: json['text'],
      value: json['value'],
    );
  }

  // From model to JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'value': value,
    };
  }
}
