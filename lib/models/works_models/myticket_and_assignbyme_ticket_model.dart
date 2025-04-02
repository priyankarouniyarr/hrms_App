class MyticketPost {
  final int CategoryId;
  final String status;
  final String priority;
  final String severity;
  final String assignTo;
  final String fromdate;
  final String todate;
  final String orderby;

  MyticketPost({
    required this.CategoryId,
    required this.status,
    required this.priority,
    required this.severity,
    required this.assignTo,
    required this.fromdate,
    required this.todate,
    required this.orderby,
  });

  Map<String, dynamic> toJson() {
    return {
      "CategoryId": CategoryId,
      "Status": status,
      "Priority": priority,
      "Severity": severity,
      "AssignedTo": assignTo,
      "FromDate": fromdate,
      "ToDate": todate,
      "OrderBy": orderby,
    };
  }
}

//response model

class TicketMeAndAssignToMe {
  final int id;
  final String ticketNo;
  final int ticketNoSequence;
  final int ticketYearSequence;
  final int ticketMonthlySequence;
  final int ticketDailySequence;
  final int ticketMonthlyNpSequence;
  final int ticketYearlyNpSequence;
  final int ticketFySequence;
  final int ticketYearlySequenceByCategory;
  final int ticketMonthlySequenceByCategory;
  final int ticketDailySequenceByCategory;
  final String ticketNo2;
  final String applicationUserId;
  final String title;
  final String description;
  final DateTime ticketDate;
  final String status;
  final String severity;
  final String priority;
  final int ticketCategoryId;
  final String? ticketCategoryName;
  final int assignToEmployeeId;
  final String assignedTo;
  final DateTime assignedOn;
  final String? issueByEmployeeId;
  final String issueBy;
  final DateTime issueOn;
  final String? sessionTag;
  final List<dynamic> attachmentFiles;
  final List<dynamic> attachedDocuments;
  final String insertUser;
  final DateTime insertTime;
  final String updateUser;
  final DateTime updateTime;

  TicketMeAndAssignToMe({
    required this.id,
    required this.ticketNo,
    required this.ticketNoSequence,
    required this.ticketYearSequence,
    required this.ticketMonthlySequence,
    required this.ticketDailySequence,
    required this.ticketMonthlyNpSequence,
    required this.ticketYearlyNpSequence,
    required this.ticketFySequence,
    required this.ticketYearlySequenceByCategory,
    required this.ticketMonthlySequenceByCategory,
    required this.ticketDailySequenceByCategory,
    required this.ticketNo2,
    required this.applicationUserId,
    required this.title,
    required this.description,
    required this.ticketDate,
    required this.status,
    required this.severity,
    required this.priority,
    required this.ticketCategoryId,
    this.ticketCategoryName,
    required this.assignToEmployeeId,
    required this.assignedTo,
    required this.assignedOn,
    this.issueByEmployeeId,
    required this.issueBy,
    required this.issueOn,
    this.sessionTag,
    required this.attachmentFiles,
    required this.attachedDocuments,
    required this.insertUser,
    required this.insertTime,
    required this.updateUser,
    required this.updateTime,
  });

  factory TicketMeAndAssignToMe.fromJson(Map<String, dynamic> json) {
    return TicketMeAndAssignToMe(
      id: json['id'] ?? '', // Default value if 'id' is missing
      ticketNo:
          json['ticketNo'] ?? '', // Default value if 'ticketNo' is missing
      ticketNoSequence: json['ticketNoSequence'] ??
          0, // Default value if 'ticketNoSequence' is missing
      ticketYearSequence: json['ticketYearSequence'] ??
          0, // Default value if 'ticketYearSequence' is missing
      ticketMonthlySequence: json['ticketMonthlySequence'] ??
          0, // Default value if 'ticketMonthlySequence' is missing
      ticketDailySequence: json['ticketDailySequence'] ??
          0, // Default value if 'ticketDailySequence' is missing
      ticketMonthlyNpSequence: json['ticketMonthlyNpSequence'] ??
          0, // Default value if 'ticketMonthlyNpSequence' is missing
      ticketYearlyNpSequence: json['ticketYearlyNpSequence'] ??
          0, // Default value if 'ticketYearlyNpSequence' is missing
      ticketFySequence: json['ticketFySequence'] ??
          0, // Default value if 'ticketFySequence' is missing
      ticketYearlySequenceByCategory: json['ticketYearlySequenceByCategory'] ??
          0, // Default value if 'ticketYearlySequenceByCategory' is missing
      ticketMonthlySequenceByCategory: json[
              'ticketMonthlySequenceByCategory'] ??
          0, // Default value if 'ticketMonthlySequenceByCategory' is missing
      ticketDailySequenceByCategory: json['ticketDailySequenceByCategory'] ??
          0, // Default value if 'ticketDailySequenceByCategory' is missing
      ticketNo2:
          json['ticketNo2'] ?? '', // Default value if 'ticketNo2' is missing
      applicationUserId: json['applicationUserId'] ??
          '', // Default value if 'applicationUserId' is missing
      title: json['title'] ?? '', // Default value if 'title' is missing
      description: json['description'] ??
          '', // Default value if 'description' is missing
      ticketDate: json['ticketDate'] != null
          ? DateTime.parse(json['ticketDate'])
          : DateTime.now(), // Handle invalid date
      status: json['status'] ?? '', // Default value if 'status' is missing
      severity:
          json['severity'] ?? '', // Default value if 'severity' is missing
      priority:
          json['priority'] ?? '', // Default value if 'priority' is missing
      ticketCategoryId: json['ticketCategoryId'] ??
          '', // Default value if 'ticketCategoryId' is missing
      ticketCategoryName: json['ticketCategoryName'] ??
          '', // Default value if 'ticketCategoryName' is missing
      assignToEmployeeId: json['assignToEmployeeId'] ??
          '', // Default value if 'assignToEmployeeId' is missing
      assignedTo:
          json['assignedTo'] ?? '', // Default value if 'assignedTo' is missing
      assignedOn: json['assignedOn'] != null
          ? DateTime.parse(json['assignedOn'])
          : DateTime.now(), // Handle invalid date
      issueByEmployeeId: json['issueByEmployeeId'] ??
          '', // Default value if 'issueByEmployeeId' is missing
      issueBy: json['issueBy'] ?? '', // Default value if 'issueBy' is missing
      issueOn: json['issueOn'] != null
          ? DateTime.parse(json['issueOn'])
          : DateTime.now(), // Handle invalid date
      sessionTag:
          json['sessionTag'] ?? '', // Default value if 'sessionTag' is missing
      attachmentFiles: json['attachmentFiles'] is List
          ? List.from(json['attachmentFiles'])
          : [], // Ensure it's a List
      attachedDocuments: json['attachedDocuments'] is List
          ? List.from(json['attachedDocuments'])
          : [], // Ensure it's a List
      insertUser:
          json['insertUser'] ?? '', // Default value if 'insertUser' is missing
      insertTime: json['insertTime'] != null
          ? DateTime.parse(json['insertTime'])
          : DateTime.now(), // Handle invalid date
      updateUser:
          json['updateUser'] ?? '', // Default value if 'updateUser' is missing
      updateTime: json['updateTime'] != null
          ? DateTime.parse(json['updateTime'])
          : DateTime.now(), // Handle invalid date
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticketNo': ticketNo,
      'ticketNoSequence': ticketNoSequence,
      'ticketYearSequence': ticketYearSequence,
      'ticketMonthlySequence': ticketMonthlySequence,
      'ticketDailySequence': ticketDailySequence,
      'ticketMonthlyNpSequence': ticketMonthlyNpSequence,
      'ticketYearlyNpSequence': ticketYearlyNpSequence,
      'ticketFySequence': ticketFySequence,
      'ticketYearlySequenceByCategory': ticketYearlySequenceByCategory,
      'ticketMonthlySequenceByCategory': ticketMonthlySequenceByCategory,
      'ticketDailySequenceByCategory': ticketDailySequenceByCategory,
      'ticketNo2': ticketNo2,
      'applicationUserId': applicationUserId,
      'title': title,
      'description': description,
      'ticketDate': ticketDate.toIso8601String(),
      'status': status,
      'severity': severity,
      'priority': priority,
      'ticketCategoryId': ticketCategoryId,
      'ticketCategoryName': ticketCategoryName,
      'assignToEmployeeId': assignToEmployeeId,
      'assignedTo': assignedTo,
      'assignedOn': assignedOn.toIso8601String(),
      'issueByEmployeeId': issueByEmployeeId,
      'issueBy': issueBy,
      'issueOn': issueOn.toIso8601String(),
      'sessionTag': sessionTag,
      'attachmentFiles': attachmentFiles,
      'attachedDocuments': attachedDocuments,
      'insertUser': insertUser,
      'insertTime': insertTime.toIso8601String(),
      'updateUser': updateUser,
      'updateTime': updateTime.toIso8601String(),
    };
  }
}
