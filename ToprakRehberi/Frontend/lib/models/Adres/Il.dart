// To parse this JSON data, do
//
//     final il = ilFromJson(jsonString);

import 'dart:convert';

List<Il> ilFromJson(String str) => List<Il>.from(json.decode(str).map((x) => Il.fromJson(x)));

String ilToJson(List<Il> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Il {
  int id;
  String ilName;

  Il({
    required this.id,
    required this.ilName,
  });

  factory Il.fromJson(Map<String, dynamic> json) => Il(
    id: json["id"],
    ilName: json["ilName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ilName": ilName,
  };
}
