import 'dart:convert';
// To parse this JSON data, do
//
//     final checkIn = checkInFromJson(jsonString);

CheckIn checkInFromJson(String str) => CheckIn.fromJson(json.decode(str));

String checkInToJson(CheckIn data) => json.encode(data.toJson());

class CheckIn {
  String longitude;
  String latitude;

  CheckIn({
    required this.longitude,
    required this.latitude,
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) => CheckIn(
        longitude: json["Longitude"],
        latitude: json["Latitude"],
      );

  Map<String, dynamic> toJson() => {
        "Longitude": longitude,
        "Latitude": latitude,
      };
}
