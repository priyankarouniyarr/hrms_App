class LoanAndAdvanceModel {
  List<LoanAndAdvanceData> loanAndAdvanceData;
  int balanceAmount;

  LoanAndAdvanceModel(
      {required this.loanAndAdvanceData, required this.balanceAmount});

  factory LoanAndAdvanceModel.fromJson(Map<String, dynamic> json) {
    return LoanAndAdvanceModel(
      loanAndAdvanceData: (json['loanAndAdvanceData'] as List)
          .map((e) => LoanAndAdvanceData.fromJson(e))
          .toList(),
      balanceAmount: json['balanceAmount'].toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'loanAndAdvanceData':
            loanAndAdvanceData.map((e) => e.toJson()).toList(),
        'balanceAmount': balanceAmount,
      };
}

class LoanAndAdvanceData {
  String title;
  int amount;
  String nature;

  LoanAndAdvanceData(
      {required this.title, required this.amount, required this.nature});

  factory LoanAndAdvanceData.fromJson(Map<String, dynamic> json) {
    return LoanAndAdvanceData(
      title: json['title'],
      amount: json['amount'].toInt(),
      nature: json['nature'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'amount': amount,
        'nature': nature,
      };
}
