class GetMyCurrentMonthSalary {
  //for current month
  final int month;
  final int year;
  final int nextMonth;
  final int nextYear;
  final int previousMonth;
  final int previousYear;
  final List<SalaryData> monthlySalaryData;
  final double grossTotal;
  final double netTotal;

  GetMyCurrentMonthSalary({
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

  factory GetMyCurrentMonthSalary.fromJson(Map<String, dynamic> json) {
    return GetMyCurrentMonthSalary(
      month: json['month'],
      year: json['year'],
      nextMonth: json['nextMonth'],
      nextYear: json['nextYear'],
      previousMonth: json['previousMonth'],
      previousYear: json['previousYear'],
      monthlySalaryData: (json['monthlySalaryData'] as List)
          .map((e) => SalaryData.fromJson(e))
          .toList(),
      grossTotal: json['grossTotal'].toDouble(),
      netTotal: json['netTotal'].toDouble(),
    );
  }
}

//for monthlySalaryData
class SalaryData {
  final String payHead;
  final double amount;
  final String additionOrDeduction;

  SalaryData({
    required this.payHead,
    required this.amount,
    required this.additionOrDeduction,
  });

  factory SalaryData.fromJson(Map<String, dynamic> json) {
    return SalaryData(
      payHead: json['payHead'],
      amount: json['amount'].toDouble(),
      additionOrDeduction: json['additionOrDeduction'],
    );
  }
}

//post request
class GetMyMonthSalaryRequest {
  final int month;
  final int year;

  GetMyMonthSalaryRequest({
    required this.month,
    required this.year,
  });

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'year': year,
    };
  }
}

class GetMyMonthSalary {
  final int month;
  final int year;
  final int nextMonth;
  final int nextYear;
  final int previousMonth;
  final int previousYear;
  final List<SalaryData> monthlySalaryData;
  final double grossTotal;
  final double netTotal;

  GetMyMonthSalary({
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

  factory GetMyMonthSalary.fromJson(Map<String, dynamic> json) {
    return GetMyMonthSalary(
      month: json['month'],
      year: json['year'],
      nextMonth: json['nextMonth'],
      nextYear: json['nextYear'],
      previousMonth: json['previousMonth'],
      previousYear: json['previousYear'],
      monthlySalaryData: (json['monthlySalaryData'] as List)
          .map((e) => SalaryData.fromJson(e))
          .toList(),
      grossTotal: json['grossTotal'].toDouble(),
      netTotal: json['netTotal'].toDouble(),
    );
  }
}
