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
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return TicketMeAndAssignToMe(
      id: parseInt(json['id']),
      ticketNo: json['ticketNo'] ?? '',
      ticketNoSequence: parseInt(json['ticketNoSequence']),
      ticketYearSequence: parseInt(json['ticketYearSequence']),
      ticketMonthlySequence: parseInt(json['ticketMonthlySequence']),
      ticketDailySequence: parseInt(json['ticketDailySequence']),
      ticketMonthlyNpSequence: parseInt(json['ticketMonthlyNpSequence']),
      ticketYearlyNpSequence: parseInt(json['ticketYearlyNpSequence']),
      ticketFySequence: parseInt(json['ticketFySequence']),
      ticketYearlySequenceByCategory:
          parseInt(json['ticketYearlySequenceByCategory']),
      ticketMonthlySequenceByCategory:
          parseInt(json['ticketMonthlySequenceByCategory']),
      ticketDailySequenceByCategory:
          parseInt(json['ticketDailySequenceByCategory']),
      ticketNo2: json['ticketNo2'] ?? '',
      applicationUserId: json['applicationUserId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      ticketDate: json['ticketDate'] != null
          ? DateTime.tryParse(json['ticketDate']) ?? DateTime.now()
          : DateTime.now(),
      status: json['status'] ?? '',
      severity: json['severity'] ?? '',
      priority: json['priority'] ?? '',
      ticketCategoryId: parseInt(json['ticketCategoryId']),
      ticketCategoryName: json['ticketCategoryName'],
      assignToEmployeeId: parseInt(json['assignToEmployeeId']),
      assignedTo: json['assignedTo'] ?? '',
      assignedOn: json['assignedOn'] != null
          ? DateTime.tryParse(json['assignedOn']) ?? DateTime.now()
          : DateTime.now(),
      issueByEmployeeId: json['issueByEmployeeId'],
      issueBy: json['issueBy'] ?? '',
      issueOn: json['issueOn'] != null
          ? DateTime.tryParse(json['issueOn']) ?? DateTime.now()
          : DateTime.now(),
      sessionTag: json['sessionTag'],
      attachmentFiles: json['attachmentFiles'] is List
          ? List.from(json['attachmentFiles'])
          : [],
      attachedDocuments: json['attachedDocuments'] is List
          ? List.from(json['attachedDocuments'])
          : [],
      insertUser: json['insertUser'] ?? '',
      insertTime: json['insertTime'] != null
          ? DateTime.tryParse(json['insertTime']) ?? DateTime.now()
          : DateTime.now(),
      updateUser: json['updateUser'] ?? '',
      updateTime: json['updateTime'] != null
          ? DateTime.tryParse(json['updateTime']) ?? DateTime.now()
          : DateTime.now(),
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
