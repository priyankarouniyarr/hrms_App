class Ticket {
  final int id;
  final String ticketNo;
  final int ticketNoSequence;
  final String ticketNo2;
  final String title;
  final String description;
  final DateTime ticketDate;
  final String status;
  final String severity;
  final String? priority;
  final int ticketCategoryId;
  final String? ticketCategoryName;
  final int assignToEmployeeId;
  final String assignedTo;
  final String issueBy;
  final DateTime? updateTime;
  final List<dynamic> attachedDocuments;

  Ticket({
    required this.id,
    required this.ticketNo,
    required this.ticketNoSequence,
    required this.ticketNo2,
    required this.title,
    required this.description,
    required this.ticketDate,
    required this.status,
    required this.severity,
    this.priority,
    required this.ticketCategoryId,
    this.ticketCategoryName,
    required this.assignToEmployeeId,
    required this.assignedTo,
    required this.issueBy,
    this.updateTime,
    required this.attachedDocuments,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      ticketNo: json['ticketNo'],
      ticketNoSequence: json['ticketNoSequence'],
      ticketNo2: json['ticketNo2'],
      title: json['title'],
      description: json['description'],
      ticketDate: DateTime.parse(json['ticketDate']),
      status: json['status'],
      severity: json['severity'],
      priority: json['priority'],
      ticketCategoryId: json['ticketCategoryId'],
      ticketCategoryName: json['ticketCategoryName'],
      assignToEmployeeId: json['assignToEmployeeId'],
      assignedTo: json['assignedTo'],
      issueBy: json['issueBy'],
      updateTime: json['updateTime'] != null
          ? DateTime.parse(json['updateTime'])
          : null,
      attachedDocuments: json['attachedDocuments'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticketNo': ticketNo,
      'ticketNoSequence': ticketNoSequence,
      'ticketNo2': ticketNo2,
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
      'issueBy': issueBy,
      'updateTime': updateTime?.toIso8601String(),
      'attachedDocuments': attachedDocuments,
    };
  }
}
