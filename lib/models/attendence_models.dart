class Attendance {
  final int workingDaysPrimary;
  final int presentPrimary;
  final int weekendPrimary;
  final int leavePrimary;
  final int absentPrimary;

  final int workingDaysExtended;
  final int presentExtended;
  final int weekendExtended;
  final int leaveExtended;
  final int absentExtended;

  Attendance({
    required this.workingDaysPrimary,
    required this.presentPrimary,
    required this.weekendPrimary,
    required this.leavePrimary,
    required this.absentPrimary,
    required this.workingDaysExtended,
    required this.presentExtended,
    required this.weekendExtended,
    required this.leaveExtended,
    required this.absentExtended,
  });

  factory Attendance.fromJson(
      Map<String, dynamic> primary, Map<String, dynamic> extended) {
    return Attendance(
      workingDaysPrimary: (primary['Working Days'] ?? 0).toInt(),
      presentPrimary: (primary['Present'] ?? 0).toInt(),
      weekendPrimary: (primary['Week End'] ?? 0).toInt(),
      leavePrimary: (primary['Leave'] ?? 0).toInt(),
      absentPrimary: (primary['Absent'] ?? 0).toInt(),
      workingDaysExtended: (extended['Working Days'] ?? 0).toInt(),
      presentExtended: (extended['Present'] ?? 0).toInt(),
      weekendExtended: (extended['Week End'] ?? 0).toInt(),
      leaveExtended: (extended['Leave'] ?? 0).toInt(),
      absentExtended: (extended['Absent'] ?? 0).toInt(),
    );
  }
}
