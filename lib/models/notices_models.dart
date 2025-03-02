import 'dart:convert';
// To parse this JSON data, do
//
//     final notices = noticesFromJson(jsonString);

List<Notices> noticesFromJson(String str) =>
    List<Notices>.from(json.decode(str).map((x) => Notices.fromJson(x)));

String noticesToJson(List<Notices> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Notices {
  int id;
  Category category;
  String title;
  String content;
  bool isPublished;
  DateTime? publishedTime;
  String? tags;
  dynamic featuredImage;
  String excerpt;

  Notices({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.isPublished,
    required this.publishedTime,
    required this.tags,
    required this.featuredImage,
    required this.excerpt,
  });

  factory Notices.fromJson(Map<String, dynamic> json) => Notices(
        id: json["id"],
        category: categoryValues.map[json["category"]]!,
        title: json["title"],
        content: json["content"],
        isPublished: json["isPublished"],
        publishedTime: json["publishedTime"] == null
            ? null
            : DateTime.parse(json["publishedTime"]),
        tags: json["tags"],
        featuredImage: json["featuredImage"],
        excerpt: json["excerpt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": categoryValues.reverse[category],
        "title": title,
        "content": content,
        "isPublished": isPublished,
        "publishedTime": publishedTime?.toIso8601String(),
        "tags": tags,
        "featuredImage": featuredImage,
        "excerpt": excerpt,
      };
}

enum Category { NEWS, NOTICE }

final categoryValues =
    EnumValues({"News": Category.NEWS, "Notice": Category.NOTICE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
