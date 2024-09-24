// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

import '../Farming/Hasat.dart';
import '../Farming/Rehber.dart';
import '../User/User.dart';

List<Comment> commentFromJson(String str) => List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

String commentToJson(List<Comment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comment {
  String body;
  User user;
  Rehber rehber;
  Hasat hasat;
  DateTime createdDate;

  Comment({
    required this.body,
    required this.user,
    required this.rehber,
    required this.hasat,
    required this.createdDate
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    body: json["body"],
    user: User.fromJson(json["user"]),
    rehber: Rehber.fromJson(json["rehber"]),
  hasat: Hasat.fromJson(json["hasat"]),
    createdDate: DateTime.parse(json["createdDate"]),
  );

  Map<String, dynamic> toJson() => {
    "body": body,
    "user": user.toJson(),
    "rehber": rehber.toJson(),
    "hasat": hasat.toJson(),
  };
}

