import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  int id;
  String name;
  String mail;
  String telNo;
  String? profileImage;
  User({
    required this.id,
    required this.name,
    required this.mail,
    required this.telNo,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    mail: json["mail"],
    telNo: json["telNo"],
    profileImage: json["profileImage"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mail": mail,
    "telNo": telNo,
    "profileImage": profileImage,
  };
}