class SalaryDeduction {
  final String month;
  final String year;
  final double sst;
  final double incomeTax;
  final double totalDeduction;

  SalaryDeduction({
    required this.month,
    required this.year,
    required this.sst,
    required this.incomeTax,
    required this.totalDeduction,
  });

  // Factory method to create an instance from JSON
  factory SalaryDeduction.fromJson(Map<String, dynamic> json) {
    return SalaryDeduction(
      month: json['month'],
      year: json['year'],
      sst: (json['sst'] as num).toDouble(),
      incomeTax: (json['incomeTax'] as num).toDouble(),
      totalDeduction: (json['totalDeduction'] as num).toDouble(),
    );
  }

  // Convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'year': year,
      'sst': sst,
      'incomeTax': incomeTax,
      'totalDeduction': totalDeduction,
    };
  }

  @override
  String toString() {
    return 'SalaryDeduction(month: $month, year: $year, sst: $sst, incomeTax: $incomeTax, totalDeduction: $totalDeduction)';
  }
}
