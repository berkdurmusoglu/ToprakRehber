// To parse this JSON data, do
//
//     final ekim = ekimFromJson(jsonString);

import 'dart:convert';

import '../Land/Land.dart';
import '../Other/Product.dart';


List<Ekim> ekimFromJson(String str) => List<Ekim>.from(json.decode(str).map((x) => Ekim.fromJson(x)));

String ekimToJson(List<Ekim> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ekim {
  int id;
  int m2;
  Land land;
  Product product;
  DateTime ekimTarihi;
  String mevsim;
  int ekimDay;

  Ekim({
    required this.id,
    required this.m2,
    required this.land,
    required this.product,
    required this.ekimTarihi,
    required this.mevsim,
    required this.ekimDay,
  });

  factory Ekim.fromJson(Map<String, dynamic> json) => Ekim(
    id: json["id"],
    m2: json["m2"],
    land: Land.fromJson(json["land"]),
    product: Product.fromJson(json["product"]),
    ekimTarihi: DateTime.parse(json["ekimTarihi"]),
    mevsim: json["mevsim"],
      ekimDay: json["ekimDay"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "m2": m2,
    "land": land.toJson(),
    "product": product.toJson(),
    "ekimTarihi": "${ekimTarihi.year.toString().padLeft(4, '0')}-${ekimTarihi.month.toString().padLeft(2, '0')}-${ekimTarihi.day.toString().padLeft(2, '0')}",
    "mevsim": mevsim,
    "ekimDay": ekimDay,
  };
}


class Mahalle {
  int id;
  String mahalleName;
  IlceId ilceId;

  Mahalle({
    required this.id,
    required this.mahalleName,
    required this.ilceId,
  });

  factory Mahalle.fromJson(Map<String, dynamic> json) => Mahalle(
    id: json["id"],
    mahalleName: json["mahalleName"],
    ilceId: IlceId.fromJson(json["ilce_Id"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mahalleName": mahalleName,
    "ilce_Id": ilceId.toJson(),
  };
}

class IlceId {
  int id;
  String ilceName;
  String ilId;

  IlceId({
    required this.id,
    required this.ilceName,
    required this.ilId,
  });

  factory IlceId.fromJson(Map<String, dynamic> json) => IlceId(
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


