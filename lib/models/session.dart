// To parse this JSON data, do
//
//     final session = sessionFromMap(jsonString);

import 'dart:convert';

List<Session> sessionFromMap(String str) =>
    List<Session>.from(json.decode(str).map((x) => Session.fromMap(x)));

String sessionToMap(List<Session> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Session {
  int id;
  String title;
  String body;
  DateTime createdOn;

  Session({
    required this.id,
    required this.title,
    required this.body,
    required this.createdOn,
  });

  factory Session.fromMap(Map<String, dynamic> json) => Session(
        id: json["id"],
        title: json["title"],
        body: json["body"],
        createdOn: DateTime.fromMillisecondsSinceEpoch(json["created_on"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "body": body,
        "created_on": createdOn.millisecondsSinceEpoch,
      };
}
