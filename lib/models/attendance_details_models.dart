class AttendanceDetailsModel {
  Filter filter;
  List<AttendanceSummary> attendanceSummary;
  List<AttendanceDetail> attendanceDetails;

  AttendanceDetailsModel({
    required this.filter,
    required this.attendanceSummary,
    required this.attendanceDetails,
  });

  factory AttendanceDetailsModel.fromJson(Map<String, dynamic> json) {
    return AttendanceDetailsModel(
      filter: json["filter"] != null
          ? Filter.fromJson(json["filter"])
          : Filter(
              fromDate: DateTime.now(), toDate: DateTime.now(), shiftType: ""),
      attendanceSummary: json["attendanceSummary"] != null
          ? List<AttendanceSummary>.from(json["attendanceSummary"]
              .map((x) => AttendanceSummary.fromJson(x)))
          : [],
      attendanceDetails: json["attendanceDetails"] != null
          ? List<AttendanceDetail>.from(json["attendanceDetails"]
              .map((x) => AttendanceDetail.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "filter": filter.toJson(),
        "attendanceSummary":
            List<dynamic>.from(attendanceSummary.map((x) => x.toJson())),
        "attendanceDetails":
            List<dynamic>.from(attendanceDetails.map((x) => x.toJson())),
      };
}

class AttendanceSummary {
  String category;
  double qty;

  AttendanceSummary({
    required this.category,
    required this.qty,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      category: json["category"] ?? "",
      qty: json["qty"]?.toDouble() ?? 0.0, // Safely convert qty to double
    );
  }

  Map<String, dynamic> toJson() => {
        "category": category,
        "qty": qty,
      };
}

class AttendanceDetail {
  DateTime attendanceDate;
  String attendanceDateNp;
  String employeeName;
  dynamic departmentName;
  String dutyType;
  String shiftTitle;
  String shiftTime;
  DateTime shiftStartTime;
  DateTime shiftEndTime;
  dynamic checkInTime;
  dynamic checkOutTime;
  dynamic breakOutTime;
  dynamic breakInTime;
  dynamic status;
  dynamic remarks;
  String statusFullName;
  String statusColorCode;

  AttendanceDetail({
    required this.attendanceDate,
    required this.attendanceDateNp,
    required this.employeeName,
    required this.departmentName,
    required this.dutyType,
    required this.shiftTitle,
    required this.shiftTime,
    required this.shiftStartTime,
    required this.shiftEndTime,
    required this.checkInTime,
    required this.checkOutTime,
    required this.breakOutTime,
    required this.breakInTime,
    required this.status,
    required this.remarks,
    required this.statusFullName,
    required this.statusColorCode,
  });

  factory AttendanceDetail.fromJson(Map<String, dynamic> json) {
    return AttendanceDetail(
      attendanceDate:
          DateTime.tryParse(json["attendanceDate"] ?? "") ?? DateTime.now(),
      attendanceDateNp: json["attendanceDateNp"] ?? "",
      employeeName: json["employeeName"] ?? "",
      departmentName: json["departmentName"], // If it is null, keep it as null
      dutyType: json["dutyType"] ?? "",
      shiftTitle: json["shiftTitle"] ?? "",
      shiftTime: json["shiftTime"] ?? "",

      shiftStartTime:
          DateTime.tryParse(json["shiftStartTime"] ?? "") ?? DateTime.now(),
      shiftEndTime:
          DateTime.tryParse(json["shiftEndTime"] ?? "") ?? DateTime.now(),
      checkInTime: json["checkInTime"],
      checkOutTime: json["checkOutTime"],
      breakOutTime: json["breakOutTime"],
      breakInTime: json["breakInTime"],
      status: json["status"],
      remarks: json["remarks"],
      statusFullName: json["statusFullName"] ?? "",
      statusColorCode: json["statusColorCode"] ?? "",
    );
  }
  Map<String, dynamic> toJson() => {
        "attendanceDate": attendanceDate.toIso8601String(),
        "attendanceDateNp": attendanceDateNp,
        "employeeName": employeeName,
        "departmentName": departmentName,
        "dutyType": dutyType,
        "shiftTitle": shiftTitle,
        "shiftTime": shiftTime,
        "shiftStartTime": shiftStartTime.toIso8601String(),
        "shiftEndTime": shiftEndTime.toIso8601String(),
        "checkInTime": checkInTime,
        "checkOutTime": checkOutTime,
        "breakOutTime": breakOutTime,
        "breakInTime": breakInTime,
        "status": status,
        "remarks": remarks,
        "statusFullName": statusFullName,
        "statusColorCode": statusColorCode,
      };
}

class Filter {
  DateTime fromDate;
  DateTime toDate;
  String shiftType;

  Filter({
    required this.fromDate,
    required this.toDate,
    required this.shiftType,
  });

  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(
      fromDate: DateTime.tryParse(json["fromDate"] ?? "") ?? DateTime.now(),
      toDate: DateTime.tryParse(json["toDate"] ?? "") ?? DateTime.now(),
      shiftType: json["shiftType"] ?? "",
    );
  }
  Map<String, dynamic> toJson() => {
        "fromDate": fromDate.toIso8601String(),
        "toDate": toDate.toIso8601String(),
        "shiftType": shiftType,
      };
}
