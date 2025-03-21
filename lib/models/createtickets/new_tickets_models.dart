// Define TicketsCategories model class
class Tickets {
  final String text;
  final String value;

  // Constructor
  Tickets({required this.text, required this.value});

  // Factory method to convert JSON to TicketsCategories object
  factory Tickets.fromJson(Map<String, dynamic> json) {
    return Tickets(
      text: json['text'],
      value: json['value'],
    );
  }

  // Method to convert TicketsCategories object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'value': value,
    };
  }
}
