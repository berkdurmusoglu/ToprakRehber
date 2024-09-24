// To parse this JSON data, do
//
//     final hasat = hasatFromJson(jsonString);

import 'dart:convert';

import 'package:toprak_rehberi/models/Farming/Ekim.dart';

Hasat hasatFromJson(String str) => Hasat.fromJson(json.decode(str));

String hasatToJson(Hasat data) => json.encode(data.toJson());

class Hasat {
  int id;
  Ekim ekimId;
  String hasatSonuc;
  int hasatMiktari;
  DateTime hasatTarihi;

  Hasat({
    required this.id,
    required this.ekimId,
    required this.hasatSonuc,
    required this.hasatMiktari,
    required this.hasatTarihi,
  });

  factory Hasat.fromJson(Map<String, dynamic> json) => Hasat(
    id: json["id"],
    ekimId: Ekim.fromJson(json["ekim_Id"]),
    hasatSonuc: json["hasat_sonuc"],
    hasatMiktari: json["hasatMiktari"],
    hasatTarihi: DateTime.parse(json["hasatTarihi"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ekim_Id": ekimId.toJson(),
    "hasat_sonuc": hasatSonuc,
    "hasatMiktari": hasatMiktari,
    "hasatTarihi": "${hasatTarihi.year.toString().padLeft(4, '0')}-${hasatTarihi.month.toString().padLeft(2, '0')}-${hasatTarihi.day.toString().padLeft(2, '0')}",
  };
}

