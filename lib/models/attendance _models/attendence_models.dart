class Attendance {
  final String category;
  final int qty;

  Attendance({required this.category, required this.qty});

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      category: json['category'],
      qty: json['qty'].toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'qty': qty,
    };
  }
}
