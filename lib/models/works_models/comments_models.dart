class CommentsModels {
  final int ticketId;
  final String comment;

  final List<String>? attachmentPaths;

  CommentsModels({
    required this.ticketId,
    required this.comment,
    this.attachmentPaths,
  });

  Map<String, dynamic> toJson() {
    return {
      "TicketId": ticketId,
      "Comment": comment,

      // AttachmentFiles is handled separately in multipart request
    };
  }
}
