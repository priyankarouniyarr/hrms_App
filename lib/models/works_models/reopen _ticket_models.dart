class PriorityTicket {
  int ticketId;

  String priorityStatus;

  PriorityTicket({
    required this.ticketId,
    required this.priorityStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'Id': ticketId,
      'StatusValue': priorityStatus,
    };
  }
}

class ServityTicket {
  int ticketId;
  String servityStatus;

  ServityTicket({
    required this.ticketId,
    required this.servityStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'Id': ticketId,
      'StatusValue': servityStatus,
    };
  }
}

class AssignToTicket {
  int ticketId;

  int userId;

  AssignToTicket({
    required this.ticketId,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'Id': ticketId,
      'AssignToId': userId,
    };
  }
}
