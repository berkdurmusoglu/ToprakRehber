// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  int id;
  String productName;
  String? ekimMevsimi;
  String? hasatMevsimi;
  String? image;

  Product({
    required this.id,
    required this.productName,
    required this.ekimMevsimi,
    required this.hasatMevsimi,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    productName: json["productName"],
    ekimMevsimi: json["ekimMevsimi"],
    hasatMevsimi: json["hasatMevsimi"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "productName": productName,
    "ekimMevsimi": ekimMevsimi,
    "hasatMevsimi": hasatMevsimi,
    "image": image,
  };
}
