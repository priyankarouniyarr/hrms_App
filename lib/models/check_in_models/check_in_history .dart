class EmployeePunch {
  final int employeeId;
  final DateTime punchTime;
  final String? punchTimeNp;
  final String? logType;
  final bool skipAutoAttendence;
  final String? deviceId;
  final String? employee;
  final int id;
  final String insertUser;
  final DateTime insertTime;
  final String? updateUser;
  final DateTime? updateTime;
  final bool isDeleted;
  final String? deletedBy;
  final DateTime? deletedOn;
  final int? branchId;
  final String? branch;
  final String? dimension1;
  final String? dimension2;
  final String systemDtl;
  final dynamic extra;

  EmployeePunch({
    required this.employeeId,
    required this.punchTime,
    this.punchTimeNp,
    this.logType,
    required this.skipAutoAttendence,
    this.deviceId,
    this.employee,
    required this.id,
    required this.insertUser,
    required this.insertTime,
    this.updateUser,
    this.updateTime,
    required this.isDeleted,
    this.deletedBy,
    this.deletedOn,
    this.branchId,
    this.branch,
    this.dimension1,
    this.dimension2,
    required this.systemDtl,
    this.extra,
  });

  factory EmployeePunch.fromJson(Map<String, dynamic> json) {
    return EmployeePunch(
      employeeId: json['employeeId'] as int,
      punchTime: DateTime.parse(json['punchTime'] as String),
      punchTimeNp: json['punchTimeNp'] as String?,
      logType: json['logType'] as String?,
      skipAutoAttendence: json['skipAutoAttendence'] as bool,
      deviceId: json['deviceId'] as String?,
      employee: json['employee'] as String?,
      id: json['id'] as int,
      insertUser: json['insertUser'] as String,
      insertTime: DateTime.parse(json['insertTime'] as String),
      updateUser: json['updateUser'] as String?,
      updateTime: json['updateTime'] != null
          ? DateTime.parse(json['updateTime'] as String)
          : null,
      isDeleted: json['isDeleted'] as bool,
      deletedBy: json['deletedBy'] as String?,
      deletedOn: json['deletedOn'] != null
          ? DateTime.parse(json['deletedOn'] as String)
          : null,
      branchId: json['branchId'] as int?,
      branch: json['branch'] as String?,
      dimension1: json['dimension1'] as String?,
      dimension2: json['dimension2'] as String?,
      systemDtl: json['systemDtl'] as String,
      extra: json['extra'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'punchTime': punchTime.toIso8601String(),
      'punchTimeNp': punchTimeNp,
      'logType': logType,
      'skipAutoAttendence': skipAutoAttendence,
      'deviceId': deviceId,
      'employee': employee,
      'id': id,
      'insertUser': insertUser,
      'insertTime': insertTime.toIso8601String(),
      'updateUser': updateUser,
      'updateTime': updateTime?.toIso8601String(),
      'isDeleted': isDeleted,
      'deletedBy': deletedBy,
      'deletedOn': deletedOn?.toIso8601String(),
      'branchId': branchId,
      'branch': branch,
      'dimension1': dimension1,
      'dimension2': dimension2,
      'systemDtl': systemDtl,
      'extra': extra,
    };
  }
}
