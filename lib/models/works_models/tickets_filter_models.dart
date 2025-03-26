class TicketFilter {
  final int categoryId;
  final String status;
  final String priority;
  final String severity;
  final String assignedTo;
  final String OrderBY;
  final String FromDate;
  final String ToDate;

  TicketFilter(
      {this.categoryId = 0,
      this.status = '',
      this.priority = '',
      this.severity = '',
      this.assignedTo = '',
      this.FromDate = '',
      this.ToDate = '',
      this.OrderBY = ''});

  Map<String, dynamic> toJson() {
    return {
      'CategoryId': categoryId,
      'Status': status,
      'Priority': priority,
      'Severity': severity,
      'AssignedTo': assignedTo,
      'OrderBy': OrderBY,
      'FromDate': FromDate,
      'ToDate': ToDate,
    };
  }
}
