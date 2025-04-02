class LeaveApplicationRequest {
  // int? id;
  // String? applicationDate;
  // String? applicationDateNp;
  int? leaveTypeId;
  // int? employeeId;
  String? fromDate;
  String? fromDateNp;
  String? toDate;
  String? toDateNp;
  String? halfDayStatus;
  int? totalLeaveDays;
  String? reason;
  String? extendedFromDate;
  String? extendedToDate;
  String? extendedFromDateNp;
  String? extendedToDateNp;
  int? extendedLeaveTypeId;
  int? substituteEmployeeId;
  bool? isHalfDay;

  LeaveApplicationRequest({
    this.leaveTypeId,
    this.fromDate,
    this.fromDateNp,
    this.toDate,
    this.toDateNp,
    this.halfDayStatus,
    this.totalLeaveDays,
    this.reason,
    this.extendedFromDate,
    this.extendedToDate,
    this.extendedFromDateNp,
    this.extendedToDateNp,
    this.extendedLeaveTypeId,
    this.substituteEmployeeId,
    this.isHalfDay,
  });

  Map<String, dynamic> toJson() {
    return {
      'LeaveTypeId': leaveTypeId,
      'FromDate': fromDate,
      'FromDateNp': fromDateNp,
      'ToDate': toDate,
      'ToDateNp': toDateNp,
      'HalfDayStatus': halfDayStatus,
      'TotalLeaveDays': totalLeaveDays,
      'ExtendedFromDate': extendedFromDate,
      'ExtendedToDate': extendedToDate,
      'ExtendedFromDateNp': extendedFromDateNp,
      'ExtendedToDateNp': extendedToDateNp,
      'ExtendedLeaveTypeId': extendedLeaveTypeId,
      'SubstituteEmployeeId': substituteEmployeeId,
      'IsHalfDay': isHalfDay,
    };
  }
}
