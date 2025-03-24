class EmployeeRequest {
  final String text;
  final String value;

  EmployeeRequest({
    required this.text,
    required this.value,
  });

  factory EmployeeRequest.fromJson(Map<String, dynamic> json) {
    return EmployeeRequest(
      text: json['text'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'value': value,
    };
  }
}
