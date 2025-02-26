import 'dart:convert';

List<FiscalYearModel> fiscalYearModelFromJson(String str) =>
    List<FiscalYearModel>.from(
        json.decode(str).map((x) => FiscalYearModel.fromJson(x)));

String fiscalYearModelToJson(List<FiscalYearModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FiscalYearModel {
  int financialYearId;
  String financialYearCode;
  String isActive;
  String isLocked;
  String isClosed;

  FiscalYearModel({
    required this.financialYearId,
    required this.financialYearCode,
    required this.isActive,
    required this.isLocked,
    required this.isClosed,
  });

  factory FiscalYearModel.fromJson(Map<String, dynamic> json) =>
      FiscalYearModel(
        financialYearId: json["financialYearId"],
        financialYearCode: json["financialYearCode"],
        isActive: json["isActive"],
        isLocked: json["isLocked"],
        isClosed: json["isClosed"],
      );

  Map<String, dynamic> toJson() => {
        "financialYearId": financialYearId,
        "financialYearCode": financialYearCode,
        "isActive": isActive,
        "isLocked": isLocked,
        "isClosed": isClosed,
      };
}
