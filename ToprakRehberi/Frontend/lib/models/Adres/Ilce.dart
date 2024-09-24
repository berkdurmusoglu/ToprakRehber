// To parse this JSON data, do
//
//     final ilce = ilceFromJson(jsonString);

import 'dart:convert';

List<Ilce> ilceFromJson(String str) => List<Ilce>.from(json.decode(str).map((x) => Ilce.fromJson(x)));

String ilceToJson(List<Ilce> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ilce {
  int id;
  String ilceName;
  int ilId;

  Ilce({
    required this.id,
    required this.ilceName,
    required this.ilId,
  });

  factory Ilce.fromJson(Map<String, dynamic> json) => Ilce(
    id: json["id"],
    ilceName: json["ilceName"],
    ilId: json["il_Id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ilceName": ilceName,
    "il_Id": ilId,
  };
}
