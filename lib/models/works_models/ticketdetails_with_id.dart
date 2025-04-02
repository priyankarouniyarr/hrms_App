class TicketDetailsWithId {
  int id;
  Ticket ticket;
  List<TicketActivity> ticketActivity;
  bool isTicketUser;
  String baseUrl;

  TicketDetailsWithId({
    required this.id,
    required this.ticket,
    required this.ticketActivity,
    required this.isTicketUser,
    required this.baseUrl,
  });

  factory TicketDetailsWithId.fromJson(Map<String, dynamic> json) =>
      TicketDetailsWithId(
        id: json["id"],
        ticket: Ticket.fromJson(json["ticket"]),
        ticketActivity: List<TicketActivity>.from(
            json["ticketActivity"].map((x) => TicketActivity.fromJson(x))),
        isTicketUser: json["isTicketUser"],
        baseUrl: json["baseUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ticket": ticket.toJson(),
        "ticketActivity":
            List<dynamic>.from(ticketActivity.map((x) => x.toJson())),
        "isTicketUser": isTicketUser,
        "baseUrl": baseUrl,
      };
}

class Ticket {
  int id;
  String ticketNo;
  int ticketNoSequence;
  int ticketYearSequence;
  int ticketMonthlySequence;
  int ticketDailySequence;
  int ticketMonthlyNpSequence;
  int ticketYearlyNpSequence;
  int ticketFySequence;
  int ticketYearlySequenceByCategory;
  int ticketMonthlySequenceByCategory;
  int ticketDailySequenceByCategory;
  String ticketNo2;
  String applicationUserId;
  String title;
  String description;
  DateTime ticketDate;
  String status;
  String severity;
  String priority;
  int ticketCategoryId;
  String ticketCategoryName;
  int assignToEmployeeId;
  String assignedTo;
  DateTime assignedOn;
  dynamic issueByEmployeeId;
  String issueBy;
  DateTime issueOn;
  dynamic sessionTag;
  dynamic attachmentFiles;
  List<String> attachedDocuments;
  String insertUser;
  DateTime insertTime;
  String updateUser;
  DateTime updateTime;

  Ticket({
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
    required this.ticketCategoryName,
    required this.assignToEmployeeId,
    required this.assignedTo,
    required this.assignedOn,
    required this.issueByEmployeeId,
    required this.issueBy,
    required this.issueOn,
    required this.sessionTag,
    required this.attachmentFiles,
    required this.attachedDocuments,
    required this.insertUser,
    required this.insertTime,
    required this.updateUser,
    required this.updateTime,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        id: json["id"],
        ticketNo: json["ticketNo"],
        ticketNoSequence: json["ticketNoSequence"],
        ticketYearSequence: json["ticketYearSequence"],
        ticketMonthlySequence: json["ticketMonthlySequence"],
        ticketDailySequence: json["ticketDailySequence"],
        ticketMonthlyNpSequence: json["ticketMonthlyNpSequence"],
        ticketYearlyNpSequence: json["ticketYearlyNpSequence"],
        ticketFySequence: json["ticketFySequence"],
        ticketYearlySequenceByCategory: json["ticketYearlySequenceByCategory"],
        ticketMonthlySequenceByCategory:
            json["ticketMonthlySequenceByCategory"],
        ticketDailySequenceByCategory: json["ticketDailySequenceByCategory"],
        ticketNo2: json["ticketNo2"],
        applicationUserId: json["applicationUserId"],
        title: json["title"],
        description: json["description"],
        ticketDate: DateTime.parse(json["ticketDate"]),
        status: json["status"],
        severity: json["severity"],
        priority: json["priority"],
        ticketCategoryId: json["ticketCategoryId"],
        ticketCategoryName: json["ticketCategoryName"],
        assignToEmployeeId: json["assignToEmployeeId"],
        assignedTo: json["assignedTo"],
        assignedOn: DateTime.parse(json["assignedOn"]),
        issueByEmployeeId: json["issueByEmployeeId"],
        issueBy: json["issueBy"],
        issueOn: DateTime.parse(json["issueOn"]),
        sessionTag: json["sessionTag"],
        attachmentFiles: json["attachmentFiles"],
        attachedDocuments:
            List<String>.from(json["attachedDocuments"].map((x) => x)),
        insertUser: json["insertUser"],
        insertTime: DateTime.parse(json["insertTime"]),
        updateUser: json["updateUser"],
        updateTime: DateTime.parse(json["updateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ticketNo": ticketNo,
        "ticketNoSequence": ticketNoSequence,
        "ticketYearSequence": ticketYearSequence,
        "ticketMonthlySequence": ticketMonthlySequence,
        "ticketDailySequence": ticketDailySequence,
        "ticketMonthlyNpSequence": ticketMonthlyNpSequence,
        "ticketYearlyNpSequence": ticketYearlyNpSequence,
        "ticketFySequence": ticketFySequence,
        "ticketYearlySequenceByCategory": ticketYearlySequenceByCategory,
        "ticketMonthlySequenceByCategory": ticketMonthlySequenceByCategory,
        "ticketDailySequenceByCategory": ticketDailySequenceByCategory,
        "ticketNo2": ticketNo2,
        "applicationUserId": applicationUserId,
        "title": title,
        "description": description,
        "ticketDate": ticketDate.toIso8601String(),
        "status": status,
        "severity": severity,
        "priority": priority,
        "ticketCategoryId": ticketCategoryId,
        "ticketCategoryName": ticketCategoryName,
        "assignToEmployeeId": assignToEmployeeId,
        "assignedTo": assignedTo,
        "assignedOn": assignedOn.toIso8601String(),
        "issueByEmployeeId": issueByEmployeeId,
        "issueBy": issueBy,
        "issueOn": issueOn.toIso8601String(),
        "sessionTag": sessionTag,
        "attachmentFiles": attachmentFiles,
        "attachedDocuments":
            List<dynamic>.from(attachedDocuments.map((x) => x)),
        "insertUser": insertUser,
        "insertTime": insertTime.toIso8601String(),
        "updateUser": updateUser,
        "updateTime": updateTime.toIso8601String(),
      };
}

class TicketActivity {
  int id;
  int ticketId;
  String activity;
  dynamic comment;
  String ticketAction;
  DateTime commentDate;
  String replyBy;
  DateTime replyOn;
  String userType;
  String applicationUserId;
  bool isActive;
  dynamic attachmentFiles;
  List<dynamic> attachedDocuments;
  String insertUser;
  DateTime insertTime;
  dynamic updateUser;
  dynamic updateTime;

  TicketActivity({
    required this.id,
    required this.ticketId,
    required this.activity,
    required this.comment,
    required this.ticketAction,
    required this.commentDate,
    required this.replyBy,
    required this.replyOn,
    required this.userType,
    required this.applicationUserId,
    required this.isActive,
    required this.attachmentFiles,
    required this.attachedDocuments,
    required this.insertUser,
    required this.insertTime,
    required this.updateUser,
    required this.updateTime,
  });

  factory TicketActivity.fromJson(Map<String, dynamic> json) => TicketActivity(
        id: json["id"],
        ticketId: json["ticketId"],
        activity: json["activity"],
        comment: json["comment"],
        ticketAction: json["ticketAction"],
        commentDate: DateTime.parse(json["commentDate"]),
        replyBy: json["replyBy"],
        replyOn: DateTime.parse(json["replyOn"]),
        userType: json["userType"],
        applicationUserId: json["applicationUserId"],
        isActive: json["isActive"],
        attachmentFiles: json["attachmentFiles"],
        attachedDocuments:
            List<dynamic>.from(json["attachedDocuments"].map((x) => x)),
        insertUser: json["insertUser"],
        insertTime: DateTime.parse(json["insertTime"]),
        updateUser: json["updateUser"],
        updateTime: json["updateTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ticketId": ticketId,
        "activity": activity,
        "comment": comment,
        "ticketAction": ticketAction,
        "commentDate": commentDate.toIso8601String(),
        "replyBy": replyBy,
        "replyOn": replyOn.toIso8601String(),
        "userType": userType,
        "applicationUserId": applicationUserId,
        "isActive": isActive,
        "attachmentFiles": attachmentFiles,
        "attachedDocuments":
            List<dynamic>.from(attachedDocuments.map((x) => x)),
        "insertUser": insertUser,
        "insertTime": insertTime.toIso8601String(),
        "updateUser": updateUser,
        "updateTime": updateTime,
      };
}
