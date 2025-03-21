class TicketCreationRequest {
  final String ticketCategoryId;
  final String title;
  final String description;
  final String severity;
  final String priority;
  final String assignToEmployeeId;
  final String attachmentFiles;

  TicketCreationRequest({
    required this.ticketCategoryId,
    required this.title,
    required this.description,
    required this.severity,
    required this.priority,
    required this.assignToEmployeeId,
    required this.attachmentFiles,
  });

  Map<String, dynamic> toJson() {
    return {
      "TicketCategoryId": ticketCategoryId,
      "Title": title,
      "Description": description,
      "Severity": severity,
      "Priority": priority,
      "AssignToEmployeeId": assignToEmployeeId,
      "AttachmentFiles": attachmentFiles,
    };
  }
}
