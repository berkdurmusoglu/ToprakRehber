// To parse this JSON data, do
//
//     final land = landFromJson(jsonString);

import 'dart:convert';

import 'package:toprak_rehberi/models/User/User.dart';

Land landFromJson(String str) => Land.fromJson(json.decode(str));

String landToJson(Land data) => json.encode(data.toJson());

class Land {
  int id;
  String landTip;
  int m2;
  int ekimM2;
  String landDescription;
  User user;
  Mahalle mahalle;

  Land({
    required this.id,
    required this.landTip,
    required this.m2,
    required this.ekimM2,
    required this.landDescription,
    required this.user,
    required this.mahalle,
  });

  factory Land.fromJson(Map<String, dynamic> json) => Land(
    id: json["id"],
    landTip: json["landTip"],
    m2: json["m2"],
    ekimM2: json["ekimM2"],
    landDescription: json["landDescription"],
    user: User.fromJson(json["user_Id"]),
    mahalle: Mahalle.fromJson(json["mahalle"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "landTip": landTip,
    "m2": m2,
    "ekimM2": ekimM2,
    "landDescription": landDescription,
    "user_Id": user.toJson(),
    "mahalle": mahalle.toJson(),
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

