class AttendanceReport {
  final Filter filter;
  final List<AttendanceSummary> attendanceSummary;
  final List<AttendanceDetails> attendanceDetails;

  AttendanceReport({
    required this.filter,
    required this.attendanceSummary,
    required this.attendanceDetails,
  });

  factory AttendanceReport.fromJson(Map<String, dynamic> json) {
    return AttendanceReport(
      filter: Filter.fromJson(json['filter']),
      attendanceSummary: (json['attendanceSummary'] as List)
          .map((e) => AttendanceSummary.fromJson(e))
          .toList(),
      attendanceDetails: (json['attendanceDetails'] as List)
          .map((e) => AttendanceDetails.fromJson(e))
          .toList(),
    );
  }
}

class Filter {
  final DateTime fromDate;
  final DateTime toDate;
  final String shiftType;

  Filter({
    required this.fromDate,
    required this.toDate,
    required this.shiftType,
  });

  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
      shiftType: json['shiftType'],
    );
  }

  // Correct toJson() method that returns a Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'shiftType': shiftType,
    };
  }
}

class AttendanceSummary {
  final String category;
  final double qty;

  AttendanceSummary({
    required this.category,
    required this.qty,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      category: json['category'],
      qty: json['qty'].toDouble(),
    );
  }
}

class AttendanceDetails {
  final DateTime attendanceDate;
  final String attendanceDateNp;
  final String employeeName;
  final String? departmentName;
  final String dutyType;
  final String shiftTitle;
  final String shiftTime;
  final DateTime shiftStartTime;
  final DateTime shiftEndTime;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final DateTime? breakOutTime;
  final DateTime? breakInTime;
  final String? status;
  final String? remarks;
  final String statusFullName;
  final String statusColorCode;

  AttendanceDetails({
    required this.attendanceDate,
    required this.attendanceDateNp,
    required this.employeeName,
    this.departmentName,
    required this.dutyType,
    required this.shiftTitle,
    required this.shiftTime,
    required this.shiftStartTime,
    required this.shiftEndTime,
    this.checkInTime,
    this.checkOutTime,
    this.breakOutTime,
    this.breakInTime,
    this.status,
    this.remarks,
    required this.statusFullName,
    required this.statusColorCode,
  });

  factory AttendanceDetails.fromJson(Map<String, dynamic> json) {
    return AttendanceDetails(
      attendanceDate: DateTime.parse(json['attendanceDate']),
      attendanceDateNp: json['attendanceDateNp'],
      employeeName: json['employeeName'],
      departmentName: json['departmentName'],
      dutyType: json['dutyType'],
      shiftTitle: json['shiftTitle'],
      shiftTime: json['shiftTime'],
      shiftStartTime: DateTime.parse(json['shiftStartTime']),
      shiftEndTime: DateTime.parse(json['shiftEndTime']),
      checkInTime: json['checkInTime'] != null
          ? DateTime.parse(json['checkInTime'])
          : null,
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.parse(json['checkOutTime'])
          : null,
      breakOutTime: json['breakOutTime'] != null
          ? DateTime.parse(json['breakOutTime'])
          : null,
      breakInTime: json['breakInTime'] != null
          ? DateTime.parse(json['breakInTime'])
          : null,
      status: json['status'],
      remarks: json['remarks'],
      statusFullName: json['statusFullName'],
      statusColorCode: json['statusColorCode'],
    );
  }
}
