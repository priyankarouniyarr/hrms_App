class TicketCreationRequest {
  final int ticketCategoryId;
  final String title;
  final String description;
  final String severity;
  final String priority;
  final int assignToEmployeeId;
  final List<String>? attachmentPaths;

  TicketCreationRequest({
    required this.ticketCategoryId,
    required this.title,
    required this.description,
    required this.severity,
    required this.priority,
    required this.assignToEmployeeId,
    this.attachmentPaths,
  });

  Map<String, dynamic> toJson() {
    return {
      "TicketCategoryId": ticketCategoryId,
      "Title": title,
      "Description": description,
      "Severity": severity,
      "Priority": priority,
      "AssignToEmployeeId": assignToEmployeeId,
      // AttachmentFiles is handled separately in multipart request
    };
  }
}
