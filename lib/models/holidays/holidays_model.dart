class Holidays {
  int id;
  String? title;
  DateTime fromDate;
  DateTime toDate;
  String fromDateNp;
  String toDateNp;
  int totalHolidays;
  String? color;
  List<HolidayDate> holidayDates;

  Holidays({
    required this.id,
    required this.title,
    required this.fromDate,
    required this.toDate,
    required this.fromDateNp,
    required this.toDateNp,
    required this.totalHolidays,
    required this.color,
    required this.holidayDates,
  });

  factory Holidays.fromJson(Map<String, dynamic> json) => Holidays(
        id: json["id"],
        title: json["title"],
        fromDate: DateTime.parse(json["fromDate"]),
        toDate: DateTime.parse(json["toDate"]),
        fromDateNp: json["fromDateNp"],
        toDateNp: json["toDateNp"],
        totalHolidays: json["totalHolidays"],
        color: json["color"],
        holidayDates: List<HolidayDate>.from(
            json["holidayDates"].map((x) => HolidayDate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "fromDate": fromDate.toIso8601String(),
        "toDate": toDate.toIso8601String(),
        "fromDateNp": fromDateNp,
        "toDateNp": toDateNp,
        "totalHolidays": totalHolidays,
        "color": color,
        "holidayDates": List<dynamic>.from(holidayDates.map((x) => x.toJson())),
      };
}

class HolidayDate {
  int id;
  int holidayId;
  DateTime holidayDate;
  String description;
  bool isWeekOff;

  HolidayDate({
    required this.id,
    required this.holidayId,
    required this.holidayDate,
    required this.description,
    required this.isWeekOff,
  });

  factory HolidayDate.fromJson(Map<String, dynamic> json) => HolidayDate(
        id: json["id"],
        holidayId: json["holidayId"],
        holidayDate: DateTime.parse(json["holidayDate"]),
        description: json["description"],
        isWeekOff: json["isWeekOff"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "holidayId": holidayId,
        "holidayDate": holidayDate.toIso8601String(),
        "description": description,
        "isWeekOff": isWeekOff,
      };
}
