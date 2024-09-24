
import 'dart:convert';

List<Rehber> rehberFromJson(String str) => List<Rehber>.from(json.decode(str).map((x) => Rehber.fromJson(x)));

String rehberToJson(List<Rehber> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Rehber {
  int id;
  MahalleId mahalleId;
  Product product;
  double sonuc;
  String mevsim;

  Rehber({
    required this.id,
    required this.mahalleId,
    required this.product,
    required this.sonuc,
    required this.mevsim,
  });

  factory Rehber.fromJson(Map<String, dynamic> json) => Rehber(
    id: json["id"],
    mahalleId: MahalleId.fromJson(json["mahalleId"]),
    product: Product.fromJson(json["product"]),
    sonuc: json["sonuc"],
    mevsim: json["mevsim"],
  );

  Map<String, dynamic> toJson() => {
    "mahalleId": mahalleId.toJson(),
    "product": product.toJson(),
    "sonuc": sonuc,
    "mevsim": mevsim,
  };
}

class MahalleId {
  int id;
  String mahalleName;
  IlceId ilceId;

  MahalleId({
    required this.id,
    required this.mahalleName,
    required this.ilceId,
  });

  factory MahalleId.fromJson(Map<String, dynamic> json) => MahalleId(
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


class Product {
  int id;
  String productName;
  dynamic image;
  String? hasatMevsimi;
  String? ekimMevsimi;

  Product({
    required this.id,
    required this.productName,
    required this.image,
    required this.hasatMevsimi,
    required this.ekimMevsimi,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    productName: json["productName"],
    image: json["image"],
    hasatMevsimi: json["hasatMevsimi"],
    ekimMevsimi: json["ekimMevsimi"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "productName": productName,
    "image": image,
    "hasatMevsimi": hasatMevsimi,
    "ekimMevsimi": ekimMevsimi,
  };
}



