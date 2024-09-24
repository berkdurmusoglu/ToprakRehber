// To parse this JSON data, do
//
//     final mahalle = mahalleFromJson(jsonString);

import 'dart:convert';

List<Mahalle> mahalleFromJson(String str) => List<Mahalle>.from(json.decode(str).map((x) => Mahalle.fromJson(x)));

String mahalleToJson(List<Mahalle> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Mahalle {
  int id;
  String mahalleName;
  int ilceId;

  Mahalle({
    required this.id,
    required this.mahalleName,
    required this.ilceId,
  });

  factory Mahalle.fromJson(Map<String, dynamic> json) => Mahalle(
    id: json["id"],
    mahalleName: json["mahalleName"],
    ilceId: json["ilce_Id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mahalleName": mahalleName,
    "ilce_Id": ilceId,
  };
}