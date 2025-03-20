class TaskData {
  int? open;
  int inProgress;
  int closed;
  int severityHigh;
  int severityMedium;
  int severityLow;
  int priorityHigh;
  int priorityMedium;
  int priorityLow;
  double averageCompletionRatePerDay;

  TaskData({
    required this.open,
    required this.inProgress,
    required this.closed,
    required this.severityHigh,
    required this.severityMedium,
    required this.severityLow,
    required this.priorityHigh,
    required this.priorityMedium,
    required this.priorityLow,
    required this.averageCompletionRatePerDay,
  });

  // Factory method to create an instance from JSON data
  factory TaskData.fromJson(Map<String, dynamic> json) {
    return TaskData(
      open: json['open'] ?? 0,
      inProgress: json['inProgress'] ?? 0,
      closed: json['closed'] ?? 0,
      severityHigh: json['severityHigh'] ?? 0,
      severityMedium: json['severityMedium'] ?? 0,
      severityLow: json['severityLow'] ?? 0,
      priorityHigh: json['priorityHigh'] ?? 0,
      priorityMedium: json['priorityMedium'] ?? 0,
      priorityLow: json['priorityLow'] ?? 0,
      averageCompletionRatePerDay:
          json['averageCompletionRatePerDay']?.toDouble() ?? 0.0,
    );
  }

  // Method to convert the model to JSON
  Map<String, dynamic> toJson() {
    return {
      'open': open,
      'inProgress': inProgress,
      'closed': closed,
      'severityHigh': severityHigh,
      'severityMedium': severityMedium,
      'severityLow': severityLow,
      'priorityHigh': priorityHigh,
      'priorityMedium': priorityMedium,
      'priorityLow': priorityLow,
      'averageCompletionRatePerDay': averageCompletionRatePerDay,
    };
  }
}
