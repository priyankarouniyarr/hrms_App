class TicketDetailsWithId {
  int id;
  Ticket ticket;
  List<TicketActivity> ticketActivity;
  bool isTicketUser;
  String? baseUrl;

  TicketDetailsWithId({
    required this.id,
    required this.ticket,
    required this.ticketActivity,
    required this.isTicketUser,
    this.baseUrl,
  });

  factory TicketDetailsWithId.fromJson(Map<String, dynamic> json) =>
      TicketDetailsWithId(
        id: json["id"] ?? 0, // Provide default if null
        ticket: Ticket.fromJson(json["ticket"] ?? {}), // Handle null ticket
        ticketActivity: json["ticketActivity"] != null
            ? List<TicketActivity>.from(json["ticketActivity"]
                .map((x) => TicketActivity.fromJson(x ?? {})))
            : <TicketActivity>[], // Default empty list
        isTicketUser: json["isTicketUser"] ?? false, // Default false
        baseUrl: json["baseUrl"], // Already nullable
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
  DateTime? updateTime;

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
    this.updateTime,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        id: json["id"] ?? 0,
        ticketNo: json["ticketNo"] ?? "",
        ticketNoSequence: json["ticketNoSequence"] ?? 0,
        ticketYearSequence: json["ticketYearSequence"] ?? 0,
        ticketMonthlySequence: json["ticketMonthlySequence"] ?? 0,
        ticketDailySequence: json["ticketDailySequence"] ?? 0,
        ticketMonthlyNpSequence: json["ticketMonthlyNpSequence"] ?? 0,
        ticketYearlyNpSequence: json["ticketYearlyNpSequence"] ?? 0,
        ticketFySequence: json["ticketFySequence"] ?? 0,
        ticketYearlySequenceByCategory:
            json["ticketYearlySequenceByCategory"] ?? 0,
        ticketMonthlySequenceByCategory:
            json["ticketMonthlySequenceByCategory"] ?? 0,
        ticketDailySequenceByCategory:
            json["ticketDailySequenceByCategory"] ?? 0,
        ticketNo2: json["ticketNo2"] ?? "",
        applicationUserId: json["applicationUserId"] ?? "",
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        ticketDate: _parseDate(json["ticketDate"]),
        status: json["status"] ?? "Open",
        severity: json["severity"] ?? "Medium",
        priority: json["priority"] ?? "Medium",
        ticketCategoryId: json["ticketCategoryId"] ?? 0,
        ticketCategoryName: json["ticketCategoryName"] ?? "",
        assignToEmployeeId: json["assignToEmployeeId"] ?? 0,
        assignedTo: json["assignedTo"] ?? "",
        assignedOn: _parseDate(json["assignedOn"]),
        issueByEmployeeId: json["issueByEmployeeId"],
        issueBy: json["issueBy"] ?? "",
        issueOn: _parseDate(json["issueOn"]),
        sessionTag: json["sessionTag"],
        attachmentFiles: json["attachmentFiles"],
        attachedDocuments: json["attachedDocuments"] != null
            ? List<String>.from(json["attachedDocuments"].map((x) => x ?? ""))
            : <String>[],
        insertUser: json["insertUser"] ?? "",
        insertTime: _parseDate(json["insertTime"]),
        updateUser: json["updateUser"] ?? "",
        updateTime: _parseNullableDate(json["updateTime"]),
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
        "updateTime": updateTime?.toIso8601String(),
      };

  /// Safely parse a DateTime or fallback to DateTime.now()
  static DateTime _parseDate(dynamic value) {
    if (value != null && value.toString().isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        print("⚠️ Invalid date format: $value");
      }
    }
    return DateTime.now();
  }

  /// Safely parse a nullable DateTime
  static DateTime? _parseNullableDate(dynamic value) {
    if (value != null && value.toString().isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        print("⚠️ Invalid nullable date format: $value");
      }
    }
    return null;
  }
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
        id: json["id"] ?? 0,
        ticketId: json["ticketId"] ?? 0,
        activity: json["activity"] ?? "",
        comment: json["comment"], // Already dynamic/nullable
        ticketAction: json["ticketAction"] ?? "",
        commentDate: json["commentDate"] != null
            ? DateTime.parse(json["commentDate"])
            : DateTime.now(),
        replyBy: json["replyBy"] ?? "",
        replyOn: json["replyOn"] != null
            ? DateTime.parse(json["replyOn"])
            : DateTime.now(),
        userType: json["userType"] ?? "",
        applicationUserId: json["applicationUserId"] ?? "",
        isActive: json["isActive"] ?? false,
        attachmentFiles: json["attachmentFiles"],
        attachedDocuments: json["attachedDocuments"] != null
            ? List<dynamic>.from(json["attachedDocuments"].map((x) => x))
            : <dynamic>[],
        insertUser: json["insertUser"] ?? "",
        insertTime: json["insertTime"] != null
            ? DateTime.parse(json["insertTime"])
            : DateTime.now(),
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
