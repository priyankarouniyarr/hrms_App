class BranchModel {
  final int branchId;
  final String branchName;

  BranchModel({required this.branchId, required this.branchName});

  // Factory constructor to convert JSON to BranchModel object
  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      branchId: json['branchId'],
      branchName: json['branchName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'branchName': branchName,
    };
  }
}
