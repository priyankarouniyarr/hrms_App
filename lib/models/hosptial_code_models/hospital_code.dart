import 'dart:convert';

HospitalCode hospitalCodeFromJson(String str) =>
    HospitalCode.fromJson(json.decode(str));

String hospitalCodeToJson(HospitalCode data) => json.encode(data.toJson());

class HospitalCode {
  String url;

  HospitalCode({
    required this.url,
  });

  factory HospitalCode.fromJson(Map<String, dynamic> json) => HospitalCode(
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}
