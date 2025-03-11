class SalaryModel {
  final int month;
  final int year;
  final int nextMonth;
  final int nextYear;
  final int previousMonth;
  final int previousYear;
  final List<PayHead> monthlySalaryData;
  final double grossTotal;
  final double netTotal;

  SalaryModel({
    required this.month,
    required this.year,
    required this.nextMonth,
    required this.nextYear,
    required this.previousMonth,
    required this.previousYear,
    required this.monthlySalaryData,
    required this.grossTotal,
    required this.netTotal,
  });

  factory SalaryModel.fromJson(Map<String, dynamic> json) {
    return SalaryModel(
      month: json['month'],
      year: json['year'],
      nextMonth: json['nextMonth'],
      nextYear: json['nextYear'],
      previousMonth: json['previousMonth'],
      previousYear: json['previousYear'],
      monthlySalaryData: (json['monthlySalaryData'] as List)
          .map((item) => PayHead.fromJson(item))
          .toList(),
      grossTotal: json['grossTotal'].toDouble(),
      netTotal: json['netTotal'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'year': year,
      'nextMonth': nextMonth,
      'nextYear': nextYear,
      'previousMonth': previousMonth,
      'previousYear': previousYear,
      'monthlySalaryData':
          monthlySalaryData.map((item) => item.toJson()).toList(),
      'grossTotal': grossTotal,
      'netTotal': netTotal,
    };
  }
}

class PayHead {
  final String payHead;
  final double amount;
  final String additionOrDeduction;

  PayHead({
    required this.payHead,
    required this.amount,
    required this.additionOrDeduction,
  });

  factory PayHead.fromJson(Map<String, dynamic> json) {
    return PayHead(
      payHead: json['payHead'],
      amount: json['amount'].toDouble(),
      additionOrDeduction: json['additionOrDeduction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payHead': payHead,
      'amount': amount,
      'additionOrDeduction': additionOrDeduction,
    };
  }
}
